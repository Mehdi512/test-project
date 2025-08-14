DROP TABLE IF EXISTS `dwa_items_snapshot`;


CREATE TABLE `dwa_items_snapshot` AS
SELECT class_key, SUM(IF(status=1,1,0)) as Available,SUM(if(status=0,1,0)) as Pending from Refill.dwa_items 
where last_sell_date > now() AND STATUS IN (0, 1) group by class_key;

DROP TRIGGER IF EXISTS dwa_items_after_insert;
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
     -- Check for dwa_items_snapshot updates&inserts
    IF ( NEW.status=0 || NEW.status=1) THEN

        IF (NEW.class_key NOT IN(SELECT snap.class_key FROM dwa_items_snapshot snap)) THEN
            INSERT INTO dwa_items_snapshot
            (CLASS_KEY,
            AVAILABLE,
            PENDING)
            VALUES
            (NEW.class_key,
             IF(NEW.status=1,1,0),IF(NEW.status=0,1,0));
        ELSE
           UPDATE dwa_items_snapshot set AVAILABLE = case when NEW.status=1 then AVAILABLE + 1 else AVAILABLE end, PENDING = case when NEW.status=0 then PENDING + 1 else PENDING end where class_key=NEW.class_key;
       END IF;
   END IF;

END$$
DELIMITER ;


DROP TRIGGER IF EXISTS dwa_items_after_update;
DELIMITER $$

CREATE TRIGGER dwa_items_after_update
AFTER UPDATE
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
	 -- Start check for updating snapshot table
   IF (NEW.status != OLD.status) THEN
       IF (NEW.status=0 || NEW.status=1) THEN
          UPDATE dwa_items_snapshot set AVAILABLE = case when NEW.status=1 then AVAILABLE + 1 else AVAILABLE end, PENDING = case when NEW.status=0 then PENDING + 1 else PENDING end where class_key=NEW.class_key;
          UPDATE dwa_items_snapshot set AVAILABLE = case when OLD.status=1 then AVAILABLE - 1 else AVAILABLE end, PENDING = case when OLD.status=0 then PENDING - 1 else PENDING end where class_key=NEW.class_key;
       ELSE
        UPDATE dwa_items_snapshot set AVAILABLE = case when OLD.status=1 then AVAILABLE - 1 else AVAILABLE end, PENDING = case when OLD.status=0 then PENDING - 1 else PENDING end where class_key=NEW.class_key;

       END IF;

   END IF;
END
$$
DELIMITER ;

DROP TRIGGER IF EXISTS dwa_items_after_delete;
DELIMITER $$
CREATE TRIGGER dwa_items_after_delete
AFTER DELETE
   ON dwa_items FOR EACH ROW

BEGIN
   -- delete record into audit table
   DELETE FROM dwa_items_transition_details
   WHERE ITEM_KEY = OLD.item_key;
   -- Start logic for changes in snapshot table
   IF (OLD.class_key IN(SELECT snap.class_key FROM dwa_items_snapshot snap)) THEN
    IF (OLD.status=0 || OLD.status=1) THEN
        UPDATE dwa_items_snapshot set AVAILABLE = case when OLD.status=1 then AVAILABLE - 1 else AVAILABLE end, PENDING = case when OLD.status=0 then PENDING - 1 else PENDING end where class_key=OLD.class_key;
    END IF;
   END IF;

END$$
DELIMITER ;