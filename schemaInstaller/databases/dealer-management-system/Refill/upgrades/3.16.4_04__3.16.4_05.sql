--
-- $Id$
--

ALTER TABLE `Refill`.`pay_prereg_accounts` 
	ADD COLUMN `transaction_limit_count` INT(11) DEFAULT '0' NULL AFTER `pay_limit_currency`;