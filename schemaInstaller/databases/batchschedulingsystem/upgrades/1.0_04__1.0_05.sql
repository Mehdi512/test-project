USE `batchschedulingsystem`;
ALTER TABLE `batch_pool` MODIFY COLUMN `retriable_file_name` VARCHAR(60);