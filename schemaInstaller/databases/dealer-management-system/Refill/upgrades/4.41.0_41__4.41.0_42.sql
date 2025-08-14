ALTER TABLE `Refill`.`dwa_products`
  MODIFY COLUMN `group_order` int(10) DEFAULT 0
  AFTER `last_updated`;

