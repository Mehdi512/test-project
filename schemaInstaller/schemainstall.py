#!/usr/bin/env python3

import sys
import os
import pymysql
import datetime
import re
import subprocess
import configparser
from io import StringIO
import getopt
import logging
from typing import List

## VARS
db_user = "root"
db_pass = "refill"
databases_dir = "/schema-install/databases"
dbs_list = '/schema-install/schemas.ini'

success_message = "Host: {}\nPort: {}\nStatus: Success"
failure_message = "Host: {}\nPort: {}\nStatus: Failed"

def display_usage():
    usage_message = '''Usage: schemainstall [options] [APP_NAME]
Options:
    connectivity   check database connectivity
    install        install databases
    locale         apply locale
    upgrade        upgrade database'''
    print(usage_message)

# Helper function to ensure that a correct port number is passed. Defaults to 3306
def port_check(port):
    try:
        if port:
            port = int(port)
            if port < 1 or port > 65536:
                print('Port must be between 1 and 65536. Setting it to 3306')
                port = 3306
    except TypeError:
        print('Port must be a number. Defaulting to 3306')
        port = 3306
    return port

def check_connectivity(database_host='localhost', port=3306):
    port = port_check(port)
    db = None
    try:
        db = pymysql.connect(host=database_host, port=port, user=db_user, passwd=db_pass)
        print(success_message.format(database_host, port))
    except pymysql.Error as e:
        print(failure_message.format(database_host, port))
    finally:
        if db is not None:
            db.close()

