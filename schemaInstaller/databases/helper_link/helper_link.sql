START TRANSACTION;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS helper_link;

USE helper_link;

-- Drop statements
DROP TABLE IF EXISTS `action`;
DROP TABLE IF EXISTS `action_criteria`;
DROP TABLE IF EXISTS `action_rule_dependencies`;
DROP TABLE IF EXISTS `action_rules`;
DROP TABLE IF EXISTS `inbound_requests`;
DROP TABLE IF EXISTS `integration_rules`;
DROP TABLE IF EXISTS `link_actions`;
DROP TABLE IF EXISTS `link_actions_error_reasons`;
DROP TABLE IF EXISTS `shedlock`;
DROP TABLE IF EXISTS `ersinstall`;

-- Create syntax for TABLE 'ersinstall'
CREATE TABLE `ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0',
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'inbound_requests'
CREATE TABLE `inbound_requests` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `inbound_txn_id` varchar(255) NOT NULL,
  `operation_type` varchar(50) NOT NULL,
  `status` enum('PENDING','PROCESSING','PARTIALLY_COMPLETED','COMPLETED','FAILED','FAILED_AT_FINALLY_EXECUTION') DEFAULT 'PENDING',
  `retry_count` int(11) DEFAULT 0,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `custom_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{}',
  `token` longtext NOT NULL,
  `authorization` longtext DEFAULT '',
  `blocking_call` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `customer_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_inbound_txn_id` (`inbound_txn_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=10000000000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create syntax for TABLE 'integration_rules'
CREATE TABLE `integration_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operation_type` varchar(50) DEFAULT NULL,
  `reseller_types` varchar(255) DEFAULT NULL,
  `reseller_roles` varchar(255) DEFAULT NULL,
  `expression` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_operation_type` (`operation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create syntax for TABLE 'action'
CREATE TABLE `action` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groovy` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `load_from_config` tinyint(1) DEFAULT 1,
  `execution_criteria` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_groovy_unique` (`groovy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create syntax for TABLE 'action_rules'
CREATE TABLE `action_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_id` int(11) DEFAULT NULL,
  `action_id` int(11) DEFAULT NULL,
  `execution_order` int(11) DEFAULT NULL,
  `retry_limit` int(11) DEFAULT 3,
  `stop_on_failure` tinyint(1) DEFAULT 0,
  `finally` tinyint(1) DEFAULT 0,
  `active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_rule_id` (`rule_id`),
  KEY `idx_execution_order` (`execution_order`),
  KEY `action_rules_ibfk_2` (`action_id`),
  CONSTRAINT `action_rules_ibfk_1` FOREIGN KEY (`rule_id`) REFERENCES `integration_rules` (`id`),
  CONSTRAINT `action_rules_ibfk_2` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create syntax for TABLE 'action_rule_dependencies'
CREATE TABLE `action_rule_dependencies` (
  `action_rule_id` int(11) NOT NULL,
  `depends_on_id` int(11) NOT NULL,
  PRIMARY KEY (`action_rule_id`,`depends_on_id`),
  KEY `depends_on_id` (`depends_on_id`),
  CONSTRAINT `action_rule_dependencies_ibfk_1` FOREIGN KEY (`action_rule_id`) REFERENCES `action_rules` (`id`),
  CONSTRAINT `action_rule_dependencies_ibfk_2` FOREIGN KEY (`depends_on_id`) REFERENCES `action_rules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create syntax for TABLE 'action_data'
CREATE TABLE `action_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_id` int(11) NOT NULL,
  `data_key` varchar(255) NOT NULL,
  `data_value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_action_id` (`action_id`),
  UNIQUE KEY `uk_action_data_key` (`action_id`, `data_key`),
  CONSTRAINT `action_data_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `action` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create syntax for TABLE 'link_actions'
CREATE TABLE `link_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inbound_request_id` bigint(20) NOT NULL,
  `action_rule_id` int(11) NOT NULL,
  `status` enum('PENDING','PROCESSING','RETRIED','RETRY_FAILED','SUCCESS','FAILED_AT_LOAD_ACTION_DATA','FAILED_AT_PRECONDITION','FAILED_AT_VALIDATE_REQUEST','FAILED_AT_CREATE_REQUEST','FAILED_AT_API_CALL','FAILED_AT_HANDLE_RESPONSE','FAILED_AT_EXTERNAL_SYSTEM','FAILED_AT_EXTRACT_RESPONSE_DATA','FAILED_AT_CALLBACK','SKIPPED') NOT NULL DEFAULT 'PENDING',
  `request` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `retry_count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `version` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `inbound_request_id` (`inbound_request_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `link_actions_ibfk_2` (`action_rule_id`),
  CONSTRAINT `link_actions_ibfk_1` FOREIGN KEY (`inbound_request_id`) REFERENCES `inbound_requests` (`id`),
  CONSTRAINT `link_actions_ibfk_2` FOREIGN KEY (`action_rule_id`) REFERENCES `action_rules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create syntax for TABLE 'link_actions_error_reasons'
CREATE TABLE `link_actions_error_reasons` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `link_action_id` int(11) NOT NULL,
  `reason` longtext NOT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `link_actions_error_reasons_ifk_1` (`link_action_id`),
  CONSTRAINT `link_actions_error_reasons_ifk_1` FOREIGN KEY (`link_action_id`) REFERENCES `link_actions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create syntax for TABLE 'shedlock'
CREATE TABLE `shedlock` (
  `name` varchar(64) NOT NULL,
  `lock_until` timestamp(3) NOT NULL,
  `locked_at` timestamp(3) NOT NULL DEFAULT current_timestamp(3),
  `locked_by` varchar(255) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SET FOREIGN_KEY_CHECKS = 1; 
COMMIT;