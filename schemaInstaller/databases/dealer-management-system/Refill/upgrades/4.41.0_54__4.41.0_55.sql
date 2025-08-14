ALTER TABLE `imp_import_files` MODIFY `filename` VARCHAR(100) NOT NULL DEFAULT '';
ALTER TABLE `imp_import_files` MODIFY `data` mediumblob NOT NULL;

ALTER TABLE `id_password_policies` ADD COLUMN `make_user_editable` tinyint(1) NOT NULL DEFAULT '1';
ALTER TABLE `id_password_policies` MODIFY COLUMN `name` VARCHAR(100) NOT NULL DEFAULT '';

ALTER TABLE `id_roles` MODIFY COLUMN DynamicData blob DEFAULT '' NOT NULL;