def process_schema(schema_name, sql_file, ver_file, database_host, port, cursor, debug, extras=False):
    """Process schema installation or extra SQL sourcing based on `extras` flag."""
    
    # Read SQL file to detect the schema name from the CREATE DATABASE statement
    with open(sql_file, 'r') as file:
        sql_script = file.read()

    # Locked regex for database name detection
    match_create = re.search(
        r'CREATE\s+(?:DATABASE|SCHEMA)\s+(?:/\*.*?\*/\s*)?(?:IF\s+NOT\s+EXISTS\s+)?(?:/\*.*?\*/\s*)?`?([\w]+)`?\s*(?:/\*.*?\*/)?\s*(?:DEFAULT\s+CHARACTER\s+SET\s+\w+)?\s*(?:/\*.*?\*/)?\s*;',
        sql_script, re.IGNORECASE | re.DOTALL
    )
    if match_create:
        schema_name_from_file = match_create.group(1)
    else:
        print(f"No CREATE DATABASE query found in {os.path.basename(sql_file)}.")
        return

    # Check if the database exists
    check_db_query = f"SHOW DATABASES LIKE '{schema_name_from_file}';"
    cursor.execute(check_db_query)
    
    # If database does not exist and extras is specified, notify user to install first
    if not cursor.fetchone():
        if extras:
            print(f"Database '{schema_name_from_file}' does not exist. Please install it first before sourcing extra files.")
            return

    # Proceed with sourcing extra files only if `extras` is specified and the database exists
    if extras:
        schema_dir = os.path.dirname(sql_file)
        extra_files = [f for f in os.listdir(schema_dir) if f.endswith('.sql') and f not in {f"{schema_name}.sql", f"{schema_name}.ver", "locale.sql"}]

        if not extra_files:
            print(f"No extra .sql files found to source for schema '{schema_name_from_file}'.")
            return

        for extra_file in extra_files:
            extra_file_path = os.path.join(schema_dir, extra_file)
            user_confirm = input(f"Found extra SQL file '{extra_file}' for schema '{schema_name_from_file}'. Do you want to source it? (y/n): ")
            if user_confirm.lower() == 'y':
                source_command = [
                    "mysql",
                    f"-h{database_host}",
                    f"-P{port}",
                    f"-u{db_user}",
                    f"-p{db_pass}",
                    "-e", f"source {extra_file_path};"
                ]
                process = subprocess.run(source_command, capture_output=True, text=True)
                if process.returncode != 0:
                    print(f"Error sourcing {extra_file}: {process.stderr}")
                    return
                else:
                    print(f"Successfully sourced {extra_file}")
            else:
                print(f"Skipping {extra_file}")
        return

    # Proceed with regular installation flow if extras is not specified
    if not extras:
        # Check for USE schema_name statement
        match_use = re.search(
            r'USE\s+`?([\w]+)`?\s*;',
            sql_script, re.IGNORECASE | re.DOTALL
        )
        if match_use:
            use_schema_name_from_file = match_use.group(1)
            # Compare schema names from CREATE and USE statements
            if use_schema_name_from_file != schema_name_from_file:
                print(f"There is no USE statement for the expected schema '{schema_name_from_file}' in {os.path.basename(sql_file)}.")
                return
        else:
            print(f"There is no USE schema_name query in {os.path.basename(sql_file)}.")
            return  # Stop processing if there's no USE statement

        # Check for CREATE TABLE `ersinstall` statement
        match_ersinstall = re.search(
            r'CREATE\s+TABLE\s+(?:/\*.*?\*/\s*)?(?:IF\s+NOT\s+EXISTS\s+)?(?:/\*.*?\*/\s*)?(?:`?[\w]+`?\.)?`?ersinstall`?\s*(?:\(|;)?',
            sql_script, re.IGNORECASE | re.DOTALL
        )
        if not match_ersinstall:
            print(f"NO CREATE TABLE `ersinstall` QUERY IN {os.path.basename(sql_file)}.")
            return

        # Check if the database already exists (this time, for reinstallation)
        cursor.execute(check_db_query)
        if cursor.fetchone():
            reinstall = input(f"Schema '{schema_name_from_file}' already installed. Do you want to reinstall it? (y/n): ")
            if reinstall.lower() != 'y':
                print("Skipping installation.")
                return
            else:
                cursor.execute(f"DROP DATABASE IF EXISTS `{schema_name_from_file}`;")

        # Run `source` command to execute the SQL file using mysql CLI
        source_command = [
            "mysql",
            f"-h{database_host}",
            f"-P{port}",
            f"-u{db_user}",
            f"-p{db_pass}",
            "-e", f"source {sql_file};"
        ]
        process = subprocess.run(source_command, capture_output=True, text=True)

        if process.returncode != 0:
            print(f"Error sourcing {sql_file}: {process.stderr}")
        else:
            print(f"Successfully sourced {sql_file}")

        # Add initial entry to the ersinstall table after installation, if a version file is provided
        if os.path.isfile(ver_file):
            with open(ver_file, 'r') as file:
                version = file.read().strip()

            select_query = f"SELECT COUNT(*) FROM {schema_name_from_file}.ersinstall"
            cursor.execute(select_query)
            version_key = cursor.fetchone()[0] + 1
            last_modified = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            insert_query = f"""
            INSERT INTO {schema_name_from_file}.ersinstall (VersionKey, Version, Status, Script, last_modified)
            VALUES ({version_key}, '{version}', 1, 'Fresh installation', '{last_modified}')
            """
            cursor.execute(insert_query)
            cursor.connection.commit()
            print(f"Schema for {schema_name_from_file} successfully installed with version {version}")

