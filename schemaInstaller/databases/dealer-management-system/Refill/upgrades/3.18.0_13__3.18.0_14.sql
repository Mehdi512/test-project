--
-- $Id$
--

ALTER TABLE `Refill`.`reseller_account_template`
   ADD COLUMN `credit_limit` DECIMAL(20,5) DEFAULT '0.00000' AFTER `account_pay_limit_value`;