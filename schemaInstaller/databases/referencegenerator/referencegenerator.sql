CREATE DATABASE IF NOT EXISTS referencegenerator;

USE referencegenerator;

DROP TABLE IF EXISTS `referencegenerator`.`ersinstall`;
CREATE TABLE `referencegenerator`.`ersinstall` (
  `VersionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `Version` varchar(20) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT '0',
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `reference_sequence` (
  `seqNo` int(11) NOT NULL,
  PRIMARY KEY (`seqNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `prefixed_reference_sequence` (
   `name` varchar(255) NOT NULL,
   `next` int(11) NOT NULL,
   `inc` int(11) NOT NULL,
   UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP FUNCTION IF EXISTS NextVal;
DELIMITER //

CREATE FUNCTION NextVal (vname VARCHAR(30))
    RETURNS INT
BEGIN
    DECLARE result INT;

    -- Lock the row and select the current value
    SELECT next INTO result
    FROM prefixed_reference_sequence
    WHERE name = vname FOR UPDATE;

    -- Update the next value
    UPDATE prefixed_reference_sequence
    SET next = next + 1
    WHERE name = vname;

    RETURN result;
END;

//
DELIMITER ;