def install_database(app_name, database_host='localhost', port=3306, extras=False):
    config = configparser.ConfigParser()
    config.read(dbs_list)
    debug = config.get('general', 'debug').strip()

    # Extract and parse database lists from the config
    transaction_dbs = config.get('transaction', 'dbs').split(',')
    reporting_dbs = config.get('reporting', 'dbs').split(',')
    
    # Trim and clean whitespace from database names
    transaction_dbs = [db.strip() for db in transaction_dbs]
    reporting_dbs = [db.strip() for db in reporting_dbs]

    # Check if app_name exists in either list
    if app_name not in transaction_dbs and app_name not in reporting_dbs:
        print(f"Schema '{app_name}' not found in config file.")
        return

    port = port_check(port)
    db = None

    try:
        db = pymysql.connect(host=database_host, port=port, user=db_user, passwd=db_pass)
        cursor = db.cursor()

        # Locate main SQL file
        main_sql_file = os.path.join(databases_dir, app_name, f"{app_name}.sql")

        if os.path.isfile(main_sql_file):
            # If main app_name.sql file exists, install from it directly
            ver_file = os.path.join(databases_dir, app_name, f"{app_name}.ver")
            process_schema(app_name, main_sql_file, ver_file, database_host, port, cursor, debug, extras=extras)

        else:
            # If no main app_name.sql, treat each immediate subdirectory as its own schema
            app_dir = os.path.join(databases_dir, app_name)
            if os.path.isdir(app_dir):
                child_dirs = [d for d in os.listdir(app_dir) if os.path.isdir(os.path.join(app_dir, d))]

                for child_dir in child_dirs:
                    # Define the paths for the SQL and version files in each child_dir
                    child_sql_file = os.path.join(app_dir, child_dir, f"{child_dir}.sql")
                    child_ver_file = os.path.join(app_dir, child_dir, f"{child_dir}.ver")

                    if os.path.isfile(child_sql_file):
                        # Process each child_dir as a separate schema
                        process_schema(child_dir, child_sql_file, child_ver_file, database_host, port, cursor, debug, extras=extras)
                    else:
                        print(f"No .sql file found in child directory {child_dir}, skipping...")
            else:
                print(f"No .sql files or child directories found for {app_name}")
                return

    except pymysql.Error as e:
        print(f"Schema installation failed: {e}")
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def read_database_list(dbs_list: str, section: str) -> List[str]:
    """Read the list of databases from the specified section of the config."""
    try:
        with open(dbs_list, 'r') as file:
            contents = file.read()

        config = configparser.ConfigParser()
        config.read_file(StringIO(contents))

        if config.has_section(section):
            dbs = config.get(section, 'dbs')
            return [db.strip() for db in dbs.split(',')]

    except OSError as e:
        logger.error("Error reading database list from file '%s': %s", dbs_list, e)

    return []

def install_all_tr_databases(dbs_list: str, database_host: str = 'localhost', database_port: int = 3306):
    """Install all transaction databases."""
    database_list = read_database_list(dbs_list, 'transaction')

    for app_name in database_list:
        install_database(app_name, database_host, database_port)

def install_all_rp_databases(dbs_list: str, database_host: str = 'localhost', database_port: int = 3306):
    """Install all reporting databases."""
    database_list = read_database_list(dbs_list, 'reporting')

    for app_name in database_list:
        install_database(app_name, database_host, database_port)

def install_all_databases(database_host: str = 'localhost', database_port: int = 3306):
    """Install all databases."""
    try:
        install_all_tr_databases(dbs_list, database_host, database_port)
        install_all_rp_databases(dbs_list, database_host, database_port)
    except Exception as e:
        logger.error("Error occurred while installing all databases: %s", e)

def connect_to_database(host, port):
    """Establishes a connection to the MySQL database."""
    return pymysql.connect(host=host, port=port, user=db_user, passwd=db_pass)

