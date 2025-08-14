START TRANSACTION;

CREATE DATABASE IF NOT EXISTS idmpollink;

USE idmpollink;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0',
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table `test_table` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_stamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`),
  KEY `last_modified_stamp_idx` (`last_modified`),
  KEY `created_stamp_idx` (`created_stamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `payment_records` (
   `id` bigint(20) NOT NULL AUTO_INCREMENT,
   `transaction_id` varchar(255) NOT NULL,
   `href` varchar(255) DEFAULT NULL,
   `status` tinyint(1) DEFAULT NULL,
   `message` varchar(500) DEFAULT NULL,
   `created_at` timestamp NOT NULL,
   `payment_status` varchar(50) DEFAULT NULL,
   `status_check_count` int(11) DEFAULT NULL,
   `status_check_max_count` int(11) DEFAULT NULL,
   `last_status_check` timestamp NULL DEFAULT NULL,
   `status_check_interval` int(11) DEFAULT NULL,
   `version` bigint(20) NOT NULL DEFAULT 1,
   `status_history` text DEFAULT NULL COMMENT 'JSON array storing the history of status changes with timestamp and source',
   PRIMARY KEY (`id`),
   UNIQUE KEY `uk_transaction_id` (`transaction_id`),
   KEY `idx_payment_records_version_status` (`version`,`payment_status`),
   KEY `status_idx` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE oms_notification_failures (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(255) NOT NULL,
    response_code VARCHAR(50),
    response_message VARCHAR(500),
    created_at TIMESTAMP NOT NULL,
    INDEX idx_order_id (order_id)
);

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;