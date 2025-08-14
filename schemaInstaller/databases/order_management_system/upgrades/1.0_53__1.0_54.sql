SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE `orders` DROP PRIMARY KEY;
ALTER TABLE `orders` ADD PRIMARY KEY (order_id,create_timestamp);

ALTER TABLE `invoice` DROP PRIMARY KEY;
ALTER TABLE `invoice` ADD PRIMARY KEY (invoice_id,create_timestamp);

ALTER TABLE `order_internal` DROP PRIMARY KEY;
ALTER TABLE `order_internal` ADD PRIMARY KEY (order_internal_id,create_timestamp);

SET FOREIGN_KEY_CHECKS = 1;