def apply_locale(app_name, database_host='localhost', port=3306):
    """
    Applies locale to the specified schema based on app_name.sql and locale.sql.
    If app_name.sql is not found, treats each child directory as a potential app_name.
    """
    config = configparser.ConfigParser()
    db, cursor = None, None

    try:
        # Load configuration file
        config.read(dbs_list)

        # Check if app_name exists in config file
        schema_found = False
        for section in ['transaction', 'reporting']:
            if config.has_section(section):
                if app_name in [db.strip() for db in config.get(section, 'locales').split(',')]:
                    schema_found = True
                    break

        if not schema_found:
            print(f"Locale for schema '{app_name}' not found in config file.")
            return

        # Function to process a single directory for app_name.sql and locale.sql
        def process_directory(directory, current_app_name):
            """Processes a directory to find and validate SQL files."""
            sql_file_path = os.path.join(directory, f"{current_app_name}.sql")

            if not os.path.isfile(sql_file_path):
                return None  # No app_name.sql found

            # Extract schema_name from app_name.sql
            try:
                with open(sql_file_path, 'r') as sql_file:
                    sql_script = sql_file.read()

                match_create = re.search(
                    r'CREATE\s+(?:DATABASE|SCHEMA)\s+(?:/\*.*?\*/\s*)?(?:IF\s+NOT\s+EXISTS\s+)?(?:/\*.*?\*/\s*)?`?([\w]+)`?\s*(?:/\*.*?\*/)?\s*(?:DEFAULT\s+CHARACTER\s+SET\s+\w+)?\s*(?:/\*.*?\*/)?\s*;',
                    sql_script, re.IGNORECASE | re.DOTALL
                )

                if match_create:
                    schema_name_from_file = match_create.group(1)
                else:
                    return f"No CREATE DATABASE query found in {os.path.basename(sql_file_path)}."
            except Exception as e:
                return f"Error reading {current_app_name}.sql: {e}"

            # Validate schema_name on database host
            schema_exists = False
            try:
                db = connect_to_database(database_host, port)
                cursor = db.cursor()
                cursor.execute(f"SHOW DATABASES LIKE '{schema_name_from_file}';")

                if cursor.fetchone():
                    schema_exists = True
                else:
                    return f"Schema '{schema_name_from_file}' is not installed. Please install it first."
            except pymysql.Error as e:
                return f"Database connection error: {e}"
            finally:
                if cursor:
                    cursor.close()
                if db:
                    db.close()

            # Search for locale.sql in the same directory as app_name.sql
            locale_file_path = os.path.join(directory, "locale.sql")

            if not os.path.isfile(locale_file_path):
                return f"No locale.sql file found for {current_app_name}."

            # Validate USE schema_name in locale.sql
            try:
                with open(locale_file_path, 'r') as locale_file:
                    locale_script = locale_file.read()

                match_use = re.search(
                    r'USE\s+`?([\w]+)`?\s*;',
                    locale_script, re.IGNORECASE | re.DOTALL
                )

                if not match_use or match_use.group(1) != schema_name_from_file:
                    return f"No 'USE {schema_name_from_file}' statement found in locale.sql."

                # Source locale.sql using mysql CLI
                source_command = [
                    "mysql",
                    f"-h{database_host}",
                    f"-P{port}",
                    f"-u{db_user}",
                    f"-p{db_pass}",
                    "-e", f"source {locale_file_path};"
                ]

                process = subprocess.run(source_command, capture_output=True, text=True)

                if process.returncode != 0:
                    return f"Error sourcing {locale_file_path}: {process.stderr}"
                else:
                    print(f"Locale for {current_app_name} successfully applied from {locale_file_path}.")
                    return True

            except Exception as e:
                return f"An unexpected error occurred: {e}"

        # Check the parent directory first
        parent_result = process_directory(os.path.join(databases_dir, app_name), app_name)
        if parent_result:
            if parent_result is not True:
                print(parent_result)
            return

        # If no match in parent directory, process child directories
        parent_dir = os.path.join(databases_dir, app_name)
        if os.path.isdir(parent_dir):
            for child_dir in os.listdir(parent_dir):
                child_path = os.path.join(parent_dir, child_dir)
                if os.path.isdir(child_path):
                    # Treat the child directory as the current app_name
                    child_result = process_directory(child_path, child_dir)
                    if child_result and child_result is not True:
                        print(child_result)

    except pymysql.Error as e:
        print(f"Database connection error: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

def apply_all_tr_locales(dbs_list, database_host='localhost', database_port=3306):
    try:
        with open(dbs_list, 'r') as file:
            contents = file.read()

        database_list = []
        config = configparser.ConfigParser()
        config.read_file(StringIO(contents))

        if config.has_section('transaction'):
            dbs = config.get('transaction', 'locales')
            database_list = [db.strip() for db in dbs.split(',')]

        for app_name in database_list:
            apply_locale(app_name, database_host, database_port)

    except OSError as e:
        print("Error occurred while applying locales:", e)

def apply_all_rp_locales(dbs_list, database_host='localhost', database_port=3306):
    try:
        with open(dbs_list, 'r') as file:
            contents = file.read()

        database_list = []
        config = configparser.ConfigParser()
        config.read_file(StringIO(contents))

        if config.has_section('reporting'):
            dbs = config.get('reporting', 'locales')
            database_list = [db.strip() for db in dbs.split(',')]

        for app_name in database_list:
            apply_locale(app_name, database_host, database_port)

    except OSError as e:
        print("Error occurred while applying locales:", e)

def apply_all_locales(database_host='localhost', database_port=3306):
    try:
        apply_all_tr_locales(dbs_list, database_host, database_port)
        apply_all_rp_locales(dbs_list, database_host, database_port)

    except OSError as e:
        print("Error occurred while applying locales:", e)

def get_schema_name_from_file(sql_file):
    with open(sql_file, 'r') as file:
        sql_script = file.read()
    match_create = re.search(
        r'CREATE\s+(?:DATABASE|SCHEMA)\s+(?:/\*.*?\*/\s*)?(?:IF\s+NOT\s+EXISTS\s+)?(?:/\*.*?\*/\s*)?`?([\w]+)`?\s*(?:/\*.*?\*/)?\s*(?:DEFAULT\s+CHARACTER\s+SET\s+\w+)?\s*(?:/\*.*?\*/)?\s*;',
        sql_script, re.IGNORECASE | re.DOTALL
    )
    return match_create.group(1) if match_create else None

def process_upgrades(schema_name, upgrade_files_dir, database_host, port):
    """Process all upgrade files for the specified schema with user confirmation for each upgrade step."""
    upgrades_applied = False  # Track if any upgrades were applied

    try:
        db = pymysql.connect(host=database_host, port=port, user=db_user, passwd=db_pass)
        cursor = db.cursor()

        # Get the current version from ersinstall table
        cursor.execute(f"SELECT Version FROM {schema_name}.ersinstall ORDER BY VersionKey DESC LIMIT 1;")
        current_version = cursor.fetchone()[0]

        # List all upgrade files in sorted order
        upgrade_files = sorted(
            [f for f in os.listdir(upgrade_files_dir) if os.path.isfile(os.path.join(upgrade_files_dir, f))]
        )

        # Loop through and process upgrades until no more matching files are found
        while True:
            # Filter the upgrade files based on the current version
            filtered_upgrade_files = [
                f for f in upgrade_files if re.match(rf'^{re.escape(current_version)}__(.*)\.sql$', f)
            ]

            if not filtered_upgrade_files:
                # Only print this message if no upgrades were applied at all
                if not upgrades_applied:
                    print(f"No matching upgrade files found for {schema_name}")
                break  # Exit the loop if no further upgrades are found

            # Process each filtered upgrade file
            for upgrade_file in filtered_upgrade_files:
                next_version = re.match(rf'^{re.escape(current_version)}__(.*)\.sql$', upgrade_file).group(1)
                upgrade_file_path = os.path.abspath(os.path.join(upgrade_files_dir, upgrade_file))  # Get absolute path

                # Prompt user to continue with the upgrade
                user_confirm = input(f"{schema_name} will be upgraded from version {current_version} to {next_version}. Do you want to continue? (y/n): ")
                if user_confirm.lower() != 'y':
                    print(f"Upgrade process halted by user at version {current_version}.")
                    return  # Quit upgrades if the user declines

                # Add initial entry to ersinstall table with status 0
                start_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                insert_initial_status_query = f"""
                    INSERT INTO {schema_name}.ersinstall (Version, Status, Script, last_modified) 
                    VALUES ('{next_version}', 0, '{upgrade_file_path}', '{start_time}')
                """
                cursor.execute(insert_initial_status_query)
                db.commit()

                # Source the next upgrade file
                source_command = [
                    "mysql",
                    f"-h{database_host}",
                    f"-P{port}",
                    f"-u{db_user}",
                    f"-p{db_pass}",
                    schema_name,
                    "-e", f"source {upgrade_file_path};"
                ]
                process = subprocess.run(source_command, capture_output=True, text=True)

                if process.returncode != 0:
                    print(f"Error sourcing {upgrade_file_path}: {process.stderr}")
                    return  # Stop on error
                else:
                    print(f"Sourced {upgrade_file_path} successfully.")

                # Add successful entry to ersinstall table with status 1
                end_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                insert_success_status_query = f"""
                    INSERT INTO {schema_name}.ersinstall (Version, Status, Script, last_modified) 
                    VALUES ('{next_version}', 1, '{upgrade_file_path}', '{end_time}')
                """
                cursor.execute(insert_success_status_query)
                db.commit()
                print(f"Upgraded {schema_name} to version {next_version}.")

                # Update current version for the next iteration
                current_version = next_version
                upgrades_applied = True  # Mark that an upgrade has been applied

    except Exception as e:
        print(f"Error during upgrade processing for {schema_name}: {e}")
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

def upgrade_database(app_name, database_host='localhost', port=3306):
    port = port_check(port)
    config = configparser.ConfigParser()
    
    try:
        config.read(dbs_list)
    except configparser.Error as e:
        print(f"Error reading configuration file: {e}")
        return

    # Check if app_name is in config sections
    schema_found = False
    if config.has_section('transaction'):
        transaction_dbs = config.get('transaction', 'dbs').split(',')
        if app_name in [db.strip() for db in transaction_dbs]:
            schema_found = True
    if config.has_section('reporting'):
        reporting_dbs = config.get('reporting', 'dbs').split(',')
        if app_name in [db.strip() for db in reporting_dbs]:
            schema_found = True

    if not schema_found:
        print(f"Schema name '{app_name}' not found in config file.")
        return

    db = None
    cursor = None
    try:
        # Connect to the database
        db = pymysql.connect(host=database_host, port=port, user=db_user, passwd=db_pass)
        cursor = db.cursor()

        # Locate the main .sql file
        main_sql_file = os.path.join(databases_dir, app_name, f"{app_name}.sql")

        # If main app_name.sql file exists, derive schema_name from it
        if os.path.isfile(main_sql_file):
            with open(main_sql_file, 'r') as file:
                sql_script = file.read()
                match_create = re.search(
                    r'CREATE\s+(?:DATABASE|SCHEMA)\s+(?:/\*.*?\*/\s*)?(?:IF\s+NOT\s+EXISTS\s+)?(?:/\*.*?\*/\s*)?`?([\w]+)`?\s*(?:/\*.*?\*/)?\s*(?:DEFAULT\s+CHARACTER\s+SET\s+\w+)?\s*(?:/\*.*?\*/)?\s*;',
                    sql_script, re.IGNORECASE | re.DOTALL
                )
                schema_name = match_create.group(1) if match_create else None

            if not schema_name:
                print(f"Unable to determine schema name from {main_sql_file}.")
                return

            # Verify schema existence
            cursor.execute(f"SHOW DATABASES LIKE '{schema_name}';")
            if not cursor.fetchone():
                print(f"Schema '{schema_name}' is not installed. Please install it first.")
                return

            # Check for the existence of the ersinstall table
            cursor.execute(f"USE `{schema_name}`;")
            cursor.execute(f"SHOW TABLES LIKE 'ersinstall';")
            if not cursor.fetchone():
                print(f"'{schema_name}.ersinstall' table is missing. Unable to fetch version info. Exiting.")
                return

            # Define the directory containing upgrade files and call process_upgrades
            upgrade_files_dir = os.path.join(databases_dir, app_name, "upgrades")
            process_upgrades(schema_name, upgrade_files_dir, database_host, port)

        # If no main app_name.sql, look for upgrades in each child directory
        else:
            app_dir = os.path.join(databases_dir, app_name)
            if os.path.isdir(app_dir):
                child_dirs = [d for d in os.listdir(app_dir) if os.path.isdir(os.path.join(app_dir, d))]

                for child_dir in child_dirs:
                    child_sql_file = os.path.join(app_dir, child_dir, f"{child_dir}.sql")
                    if os.path.isfile(child_sql_file):
                        with open(child_sql_file, 'r') as file:
                            sql_script = file.read()
                            match_create = re.search(
                                r'CREATE\s+(?:DATABASE|SCHEMA)\s+(?:/\*.*?\*/\s*)?(?:IF\s+NOT\s+EXISTS\s+)?(?:/\*.*?\*/\s*)?`?([\w]+)`?\s*(?:/\*.*?\*/)?\s*(?:DEFAULT\s+CHARACTER\s+SET\s+\w+)?\s*(?:/\*.*?\*/)?\s*;',
                                sql_script, re.IGNORECASE | re.DOTALL
                            )
                            schema_name = match_create.group(1) if match_create else None

                        if not schema_name:
                            print(f"Unable to determine schema name from {child_sql_file}.")
                            continue

                        # Verify schema existence
                        cursor.execute(f"SHOW DATABASES LIKE '{schema_name}';")
                        if not cursor.fetchone():
                            print(f"Schema '{schema_name}' is not installed. Please install it first.")
                            continue

                        # Check for the existence of the ersinstall table
                        cursor.execute(f"USE `{schema_name}`;")
                        cursor.execute(f"SHOW TABLES LIKE 'ersinstall';")
                        if not cursor.fetchone():
                            print(f"'{schema_name}.ersinstall' table is missing. Unable to fetch version info for {schema_name}. Skipping.")
                            continue

                        # Define directory containing upgrade files for this schema and process them
                        upgrade_files_dir = os.path.join(app_dir, child_dir, "upgrades")
                        process_upgrades(schema_name, upgrade_files_dir, database_host, port)
                    else:
                        print(f"No .sql file found in child directory {child_dir}, skipping...")
            else:
                print(f"No .sql files found for {app_name}.")
                return

    except pymysql.Error as e:
        print(f"Upgrade failed for {app_name}: {e}")
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

def get_schema_info(app_name, database_host='localhost', port=3306):
    """Fetch and print schema information, including status, version, and available upgrades."""
    port = port_check(port)
    db, cursor = None, None
    info_list = []

    try:
        db = pymysql.connect(host=database_host, port=port, user=db_user, passwd=db_pass)
        cursor = db.cursor()

        main_sql_file = os.path.join(databases_dir, app_name, f"{app_name}.sql")
        if os.path.isfile(main_sql_file):
            # Process as main directory schema
            schema_info = extract_schema_info(main_sql_file, app_name, app_name, database_host, port, cursor, upgrade_dir=os.path.join(databases_dir, app_name, "upgrades"))
            if schema_info:
                info_list.append(schema_info)
        else:
            # Process each child directory as a separate schema
            app_dir = os.path.join(databases_dir, app_name)
            if os.path.isdir(app_dir):
                for child_dir in os.listdir(app_dir):
                    child_sql_file = os.path.join(app_dir, child_dir, f"{child_dir}.sql")
                    if os.path.isfile(child_sql_file):
                        # Treat each child directory as its own schema
                        schema_info = extract_schema_info(child_sql_file, child_dir, app_name, database_host, port, cursor, upgrade_dir=os.path.join(app_dir, child_dir, "upgrades"))
                        if schema_info:
                            info_list.append(schema_info)
            else:
                print(f"No schema files found for '{app_name}'.")
                return

    except pymysql.Error as e:
        print(f"Database connection error: {e}")
    finally:
        if cursor:
            cursor.close()
        if db:
            db.close()

    # Print collected information for each schema
    for schema_info in info_list:
        print(f"App Name: {app_name}")
        print(f"Schema Name: {schema_info['schema_name']}")
        print(f"Status: {schema_info['status']}")
        print(f"Version: {schema_info['version']}")
        print(f"Available Upgrade Versions: {', '.join(schema_info['available_upgrades']) or 'None'}\n")

def extract_schema_info(sql_file, schema_name, app_name, database_host, port, cursor, upgrade_dir):
    """Extracts schema name, status, version, and available upgrades."""
    schema_info = {"schema_name": schema_name, "status": "Absent", "version": "None", "available_upgrades": []}

    # Extract schema name from SQL file
    with open(sql_file, 'r') as file:
        sql_script = file.read()
    match_create = re.search(
        r'CREATE\s+(?:DATABASE|SCHEMA)\s+(?:/\*.*?\*/\s*)?(?:IF\s+NOT\s+EXISTS\s+)?(?:/\*.*?\*/\s*)?`?([\w]+)`?\s*(?:/\*.*?\*/)?\s*(?:DEFAULT\s+CHARACTER\s+SET\s+\w+)?\s*(?:/\*.*?\*/)?\s*;',
        sql_script, re.IGNORECASE | re.DOTALL
    )
    if match_create:
        schema_info["schema_name"] = match_create.group(1)
    else:
        print(f"Unable to determine schema name from {sql_file}.")
        return None

    # Check if schema exists on DB_HOST
    cursor.execute(f"SHOW DATABASES LIKE '{schema_info['schema_name']}';")
    if cursor.fetchone():
        schema_info["status"] = "Present"

        # Fetch current version from ersinstall table
        cursor.execute(f"USE `{schema_info['schema_name']}`;")
        cursor.execute(f"SHOW TABLES LIKE 'ersinstall';")
        if cursor.fetchone():
            cursor.execute(f"SELECT Version FROM {schema_info['schema_name']}.ersinstall ORDER BY VersionKey DESC LIMIT 1;")
            result = cursor.fetchone()
            if result:
                schema_info["version"] = result[0]

    # Get available upgrade versions, only including .sql files and sorting numerically
    if os.path.isdir(upgrade_dir):
        upgrade_files = sorted(
            [f for f in os.listdir(upgrade_dir) if f.endswith('.sql') and os.path.isfile(os.path.join(upgrade_dir, f))],
            key=lambda x: tuple(int(part) if part.isdigit() else part for part in re.split(r'[._]', x))
        )
        available_versions = [
            re.sub(r'^.*__(.*)\.sql$', r'\1', f) for f in upgrade_files
        ]

        # Filter to show only versions greater than the current version if schema is installed
        if schema_info["version"] != "None":
            current_version_tuple = tuple(int(part) if part.isdigit() else part for part in re.split(r'[._]', schema_info["version"]))
            schema_info["available_upgrades"] = [
                version for version in available_versions
                if tuple(int(part) if part.isdigit() else part for part in re.split(r'[._]', version)) > current_version_tuple
            ]
        else:
            schema_info["available_upgrades"] = available_versions  # If not installed, show all versions

    return schema_info

def get_database_params():
    database_host = 'localhost'
    database_port = 3306
    extras = False

    # Loop through arguments to detect -H, -P, and --extras
    i = 3  # Start checking from the 3rd argument onwards
    while i < len(sys.argv):
        if sys.argv[i] == "-H":
            database_host = sys.argv[i + 1]
            i += 2
        elif sys.argv[i] == "-P":
            database_port = int(sys.argv[i + 1])
            i += 2
        elif sys.argv[i] == "--extras":
            extras = True
            i += 1
        else:
            i += 1

    return database_host, database_port, extras

def main():
    if len(sys.argv) == 1:
        display_usage()
    elif sys.argv[1] == "install":
        # Update to retrieve extras flag from get_database_params
        database_host, database_port, extras = get_database_params()
        if sys.argv[2] == "all_tr":
            install_all_tr_databases(dbs_list, database_host, database_port)
        elif sys.argv[2] == "all_rp":
            install_all_rp_databases(dbs_list, database_host, database_port)
        elif sys.argv[2] == "all":
            install_all_databases(database_host, database_port)
        else:
            app_name = sys.argv[2]
            install_database(app_name, database_host, database_port, extras=extras)  # Pass extras to install_database
        return  # Add return to prevent falling through to display_usage

    elif sys.argv[1] == "info":
        app_name = sys.argv[2]
        database_host, port, _ = get_database_params()  # Ignore extras for info command
        get_schema_info(app_name, database_host, port)
        return  # Add return after info command

    elif sys.argv[1] == "upgrade":
        app_name = sys.argv[2]
        database_host, port, _ = get_database_params()  # Ignore extras for upgrade command
        upgrade_database(app_name, database_host, port)
        return

    elif sys.argv[1] == "locale":
        database_host, database_port, _ = get_database_params()  # Ignore extras for locale commands
        if sys.argv[2] == "all_tr":
            apply_all_tr_locales(dbs_list, database_host, database_port)
        elif sys.argv[2] == "all_rp":
            apply_all_rp_locales(dbs_list, database_host, database_port)
        elif sys.argv[2] == "all":
            apply_all_locales(database_host, database_port)
        else:
            app_name = sys.argv[2]
            apply_locale(app_name, database_host, database_port)
        return

    elif sys.argv[1] == "connectivity":
        if len(sys.argv) == 2:
            check_connectivity()
        elif len(sys.argv) == 4 and sys.argv[2] == "-H":
            database_host = sys.argv[3]
            check_connectivity(database_host)
        elif len(sys.argv) == 4 and sys.argv[2] == "-P":
            port = int(sys.argv[3])
            check_connectivity(port=port)
        elif len(sys.argv) == 6 and sys.argv[2] == "-H" and sys.argv[4] == "-P":
            database_host = sys.argv[3]
            port = int(sys.argv[5])
            check_connectivity(database_host, port)
        return

    else:
        display_usage()

if __name__ == "__main__":
    main()
