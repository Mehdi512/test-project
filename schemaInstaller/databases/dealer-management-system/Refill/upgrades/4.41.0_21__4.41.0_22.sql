REPLACE INTO `id_audit_actions` (`action_key`, `action`, `description`) VALUES
(35,'USER ACCOUNT DELETED',''),
(95,'PASSWORD POLICY CHANGED',''),
(96,'PASSWORD POLICY ADDED',''),
(97,'RESELLER ROLE ADDED',''),
(98,'RESELLER ROLE DELETED',''),
(99,'RESELLER ROLE UPDATED','');

ALTER TABLE `Refill`.`dwa_items` 
CHANGE COLUMN `ownerId` `ownerId` VARCHAR(80) NULL DEFAULT NULL ;

ALTER TABLE `Refill`.`cluster_update_info` 
ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT AFTER `fields`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`dwa_items_snapshot` 
ADD COLUMN `id` INT NOT NULL AUTO_INCREMENT AFTER `Pending`,
ADD PRIMARY KEY (`id`);
