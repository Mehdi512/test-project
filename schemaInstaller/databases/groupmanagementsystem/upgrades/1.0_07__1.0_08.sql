ALTER TABLE `group` ADD code varchar(15) ;

CREATE TABLE `keys_mapping` (
    `key_id` int(11) NOT NULL AUTO_INCREMENT,
    `key_name` varchar(255) NOT NULL,
    PRIMARY KEY (`key_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `group_properties` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `group_id` bigint(20) NOT NULL,
    `key_id` int(11) NOT NULL,
    `value_type` tinyint(1) NOT NULL,
    `value_int` int(11) DEFAULT NULL,
    `value_text` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `group_id_key` (`group_id`,`key_id`),
    KEY `group_id_fk` (`group_id`),
    KEY `key_id_fk` (`key_id`),
    CONSTRAINT `group_id_fk` FOREIGN KEY (`group_id`) REFERENCES `group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `key_id_fk` FOREIGN KEY (`key_id`) REFERENCES `keys_mapping` (`key_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE `group_admin_properties` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) NOT NULL,
  `admin_id` bigint(20) NOT NULL,
  `key_id` int(11) NOT NULL,
  `value_type` tinyint(1) NOT NULL,
  `value_int` int(11) DEFAULT NULL,
  `value_text` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_admin_key` (`group_id`,`admin_id`,`key_id`),
  KEY `group_admin_fk` (`group_id`,`admin_id`),
  KEY `key_id_gap_fk` (`key_id`),
  CONSTRAINT `group_admin_fk` FOREIGN KEY (`group_id`, `admin_id`) REFERENCES `group_admin` (`group_id`, `admin_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `key_id_gap_fk` FOREIGN KEY (`key_id`) REFERENCES `keys_mapping` (`key_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;