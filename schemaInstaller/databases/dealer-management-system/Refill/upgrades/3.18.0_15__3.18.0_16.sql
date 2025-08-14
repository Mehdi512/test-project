--
-- $Id: 3.18.0_14__3.18.0_15.sql 46950 2011-04-12 07:52:59Z shadid $
--

ALTER TABLE `Refill`.`dwa_evoucher_products` ADD COLUMN `payment_account_type_key` int(11) NOT NULL DEFAULT '1';
