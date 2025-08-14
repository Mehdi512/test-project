START TRANSACTION;

CREATE
DATABASE IF NOT EXISTS Refill;

USE Refill;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `associations`;
CREATE TABLE `associations` (
  `category_key` int(11) NOT NULL AUTO_INCREMENT,
  `type_key` int(11) NOT NULL DEFAULT '0',
  `item_key` int(11) NOT NULL DEFAULT '0',
  `ordinal` int(10) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_key`,`type_key`,`item_key`),
  KEY `category_key` (`category_key`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `category_type_ordinal` (`category_key`,`type_key`,`ordinal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `calendar_days`;
CREATE TABLE `calendar_days` (
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `catalogue_addresses`;
CREATE TABLE `catalogue_addresses` (
  `owner_key` int(11) NOT NULL DEFAULT '0',
  `street` varchar(64) NULL DEFAULT '',
  `zip` varchar(16) NULL DEFAULT '',
  `city` varchar(32) NULL DEFAULT '',
  `country` varchar(32) NULL DEFAULT '',
  `purpose` varchar(12) NULL DEFAULT '',
  `care_of` varchar(64) NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`owner_key`,`purpose`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `catalogue_attachments`;
CREATE TABLE `catalogue_attachments` (
  `attachment_key` int(11) NOT NULL AUTO_INCREMENT,
  `entry_key` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(80) NOT NULL DEFAULT '',
  `mime_type` varchar(20) NOT NULL DEFAULT '',
  `size` int(6) NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `data` mediumblob NOT NULL,
  PRIMARY KEY (`attachment_key`),
  KEY `entry_key` (`entry_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `catalogue_companies`;
CREATE TABLE `catalogue_companies` (
  `entry_key` int(11) NOT NULL AUTO_INCREMENT,
  `org_nr` varchar(16) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `_dynamic` blob NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`entry_key`),
  KEY `SECONDARY` (`org_nr`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `catalogue_contacts`;
CREATE TABLE `catalogue_contacts` (
  `owner_key` int(11) NOT NULL DEFAULT '0',
  `purpose`   varchar(12) NULL DEFAULT '0',
  `email`     varchar(1000) NULL DEFAULT '',
  `phone`     varchar(1000) NULL DEFAULT '',
  `_dynamic`  blob NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`owner_key`,`purpose`),
  KEY `EMAIL` (`email`),
  KEY `PHONE` (`phone`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `catalogue_persons`;
CREATE TABLE `catalogue_persons` (
  `entry_key` int(11) NOT NULL AUTO_INCREMENT,
  `id_nr` varchar(16) NOT NULL DEFAULT '',
  `name` varchar(64) DEFAULT '',
  `_dynamic` blob NOT NULL,
  `primary_employer` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`entry_key`),
  KEY `SECONDARY` (`id_nr`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `category_key` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(80) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `commission_contracts`;
CREATE TABLE `commission_contracts` (
  `contract_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `receiver_key1` int(11) NOT NULL DEFAULT '0',
  `receiver_key2` int(11) NOT NULL DEFAULT '0',
  `receiver_key3` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `country_key` int(11) NOT NULL DEFAULT '0',
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `chain_key` int(11) NOT NULL DEFAULT '0',
  `currency_key` int(11) NOT NULL DEFAULT '0',
  `id` varchar(20) NOT NULL DEFAULT '',
  `reseller_type_key` int(11) NOT NULL DEFAULT '0',
  `reseller_tag` varchar(45) DEFAULT NULL,
  `receiver_tag` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`contract_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cluster`;
CREATE TABLE `cluster` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cluster` varchar(40) NOT NULL DEFAULT '',
  `subcluster` varchar(255) NOT NULL DEFAULT '',
  `rank` int(11) NOT NULL DEFAULT 0,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `commission_receivers`;
CREATE TABLE `commission_receivers` (
  `receiver_key` int(11) NOT NULL AUTO_INCREMENT,
  `contract_key` int(11) NOT NULL DEFAULT '0',
  `region_key` int(11) NOT NULL DEFAULT '0',
  `name` varchar(80) NOT NULL DEFAULT '',
  `tag` varchar(80) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `logo_url` varchar(255) NOT NULL DEFAULT '',
  `address_key` int(11) NOT NULL DEFAULT '0',
  `report_url` varchar(255) NOT NULL DEFAULT '',
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `chain_key` int(11) NOT NULL DEFAULT '0',
  `rgroup` varchar(80) NOT NULL DEFAULT '',
  `subrgroup` varchar(80) NOT NULL DEFAULT '',
  `subsubrgroup` varchar(80) NOT NULL DEFAULT '',
  `timezone` varchar(80) NOT NULL DEFAULT '',
  `language` varchar(80) NOT NULL DEFAULT '',
  `invoicing_type` tinyint(2) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `country_key` int(11) NOT NULL DEFAULT '0',
  `subdevice_policy` tinyint(4) NOT NULL DEFAULT '0',
  `time_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_first_terminal_activation` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `custom_parameters` blob NOT NULL,
  `chain_store_id` varchar(80) NOT NULL DEFAULT '',
  `domain_key` int(11) NOT NULL DEFAULT '0',
  `type_key` int(11) NOT NULL DEFAULT '0',
  `tax_group_key` int(11) NOT NULL DEFAULT '0',
  `reseller_path` varchar(255) DEFAULT '',
  `fields` text NOT NULL,
  `cluster_id` int(11),
  `is_autotransfer` INT(11) NULL DEFAULT '0',
  PRIMARY KEY (`receiver_key`),
  KEY `chain_store_id` (`chain_store_id`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `chain_key_index` (`chain_key`),
  KEY `tag` (`tag`),
  KEY `reseller_path` (`reseller_path`),
  CONSTRAINT `fk_cluster_id`
  FOREIGN KEY (`cluster_id`)
  REFERENCES `cluster`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `commission_shop_settings`;
CREATE TABLE `commission_shop_settings` (
  `shop_key` int(11) NOT NULL AUTO_INCREMENT,
  `reseller_key` int(11) NOT NULL DEFAULT '0',
  `shop_tag` varchar(80) NOT NULL DEFAULT '',
  `shop_name` varchar(80) NOT NULL DEFAULT '',
  `shop_type` varchar(80) NOT NULL DEFAULT '',
  `product_selection_tag` varchar(80) NOT NULL DEFAULT '',
  `payment_options_tag` varchar(80) NOT NULL DEFAULT '',
  `application` varchar(36) NOT NULL DEFAULT '',
  `default_language` varchar(16) NOT NULL DEFAULT '',
  `custom_parameters` blob NOT NULL,
  `appearence_base` varchar(80) NOT NULL DEFAULT '',
  `appearence_addition` varchar(80) NOT NULL DEFAULT '',
  `receipt_template_key` int(11) NOT NULL DEFAULT '0',
  `product_range_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`shop_key`),
  KEY `product_range_key` (`product_range_key`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `shop_tag` (`shop_tag`),
  KEY `type_product_range` (`shop_type`,`product_range_key`),
  KEY `reseller_key` (`reseller_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `counting`;
CREATE TABLE `counting` (
  `category_key` int(11) NOT NULL DEFAULT '0',
  `type_key` int(11) NOT NULL DEFAULT '0',
  `nof_items` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_key`,`type_key`),
  KEY `category_key` (`category_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ctg_preparedsearch`;
CREATE TABLE `ctg_preparedsearch` (
  `search_key` int(11) NOT NULL AUTO_INCREMENT,
  `search_tag` varchar(80) NOT NULL DEFAULT '',
  `search_description` varchar(120) NOT NULL DEFAULT '',
  `search_statement` varchar(80) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`search_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_contract_price_entries`;
CREATE TABLE `dwa_contract_price_entries` (
  `entry_key` int(11) NOT NULL AUTO_INCREMENT,
  `contract_key` int(11) NOT NULL DEFAULT '0',
  `currency_key` int(11) NOT NULL DEFAULT '0',
  `product_key` int(11) NOT NULL DEFAULT '0',
  `valid_from` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `description` varchar(80) NOT NULL DEFAULT '',
  `comment` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`entry_key`),
  KEY `contract_key` (`contract_key`,`product_key`,`valid_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_delivery_addresses`;
CREATE TABLE `dwa_delivery_addresses` (
  `order_key` int(11) NOT NULL DEFAULT '0',
  `delivery_address_type` tinyint(4) NOT NULL DEFAULT '0',
  `delivery_address_string` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`order_key`),
  KEY `delivery_address_string` (`delivery_address_string`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_deliveryformats`;
CREATE TABLE `dwa_deliveryformats` (
  `format_key` int(11) NOT NULL AUTO_INCREMENT,
  `product_group_key` int(11) NOT NULL DEFAULT '0',
  `target_type` int(4) NOT NULL DEFAULT '0',
  `target_key` int(11) NOT NULL DEFAULT '0',
  `description` varchar(80) NOT NULL DEFAULT '',
  `format_template` text NOT NULL,
  `purpose` int(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mime_type` varchar(40) NOT NULL DEFAULT '',
  `template_type_key` int(11) NOT NULL DEFAULT '0',
  `language_key` int(11) NOT NULL DEFAULT '0',
  `scheduled_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `character_set` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`format_key`),
  KEY `class_type_purpose` (`product_group_key`,`template_type_key`,`purpose`,`scheduled_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_etopup_data`;
CREATE TABLE `dwa_etopup_data` (
  `order_key` int(11) NOT NULL DEFAULT '0',
  `subscriber_key` int(11) NOT NULL DEFAULT '0',
  `amount_value` bigint(20) NOT NULL DEFAULT '0',
  `amount_currency` varchar(3) NOT NULL DEFAULT 'SEK',
  `supplier_reference` varchar(20) NOT NULL DEFAULT '',
  `etopup_parameters` text NOT NULL,
  `result` int(11) NOT NULL DEFAULT '1',
  `internal_reference` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`order_key`),
  KEY `account_id` (`subscriber_key`),
  KEY `imported_reference` (`supplier_reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_etopup_products`;
CREATE TABLE `dwa_etopup_products` (
  `product_key` int(11) NOT NULL DEFAULT '0',
  `account_id_regexp` varchar(255) NOT NULL DEFAULT '0',
  `imported_reference_regexp` varchar(255) NOT NULL DEFAULT '0',
  `etopup_reversible` tinyint(4) NOT NULL DEFAULT '0',
  `receiver_type` tinyint(4) NOT NULL DEFAULT '0',
  `operator_link_key` int(11) NOT NULL DEFAULT '0',
  `etopup_confirmation` tinyint(4) NOT NULL DEFAULT '0',
  `etopup_parameters` varchar(255) NOT NULL DEFAULT '',
  `requires_approval` tinyint(4) NOT NULL DEFAULT '0',
  `topup_type` tinyint(2) DEFAULT '0',
  `contract_type` tinyint(2) DEFAULT '0',
  `contract_mandatory` tinyint(2) DEFAULT '1',
  `max_levels` tinyint(2) DEFAULT '1',
  `denomination_type` tinyint(2) NOT NULL DEFAULT '1',
  `denomination_face_value_source` tinyint(2) DEFAULT '0',
  `min_denomination` int(11) DEFAULT '0',
  `denomination_multiple` int(11) DEFAULT '0',
  `denomination_list` text,
  `sender_account_type_key` int(11) NOT NULL DEFAULT '0',
  `receiver_account_type_key` int(11) DEFAULT '0',
  PRIMARY KEY (`product_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_evoucher_products`;
CREATE TABLE `dwa_evoucher_products` (
  `product_key` int(11) NOT NULL DEFAULT '0',
  `item_format` int(4) NOT NULL DEFAULT '0',
  `value` int(11) NOT NULL DEFAULT '0',
  `default_reseller_price_value` int(11) NOT NULL DEFAULT '0',
  `default_reseller_price_currency` varchar(5) NOT NULL DEFAULT 'SEK',
  `default_customer_price_value` int(11) NOT NULL DEFAULT '0',
  `default_customer_price_currency` varchar(5) NOT NULL DEFAULT '',
  `default_distributor_price_value` int(11) NOT NULL DEFAULT '0',
  `default_distributor_price_currency` varchar(5) NOT NULL DEFAULT '',
  `stock_value` tinyint(1) NOT NULL DEFAULT '1',
  `pos_reprints` tinyint(1) NOT NULL DEFAULT '0',
  `pos_returns` tinyint(1) NOT NULL DEFAULT '0',
  `payment_account_type_key` int(11) NOT NULL DEFAULT '0',
  `regexp_requisition_count` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`product_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_exported_report_batches`;
CREATE TABLE `dwa_exported_report_batches` (
  `batch_key` int(11) NOT NULL AUTO_INCREMENT,
  `create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `delivered_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `from_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `to_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `chain_key` int(11) NOT NULL DEFAULT '0',
  `data_report_key` int(11) NOT NULL DEFAULT '0',
  `batch_report_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`batch_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_exported_reports`;
CREATE TABLE `dwa_exported_reports` (
  `report_key` int(11) NOT NULL AUTO_INCREMENT,
  `status` tinyint(3) NOT NULL DEFAULT '0',
  `reseller_key` int(11) NOT NULL DEFAULT '0',
  `create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `delivered_date` datetime DEFAULT NULL,
  `from_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `to_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `currency` varchar(20) NOT NULL DEFAULT '0',
  `nof_items` smallint(5) NOT NULL DEFAULT '0',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `data_report_key` int(11) NOT NULL DEFAULT '0',
  `invoice_nr` int(11) NOT NULL DEFAULT '0',
  `salespoint_type_key` int(11) NOT NULL DEFAULT '0',
  `state` int(4) NOT NULL DEFAULT '0',
  `payed_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `batch_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reseller_invoice_nr` int(11) NOT NULL DEFAULT '0',
  `chain_invoice_nr` int(11) NOT NULL DEFAULT '0',
  `distributor_invoice_nr` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`report_key`),
  KEY `reseller_key` (`reseller_key`),
  KEY `status` (`status`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `batch_key_index` (`batch_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_generic_invoice_nrs`;
CREATE TABLE `dwa_generic_invoice_nrs` (
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `generic_key` int(11) NOT NULL DEFAULT '0',
  `invoice_nr` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`type`,`generic_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_import_formats`;
CREATE TABLE `dwa_import_formats` (
  `format_key` int(11) NOT NULL AUTO_INCREMENT,
  `implementation_id` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `description` varchar(80) NOT NULL DEFAULT '',
  `import_script` varchar(255) NOT NULL DEFAULT '',
  `import_script_config` text NOT NULL,
  `import_format_handler` text NOT NULL,
  `encryption_type` int(4) NOT NULL DEFAULT '0',
  `secret_key_data` blob NOT NULL,
  `public_key_data` blob NOT NULL,
  `signature_key_data` blob NOT NULL,
  `has_encryption` tinyint(1) NOT NULL DEFAULT '0',
  `secret_key_passphrase` varchar(255) NOT NULL DEFAULT '',
  `has_signature` tinyint(1) NOT NULL DEFAULT '0',
  `encryption_key_description` varchar(255) NOT NULL DEFAULT '',
  `signature_key_description` varchar(255) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`format_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_import_logs`;
CREATE TABLE `dwa_import_logs` (
  `import_key` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `message` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`import_key`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_imports`;
CREATE TABLE `dwa_imports` (
  `import_key` int(11) NOT NULL AUTO_INCREMENT,
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `requisition_key` int(11) NOT NULL DEFAULT '0',
  `source` varchar(80) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `format` varchar(80) NOT NULL DEFAULT '',
  `status` int(4) NOT NULL DEFAULT '0',
  `submit_date` datetime DEFAULT NULL,
  `commit_date` datetime DEFAULT NULL,
  `class_key` int(11) NOT NULL DEFAULT '0',
  `count` int(4) NOT NULL DEFAULT '0',
  `first_serial` varchar(80) NOT NULL DEFAULT '',
  `last_serial` varchar(80) NOT NULL DEFAULT '',
  `unsorted` tinyint(1) NOT NULL DEFAULT '0',
  `status_text` varchar(255) NOT NULL DEFAULT '',
  `supplier_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `format_key` int(11) NOT NULL DEFAULT '0',
  `batch_id` varchar(40) NOT NULL DEFAULT '',
  `header_info` varchar(255) NOT NULL DEFAULT '',
  `min_expiry_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `max_expiry_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_sell_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `activation_reference` varchar(40) NOT NULL DEFAULT '',
  `purchase_order_id` varchar(40) NOT NULL DEFAULT '',
  `batch_create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `imported_reference` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`import_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_invoice_batch_creators`;
CREATE TABLE `dwa_invoice_batch_creators` (
  `creator_key` int(11) NOT NULL AUTO_INCREMENT,
  `reseller_keys` text NOT NULL,
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `chain_key` int(11) NOT NULL DEFAULT '0',
  `create_interval` tinyint(1) NOT NULL DEFAULT '0',
  `next_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `threshold_value` int(20) NOT NULL DEFAULT '0',
  `threshold_currency` varchar(10) NOT NULL DEFAULT '',
  `ordering` tinyint(1) NOT NULL DEFAULT '0',
  `salespoint_type_key` int(11) NOT NULL DEFAULT '1011',
  `batch_report_key` int(11) NOT NULL DEFAULT '0',
  `report_language` varchar(10) NOT NULL DEFAULT '',
  `description` varchar(80) NOT NULL DEFAULT '',
  `separate_credit_invoices` tinyint(1) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`creator_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_item_logs`;
CREATE TABLE `dwa_item_logs` (
  `log_key` int(11) NOT NULL AUTO_INCREMENT,
  `item_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `submit_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `from_item_status` int(4) NOT NULL DEFAULT '0',
  `to_item_status` int(4) NOT NULL DEFAULT '0',
  `request_info` int(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_itemclassprices`;
CREATE TABLE `dwa_itemclassprices` (
  `contract_key` int(11) NOT NULL DEFAULT '0',
  `class_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `comment` varchar(30) NOT NULL DEFAULT '',
  `reseller_price_value` int(11) NOT NULL DEFAULT '0',
  `customer_price_value` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reseller_price_currency` varchar(10) NOT NULL DEFAULT '',
  `customer_price_currency` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`contract_key`,`class_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_itemclassprices_history`;
CREATE TABLE `dwa_itemclassprices_history` (
  `contract_key` int(11) NOT NULL DEFAULT '0',
  `class_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `comment` varchar(40) NOT NULL DEFAULT '',
  `reseller_price_value` int(11) NOT NULL DEFAULT '0',
  `customer_price_value` int(11) NOT NULL DEFAULT '0',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contract_key`,`class_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_items`;
CREATE TABLE `dwa_items` (
  `item_key` int(11) NOT NULL AUTO_INCREMENT,
  `class_key` int(11) NOT NULL DEFAULT '0',
  `import_key` int(11) NOT NULL DEFAULT '0',
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `item_format` tinyint(4) NOT NULL DEFAULT '0',
  `serial` varchar(32) NOT NULL DEFAULT '',
  `external_reference` varchar(20) NULL DEFAULT '',
  `text_content` tinyblob NOT NULL,
  `price_value` bigint(20) NOT NULL DEFAULT '0',
  `price_currency` varchar(3) NOT NULL DEFAULT '',
  `in_price_value` bigint(20) NOT NULL DEFAULT '0',
  `in_price_currency` varchar(3) NOT NULL DEFAULT '',
  `unit_value` bigint(20) NOT NULL DEFAULT '0',
  `expiry_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `delivery_info` text NULL DEFAULT '',
  `usage_data` varchar(255) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_sell_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `extra_parameters` text NULL DEFAULT '',
  `region_key` int(11) NOT NULL DEFAULT '0',
  `ownerId` varchar(80) DEFAULT NULL,
  `reservationRef` varchar(25) NULL DEFAULT '',
  `reservationTime` datetime DEFAULT NULL,
  `reversal_reference`varchar(25) DEFAULT NULL,
  PRIMARY KEY (`item_key`),
  KEY `serial` (`serial`),
  KEY `reservationIndex` (`reservationRef`),
  KEY `status` (`status`),
  KEY `allocate_key` (`distributor_key`,`class_key`,`status`,`last_sell_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_items_snapshot`;
CREATE TABLE `dwa_items_snapshot` AS
SELECT class_key, SUM(IF(status=1,1,0)) as Available,SUM(if(status=0,1,0)) as Pending from Refill.dwa_items
where last_sell_date > now() AND STATUS IN (0, 1) group by class_key;

ALTER TABLE `Refill`.`dwa_items_snapshot`
ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT AFTER `Pending`,
ADD PRIMARY KEY (`id`);

DROP TABLE IF EXISTS `dwa_items_transition_details`;
CREATE TABLE `dwa_items_transition_details` (
  `TRANSITION_ID` int(11) NOT NULL AUTO_INCREMENT,
  `ITEM_KEY` int(11) NOT NULL,
  `VOUCHER_STATUS` tinyint(4) NOT NULL DEFAULT '0',
  `EXTRA_PARAMETERS` text DEFAULT NULL,
  `TRANSITION_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`TRANSITION_ID`),
  FOREIGN KEY `item_key_fk` (`ITEM_KEY`)
  REFERENCES `dwa_items`(`item_key`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=0001 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_items_export_batch`;
CREATE TABLE `dwa_items_export_batch` (
  `batch_key` int(11) NOT NULL AUTO_INCREMENT,
  `create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `comment` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`batch_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_items_exported`;
CREATE TABLE `dwa_items_exported` (
  `product_name` varchar(64) NOT NULL DEFAULT '',
  `product_SKU` varchar(32) NOT NULL DEFAULT '',
  `product_supplier_reference` varchar(32) NOT NULL DEFAULT '',
  `amount_value` int(11) NOT NULL DEFAULT '0',
  `voucher` varchar(32) NOT NULL DEFAULT '',
  `serial` varchar(32) NOT NULL DEFAULT '',
  `batch_key` int(11) NOT NULL DEFAULT '0',
  `item_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_order_log_reason_codes`;
CREATE TABLE `dwa_order_log_reason_codes` (
  `to_status` int(11) NOT NULL DEFAULT '0',
  `reason_code` varchar(10) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `from_status` int(11) NOT NULL DEFAULT '0',
  `system` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `for_status` (`to_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_order_logs`;
CREATE TABLE `dwa_order_logs` (
  `order_key` int(11) NOT NULL DEFAULT '0',
  `status` int(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `from_status` int(4) NOT NULL DEFAULT '0',
  `reason` varchar(255) NOT NULL DEFAULT '',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `reason_code` varchar(10) NOT NULL DEFAULT '',
  `reference` varchar(40) NOT NULL DEFAULT '',
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `report_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `imported_reference` varchar(40) NOT NULL DEFAULT '',
  `log_key` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`log_key`),
  KEY `order_key_status` (`order_key`,`status`),
  KEY `time` (`time`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_order_status_descriptions`;
CREATE TABLE `dwa_order_status_descriptions` (
  `status` int(11) NOT NULL DEFAULT '0',
  `name` varchar(40) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `selectable` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_orders`;
CREATE TABLE `dwa_orders` (
  `order_key` int(11) NOT NULL AUTO_INCREMENT,
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `item_key` int(11) NOT NULL DEFAULT '0',
  `item_class_key` int(11) NOT NULL DEFAULT '0',
  `invoice_key` int(11) NOT NULL DEFAULT '0',
  `payment_option_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `reseller_key` int(11) NOT NULL DEFAULT '0',
  `salespoint_type_key` int(11) NOT NULL DEFAULT '0',
  `salespoint_key` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(2) NOT NULL DEFAULT '0',
  `expiry_date` datetime DEFAULT NULL,
  `create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `delivery_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `delivered_by_user_key` int(11) NOT NULL DEFAULT '0',
  `delivery_count` tinyint(4) NOT NULL DEFAULT '0',
  `server_delivery_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reported_paid` int(11) NOT NULL DEFAULT '0',
  `reported_delivered` int(11) NOT NULL DEFAULT '0',
  `reported_returned` int(11) NOT NULL DEFAULT '0',
  `report_status` tinyint(3) NOT NULL DEFAULT '0',
  `report_status_tobe` tinyint(3) NOT NULL DEFAULT '0',
  `last_redelivery_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reseller_price_value` bigint(20) NOT NULL DEFAULT '0',
  `reseller_price_currency` varchar(3) NOT NULL DEFAULT '',
  `customer_price_value` bigint(20) NOT NULL DEFAULT '0',
  `customer_price_currency` varchar(3) NOT NULL DEFAULT '',
  `customer_direct_purchase` tinyint(2) DEFAULT NULL,
  `type` tinyint(4) NOT NULL DEFAULT '0',
  `delivery_template_type_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `subdevice_key` int(11) NOT NULL DEFAULT '0',
  `info_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`order_key`),
  KEY `delivery_date` (`delivery_date`),
  KEY `item_class_key` (`item_class_key`),
  KEY `salespoint_type_key` (`salespoint_type_key`),
  KEY `invoice_key` (`invoice_key`),
  KEY `item_key` (`item_key`),
  KEY `createdateindex` (`create_date`),
  KEY `delivered_by_user_key` (`delivered_by_user_key`),
  KEY `status_delivery_date` (`status`,`delivery_date`),
  KEY `salespoint_status_index` (`salespoint_key`,`status`),
  KEY `report_status_tobe_commission_key` (`report_status_tobe`,`reseller_key`),
  KEY `export_report` (`reseller_key`,`report_status_tobe`,`create_date`,`salespoint_type_key`),
  KEY `status_delivery_address_type` (`status`),
  KEY `reported_paid` (`reported_paid`),
  KEY `delivered_index` (`reported_delivered`),
  KEY `returned_index` (`reported_returned`),
  KEY `report_status_tobe_index` (`report_status_tobe`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `subdevice_status` (`subdevice_key`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_orders_info`;
CREATE TABLE `dwa_orders_info` (
  `order_key` int(11) NOT NULL DEFAULT '0',
  `info` varchar(40) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_key`),
  KEY `sales_data` (`info`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_orders_info2`;
CREATE TABLE `dwa_orders_info2` (
  `info_key` int(11) NOT NULL AUTO_INCREMENT,
  `info` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`info_key`),
  KEY `info` (`info`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_price_entry_ranges`;
CREATE TABLE `dwa_price_entry_ranges` (
  `entry_key` int(11) NOT NULL DEFAULT '0',
  `from_amount` bigint(20) NOT NULL DEFAULT '0',
  `to_amount` bigint(20) NOT NULL DEFAULT '0',
  `reseller_margin` int(11) NOT NULL DEFAULT '0',
  `customer_margin` int(11) NOT NULL DEFAULT '0',
  `margin_type` int(11) NOT NULL DEFAULT '0',
  `customer_bonus` int(11) NOT NULL DEFAULT '0',
  `bonus_type` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `entry_key` (`entry_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_pricing_scripts`;
CREATE TABLE `dwa_pricing_scripts` (
  `script_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(24) NOT NULL DEFAULT '',
  `source` text NOT NULL,
  PRIMARY KEY (`script_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_product_denominations`;
CREATE TABLE `dwa_product_denominations` (
  `product_key` int(11) NOT NULL DEFAULT '0',
  `sender_amount` bigint(20) NOT NULL DEFAULT '0',
  `receiver_amount` bigint(20) NOT NULL DEFAULT '0',
  `receiver_price` bigint(20) NOT NULL DEFAULT '0',
  `parameters` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_product_groups`;
CREATE TABLE `dwa_product_groups` (
  `product_group_key` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_key` int(11) NOT NULL DEFAULT '0',
  `description` varchar(80) NOT NULL DEFAULT '',
  `id_tag` varchar(40) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_group_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_products`;
CREATE TABLE `dwa_products` (
  `product_key` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_key` int(11) NOT NULL DEFAULT '0',
  `product_group_key` int(11) NOT NULL DEFAULT '0',
  `pricing_script_key` int(11) NOT NULL DEFAULT '0',
  `type` tinyint(1) NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `group_id` varchar(100) NOT NULL DEFAULT '',
  `group_name` varchar(45) DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `supplier_reference` varchar(80) NOT NULL DEFAULT '',
  `supplier_reference_group_id` varchar(80) DEFAULT '',
  `global_SKU` varchar(255) NOT NULL DEFAULT '',
  `EAN_code` varchar(255) NOT NULL DEFAULT '',
  `custom_parameters` varchar(1024) NOT NULL DEFAULT '',
  `available_from` datetime DEFAULT NULL,
  `available_until` datetime DEFAULT NULL,
  `currency` varchar(5) NOT NULL DEFAULT '',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `group_order` int(10) DEFAULT 0,
  PRIMARY KEY (`product_key`),
  KEY `supplier_reference` (`supplier_reference`),
  KEY `global_SKU` (`global_SKU`),
  KEY `EAN_code` (`EAN_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_receipt_templates`;
CREATE TABLE `dwa_receipt_templates` (
  `template_key` int(11) NOT NULL AUTO_INCREMENT,
  `reseller_unique` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(80) NOT NULL DEFAULT '',
  `type` int(4) NOT NULL DEFAULT '0',
  `format_template` blob NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `template_type_key` int(11) NOT NULL DEFAULT '0',
  `chain_key` int(11) NOT NULL DEFAULT '0',
  `purpose` int(4) NOT NULL DEFAULT '0',
  `language_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`template_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_requisition_rows`;
CREATE TABLE `dwa_requisition_rows` (
  `requisition_key` int(11) NOT NULL DEFAULT '0',
  `item_class_key` int(11) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  `receive_count` int(11) NOT NULL DEFAULT '0',
  `price_per_item_value` int(11) NOT NULL DEFAULT '0',
  `price_per_item_currency` varchar(3) NOT NULL DEFAULT '',
  PRIMARY KEY (`requisition_key`,`item_class_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_requisitions`;
CREATE TABLE `dwa_requisitions` (
  `requisition_key` int(11) NOT NULL AUTO_INCREMENT,
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `supplier_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `reference` varchar(20) NOT NULL DEFAULT '',
  `title` varchar(80) NOT NULL DEFAULT '',
  `note` text NOT NULL,
  `rows_locked` tinyint(4) NOT NULL DEFAULT '0',
  `create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `receive_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `invoice_id` varchar(30) NOT NULL DEFAULT '',
  `amount_paid_value` bigint(20) NOT NULL DEFAULT '0',
  `amount_paid_currency` varchar(3) NOT NULL DEFAULT '',
  `purchase_order_id` varchar(40) NOT NULL DEFAULT '',
  `invoice_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `custom_parameters` text NOT NULL,
  PRIMARY KEY (`requisition_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_reseller_invoice_nr`;
CREATE TABLE `dwa_reseller_invoice_nr` (
  `reseller_key` int(11) NOT NULL DEFAULT '0',
  `invoice_nr` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`reseller_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_segment_data`;
CREATE TABLE `dwa_segment_data` (
  `segment_data_key` int(11) NOT NULL AUTO_INCREMENT,
  `segment_id` varchar(16) NOT NULL,
  `type` varchar(6) NOT NULL DEFAULT '0',
  `amount_from` int(11) NOT NULL DEFAULT '0',
  `amount_to` int(11) NOT NULL DEFAULT '0',
  `data` varchar(64) NOT NULL DEFAULT '',
  `description` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`segment_data_key`),
  KEY `segment_key` (`segment_id`,`type`,`amount_from`,`amount_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_template_types`;
CREATE TABLE `dwa_template_types` (
  `type_key` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` varchar(20) NOT NULL DEFAULT '',
  `description` varchar(80) NOT NULL DEFAULT '',
  `mime_type` varchar(80) NOT NULL DEFAULT '',
  `mandatory` smallint(6) NOT NULL DEFAULT '0',
  `instruction_text` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`type_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_virtual_etopup_products`;
CREATE TABLE `dwa_virtual_etopup_products` (
  `row_key` int(11) NOT NULL AUTO_INCREMENT,
  `product_key` int(11) NOT NULL DEFAULT '0',
  `subproduct_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`row_key`),
  KEY `product_key` (`product_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ersinstall`;
CREATE TABLE `ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Script` varchar(200) NOT NULL,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_buffers`;
CREATE TABLE `extdev_buffers` (
  `device_key` int(11) NOT NULL DEFAULT '0',
  `item_type_key` int(11) NOT NULL DEFAULT '0',
  `item_key` int(11) NOT NULL DEFAULT '0',
  `min_buffer` int(4) NOT NULL DEFAULT '0',
  `preferred_buffer` int(4) NOT NULL DEFAULT '0',
  `max_buffer` int(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_key`,`item_type_key`,`item_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_buffers_history`;
CREATE TABLE `extdev_buffers_history` (
  `device_key` int(11) NOT NULL AUTO_INCREMENT,
  `item_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `min` int(11) NOT NULL DEFAULT '0',
  `threshold` int(11) NOT NULL DEFAULT '0',
  `preferred` int(11) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_key`),
  KEY `device_item` (`device_key`,`item_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_classes`;
CREATE TABLE `extdev_classes` (
  `class_key` int(11) NOT NULL AUTO_INCREMENT,
  `maint_server_key` int(11) NOT NULL DEFAULT '0',
  `id` varchar(80) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `manufacturer` varchar(80) NOT NULL DEFAULT '',
  `serial_prefix` varchar(80) NOT NULL DEFAULT '',
  `serial_digits` int(4) NOT NULL DEFAULT '8',
  `print_template_type_key` int(11) NOT NULL DEFAULT '0',
  `interaction_template_type_key` int(11) NOT NULL DEFAULT '0',
  `connection_pool_key` int(11) NOT NULL DEFAULT '0',
  `default_language` varchar(20) NOT NULL DEFAULT '',
  `default_buffer_type` tinyint(4) NOT NULL DEFAULT '0',
  `prepare_instructions` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `init_data` varchar(255) NOT NULL DEFAULT '',
  `allow_serial_select` tinyint(1) NOT NULL DEFAULT '0',
  `activate_instructions` text NOT NULL,
  `activation_code_type` int(4) NOT NULL DEFAULT '0',
  `default_signature_type` tinyint(4) NOT NULL DEFAULT '0',
  `default_encryption_type` tinyint(4) NOT NULL DEFAULT '0',
  `allow_remote_imprint` int(2) NOT NULL DEFAULT '0',
  `charset` varchar(80) NOT NULL DEFAULT 'ISO-8859-1',
  `supports_synchronization` tinyint(4) NOT NULL DEFAULT '1',
  `supports_remote_upgrade` tinyint(4) NOT NULL DEFAULT '1',
  `supports_service_code` tinyint(4) NOT NULL DEFAULT '1',
  `supports_properties` tinyint(4) NOT NULL DEFAULT '1',
  `properties_declarations` text NOT NULL,
  `supports_buffering` tinyint(4) NOT NULL DEFAULT '1',
  `supports_server_deactivation` tinyint(4) NOT NULL DEFAULT '0',
  `address_mandatory` tinyint(4) NOT NULL DEFAULT '0',
  `used` tinyint(4) NOT NULL DEFAULT '1',
  `default_user_role_key` int(11) NOT NULL DEFAULT '0',
  `report_group` varchar(80) NOT NULL DEFAULT '',
  `max_buffers` int(8) NOT NULL DEFAULT '0',
  `sync_window_start` int(8) NOT NULL DEFAULT '68400',
  `sync_window_end` int(8) NOT NULL DEFAULT '18000',
  `supports_ussd_push_service` tinyint(4) NOT NULL DEFAULT '0',
  `default_user_id` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`class_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_connection_pools`;
CREATE TABLE `extdev_connection_pools` (
  `pool_key` int(11) NOT NULL DEFAULT '0',
  `type` int(4) NOT NULL DEFAULT '0',
  `status` int(4) NOT NULL DEFAULT '0',
  `id` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `default_prefix` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`pool_key`),
  KEY `id` (`id`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_devices`;
CREATE TABLE `extdev_devices` (
  `device_key` int(11) NOT NULL AUTO_INCREMENT,
  `class_key` int(11) NOT NULL DEFAULT '0',
  `name` varchar(80) NOT NULL DEFAULT '',
  `serial` varchar(80) NOT NULL DEFAULT '',
  `state` int(4) NOT NULL DEFAULT '0',
  `activation_code` varchar(80) NOT NULL DEFAULT '',
  `owner_key` int(11) NOT NULL DEFAULT '0',
  `country_key` int(11) NOT NULL DEFAULT '0',
  `language_key` int(11) NOT NULL DEFAULT '0',
  `encryption_key` blob,
  `parameters` text NOT NULL,
  `parameters2` text,
  `type` varchar(80) NOT NULL DEFAULT '',
  `address` varchar(80) NOT NULL DEFAULT '',
  `compression_type` int(11) NOT NULL DEFAULT '0',
  `encryption_type` int(11) NOT NULL DEFAULT '0',
  `software_version` varchar(80) NOT NULL DEFAULT '',
  `software_build` varchar(80) NOT NULL DEFAULT '',
  `time_imprinted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_assigned` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_activated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `signature_key` blob,
  `signature_type` int(11) NOT NULL DEFAULT '0',
  `note` text NOT NULL,
  `position_status` int(11) NOT NULL DEFAULT '0',
  `primary_connection_point` varchar(80) NOT NULL DEFAULT '',
  `secondary_connection_point` varchar(80) NOT NULL DEFAULT '',
  `system_update_timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `products_update_timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `users_update_timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_syncronized` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `next_syncronize` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sync_window_start` int(10) NOT NULL DEFAULT '0',
  `sync_window_end` int(10) NOT NULL DEFAULT '0',
  `sync_interval` int(10) NOT NULL DEFAULT '86400',
  `download_status` int(4) NOT NULL DEFAULT '0',
  `next_software_download` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_syncronized_local` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_request_serial` int(11) NOT NULL DEFAULT '0',
  `device_buffer_type` int(11) NOT NULL DEFAULT '0',
  `last_state_change` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `max_buffers` int(11) NOT NULL DEFAULT '185',
  `max_categories` int(11) NOT NULL DEFAULT '0',
  `max_products` int(11) NOT NULL DEFAULT '0',
  `max_resources` int(11) NOT NULL DEFAULT '0',
  `max_users` int(11) NOT NULL DEFAULT '0',
  `last_software_download` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `receipt_template_type_key` int(11) NOT NULL DEFAULT '0',
  `interact_template_type_key` int(11) NOT NULL DEFAULT '0',
  `language` varchar(20) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activation_code_type` int(4) NOT NULL DEFAULT '0',
  `activation_instructions` text NOT NULL,
  `address_lock` varchar(40) NOT NULL DEFAULT '',
  `planned_deactivation_time` datetime DEFAULT NULL,
  `planned_activation_time` datetime DEFAULT NULL,
  `trace_level` int(11) NOT NULL DEFAULT '0',
  `default_user_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`device_key`),
  KEY `serial` (`serial`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `owner_key` (`owner_key`),
  KEY `default_user_key` (`default_user_key`),
  KEY `address` (`address`(16))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_history`;
CREATE TABLE `extdev_history` (
  `device_key` int(11) NOT NULL DEFAULT '0',
  `owner_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `state` int(4) NOT NULL DEFAULT '0',
  `name` varchar(80) NOT NULL DEFAULT '',
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `note` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_logs`;
CREATE TABLE `extdev_logs` (
  `item_key` int(11) NOT NULL AUTO_INCREMENT,
  `device_key` int(11) NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `type` int(4) NOT NULL DEFAULT '0',
  `code` int(8) NOT NULL DEFAULT '0',
  `message` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_key`),
  KEY `device_key` (`device_key`),
  KEY `timestamp` (`timestamp`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_messages`;
CREATE TABLE `extdev_messages` (
  `message_key` int(11) NOT NULL AUTO_INCREMENT,
  `device_key` int(11) NOT NULL DEFAULT '0',
  `from_user_key` int(11) NOT NULL DEFAULT '0',
  `status` int(4) NOT NULL DEFAULT '0',
  `send_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `read_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `subject` varchar(40) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `parameters2` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_key`),
  KEY `device_key` (`device_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_resources`;
CREATE TABLE `extdev_resources` (
  `resource_key` int(11) NOT NULL AUTO_INCREMENT,
  `class_key` int(11) NOT NULL DEFAULT '0',
  `resource_name` varchar(80) NOT NULL DEFAULT '',
  `filename` varchar(80) NOT NULL DEFAULT '',
  `mime_type` varchar(20) NOT NULL DEFAULT '',
  `size` int(6) NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `data` mediumblob NOT NULL,
  PRIMARY KEY (`resource_key`),
  KEY `entry_key` (`resource_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_session_logs`;
CREATE TABLE `extdev_session_logs` (
  `session_key` int(11) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `message` varchar(255) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `session_key` (`session_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_sessions`;
CREATE TABLE `extdev_sessions` (
  `session_key` int(11) NOT NULL AUTO_INCREMENT,
  `device_key` int(11) NOT NULL DEFAULT '0',
  `status` int(4) NOT NULL DEFAULT '0',
  `status_text` varchar(20) NOT NULL DEFAULT '',
  `source_address` varchar(20) NOT NULL DEFAULT '',
  `destination_address` varchar(20) NOT NULL DEFAULT '',
  `start_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `pool_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_key`),
  KEY `device_key` (`device_key`),
  KEY `status` (`status`),
  KEY `source_address` (`source_address`),
  KEY `pool_key` (`pool_key`),
  KEY `pool_key_status` (`pool_key`,`status`),
  KEY `device_start_index` (`device_key`,`start_date`),
  KEY `device_index` (`device_key`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `device_session` (`device_key`,`session_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_subdevice_history`;
CREATE TABLE `extdev_subdevice_history` (
  `subdevice_key` int(11) NOT NULL DEFAULT '0',
  `device_key` int(11) NOT NULL DEFAULT '0',
  `type` int(4) NOT NULL DEFAULT '0',
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `note` varchar(40) NOT NULL DEFAULT '',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `subdevice_key` (`subdevice_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_subdevice_users`;
CREATE TABLE `extdev_subdevice_users` (
  `user_key` int(11) NOT NULL AUTO_INCREMENT,
  `subdevice_key` int(11) NOT NULL DEFAULT '0',
  `reseller_key` int(11) NOT NULL DEFAULT '0',
  `user_id` varchar(40) NOT NULL DEFAULT '',
  `status` int(4) NOT NULL DEFAULT '0',
  `entry_key` int(11) NOT NULL DEFAULT '0',
  `time_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_activated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_key`),
  UNIQUE KEY `user_id_2` (`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_subdevices`;
CREATE TABLE `extdev_subdevices` (
  `subdevice_key` int(11) NOT NULL AUTO_INCREMENT,
  `device_key` int(11) NOT NULL DEFAULT '0',
  `class_key` int(11) NOT NULL DEFAULT '0',
  `reseller_key` int(11) NOT NULL DEFAULT '0',
  `subdevice_user_key` int(11) NOT NULL DEFAULT '0',
  `serial` varchar(80) NOT NULL DEFAULT '',
  `software_version` varchar(80) NOT NULL DEFAULT '',
  `state` int(4) NOT NULL DEFAULT '0',
  `state_text` varchar(80) NOT NULL DEFAULT '',
  `time_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `note` text NOT NULL,
  `signature_type` int(11) NOT NULL DEFAULT '0',
  `signature_key` blob NOT NULL,
  `encryption_type` int(11) NOT NULL DEFAULT '0',
  `encryption_key` blob NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `PUK` varchar(20) NOT NULL DEFAULT '',
  `custom_parameters` blob NOT NULL,
  `hardware_version` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`subdevice_key`),
  UNIQUE KEY `serial` (`serial`),
  KEY `device_key` (`device_key`),
  KEY `device_state` (`device_key`,`state`),
  KEY `state` (`state`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `last_modified` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_transaction_log`;
CREATE TABLE `extdev_transaction_log` (
  `transaction_key` int(11) NOT NULL AUTO_INCREMENT,
  `device_key` int(11) NOT NULL DEFAULT '0',
  `session_key` int(11) NOT NULL DEFAULT '0',
  `order_key` int(11) NOT NULL DEFAULT '0',
  `transaction_type` varchar(10) NOT NULL DEFAULT '',
  `transaction_id` varchar(20) NOT NULL DEFAULT '',
  `terminal_reference` varchar(20) NOT NULL DEFAULT '',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `result_code` varchar(10) NOT NULL DEFAULT '',
  `request_description` text NOT NULL,
  `response_description` text NOT NULL,
  `request_data` mediumblob NOT NULL,
  `response_data` mediumblob NOT NULL,
  `location_reference` varchar(20) NOT NULL DEFAULT '',
  `channel` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`transaction_key`),
  KEY `session_key` (`session_key`),
  KEY `order_key` (`order_key`),
  KEY `start_time` (`start_time`,`transaction_type`,`transaction_id`),
  KEY `imported_reference` (`terminal_reference`),
  KEY `device_transaction` (`device_key`,`transaction_id`),
  KEY `device_transaction_key` (`device_key`,`transaction_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `extdev_transaction_result_codes`;
CREATE TABLE `extdev_transaction_result_codes` (
  `transaction_type` varchar(10) NOT NULL DEFAULT '',
  `result_code` varchar(10) NOT NULL DEFAULT '',
  `description` text,
  PRIMARY KEY (`transaction_type`,`result_code`),
  KEY `transaction_type` (`transaction_type`,`result_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `hierarchy`;
CREATE TABLE `hierarchy` (
  `parent` int(11) NOT NULL DEFAULT '0',
  `child` int(11) NOT NULL DEFAULT '0',
  `ordinal` int(10) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`parent`,`child`),
  KEY `parent` (`parent`),
  KEY `child` (`child`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `parent_ordinal` (`parent`,`ordinal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_applicationgroups`;
CREATE TABLE `id_applicationgroups` (
  `ApplicationGroupKey` int(11) NOT NULL AUTO_INCREMENT,
  `ApplicationGroupName` varchar(64) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ApplicationGroupKey`),
  KEY `APPLICATIONGROUPNAME` (`ApplicationGroupName`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_audit_actions`;
CREATE TABLE `id_audit_actions` (
  `action_key` int(11) NOT NULL DEFAULT '0',
  `action` varchar(32) NOT NULL DEFAULT '',
  `description` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`action_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_audit_channels`;
CREATE TABLE `id_audit_channels` (
  `channel_key` int(11) NOT NULL DEFAULT '0',
  `channel` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`channel_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_audit_log`;
CREATE TABLE `id_audit_log` (
  `audit_entry_key` int(11) NOT NULL AUTO_INCREMENT,
  `user_key` int(11) NOT NULL DEFAULT '0',
  `action_key` int(11) NOT NULL DEFAULT '0',
  `channel_key` int(11) NOT NULL DEFAULT '0',
  `action_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` varchar(1000) NOT NULL DEFAULT '',
  PRIMARY KEY (`audit_entry_key`),
  KEY `date_user` (`action_date`,`user_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_connection_profiles`;
CREATE TABLE `id_connection_profiles` (
  `profile_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `description` varchar(128) NOT NULL DEFAULT '',
  `ip_addresses` varchar(256) NOT NULL DEFAULT '',
  `channel` varchar(256) NOT NULL DEFAULT  '',
  PRIMARY KEY (`profile_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_domainaccess`;
CREATE TABLE `id_domainaccess` (
  `DomainKey` int(11) NOT NULL DEFAULT '0',
  `UserKey` int(11) NOT NULL DEFAULT '0',
  `AccessRights` blob NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`DomainKey`,`UserKey`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_domains`;
CREATE TABLE `id_domains` (
  `DomainKey` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ParentDomainKey` int(11) NOT NULL DEFAULT '0',
  `PathName` varchar(64) NOT NULL DEFAULT '',
  `DynamicData` blob,
  `CreatorUserKey` int(11) NOT NULL DEFAULT '0',
  `ApplicationGroupKey` int(10) unsigned NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`DomainKey`),
  KEY `SECONDARY` (`PathName`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_password_policies`;
CREATE TABLE `id_password_policies` (
  `policy_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `change_policy` tinyint(4) NOT NULL DEFAULT '0',
  `visible_password` tinyint(1) NOT NULL DEFAULT '0',
  `password_min_length` tinyint(4) NOT NULL DEFAULT '0',
  `password_max_length` tinyint(4) NOT NULL DEFAULT '0',
  `password_regexp` varchar(80) NOT NULL DEFAULT '',
  `password_change_template_key` int(11) NOT NULL DEFAULT '0',
  `password_change_at_first_login` tinyint(1) NOT NULL DEFAULT '0',
  `legal_characters` tinyint(4) NOT NULL DEFAULT '0',
  `encryption_format` tinyint(4) NOT NULL DEFAULT '0',
  `create_policy` tinyint(4) NOT NULL DEFAULT '0',
  `create_message` tinyint(4) NOT NULL DEFAULT '0',
  `create_template_key` int(11) NOT NULL DEFAULT '0',
  `password_expiry_period` int(11) NOT NULL DEFAULT '0',
  `password_control` tinyint(4) NOT NULL DEFAULT '0',
  `banned_passwords` text NOT NULL,
  `incorrectlogin_max_attempt` tinyint(4) NOT NULL DEFAULT '0',
  `user_passwords_history` tinyint(4) NOT NULL DEFAULT '0',
  `make_user_editable` tinyint(1) NOT NULL DEFAULT '1',
  `dormancy_period` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`policy_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_role_scenario`;
CREATE TABLE `id_role_scenario` (
  `ScenarioKey` int(11) NOT NULL DEFAULT '0',
  `RoleKey` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ScenarioKey`,`RoleKey`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_roles`;
CREATE TABLE `id_roles` (
  `RoleKey` int(11) NOT NULL AUTO_INCREMENT,
  `RoleName` varchar(64) NOT NULL DEFAULT '',
  `RoleDescription` varchar(255) NOT NULL DEFAULT '',
  `DynamicData` blob NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `password_policy_key` int(11) NOT NULL DEFAULT '0',
  `domain_key` int(11) NOT NULL DEFAULT '0',
  `import_id` varchar(32) NOT NULL DEFAULT '',
  `terminal_user` tinyint(1) NOT NULL DEFAULT '0',
  `web_user` tinyint(1) NOT NULL DEFAULT '0',
  `address_lock` varchar(80) NOT NULL DEFAULT '',
  `userid_regexp` varchar(80) NOT NULL DEFAULT '',
  `parent_role_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`RoleKey`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_scenario_objects`;
CREATE TABLE `id_scenario_objects` (
  `ObjectKey` int(11) NOT NULL AUTO_INCREMENT,
  `ScenarioKey` int(11) NOT NULL DEFAULT '0',
  `ObjectPath` text NOT NULL,
  `AutoActivate` tinyint(1) NOT NULL DEFAULT '0',
  `ErrorMark` tinyint(4) NOT NULL DEFAULT '0',
  `Comment` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`ObjectKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_scenarios`;
CREATE TABLE `id_scenarios` (
  `ScenarioKey` int(11) NOT NULL AUTO_INCREMENT,
  `ScenarioName` varchar(64) NOT NULL DEFAULT '',
  `ScenarioDescription` varchar(255) NOT NULL DEFAULT '',
  `ScenarioGroup` varchar(80) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `domain_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ScenarioKey`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_tickets`;
CREATE TABLE `id_tickets` (
  `TicketKey` int(11) NOT NULL AUTO_INCREMENT,
  `UserKey` int(11) NOT NULL DEFAULT '0',
  `ExpiryDate` bigint(16) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`TicketKey`),
  KEY `USERKEY` (`UserKey`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_users`;
CREATE TABLE `id_users` (
  `UserKey` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` varchar(40) NOT NULL DEFAULT '',
  `Password` blob NOT NULL,
  `Status` int(4) NOT NULL DEFAULT '0',
  `IncorrectAttempts` int(4) NOT NULL DEFAULT '0',
  `LastIncorrectAttemptTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LastLoginTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CreationTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `TotalLogins` int(11) NOT NULL DEFAULT '777',
  `AddressKey` int(11) NOT NULL DEFAULT '0',
  `DomainKey` int(11) NOT NULL DEFAULT '0',
  `DynamicData` blob,
  `CreatorKey` int(11) NOT NULL DEFAULT '0',
  `password_expiry_period` int(11) NOT NULL DEFAULT '0',
  `password_expiry` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `password_format` int(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_password_change_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `role_key` int(4) NOT NULL DEFAULT '0',
  `connection_profile_key` int(4) NOT NULL DEFAULT '0',
  `fields` text NOT NULL,
  `time_in_mili_second` INT(11) NULL DEFAULT '0',
  PRIMARY KEY (`UserKey`),
  KEY `USERID` (`UserId`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `domainkey` (`DomainKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `id_users_passwords_history`;
CREATE TABLE `id_users_passwords_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `UserKey` int(11) NOT NULL DEFAULT '0',
  `Password` blob NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `password_format` int(4) NOT NULL DEFAULT '0',
  `time_in_mili_second` INT(11) NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_users_passwords_history_ibfk_1` (`UserKey`),
  CONSTRAINT `id_users_passwords_history_ibfk_1` FOREIGN KEY (`UserKey`) REFERENCES `id_users` (`UserKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `imp_definitions`;
CREATE TABLE `imp_definitions` (
  `definition_key` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL DEFAULT '0',
  `native_format_id` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `reformatter_id` varchar(20) NOT NULL DEFAULT '',
  `reformatter_config` text NOT NULL,
  `file_list` text NOT NULL,
  `interactive` tinyint(4) NOT NULL DEFAULT '0',
  `interactive_role_key` int(11) NOT NULL DEFAULT '0',
  `save_files` tinyint(4) NOT NULL DEFAULT '0',
  `automatic_imports` tinyint(4) NOT NULL DEFAULT '0',
  `automatic_msg_filter_key` int(11) NOT NULL DEFAULT '0',
  `automatic_interval` int(11) NOT NULL DEFAULT '0',
  `info` varchar(40) NOT NULL DEFAULT '',
  `info_template_key` int(11) NOT NULL DEFAULT '0',
  `complete_report_key` int(11) NOT NULL DEFAULT '0',
  `fail_report_key` int(11) NOT NULL DEFAULT '0',
  `import_parameters` text NOT NULL,
  `automatic_use_msg_body` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`definition_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `imp_import_files`;
CREATE TABLE `imp_import_files` (
  `import_key` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(100) NOT NULL DEFAULT '',
  `size` int(11) NOT NULL DEFAULT '0',
  `data` mediumblob NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `import_key` (`import_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `imp_import_logs`;
CREATE TABLE `imp_import_logs` (
  `import_key` int(11) NOT NULL DEFAULT '0',
  `log_type` tinyint(4) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `item_type_key` int(11) NOT NULL DEFAULT '0',
  `item_key` int(11) NOT NULL DEFAULT '0',
  `message` text NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `import_key` (`import_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `imp_imported_log_rows`;
CREATE TABLE `imp_imported_log_rows` (
  `log_key` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL DEFAULT '0',
  `title` varchar(20) NOT NULL DEFAULT '0',
  `data` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_key`),
  KEY `log_key` (`log_key`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `imp_imported_logs`;
CREATE TABLE `imp_imported_logs` (
  `log_key` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(20) NOT NULL DEFAULT '0',
  `name` varchar(40) NOT NULL DEFAULT '',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_key`),
  KEY `reference` (`reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `imp_imports`;
CREATE TABLE `imp_imports` (
  `import_key` int(11) NOT NULL AUTO_INCREMENT,
  `definition_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `time_submitted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_finished` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment` text NOT NULL,
  `summary` text NOT NULL,
  `import_parameters` text NOT NULL,
  PRIMARY KEY (`import_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `loc_VAT_levels`;
CREATE TABLE `loc_VAT_levels` (
  `VAT_Level_key` int(11) NOT NULL AUTO_INCREMENT,
  `country_key` int(11) NOT NULL DEFAULT '0',
  `name` varchar(20) NOT NULL DEFAULT '',
  `percentage` float NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VAT_Level_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `loc_countries`;
CREATE TABLE `loc_countries` (
  `country_key` int(11) NOT NULL AUTO_INCREMENT,
  `abbreviation` varchar(10) NOT NULL DEFAULT '',
  `name` varchar(40) NOT NULL DEFAULT '',
  `system_primary` tinyint(1) NOT NULL DEFAULT '0',
  `date_format` varchar(40) NOT NULL DEFAULT '',
  `time_format` varchar(40) NOT NULL DEFAULT '',
  `decimal_separator` varchar(5) NOT NULL DEFAULT '',
  `thousands_separator` varchar(5) NOT NULL DEFAULT '',
  `number_format` varchar(40) NOT NULL DEFAULT '',
  `number_regexp` varchar(40) NOT NULL DEFAULT '',
  `primary_currency_key` int(11) NOT NULL DEFAULT '0',
  `primary_language_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `selectable` tinyint(4) NOT NULL DEFAULT '0',
  `country_code` varchar(5) NOT NULL DEFAULT '',
  `MSISDN_significant_digits` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`country_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `loc_currencies`;
CREATE TABLE `loc_currencies` (
  `currency_key` int(11) NOT NULL AUTO_INCREMENT,
  `country_key` int(11) NOT NULL DEFAULT '0',
  `abbreviation` varchar(10) NOT NULL DEFAULT '',
  `name` varchar(40) NOT NULL DEFAULT '',
  `symbol` varchar(10) NOT NULL DEFAULT '',
  `natural_format` varchar(255) NOT NULL DEFAULT '',
  `minorcur_decimals` tinyint(4) NOT NULL DEFAULT '0',
  `minorcur_name` varchar(20) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `selectable` tinyint(4) NOT NULL DEFAULT '1',
  `currency_code` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`currency_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `loc_exchange_rate`;
CREATE TABLE `loc_exchange_rate` (
  `from_currency_key` int(11) NOT NULL DEFAULT '0',
  `to_currency_key` int(11) NOT NULL DEFAULT '0',
  `rate` float NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `loc_languages`;
CREATE TABLE `loc_languages` (
  `language_key` int(11) NOT NULL AUTO_INCREMENT,
  `country_key` int(11) NOT NULL DEFAULT '0',
  `abbreviation` varchar(10) NOT NULL DEFAULT '',
  `name` varchar(40) NOT NULL DEFAULT '',
  `native_name` varchar(40) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`language_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `log_benchmarks`;
CREATE TABLE `log_benchmarks` (
  `submit_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `grp` varchar(20) NOT NULL DEFAULT '',
  `id` varchar(20) NOT NULL DEFAULT '',
  `ms_time` int(8) NOT NULL DEFAULT '0',
  `info` text NOT NULL,
  PRIMARY KEY (`id`,`grp`),
  KEY `grp` (`grp`,`id`,`ms_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `log_entries`;
CREATE TABLE `log_entries` (
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `client_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `application` varchar(32) NOT NULL DEFAULT '',
  `description` varchar(32) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  `details` text NOT NULL,
  `ip` varchar(32) NOT NULL DEFAULT '',
  `session_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `create_time` (`create_time`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `msg_account_logs`;
CREATE TABLE `msg_account_logs` (
  `log_key` int(11) NOT NULL AUTO_INCREMENT,
  `account_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `message` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_key`),
  KEY `account_key` (`account_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `msg_accounts`;
CREATE TABLE `msg_accounts` (
  `account_key` int(11) NOT NULL AUTO_INCREMENT,
  `address_type` smallint(6) NOT NULL DEFAULT '0',
  `account_name` varchar(40) NOT NULL DEFAULT '',
  `account_status` smallint(6) NOT NULL DEFAULT '0',
  `account_type` smallint(6) NOT NULL DEFAULT '0',
  `sent_delete_delay` int(11) NOT NULL DEFAULT '0',
  `read_inbox_delete_delay` int(11) NOT NULL DEFAULT '0',
  `server_from_address` varchar(40) NOT NULL DEFAULT '',
  `parameters` text NOT NULL,
  `outgoing` tinyint(4) NOT NULL DEFAULT '0',
  `inbox_address_filter` text NOT NULL,
  `outbox_address_filter` text NOT NULL,
  `incoming` tinyint(4) NOT NULL DEFAULT '0',
  `account_id` varchar(40) NOT NULL DEFAULT '',
  `log_delete_delay` int(11) NOT NULL DEFAULT '0',
  `keystore` mediumblob NOT NULL,
  `priority` int(11) NOT NULL DEFAULT '0',
  `resend_delay` int(11) NOT NULL DEFAULT '60',
  `resend_attempts` int(11) NOT NULL DEFAULT '3',
  `store_messages` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`account_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `msg_destination_groups`;
CREATE TABLE `msg_destination_groups` (
  `group_key` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `destinations` text NOT NULL,
  PRIMARY KEY (`group_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `msg_filters`;
CREATE TABLE `msg_filters` (
  `filter_key` int(11) NOT NULL AUTO_INCREMENT,
  `account_key` int(11) NOT NULL DEFAULT '0',
  `folder` int(11) NOT NULL DEFAULT '0',
  `priority` int(11) NOT NULL DEFAULT '0',
  `subject_filter` varchar(80) NOT NULL DEFAULT '',
  `address_type` int(11) NOT NULL DEFAULT '0',
  `from_filter` varchar(80) NOT NULL DEFAULT '',
  `to_filter` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`filter_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `msg_messages`;
CREATE TABLE `msg_messages` (
  `MessageKey` int(11) NOT NULL AUTO_INCREMENT,
  `Subject` varchar(80) NOT NULL DEFAULT '',
  `FromAddress` varchar(80) DEFAULT '',
  `FromAddressType` int(4) NOT NULL DEFAULT '0',
  `ToAddress` varchar(80) NOT NULL DEFAULT '',
  `ToAddressType` int(4) NOT NULL DEFAULT '0',
  `Folder` int(8) NOT NULL DEFAULT '0',
  `OwnerUserKey` int(8) NOT NULL DEFAULT '0',
  `NativeHeader` text NOT NULL,
  `BodyMimeType` varchar(40) NOT NULL DEFAULT '',
  `Body` longtext NOT NULL,
  `MimeParts` longtext NOT NULL,
  `SendTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ReceiveTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ReadTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `CreateTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Status` int(4) NOT NULL DEFAULT '0',
  `Type` int(4) NOT NULL DEFAULT '0',
  `SendRetries` int(4) NOT NULL DEFAULT '0',
  `LastSendTryTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `account_key` int(11) NOT NULL DEFAULT '0',
  `BodyCharset` varchar(20) NOT NULL DEFAULT '',
  `ReadFlag` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`MessageKey`),
  KEY `to_address` (`ToAddress`),
  KEY `from_address` (`FromAddress`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `filter_index` (`account_key`,`ReadFlag`),
  KEY `ReadFlag` (`ReadFlag`),
  KEY `folder_read` (`Folder`,`ReadFlag`),
  KEY `read_time` (`ReadTime`),
  KEY `send_index` (`account_key`,`Folder`,`LastSendTryTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_account_applications`;
CREATE TABLE `pay_account_applications` (
  `application_key` int(11) NOT NULL AUTO_INCREMENT,
  `submitted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `managed_by_user` int(11) NOT NULL DEFAULT '0',
  `application_comment` varchar(255) NOT NULL DEFAULT '',
  `stated_issuer` varchar(64) NOT NULL DEFAULT '',
  `status` int(4) NOT NULL DEFAULT '0',
  `prereg_account_key` int(11) NOT NULL DEFAULT '0',
  `reseller_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_account_issuers`;
CREATE TABLE `pay_account_issuers` (
  `issuer_key` int(11) NOT NULL AUTO_INCREMENT,
  `issuer_name` varchar(64) NOT NULL DEFAULT '',
  `payment_option_key` int(11) NOT NULL DEFAULT '0',
  `country_key` int(11) NOT NULL DEFAULT '0',
  `issuer_comment` varchar(255) NOT NULL DEFAULT '',
  `account_provider_name` varchar(32) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`issuer_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_account_prefixes`;
CREATE TABLE `pay_account_prefixes` (
  `prefix_key` int(11) NOT NULL AUTO_INCREMENT,
  `issuer_key` int(11) NOT NULL DEFAULT '0',
  `from_account_nr_prefix` varchar(32) NOT NULL DEFAULT '',
  `to_account_nr_prefix` varchar(32) NOT NULL DEFAULT '',
  `prefix_type` varchar(32) NOT NULL DEFAULT '',
  `issuer_account_name` varchar(32) NOT NULL DEFAULT '',
  `min_length` int(4) NOT NULL DEFAULT '0',
  `max_length` int(4) NOT NULL DEFAULT '0',
  `is_valid` tinyint(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`prefix_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_account_types`;
CREATE TABLE `pay_account_types` (
  `account_type_key` int(11) NOT NULL AUTO_INCREMENT,
  `payment_option_key` int(11) NOT NULL DEFAULT '0',
  `type_id` varchar(40) NOT NULL DEFAULT '',
  `type_tag` varchar(80) NOT NULL DEFAULT '',
  `min_length` int(4) NOT NULL DEFAULT '0',
  `max_length` int(4) NOT NULL DEFAULT '0',
  `alphanumeric` tinyint(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_type_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_creditorders`;
CREATE TABLE `pay_creditorders` (
  `creditorder_key` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_key` int(11) NOT NULL DEFAULT '0',
  `debitorder_key` int(11) NOT NULL DEFAULT '0',
  `amount_value` bigint(20) NOT NULL DEFAULT '0',
  `amount_currency` varchar(10) NOT NULL DEFAULT 'SEK',
  `payment_option_key` int(11) NOT NULL DEFAULT '0',
  `implementation_id` varchar(20) NOT NULL DEFAULT '',
  `status` int(4) NOT NULL DEFAULT '0',
  `exported_reference` varchar(255) NOT NULL DEFAULT '',
  `imported_reference` varchar(255) NOT NULL DEFAULT '',
  `reason` varchar(255) NOT NULL DEFAULT '',
  `imported_reason` varchar(255) NOT NULL DEFAULT '',
  `imported_user_message` varchar(255) NOT NULL DEFAULT '',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `transaction_cost_value` bigint(20) NOT NULL DEFAULT '0',
  `transaction_cost_currency` varchar(20) NOT NULL DEFAULT 'SEK',
  `account_key` int(11) NOT NULL DEFAULT '0',
  `pay_account_type_key` int(11) NOT NULL DEFAULT '0',
  `pay_account_nr` varchar(255) NOT NULL DEFAULT '',
  `pay_account_expire_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `authentic` tinyint(1) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`creditorder_key`),
  KEY `accountkeyindex` (`account_key`),
  KEY `exported_reference` (`exported_reference`),
  KEY `invoice_key` (`invoice_key`),
  KEY `debitorder_key` (`debitorder_key`),
  KEY `payment_option_key` (`payment_option_key`),
  KEY `start_time` (`start_time`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_debitorders`;
CREATE TABLE `pay_debitorders` (
  `debitorder_key` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_key` int(11) NOT NULL DEFAULT '0',
  `amount_value` bigint(20) NOT NULL DEFAULT '0',
  `amount_currency` varchar(3) NOT NULL DEFAULT 'SEK',
  `payment_option_key` int(11) NOT NULL DEFAULT '0',
  `implementation_id` varchar(20) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `authentic` tinyint(1) NOT NULL DEFAULT '0',
  `exported_reference` varchar(20) NOT NULL DEFAULT '',
  `imported_reference` varchar(20) NOT NULL DEFAULT '',
  `reason` varchar(255) NOT NULL DEFAULT '',
  `imported_reason` varchar(255) NOT NULL DEFAULT '',
  `imported_user_message` varchar(255) NOT NULL DEFAULT '',
  `start_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `transaction_cost_value` bigint(20) NOT NULL DEFAULT '0',
  `transaction_cost_currency` varchar(3) NOT NULL DEFAULT 'SEK',
  `account_key` int(11) NOT NULL DEFAULT '0',
  `pay_account_type_key` int(11) NOT NULL DEFAULT '0',
  `pay_account_nr` varchar(40) NOT NULL DEFAULT '',
  `pay_account_expire_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`debitorder_key`),
  KEY `exported_reference` (`exported_reference`),
  KEY `invoice_key` (`invoice_key`),
  KEY `payment_option_key` (`payment_option_key`),
  KEY `start_time` (`start_time`),
  KEY `status_key` (`status`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `pay_account_nr_start_time` (`pay_account_nr`,`start_time`),
  KEY `account_status_time` (`account_key`,`status`,`start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_invoice_log`;
CREATE TABLE `pay_invoice_log` (
  `invoice_key` int(11) NOT NULL DEFAULT '0',
  `debitorder_key` int(11) DEFAULT NULL,
  `creditorder_key` int(11) DEFAULT NULL,
  `time_of_change` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reason` text NOT NULL,
  `imported_reason` text,
  `request_data` text,
  `response_data` text,
  `imported_user_message` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`time_of_change`,`invoice_key`),
  KEY `invoice_key` (`invoice_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_invoice_rows`;
CREATE TABLE `pay_invoice_rows` (
  `row_key` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_key` int(11) NOT NULL DEFAULT '0',
  `product_SKU` varchar(32) NOT NULL DEFAULT '',
  `product_dist_SKU` varchar(32) NOT NULL DEFAULT '',
  `product_name` varchar(40) NOT NULL DEFAULT '',
  `product_count` tinyint(4) NOT NULL DEFAULT '0',
  `total_price_value` bigint(11) NOT NULL DEFAULT '0',
  `total_price_currency` varchar(3) NOT NULL DEFAULT '',
  `external_type_key` int(11) NOT NULL DEFAULT '0',
  `external_key` int(11) NOT NULL DEFAULT '0',
  `require_status` tinyint(1) NOT NULL DEFAULT '1',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`row_key`),
  KEY `invoice_key_index` (`invoice_key`),
  KEY `external_key` (`external_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_invoices`;
CREATE TABLE `pay_invoices` (
  `invoice_key` int(11) NOT NULL AUTO_INCREMENT,
  `user_key` int(11) NOT NULL DEFAULT '0',
  `issuer_description` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `exported_reference` varchar(40) NOT NULL DEFAULT '',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `amount_value` bigint(20) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `reseller_key` int(11) NOT NULL DEFAULT '0',
  `delivery_address_type` tinyint(4) NOT NULL DEFAULT '0',
  `delivery_address_string` varchar(80) NOT NULL DEFAULT '',
  `payment_due_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `imported_reference` varchar(40) NOT NULL DEFAULT '',
  `currency` varchar(3) NOT NULL DEFAULT 'EUR',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`invoice_key`),
  KEY `status_index` (`status`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_options`;
CREATE TABLE `pay_options` (
  `account_type_key` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(32) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `url` varchar(64) NOT NULL DEFAULT '',
  `status` int(4) NOT NULL DEFAULT '1',
  `description` varchar(255) NOT NULL DEFAULT '',
  `balance_check` tinyint(1) NOT NULL DEFAULT '0',
  `reseller_account_type` tinyint(1) NOT NULL DEFAULT '0',
  `account_sharing_policy` tinyint(1) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `payment_currency_key` int(11) NOT NULL DEFAULT '0',
  `min_account_balance` bigint(20) NOT NULL DEFAULT '0',
  `max_account_balance` bigint(20) NOT NULL DEFAULT '0',
  `min_transaction_amount` bigint(20) NOT NULL DEFAULT '0',
  `max_transaction_amount` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_type_key`),
  UNIQUE KEY `id_index` (`id`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_prefix_type`;
CREATE TABLE `pay_prefix_type` (
  `prefix_type_key` int(11) NOT NULL AUTO_INCREMENT,
  `prefix_type_name` varchar(64) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`prefix_type_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_prereg_accounts`;
CREATE TABLE `pay_prereg_accounts` (
  `account_key` int(11) NOT NULL AUTO_INCREMENT,
  `payment_account_type_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `account_name` varchar(80) NOT NULL DEFAULT '',
  `pay_limit_value` bigint(20) NOT NULL DEFAULT '0',
  `pay_limit_currency` varchar(3) NOT NULL DEFAULT 'SEK',
  `transaction_limit_count` int(11) DEFAULT '0',
  `account_type` varchar(20) NOT NULL DEFAULT '',
  `account_nr` varchar(255) NOT NULL DEFAULT '',
  `account_expire_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `owner_type_key` int(11) NOT NULL DEFAULT '0',
  `owner_key` int(11) NOT NULL DEFAULT '0',
  `master_owner_key` int(11) NOT NULL,
  `account_type_key` int(11) NOT NULL DEFAULT '0',
  `issuer_key` int(11) NOT NULL DEFAULT '0',
  `pay_limit_period` int(11) NOT NULL DEFAULT '168',
  `issuer_name` varchar(32) NOT NULL DEFAULT '',
  `issuer_account_name` varchar(32) NOT NULL DEFAULT '',
  `prefix_key` int(11) NOT NULL DEFAULT '0',
  `account_provider_name` varchar(32) NOT NULL DEFAULT '',
  `valid_from` datetime NOT NULL DEFAULT '1970-01-01 01:00:00',
  `valid_to` datetime DEFAULT '2010-01-01 00:00:00',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `min_account_balance` bigint(20) NOT NULL DEFAULT '0',
  `max_account_balance` bigint(20) NOT NULL DEFAULT '0',
  `min_transaction_amount` bigint(20) NOT NULL DEFAULT '0',
  `max_transaction_amount` bigint(20) NOT NULL DEFAULT '0',
  `default_pay_limit` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_key`),
  KEY `tmstmp_index` (`last_modified`),
  KEY `owner_key` (`owner_key`),
  KEY `account_nr` (`account_nr`),
  KEY `master_owner` (`master_owner_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_references`;
CREATE TABLE `pay_references` (
  `reference_key` int(11) NOT NULL AUTO_INCREMENT,
  `prefix` varchar(255) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`reference_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `productclasses`;
CREATE TABLE `productclasses` (
  `productclass_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`productclass_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `productinstances`;
CREATE TABLE `productinstances` (
  `productinstance_key` int(11) NOT NULL AUTO_INCREMENT,
  `productclass_key` int(11) NOT NULL DEFAULT '0',
  `supplier_key` int(11) NOT NULL DEFAULT '0',
  `global_artnr` varchar(80) NOT NULL DEFAULT '',
  `reseller_artnr` varchar(80) NOT NULL DEFAULT '',
  `reseller_id` varchar(80) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `image_path` text NOT NULL,
  `direct_path` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`productinstance_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rep_batch_reports`;
CREATE TABLE `rep_batch_reports` (
  `batch_report_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `report_template_key` int(11) NOT NULL DEFAULT '0',
  `input_field_values` text NOT NULL,
  `interval_type` int(4) NOT NULL DEFAULT '0',
  `batch_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `language` varchar(2) NOT NULL DEFAULT 'en',
  `nof_reports_to_store` int(4) NOT NULL DEFAULT '0',
  `destinations` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `groupname` varchar(80) NOT NULL DEFAULT '',
  `system_type` tinyint(4) NOT NULL DEFAULT '0',
  `id` varchar(20) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `version` varchar(20) NOT NULL DEFAULT '1',
  `system_report` tinyint(4) NOT NULL DEFAULT '0',
  `standard_report` tinyint(4) NOT NULL DEFAULT '0',
  `customer_reference` varchar(20) NOT NULL DEFAULT '',
  `last_modified_by` varchar(20) NOT NULL DEFAULT '',
  `owner` varchar(20) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`batch_report_key`),
  KEY `reportindex` (`report_template_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rep_exported_batch_report_queries`;
CREATE TABLE `rep_exported_batch_report_queries` (
  `exported_batch_report_key` int(11) NOT NULL DEFAULT '0',
  `query` text NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `result` text NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `exported_batch_report_key` (`exported_batch_report_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rep_exported_batch_report_tables`;
CREATE TABLE `rep_exported_batch_report_tables` (
  `exported_batch_report_table_key` int(11) NOT NULL AUTO_INCREMENT,
  `exported_batch_report_key` int(11) NOT NULL DEFAULT '0',
  `name` varchar(40) NOT NULL DEFAULT '',
  `table_column_names` text NOT NULL,
  `table_data` longtext NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`exported_batch_report_table_key`),
  KEY `reportindex` (`exported_batch_report_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rep_exported_batch_reports`;
CREATE TABLE `rep_exported_batch_reports` (
  `exported_batch_report_key` int(11) NOT NULL AUTO_INCREMENT,
  `batch_report_key` int(11) NOT NULL DEFAULT '0',
  `create_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `report_field_values` text NULL DEFAULT '',
  `owner_key` int(11) NOT NULL DEFAULT '0',
  `owner_use` varchar(80) NOT NULL DEFAULT '',
  `finished_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `system_key` int(11) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`exported_batch_report_key`),
  KEY `reportindex` (`batch_report_key`),
  KEY `owner_key_use` (`owner_key`,`owner_use`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rep_settings`;
CREATE TABLE `rep_settings` (
  `id` int(11) NOT NULL DEFAULT '0',
  `standard_system_key` int(11) NOT NULL DEFAULT '1',
  `direct_system_key` int(11) NOT NULL DEFAULT '1',
  `archive_system_key` int(11) NOT NULL DEFAULT '1',
  `denorm_system_key` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rep_systems`;
CREATE TABLE `rep_systems` (
  `system_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL DEFAULT '',
  `host` varchar(80) NOT NULL DEFAULT '',
  `dbname` varchar(80) NOT NULL DEFAULT '',
  `user` varchar(80) NOT NULL DEFAULT '',
  `password` varchar(80) NOT NULL DEFAULT '',
  `available` tinyint(4) NOT NULL DEFAULT '0',
  `default_priority` int(11) NOT NULL DEFAULT '0',
  `max_sessions` int(11) NOT NULL DEFAULT '0',
  `custom_parameters` text NOT NULL,
  `query_timeout` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`system_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rep_template_layouts`;
CREATE TABLE `rep_template_layouts` (
  `template_key` int(11) NOT NULL DEFAULT '0',
  `id` varchar(20) NOT NULL DEFAULT '',
  `mime_type` varchar(255) NOT NULL DEFAULT '',
  `format_language` varchar(20) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `template` text NOT NULL,
  PRIMARY KEY (`template_key`,`id`),
  KEY `template_key` (`template_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `rep_templates`;
CREATE TABLE `rep_templates` (
  `report_template_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `sql_queries` text NOT NULL,
  `layouts` text NULL DEFAULT '',
  `layout_mime_types` text NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `groupname` varchar(80) NOT NULL DEFAULT '',
  `input_fields` text NOT NULL,
  `input_field_defaults` text NOT NULL,
  `declared_fields` varchar(250) NOT NULL DEFAULT '',
  `system_type` tinyint(4) NOT NULL DEFAULT '0',
  `id` varchar(20) NOT NULL DEFAULT '',
  `layout_titles` text NULL DEFAULT '',
  `version` varchar(20) NOT NULL DEFAULT '1',
  `system_report` tinyint(4) NOT NULL DEFAULT '0',
  `standard_report` tinyint(4) NOT NULL DEFAULT '0',
  `customer_reference` varchar(20) NOT NULL DEFAULT '',
  `last_modified_by` varchar(20) NOT NULL DEFAULT '',
  `owner` varchar(20) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`report_template_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_account_template`;
CREATE TABLE `reseller_account_template` (
  `reseller_type_key` int(11) NOT NULL DEFAULT '0',
  `account_type_key` int(11) NOT NULL DEFAULT '0',
  `account_type_prefix` varchar(20) NOT NULL DEFAULT '',
  `account_type_mode` tinyint(2) NOT NULL DEFAULT '0',
  `account_pay_limit_period` int(11) NOT NULL DEFAULT '86400',
  `account_transaction_limit_count` int(11) NOT NULL DEFAULT '0',
  `account_pay_limit_value` bigint(20) NOT NULL DEFAULT '10000000',
  `account_credit_limit` bigint(20) DEFAULT '0',
  `min_account_balance` bigint(20) NOT NULL DEFAULT '0',
  `max_account_balance` bigint(20) NOT NULL DEFAULT '0',
  `min_transaction_amount` bigint(20) NOT NULL DEFAULT '0',
  `max_transaction_amount` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_type_key`,`reseller_type_key`),
  KEY `reseller_type_key` (`reseller_type_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_chains`;
CREATE TABLE `reseller_chains` (
  `chain_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `logon_domain_key` int(11) NOT NULL DEFAULT '0',
  `distributor_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`chain_key`),
  KEY `distributor_key` (`distributor_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_distributors`;
CREATE TABLE `reseller_distributors` (
  `distributor_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL DEFAULT '',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `logon_domain_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`distributor_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_hierarchy`;
CREATE TABLE `reseller_hierarchy` (
  `parent_key` int(11) NOT NULL DEFAULT '0',
  `child_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`parent_key`,`child_key`),
  KEY `parent_key` (`parent_key`,`child_key`),
  KEY `child_key` (`child_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_id_generator_settings`;
CREATE TABLE `reseller_id_generator_settings` (
  `prefix` varchar(80) NOT NULL DEFAULT '',
  `suffix_digits` int(11) NOT NULL DEFAULT '0',
  `suffix_count` varchar(80) NOT NULL DEFAULT '0',
  PRIMARY KEY (`prefix`,`suffix_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_product_ranges`;
CREATE TABLE `reseller_product_ranges` (
  `product_range_key` int(11) NOT NULL AUTO_INCREMENT,
  `country_key` int(11) NOT NULL DEFAULT '0',
  `root_category_key` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `tag` varchar(80) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `last_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `product_tree` text NOT NULL,
  `item_keys` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_range_key`),
  KEY `tag` (`tag`),
  KEY `country_key` (`country_key`,`status`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_tax_groups`;
CREATE TABLE `reseller_tax_groups` (
  `group_key` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(16) NOT NULL DEFAULT '',
  `name` varchar(64) NOT NULL DEFAULT '',
  `tax_entries` blob NOT NULL,
  PRIMARY KEY (`group_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_type_children`;
CREATE TABLE `reseller_type_children` (
  `type_key` int(11) NOT NULL DEFAULT '0',
  `child_type_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`type_key`,`child_type_key`),
  KEY `type_key` (`type_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_types`;
CREATE TABLE `reseller_types` (
  `type_key` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(40) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `allow_id_specification` tinyint(4) NOT NULL DEFAULT '0',
  `id_regexp` text NOT NULL,
  `allow_id_autogeneration` tinyint(4) NOT NULL DEFAULT '0',
  `id_generator` text NOT NULL,
  `used` tinyint(4) NOT NULL DEFAULT '0',
  `allow_toplevel` tinyint(4) NOT NULL DEFAULT '0',
  `allow_webshop` tinyint(4) NOT NULL DEFAULT '0',
  `allow_terminals` tinyint(4) NOT NULL DEFAULT '0',
  `allow_weblogin` tinyint(4) NOT NULL DEFAULT '0',
  `allow_parentless` tinyint(4) NOT NULL DEFAULT '0',
  `subdevice_policy` tinyint(4) NOT NULL DEFAULT '0',
  `adminsite_supportreportgroup` varchar(40) NOT NULL DEFAULT '',
  `default_tax_group_key` int(11) NOT NULL DEFAULT '0',
  `default_contract_key` int(11) NOT NULL DEFAULT '0',
  `default_product_range_key` int(11) NOT NULL DEFAULT '0',
  `default_receipt_template_key` int(11) NOT NULL DEFAULT '0',
  `RoleKey` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`type_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `resources`;
CREATE TABLE `resources` (
  `datakey` varchar(239) NOT NULL DEFAULT '',
  `data` blob NOT NULL,
  `LastUpdated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ResourceGroup` varchar(16) NOT NULL DEFAULT '?(????)',
  `startup` datetime DEFAULT NULL,
  `touched` datetime DEFAULT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`datakey`,`ResourceGroup`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `stk_messages`;
CREATE TABLE `stk_messages` (
  `code` int(11) NOT NULL DEFAULT '0',
  `description` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_operator_links`;
CREATE TABLE `sup_operator_links` (
  `link_key` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_key` int(11) NOT NULL DEFAULT '0',
  `link_id` varchar(20) NOT NULL DEFAULT '0',
  `name` varchar(40) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `account_type_name` varchar(40) NOT NULL DEFAULT '',
  `max_topup_count` int(11) NOT NULL DEFAULT '0',
  `max_topup_amount` bigint(20) NOT NULL DEFAULT '0',
  `max_topup_period` int(11) NOT NULL DEFAULT '0',
  `max_topup_currency` varchar(10) NOT NULL DEFAULT '',
  `payments_allowed` tinyint(4) NOT NULL DEFAULT '1',
  `max_payment_amount` bigint(20) NOT NULL DEFAULT '0',
  `max_payment_amount_currency` varchar(10) NOT NULL DEFAULT '0',
  `payment_registration_required` tinyint(4) NOT NULL DEFAULT '1',
  `payment_PIN_required` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`link_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_subscriber_accounts`;
CREATE TABLE `sup_subscriber_accounts` (
  `subscriber_key` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` varchar(80) NOT NULL DEFAULT '',
  `last_order_key` int(11) NOT NULL DEFAULT '0',
  `last_order_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `total_topups` int(11) NOT NULL DEFAULT '0',
  `total_amount` bigint(20) NOT NULL DEFAULT '0',
  `comment` varchar(255) NOT NULL DEFAULT '',
  `group_key` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(2) NOT NULL DEFAULT '0',
  `payment_allowed` tinyint(1) NOT NULL DEFAULT '0',
  `payment_PIN_format` tinyint(2) DEFAULT NULL,
  `payment_PIN` tinyblob NOT NULL,
  `PIN_retries` tinyint(4) NOT NULL DEFAULT '0',
  `imported_reference` varchar(40) NOT NULL DEFAULT '',
  `contact_address_type` tinyint(4) NOT NULL DEFAULT '0',
  `contact_address` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`subscriber_key`),
  KEY `account_id` (`account_id`),
  KEY `imported_reference` (`imported_reference`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_subscriber_counters`;
CREATE TABLE `sup_subscriber_counters` (
  `counter_key` int(11) NOT NULL AUTO_INCREMENT,
  `subscriber_key` int(11) NOT NULL DEFAULT '0',
  `counters_id` varchar(20) NOT NULL DEFAULT '',
  `day` int(11) NOT NULL DEFAULT '0',
  `day_count` int(11) NOT NULL DEFAULT '0',
  `day_sum` int(11) NOT NULL DEFAULT '0',
  `week` int(11) NOT NULL DEFAULT '0',
  `week_count` int(11) NOT NULL DEFAULT '0',
  `week_sum` int(11) NOT NULL DEFAULT '0',
  `month` int(11) NOT NULL DEFAULT '0',
  `month_count` int(11) NOT NULL DEFAULT '0',
  `month_sum` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`counter_key`),
  KEY `subscriber_key` (`subscriber_key`,`counters_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_subscriber_groups`;
CREATE TABLE `sup_subscriber_groups` (
  `group_key` int(11) NOT NULL AUTO_INCREMENT,
  `link_key` int(11) NOT NULL DEFAULT '0',
  `group_id` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `default_group` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`group_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_subscriber_profile_details`;
CREATE TABLE `sup_subscriber_profile_details` (
  `profile_version_key` int(11) NOT NULL DEFAULT '0',
  `from_amount` bigint(20) NOT NULL DEFAULT '0',
  `to_amount` bigint(20) NOT NULL DEFAULT '0',
  `tax_type` int(11) NOT NULL DEFAULT '0',
  `tax_value` int(11) NOT NULL DEFAULT '0',
  `supervision_fee_expiry_days` int(11) NOT NULL DEFAULT '0',
  `service_fee_expiry_days` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `profile_version_key` (`profile_version_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_subscriber_profile_versions`;
CREATE TABLE `sup_subscriber_profile_versions` (
  `profile_version_key` int(11) NOT NULL AUTO_INCREMENT,
  `profile_key` int(11) NOT NULL DEFAULT '0',
  `valid_from` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`profile_version_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_subscriber_profiles`;
CREATE TABLE `sup_subscriber_profiles` (
  `profile_key` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_key` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`profile_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_supplier_users`;
CREATE TABLE `sup_supplier_users` (
  `supplier_key` int(11) NOT NULL DEFAULT '0',
  `user_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`supplier_key`,`user_key`),
  KEY `supplier_key` (`supplier_key`),
  KEY `user_key` (`user_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_suppliers`;
CREATE TABLE `sup_suppliers` (
  `SupplierKey` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(80) NOT NULL DEFAULT '',
  `Description` varchar(255) NOT NULL DEFAULT '',
  `OrgId` varchar(40) NOT NULL DEFAULT '',
  `MainURL` varchar(255) NOT NULL DEFAULT '',
  `LogoURL` varchar(255) NOT NULL DEFAULT '',
  `LogoURLSecondary` varchar(255) NOT NULL DEFAULT '',
  `LinkURL` varchar(255) NOT NULL DEFAULT '',
  `offer_email` varchar(255) NOT NULL DEFAULT '',
  `contact_info` text NOT NULL,
  `delivery_terms` text NOT NULL,
  `pay_options` text NOT NULL,
  `purchase_info` text NOT NULL,
  `general_info` text NOT NULL,
  `tag` varchar(40) NOT NULL DEFAULT '',
  `import_format` varchar(40) NOT NULL DEFAULT '',
  `country_key` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `import_format_key` int(11) NOT NULL DEFAULT '0',
  `activation_reference_required` tinyint(4) NOT NULL DEFAULT '0',
  `last_sell_date_margin` int(11) NOT NULL DEFAULT '0',
  `requisition_submit_report_key` int(11) NOT NULL DEFAULT '0',
  `import_submit_report_key` int(11) NOT NULL DEFAULT '0',
  `import_activate_report_key` int(11) NOT NULL DEFAULT '0',
  `import_expiry_report_key` int(11) NOT NULL DEFAULT '0',
  `import_revoke_report_key` int(11) NOT NULL DEFAULT '0',
  `cancellation_report_key` int(11) NOT NULL DEFAULT '0',
  `requisitions_required` tinyint(4) NOT NULL DEFAULT '0',
  `requisition_cancel_report_key` int(11) NOT NULL DEFAULT '0',
  `requisition_close_report_key` int(11) NOT NULL DEFAULT '0',
  `import_cancel_report_key` int(11) NOT NULL DEFAULT '0',
  `import_error_report_key` int(11) NOT NULL DEFAULT '0',
  `voucher_delivery_time` int(11) NOT NULL DEFAULT '0',
  `check_purchase_order_id` int(11) NOT NULL DEFAULT '0',
  `report_addresses` text NOT NULL,
  `stock_margin_days` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`SupplierKey`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sup_suppliers_info`;
CREATE TABLE `sup_suppliers_info` (
  `SupplierKey` int(11) NOT NULL DEFAULT '0',
  `contact_persion` varchar(80) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(80) NOT NULL DEFAULT '',
  `fax_nr` varchar(80) NOT NULL DEFAULT '',
  `phone_nr` varchar(80) NOT NULL DEFAULT '',
  `internal_text` text NOT NULL,
  `delivery_terms_text` text NOT NULL,
  `year_established` int(11) NOT NULL DEFAULT '0',
  `open_buy_policy` int(11) NOT NULL DEFAULT '0',
  `pay_options` varchar(255) NOT NULL DEFAULT '',
  `delivery_options` varchar(255) NOT NULL DEFAULT '',
  `return_policy` varchar(255) NOT NULL DEFAULT '',
  `warranty_policy` varchar(255) NOT NULL DEFAULT '',
  `insurance_options` varchar(255) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `sys_encryption_profiles`;
CREATE TABLE `sys_encryption_profiles` (
  `profile_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL DEFAULT '',
  `description` varchar(80) NOT NULL DEFAULT '',
  `encryption_type` tinyint(4) NOT NULL DEFAULT '0',
  `key_description` text NOT NULL,
  `secret_key_data` blob NOT NULL,
  `secret_key_passphrase` tinyblob,
  `public_key_data` blob NOT NULL,
  `signature_key_description` text NOT NULL,
  `signature_key_data` blob NOT NULL,
  PRIMARY KEY (`profile_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tickets`;
CREATE TABLE `tickets` (
  `TicketKey` int(11) NOT NULL AUTO_INCREMENT,
  `UserKey` int(11) NOT NULL DEFAULT '0',
  `ExpiryDate` bigint(11) NOT NULL DEFAULT '0',
  `Signature` bigint(20) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`TicketKey`),
  KEY `USERKEY` (`UserKey`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `translator_translations`;
CREATE TABLE `translator_translations` (
  `tag` varchar(80) NOT NULL DEFAULT '',
  `language` varchar(3) NOT NULL DEFAULT '',
  `domain` varchar(80) NOT NULL DEFAULT '',
  `translation` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tag`,`domain`,`language`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `types`;
CREATE TABLE `types` (
  `type_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL DEFAULT '',
  `owner` varchar(80) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`type_key`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `userfields`;
CREATE TABLE `userfields` (
  `UserKey` int(11) NOT NULL DEFAULT '0',
  `Name` varchar(40) NOT NULL DEFAULT '',
  `Value` varchar(255) NOT NULL DEFAULT '',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserKey`,`Name`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `userprivileges`;
CREATE TABLE `userprivileges` (
  `UserKey` int(11) NOT NULL DEFAULT '0',
  `SubsystemKey` int(11) NOT NULL DEFAULT '0',
  `ReadAccess` int(4) NOT NULL DEFAULT '0',
  `ModifyAccess` int(4) NOT NULL DEFAULT '0',
  `CreateAccess` int(4) NOT NULL DEFAULT '0',
  `DeleteAccess` int(4) NOT NULL DEFAULT '0',
  `AdminAccess` int(4) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserKey`,`SubsystemKey`),
  KEY `USERKEY` (`UserKey`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `UserKey` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` varchar(80) NOT NULL DEFAULT '',
  `Password` varchar(80) NOT NULL DEFAULT '',
  `verification_level` int(4) NOT NULL DEFAULT '0',
  `first_name` varchar(80) NOT NULL DEFAULT '',
  `last_name` varchar(80) NOT NULL DEFAULT '',
  `email` varchar(80) NOT NULL DEFAULT '',
  `phone` varchar(80) NOT NULL DEFAULT '',
  `address` text NOT NULL,
  `country` varchar(80) NOT NULL DEFAULT '',
  `language` varchar(80) NOT NULL DEFAULT '',
  `Status` int(4) NOT NULL DEFAULT '0',
  `IncorrectAttempts` int(4) NOT NULL DEFAULT '0',
  `LastIncorrectTime` bigint(20) NOT NULL DEFAULT '0',
  `ApplicationGroup` varchar(16) NOT NULL DEFAULT '',
  `LogonDomain` bigint(20) NOT NULL DEFAULT '0',
  `AddressKey` int(11) NOT NULL DEFAULT '0',
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserKey`),
  KEY `IDKEY` (`UserId`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `agent_supervisor_loc_map`;
CREATE TABLE `agent_supervisor_loc_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_region` varchar(64) NOT NULL,
  `agent_location` varchar(64) NOT NULL,
  `agent_cluster` varchar(64) NOT NULL,
  `agent_name` varchar(64) NOT NULL,
  `agent_msisdn` varchar(16) NOT NULL,
  `supervisor_name` varchar(64) NOT NULL,
  `supervisor_msisdn` varchar(16) NOT NULL,
  `manager_name` varchar(64) NOT NULL,
  `manager_msisdn` varchar(16) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `agent_info` (`agent_msisdn`, `agent_region`, `agent_location`, `agent_cluster`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `cluster_update_info`;
CREATE TABLE `cluster_update_info` (
  `reseller_id` varchar(80) NOT NULL DEFAULT '',
  `reseller_msisdn` varchar(64) NOT NULL,
  `old_cluster_id` int(11) ,
  `new_cluster_id` int(11) ,
  `migration_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cluster_cycle`  int(11) ,
  `fields` text NOT NULL,
  KEY `tmstmp_index` (`migration_date`),
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `agent_target_data`;
CREATE TABLE `agent_target_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_msisdn` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `start_date` DATE DEFAULT NULL,
  `end_date` DATE DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TRIGGER IF EXISTS `dwa_items_after_insert`;
DELIMITER $$
CREATE TRIGGER dwa_items_after_insert
AFTER INSERT
  ON dwa_items FOR EACH ROW

BEGIN

  -- Insert record into audit table
  INSERT INTO dwa_items_transition_details
  ( ITEM_KEY,
    VOUCHER_STATUS,
    EXTRA_PARAMETERS, TRANSITION_TIME)
  VALUES
  ( NEW.item_key,
    NEW.status,
     NEW.extra_parameters,
     NEW.last_modified );
     -- Check for dwa_items_snapshot updates&inserts
    IF ( NEW.status=0 || NEW.status=1) THEN

        IF (NEW.class_key NOT IN(SELECT snap.class_key FROM dwa_items_snapshot snap)) THEN
            INSERT INTO dwa_items_snapshot
            (CLASS_KEY,
            AVAILABLE,
            PENDING)
            VALUES
            (NEW.class_key,
             IF(NEW.status=1,1,0),IF(NEW.status=0,1,0));
        ELSE
           UPDATE dwa_items_snapshot set AVAILABLE = case when NEW.status=1 then AVAILABLE + 1 else AVAILABLE end, PENDING = case when NEW.status=0 then PENDING + 1 else PENDING end where class_key=NEW.class_key;
       END IF;
   END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `dwa_items_after_update`;
DELIMITER $$
CREATE TRIGGER dwa_items_after_update
AFTER UPDATE
   ON dwa_items FOR EACH ROW

BEGIN
   -- Insert record into audit table
   INSERT INTO dwa_items_transition_details
   ( ITEM_KEY,
     VOUCHER_STATUS,
     EXTRA_PARAMETERS, TRANSITION_TIME)
   VALUES
   ( NEW.item_key,
     NEW.status,
	 NEW.extra_parameters,
	 NEW.last_modified );
	 -- Start check for updating snapshot table
   IF (NEW.status != OLD.status) THEN
       IF (NEW.status=0 || NEW.status=1) THEN
          UPDATE dwa_items_snapshot set AVAILABLE = case when NEW.status=1 then AVAILABLE + 1 else AVAILABLE end, PENDING = case when NEW.status=0 then PENDING + 1 else PENDING end where class_key=NEW.class_key;
          UPDATE dwa_items_snapshot set AVAILABLE = case when OLD.status=1 then AVAILABLE - 1 else AVAILABLE end, PENDING = case when OLD.status=0 then PENDING - 1 else PENDING end where class_key=NEW.class_key;
       ELSE
        UPDATE dwa_items_snapshot set AVAILABLE = case when OLD.status=1 then AVAILABLE - 1 else AVAILABLE end, PENDING = case when OLD.status=0 then PENDING - 1 else PENDING end where class_key=NEW.class_key;

       END IF;

   END IF;
END
$$
DELIMITER ;

DROP TRIGGER IF EXISTS `dwa_items_after_delete`;
DELIMITER $$
CREATE TRIGGER dwa_items_after_delete
AFTER DELETE
   ON dwa_items FOR EACH ROW

BEGIN
   -- delete record into audit table
   DELETE FROM dwa_items_transition_details
   WHERE ITEM_KEY = OLD.item_key;
   -- Start logic for changes in snapshot table
   IF (OLD.class_key IN(SELECT snap.class_key FROM dwa_items_snapshot snap)) THEN
    IF (OLD.status=0 || OLD.status=1) THEN
     UPDATE dwa_items_snapshot set AVAILABLE = case when OLD.status=1 then AVAILABLE - 1 else AVAILABLE end, PENDING = case when OLD.status=0 then PENDING - 1 else PENDING end where class_key=OLD.class_key;
    END IF;
   END IF;
END$$
DELIMITER ;


-- principal_type '1' represents Reseller and '2' represents Subscriber
-- service_status '0' means block and '1' means unblocked
DROP TABLE IF EXISTS `principal_service_status`;
CREATE TABLE `principal_service_status` (
  `principal_id` varchar(80) NOT NULL,
  `principal_type` tinyint(1) NOT NULL DEFAULT '0',
  `service_status` tinyint(1) NOT NULL DEFAULT '1',
  `service_name` varchar(32) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`principal_id`,`principal_type`,`service_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Introduced dwa_contract_account_types, dwa_contract_margin_type, dwa_contract_account_tags and dwa_contract_margin_rules to
-- configure new contract margin rules, these data can be configured by UI from admin portal

DROP TABLE IF EXISTS `dwa_contract_margin_rules`;
CREATE TABLE `dwa_contract_margin_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `entry_key` int(11) DEFAULT NULL,
  `entry_range_key` int(11) DEFAULT NULL,
  `account_id` varchar(80) DEFAULT NULL,
  `pay_options_account_type_id` varchar(80) DEFAULT NULL,
  `contract_account_type_id` int(11) DEFAULT NULL,
  `value_type_id` int(11) DEFAULT NULL,
  `value_expression` varchar(256) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_contract_value_type`;
CREATE TABLE `dwa_contract_value_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_contract_account_types`;
CREATE TABLE `dwa_contract_account_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `account_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `dwa_contract_tags`;
CREATE TABLE `dwa_contract_tags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `subscriber_bonus_rule`;
CREATE TABLE `subscriber_bonus_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bonus_type` VARCHAR(40) NOT NULL,
  `bonus_amount` DECIMAL (11,2) NOT NULL,
  `valid_from` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `valid_till` timestamp NOT NULL,
  `amount_from` DECIMAL (11,2) NOT NULL DEFAULT 0,
  `amount_till` DECIMAL (11,2) NOT NULL,
  `criteria_type` VARCHAR(80) NOT NULL,
  `criteria_value` VARCHAR(200) NOT NULL,
  `bonus_validity_duration` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `eligible_sub_Index` (`criteria_value`, `amount_from`, `amount_till`, `valid_from`, `valid_till`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_link_kyc`;
CREATE TABLE `reseller_link_kyc` (
  `reseller_type_key` int(11) NOT NULL,
  `kyc_id` int(11) NOT NULL,
  PRIMARY KEY (`reseller_type_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_kyc`;
CREATE TABLE `reseller_kyc` (
  `kyc_id` int(11) NOT NULL,
  `kyc_property` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`kyc_id`,`kyc_property`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_extra_params`;
CREATE TABLE `reseller_extra_params` (
  `extra_paramId` int(11) NOT NULL AUTO_INCREMENT,
  `parameter_key` varchar(45) DEFAULT NULL,
  `parameter_value` varchar(45) DEFAULT NULL,
  `receiver_key` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`extra_paramId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_profile_id`;
CREATE TABLE `reseller_profile_id` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_name` varchar(45) DEFAULT NULL,
  `partner_name` varchar(45) DEFAULT NULL,
  `profile_id` int(11) DEFAULT NULL ,
  `credit_limit_period` bigint(20) NOT NULL DEFAULT 0,
  `credit_limit` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `reseller_short_code_generator_settings`;
CREATE TABLE `reseller_short_code_generator_settings` (
  `reseller_type` varchar(80) NOT NULL DEFAULT '',
  `suffix_count` varchar(80) NOT NULL DEFAULT '0',
  PRIMARY KEY (`reseller_type`,`suffix_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `reseller_extra_params`
  ADD CONSTRAINT `constraint_reseller_extra_params_parameter_key_receiver_key` UNIQUE (parameter_key, receiver_key);

DROP TABLE IF EXISTS `dwa_contract_audit_entries`;
CREATE TABLE `dwa_contract_audit_entries` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_key` int(11) DEFAULT '0',
  `product_key` int(11) DEFAULT '0',
  `entry_key` int(11) DEFAULT NULL,
  `entry_range_key` int(11) DEFAULT NULL,
  `from_amount` bigint(20) DEFAULT '0',
  `to_amount` bigint(20) DEFAULT '0',
  `valid_from` datetime DEFAULT '0000-00-00 00:00:00',
  `valid_until` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `margin_rule_key` int(11) DEFAULT '0',
  `account_id` varchar(80) DEFAULT NULL,
  `pay_options_account_type_id` int(11) DEFAULT NULL,
  `contract_account_type_id` int(11) DEFAULT NULL,
  `value_type_id` int(11) DEFAULT NULL,
  `value_expression` varchar(256) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_customers`;
CREATE TABLE `reseller_customers` (
  `customer_national_identification_id` varchar(45) NOT NULL,
  `customer_name` varchar(40) DEFAULT NULL,
  `contact_msisdn` varchar(40) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `facebook` varchar(40) DEFAULT NULL,
  `is_tax_payer` tinyint(1) DEFAULT NULL,
  `tax_payer_type` varchar(40) DEFAULT NULL,
  `tax_payer_name` varchar(40) DEFAULT NULL,
  `tax_payer_id` varchar(40) DEFAULT NULL,
  `is_tax_vat_enabled` tinyint(1) DEFAULT NULL,
  `customer_id` varchar(255) NOT NULL,
  `created_on` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_on` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_id` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `reseller_extra_param_keys`;
CREATE TABLE `reseller_extra_param_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter_key` varchar(40) NULL,
  `is_unique` boolean NULL,
  `is_mutable` boolean NULL,
  `widget_type` varchar(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `reseller_type_params`;
CREATE TABLE `reseller_type_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_key` varchar(40) NULL,
  `parameter_key` varchar(40) NULL,
  `is_mandatory` varchar(40) NULL,
  `default_value` varchar(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_account_types`;
CREATE TABLE `reseller_account_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_type_key` int(11) NULL,
  `account_type_id` varchar(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_accounts`;
CREATE TABLE `reseller_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reseller_id` varchar(40) NULL,
  `account_id` varchar(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_lifecycle`;
CREATE TABLE `reseller_lifecycle` (
  `reseller_id` varchar(80) NOT NULL,
  `balance_lifeline` timestamp NULL,
  `balance_status` varchar(50) NULL,
  `scratchcard_lifeline` timestamp NULL,
  `scratchcard_status` varchar(50) NULL,
  `last_balance_inactive` timestamp NULL,
  `last_scratchcard_inactive` timestamp NULL,
  `has_grace_period` boolean NOT NULL DEFAULT FALSE,
  `newly_created` boolean NOT NULL DEFAULT TRUE,
  `remaining_inventory` int NULL,
  PRIMARY KEY (`reseller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `prefix_counter`;
CREATE TABLE `prefix_counter` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `prefix` varchar(250) DEFAULT '',
  `counter` int(16) NOT NULL,
  `type` varchar(255) NOt NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_prefix_type` (`prefix`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `asset_type`;
CREATE TABLE `asset_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `asset`;
CREATE TABLE `asset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `type` smallint(6) NOT NULL,
  `owner_id` varchar(80) NOT NULL,
  `description` varchar(250) DEFAULT NULL,
  `status` varchar(40) DEFAULT 'Active',
  PRIMARY KEY (`id`),
  KEY `FK_asset_type` (`type`),
  KEY `FK_owner_id` (`owner_id`),
  CONSTRAINT `FK_asset_type` FOREIGN KEY (`type`) REFERENCES `asset_type` (`id`),
  CONSTRAINT `FK_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `commission_receivers` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `asset_allocation`;
CREATE TABLE `asset_allocation` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `assignee_id` varchar(80) NOT NULL,
  `allocation_start_date` date DEFAULT NULL,
  `allocation_end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_asset_id` (`asset_id`),
  KEY `FK_assignee_id` (`assignee_id`),
  CONSTRAINT `FK_asset_id` FOREIGN KEY (`asset_id`) REFERENCES `asset` (`id`),
  CONSTRAINT `FK_assignee_id` FOREIGN KEY (`assignee_id`) REFERENCES `commission_receivers` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `reseller_type_prefixes`;
CREATE TABLE `reseller_type_prefixes` (
    `type_key` SMALLINT(6) NOT NULL,
    `prefix` VARCHAR(20) NOT NULL,
    `last_modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`type_key`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `reseller_allowed_types`;
CREATE TABLE `reseller_allowed_types` (
  `type_key` int(11) NOT NULL DEFAULT '0',
  `allowed_type_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`type_key`,`allowed_type_key`),
  KEY `type_key` (`type_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_template_dropdown`;
CREATE TABLE `reseller_template_dropdown` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(250) NOT NULL,
  `field_value` varchar(250) NOT NULL,
  `associated_field_name` varchar(250) DEFAULT NULL,
  `associated_field_value` varchar(250) DEFAULT NULL,
  `created_on` datetime DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pay_account_limits`;
CREATE TABLE `pay_account_limits` (
    `account_key` int (11)  not null,
    `owner_key` INT(11) NOT NULL DEFAULT 0,
    `receiver_daily_pay_limit` BIGINT(20) DEFAULT 0,
    `receiver_weekly_pay_limit` BIGINT(20) DEFAULT 0,
    `receiver_monthly_pay_limit` BIGINT(20) DEFAULT 0,
    `sender_daily_pay_limit` BIGINT(20) DEFAULT 0,
    `sender_weekly_pay_limit` BIGINT(20) DEFAULT 0,
    `sender_monthly_pay_limit` BIGINT(20) DEFAULT 0,
    `enable_min_transfer` TINYINT(1) DEFAULT 0,
    `enable_max_transfer` TINYINT(1) DEFAULT 0,
    `enable_receiver_daily_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_receiver_weekly_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_receiver_monthly_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_sender_daily_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_sender_weekly_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_sender_monthly_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_transaction_count` TINYINT(1) DEFAULT 0,
    PRIMARY KEY (`account_key`),
    FOREIGN KEY (`account_key`) REFERENCES pay_prereg_accounts(`account_key`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `reseller_dynamic_data`;
CREATE TABLE `reseller_dynamic_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`value`)),
  `receiver_key` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_receiver_key` (`receiver_key`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

ALTER TABLE Refill.reseller_extra_params MODIFY parameter_value VARCHAR(100);

ALTER TABLE Refill.catalogue_addresses MODIFY street VARCHAR(100);

create index idx_parameter_value on reseller_extra_params (parameter_value);
alter table reseller_extra_params modify column receiver_key int(11);
create index idx_receiver_key on reseller_extra_params(receiver_key);
CREATE INDEX idx_import_key ON dwa_items (import_key);

DROP TABLE IF EXISTS `demarcation_region`;
CREATE TABLE `demarcation_region` (
`id` bigint(20) NOT NULL AUTO_INCREMENT,
`job_id` varchar(100) NOT NULL,
`batch_id` bigint(20) DEFAULT NULL,
`circle` varchar(255) NOT NULL,
`region` varchar(255) NOT NULL,
`cluster` varchar(255) NOT NULL,
`territory` varchar(255) NOT NULL,
`thana` varchar(255) NOT NULL,
`status` enum('PENDING','PROCESSING','PROCESSED','FAILED') NOT NULL,
`created_on` timestamp NOT NULL DEFAULT current_timestamp(),
`last_process_runs_on` timestamp NULL DEFAULT NULL,
`processed_date` timestamp NULL DEFAULT NULL,
`file_name` varchar(255) DEFAULT NULL,
`attempts` int(11) DEFAULT 0,
`extra_params` longtext DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `demarcation_reseller`;
CREATE TABLE `demarcation_reseller` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job_id` varchar(100) NOT NULL,
  `batch_id` bigint(20) DEFAULT NULL,
  `msisdn` varchar(20) NOT NULL,
  `reseller_type` varchar(50) DEFAULT NULL,
  `to_be_parent` varchar(100) DEFAULT NULL,
  `to_be_owner` varchar(100) DEFAULT NULL,
  `to_be_region` varchar(50) DEFAULT NULL,
  `to_be_cluster` varchar(50) DEFAULT NULL,
  `to_be_territory` varchar(50) DEFAULT NULL,
  `to_be_thana` varchar(50) DEFAULT NULL,
  `status` enum('PENDING','PROCESSING','PROCESSED','FAILED') DEFAULT 'PENDING',
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_process_runs_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `file_name` varchar(255) DEFAULT NULL,
  `attempts` int(11) DEFAULT 0,
  `extra_params` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$

   CREATE TRIGGER trg_commission_receivers_delete
   AFTER DELETE ON commission_receivers
   FOR EACH ROW
   BEGIN
       IF OLD.type_key IN (2, 4) THEN
           INSERT INTO commission_receivers_deleted (
               tag,
               type_key,
               receiver_key,
               address_key,
               -- add any other required columns here
               deleted_timestamp
           ) VALUES (
               OLD.tag,
               OLD.type_key,
               OLD.receiver_key,
               OLD.address_key,
               -- add any other required columns here
               NOW()
           );
       END IF;
   END$$

   DELIMITER ;

   CREATE TABLE IF NOT EXISTS commission_receivers_deleted (
       tag VARCHAR(255),
       type_key INT,
       receiver_key VARCHAR(255),
       address_key VARCHAR(255),
       deleted_timestamp DATETIME NOT NULL
   );
   
SET
FOREIGN_KEY_CHECKS = 1;

COMMIT;
