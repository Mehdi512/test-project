ALTER TABLE `dwa_items_transition_details` 
ADD INDEX `item_key_fk_idx` (`ITEM_KEY` ASC);
ALTER TABLE `dwa_items_transition_details` 
ADD CONSTRAINT `item_key_fk`
FOREIGN KEY (`ITEM_KEY`)
REFERENCES `dwa_items` (`item_key`)
ON DELETE CASCADE
ON UPDATE NO ACTION;