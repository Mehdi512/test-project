--
-- $Id$
--

ALTER TABLE `dwa_etopup_data` 
	CHANGE COLUMN `amount_value` `amount_value` bigint(20) NOT NULL default '0'; # was int(11) NOT NULL default '0'

ALTER TABLE `dwa_etopup_products`
	ADD COLUMN `requires_approval` tinyint(4) NOT NULL default '0';

ALTER TABLE `dwa_requisitions` 
	CHANGE COLUMN `amount_paid_value` `amount_paid_value` bigint(20) NOT NULL default '0'; # was int(11) NOT NULL default '0'

ALTER TABLE `extdev_devices` 
	ADD COLUMN `default_user_key` int(11) NOT NULL default '0',
	ADD INDEX `address` (`address`(16)),
	ADD INDEX `default_user_key` (`default_user_key`);

ALTER TABLE `pay_invoices` CHANGE COLUMN `amount_value` `amount_value` bigint(20) NOT NULL default '0'; # was bigint(11) NOT NULL default '0'

ALTER TABLE `pay_options`
	CHANGE COLUMN `transaction_cost_value` `transaction_cost_value` bigint(20) NOT NULL default '0',
	CHANGE COLUMN `min_payment_amount` `min_payment_amount` bigint(20) NOT NULL default '0',
	CHANGE COLUMN `max_payment_amount` `max_payment_amount` bigint(20) NOT NULL default '0',
	CHANGE COLUMN `max_payment_period_amount` `max_payment_period_amount` bigint(20) NOT NULL default '0';

ALTER TABLE `rep_settings` ADD COLUMN `denorm_system_key` int(11) NOT NULL default '1';

ALTER TABLE `reseller_types` 
	ADD COLUMN `default_product_range_key` int(11) NOT NULL default '0',
	ADD COLUMN `default_contract_key` int(11) NOT NULL default '0',
	ADD COLUMN `default_receipt_template_key` int(11) NOT NULL default '0';

ALTER TABLE `sup_operator_links` 
	CHANGE COLUMN `max_payment_amount` `max_payment_amount` bigint(20) NOT NULL default '0',
	CHANGE COLUMN `max_topup_amount` `max_topup_amount` bigint(20) NOT NULL default '0';

ALTER TABLE `sup_subscriber_accounts`
	CHANGE COLUMN `total_amount` `total_amount` bigint(20) NOT NULL default '0'; # was int(11) NOT NULL default '0'

ALTER TABLE `sup_subscriber_profile_details` 
	CHANGE COLUMN `from_amount` `from_amount` bigint(20) NOT NULL default '0',
	CHANGE COLUMN `to_amount` `to_amount` bigint(20) NOT NULL default '0';

CREATE TABLE `dwa_segment_data` (
  `segment_data_key` int(11) NOT NULL auto_increment,
  `segment_id` varchar(16) NOT NULL,
  `type` varchar(6) NOT NULL default '0',
  `amount_from` int(11) NOT NULL default '0',
  `amount_to` int(11) NOT NULL default '0',
  `data` varchar(64) NOT NULL default '',
  `description` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`segment_data_key`),
  KEY `segment_key` (`segment_id`,`type`,`amount_from`,`amount_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

