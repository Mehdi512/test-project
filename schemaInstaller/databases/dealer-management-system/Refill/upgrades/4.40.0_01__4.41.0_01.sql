ALTER TABLE `Refill`.`dwa_items` 
ADD INDEX `reservationIndex` (`reservationRef`),
ADD INDEX `status` (`status`),
ADD INDEX `allocate_key` (`distributor_key`, `class_key`, `status`, `last_sell_date`);