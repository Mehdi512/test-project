--
-- $Id$
--

ALTER TABLE `payment_records` ADD COLUMN `status_check_count` int(11) DEFAULT NULL AFTER `payment_status`;
ALTER TABLE `payment_records` ADD COLUMN `status_check_max_count` int(11) DEFAULT NULL AFTER `status_check_count`;
ALTER TABLE `payment_records` ADD COLUMN `last_status_check` timestamp NULL DEFAULT NULL AFTER `status_check_max_count`;
ALTER TABLE `payment_records` ADD COLUMN  `status_check_interval` int(11) DEFAULT NULL AFTER `last_status_check`;
ALTER TABLE `payment_records` ADD INDEX `status_idx`(`status`);