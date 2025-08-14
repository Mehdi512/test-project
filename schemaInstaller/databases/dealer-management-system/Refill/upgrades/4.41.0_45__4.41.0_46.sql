ALTER TABLE `Refill`.`dwa_items` CHANGE COLUMN `delivery_info` `delivery_info` TEXT NULL DEFAULT '' ;
ALTER TABLE `Refill`.`dwa_items` CHANGE COLUMN `external_reference` `external_reference` VARCHAR(20) NULL DEFAULT '' ;
ALTER TABLE `Refill`.`dwa_items` CHANGE COLUMN `extra_parameters` `extra_parameters` TEXT NULL DEFAULT '' ;
ALTER TABLE `Refill`.`rep_exported_batch_reports` CHANGE COLUMN `report_field_values` `report_field_values` text NULL DEFAULT '' ;
ALTER TABLE `Refill`.`rep_templates` CHANGE COLUMN `layouts` `layouts` text NULL DEFAULT '' ;
ALTER TABLE `Refill`.`rep_templates` CHANGE COLUMN `layout_mime_types` `layout_mime_types` text NULL DEFAULT '' ;
ALTER TABLE `Refill`.`rep_templates` CHANGE COLUMN `layout_titles` `layout_titles` text NULL DEFAULT '' ;