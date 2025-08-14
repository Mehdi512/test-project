CREATE TABLE `asset_type` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
