ALTER TABLE `pay_prereg_accounts`
ADD column `default_pay_limit` bigint(20) DEFAULT '0' NOT NULL after `max_transaction_amount`;
UPDATE `pay_prereg_accounts` set `default_pay_limit` = `pay_limit_value`;