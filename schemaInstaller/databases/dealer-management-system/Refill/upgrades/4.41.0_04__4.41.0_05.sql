ALTER TABLE `Refill`.`commission_contracts` 
ADD COLUMN `reseller_tag` VARCHAR(45) NULL AFTER `reseller_type_key`,
ADD COLUMN `receiver_tag` VARCHAR(45) NULL AFTER `reseller_tag`;