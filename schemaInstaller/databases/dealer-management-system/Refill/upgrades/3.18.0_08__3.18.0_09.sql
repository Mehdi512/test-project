--
-- $Id$
--

alter table `Refill`.`reseller_account_template` 
   add column `account_pay_limit_period` int(11) DEFAULT '86400' NOT NULL after `account_type_mode`, 
   add column `account_transaction_limit_count` int(11) DEFAULT '0' NOT NULL after `account_pay_limit_period`, 
   add column `account_pay_limit_value` bigint(20) DEFAULT '10000000' NOT NULL after `account_transaction_limit_count`;
   
