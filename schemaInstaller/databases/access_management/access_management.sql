START TRANSACTION;

CREATE DATABASE IF NOT EXISTS access_management;

USE access_management;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `app_features`;
-- Create syntax for TABLE 'app_features'
CREATE TABLE `app_features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feature_code` varchar(100) NOT NULL,
  `feature_description` varchar(100) DEFAULT NULL,
  `feature_value` mediumtext DEFAULT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_app_features_code` (`feature_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `app_features_hierarchy`;
-- Create syntax for TABLE 'app_features_hierarchy'
CREATE TABLE `app_features_hierarchy` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `app_type` varchar(45) NOT NULL,
  `feature_code` varchar(100) NOT NULL,
  `parent_feature_code` varchar(100) DEFAULT NULL,
  `feature_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_app_features_hierarchy` (`feature_code`,`app_type`),
  KEY `fk_policy_feature_map_feature_code_idx` (`feature_code`),
  KEY `fk_app_feature_hierarchy_feature_parent_code_idx` (`parent_feature_code`),
  CONSTRAINT `fk_app_feature_hierarchy_feature_parent_code` FOREIGN KEY (`parent_feature_code`) REFERENCES `app_features` (`feature_code`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_policy_feature_map_feature_code` FOREIGN KEY (`feature_code`) REFERENCES `app_features` (`feature_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `app_hierarchy`;
-- Create syntax for TABLE 'app_hierarchy'
CREATE TABLE `app_hierarchy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_feature_hierarchy_id` int(8) NOT NULL,
  `policy_id` smallint(6) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `fk_policy_app_feature_idx` (`policy_id`),
  KEY `fk_app_feature_hierarchy_id_idx` (`app_feature_hierarchy_id`),
  CONSTRAINT `fk_app_feature_hierarchy_id` FOREIGN KEY (`app_feature_hierarchy_id`) REFERENCES `app_features_hierarchy` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_policy_app_feature` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `ersinstall`;
-- Create syntax for TABLE 'ersinstall'
CREATE TABLE `ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT 0,
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `gateway_management`;
-- Create syntax for TABLE 'gateway_management'
CREATE TABLE `gateway_management` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gateway_code` varchar(30) NOT NULL DEFAULT '',
  `gateway_type_channel` varchar(50) NOT NULL DEFAULT '',
  `service_port` varchar(20) DEFAULT NULL,
  `source_type` varchar(30) DEFAULT NULL,
  `login` varchar(50) DEFAULT '',
  `password` text NOT NULL,
  `content_type` varchar(30) DEFAULT NULL,
  `auth_type` varchar(30) DEFAULT NULL,
  `status` int(4) NOT NULL DEFAULT 0,
  `network_code` varchar(20) DEFAULT NULL,
  `ip_auth` text DEFAULT NULL,
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `created_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modified_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `sms_notification` varchar(50) DEFAULT NULL,
  `tps_control` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gateway_code` (`gateway_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `module_endpoints`;
-- Create syntax for TABLE 'module_endpoints'
CREATE TABLE `module_endpoints` (
  `id` smallint(8) NOT NULL AUTO_INCREMENT,
  `module` varchar(80) NOT NULL,
  `module_feature` varchar(100) DEFAULT NULL,
  `component_name` varchar(1000) NOT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `endpoint` text NOT NULL,
  `http_method` varchar(50) NOT NULL,
  `content_type` varchar(80) NOT NULL,
  `description` text DEFAULT NULL,
  `available_from` datetime NOT NULL DEFAULT current_timestamp(),
  `available_until` datetime NOT NULL DEFAULT current_timestamp(),
  `default_flag` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `policy`;
-- Create syntax for TABLE 'policy'
CREATE TABLE `policy` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `description` text DEFAULT NULL,
  `available_from` datetime NOT NULL DEFAULT current_timestamp(),
  `available_until` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `policy_endpoint_map`;
-- Create syntax for TABLE 'policy_endpoint_map'
CREATE TABLE `policy_endpoint_map` (
  `id` smallint(8) NOT NULL AUTO_INCREMENT,
  `policy_id` smallint(6) NOT NULL,
  `endpoint_id` smallint(8) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_endpoint_map_unique` (`policy_id`,`endpoint_id`),
  KEY `fk_policy_endpoint_map_endpoint_id` (`endpoint_id`),
  CONSTRAINT `fk_policy_endpoint_map_endpoint_id` FOREIGN KEY (`endpoint_id`) REFERENCES `module_endpoints` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_policy_endpoint_map_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `resellertype_policy_map`;
-- Create syntax for TABLE 'resellertype_policy_map'
CREATE TABLE `resellertype_policy_map` (
  `id` smallint(8) NOT NULL AUTO_INCREMENT,
  `reseller_type` varchar(80) NOT NULL,
  `user_role` varchar(80) DEFAULT NULL,
  `policy_id` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_resellertype_policy_map_policy_id` (`policy_id`),
  CONSTRAINT `fk_resellertype_policy_map_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `master_resource`;
-- Create syntax for TABLE 'master_resource'
CREATE TABLE `master_resource` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `resource`;
-- Create syntax for TABLE 'resource'
CREATE TABLE `resource` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `endpoints` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `resource_mapping`;
-- Create syntax for TABLE 'resource_mapping'
CREATE TABLE `resource_mapping` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `master_resource_id` smallint(6) NOT NULL,
  `resource_id` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resource_mapping_unique` (`master_resource_id`,`resource_id`),
  KEY `fk_resource_mapping_resource_id` (`resource_id`),
  CONSTRAINT `fk_resource_mapping_master_resource_id` FOREIGN KEY (`master_resource_id`) REFERENCES `master_resource` (`id`),
  CONSTRAINT `fk_resource_mapping_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `policy_resource_mapping_applied`;
-- Create syntax for TABLE 'policy_resource_mapping_applied'
CREATE TABLE `policy_resource_mapping_applied` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `policy_id` smallint(6) NOT NULL,
  `master_resource_id` smallint(6) NOT NULL,
  `resource_id` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_resource_mapping_applied_unique` (`policy_id`,`master_resource_id`,`resource_id`),
  KEY `fk_policy_resource_mapping_applied_master_resource_id` (`master_resource_id`),
  KEY `fk_policy_resource_mapping_applied_resource_id` (`resource_id`),
  CONSTRAINT `fk_policy_resource_mapping_applied_master_resource_id` FOREIGN KEY (`master_resource_id`) REFERENCES `master_resource` (`id`),
  CONSTRAINT `fk_policy_resource_mapping_applied_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`id`),
  CONSTRAINT `fk_policy_resource_mapping_applied_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;