START TRANSACTION;

CREATE DATABASE IF NOT EXISTS idmvoucheractivator;

USE idmvoucheractivator;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0',
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `activation_pool` (
   `id` bigint(20) NOT NULL AUTO_INCREMENT,
   `start_serial` varchar(255) NOT NULL,
   `end_serial` varchar(255) NOT NULL,
   `new_state` INT NOT NULL,
   `volume` bigint(20) DEFAULT 0,
   `status` varchar(255) NOT NULL,
   `tracking_id` varchar(255) NOT NULL,
   `task_id` varchar(255) DEFAULT '',
   `status_check_count` int(11) DEFAULT NULL,
   `status_check_max_count` int(11) DEFAULT NULL,
   `last_status_check` timestamp NULL DEFAULT NULL,
   `status_check_interval` int(11) DEFAULT NULL,
   `data` longtext DEFAULT NULL,
   `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `activate_attempt_count` int(11) DEFAULT 0,
   `activate_max_count` int(11) DEFAULT 0,
   `last_activation_attempt` timestamp NULL DEFAULT NULL,
   PRIMARY KEY (`id`),
   KEY `created_at_idx` (`created_at`),
   KEY `status_idx` (`status`),
   KEY `tracking_idx` (`tracking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `wait_pool` (
     `id` bigint(20) NOT NULL AUTO_INCREMENT,
     `start_serial` varchar(255) NOT NULL,
     `end_serial` varchar(255) NOT NULL,
     `new_state` INT NOT NULL,
     `volume` bigint(20) DEFAULT 0,
     `status` varchar(255) NOT NULL,
     `tracking_id` varchar(255) NOT NULL,
     `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
     PRIMARY KEY (`id`),
     KEY `created_at_idx` (`created_at`),
     KEY `status_idx` (`status`),
     KEY `tracking_idx` (`tracking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `shedlock` (
    `name` varchar(64) NOT NULL,
    `lock_until` datetime NOT NULL,
    `locked_at` datetime NOT NULL,
    `locked_by` varchar(255) NOT NULL,
    PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;