START TRANSACTION;

USE `helper_link`;

CREATE TABLE IF NOT EXISTS `ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0',
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE inbound_requests 
    ADD COLUMN custom_data LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{}' AFTER payload,
    ADD COLUMN customer_id VARCHAR(255) AFTER updated_at;

COMMIT;