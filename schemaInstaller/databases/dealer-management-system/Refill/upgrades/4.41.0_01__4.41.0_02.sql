
DROP TABLE IF EXISTS `dwa_items_transition_details`;
CREATE TABLE `dwa_items_transition_details` (
  `TRANSITION_ID` int(11) NOT NULL AUTO_INCREMENT,
  `ITEM_KEY` int(11) NOT NULL,
  `VOUCHER_STATUS` tinyint(4) NOT NULL DEFAULT '0',
  `EXTRA_PARAMETERS` text DEFAULT NULL,
  `TRANSITION_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`TRANSITION_ID`),
  FOREIGN KEY (ITEM_KEY) REFERENCES dwa_items(item_key)
) ENGINE=InnoDB AUTO_INCREMENT=0001 DEFAULT CHARSET=utf8;

DELIMITER $$
CREATE TRIGGER dwa_items_after_update
AFTER UPDATE
   ON dwa_items FOR EACH ROW
   
BEGIN
	IF (NEW.status != OLD.status) THEN
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
	END IF;
END$$ 
DELIMITER ;


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
END$$ 
DELIMITER ;

