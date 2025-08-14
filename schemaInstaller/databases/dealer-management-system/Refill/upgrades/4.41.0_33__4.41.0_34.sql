ALTER TABLE `Refill`.`dwa_products`
  ADD COLUMN `group_order` int(10) DEFAULT 0
  AFTER `group_name`;

