CREATE TABLE `REGION_CATEGORY` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` varchar(255) NOT NULL,
  `CREATE_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `UPDATE_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `IDENTIFIER` enum('MASTER','SLAVE') NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

ALTER TABLE `REGION_TYPE` ADD COLUMN `REGION_CATEGORY_ID` INT(11);
ALTER TABLE `REGION_TYPE` ADD CONSTRAINT `fk_region_category` FOREIGN KEY (`REGION_CATEGORY_ID`) references `REGION_CATEGORY`(`ID`);
ALTER TABLE `REGION_TYPE` DROP CONSTRAINT `level_unique`;
ALTER TABLE `REGION_TYPE` ADD CONSTRAINT `level_category_unique` UNIQUE KEY (`REGION_CATEGORY_ID`,`LEVEL`);

CREATE TABLE `LEAF_REGION_MAPPING` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MASTER_ID` int(11) NOT NULL,
  `SLAVE_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_master_leaf_id` (`MASTER_ID`),
  KEY `fk_slave_leaf_id` (`SLAVE_ID`),
  CONSTRAINT `fk_master_leaf_id` FOREIGN KEY (`MASTER_ID`) REFERENCES `REGION` (`REGION_ID`),
  CONSTRAINT `fk_slave_leaf_id` FOREIGN KEY (`SLAVE_ID`) REFERENCES `REGION` (`REGION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


-- Local data for region category
INSERT INTO `REGION_CATEGORY` (`ID`, `NAME`, `DESCRIPTION`, `IDENTIFIER`)
VALUES
	(1, 'Admin', 'Admin region category as followed by the country', 'MASTER'),
	(2, 'Market', 'Market region category as followed by the operator', 'SLAVE');
