--
-- $Id$
--

ALTER TABLE `dwa_etopup_data` MODIFY `amount_value` bigint(20) NOT NULL default '0';

ALTER TABLE `dwa_etopup_products` 
	ADD COLUMN `min_denomination` int default '0', 
	ADD COLUMN `denomination_multiple` int default '0', 
	ADD COLUMN `denomination_list` text default '',
	MODIFY `contract_mandatory` tinyint(2) default '1'; # was tinyint(2) default '0'

ALTER TABLE `dwa_price_entry_ranges` 
	CHANGE COLUMN `from_amount` `from_amount` bigint(20) NOT NULL default '0',
	CHANGE COLUMN `to_amount` `to_amount` bigint(20) NOT NULL default '0';

ALTER TABLE `dwa_orders_info2`
	MODIFY `info` varchar(255) NOT NULL default '';

ALTER TABLE `dwa_requisitions` MODIFY `amount_paid_value` bigint(20) NOT NULL default '0';

ALTER TABLE `pay_invoices` MODIFY `amount_value` bigint(20) NOT NULL default '0';

ALTER TABLE `pay_options` 
	MODIFY `transaction_cost_value` bigint(20) NOT NULL default '0',
	MODIFY `min_payment_amount` bigint(20) NOT NULL default '0',
	MODIFY `max_payment_amount` bigint(20) NOT NULL default '0',
	MODIFY `max_payment_period_amount` bigint(20) NOT NULL default '0';

ALTER TABLE `pay_prereg_accounts` 
	MODIFY `account_name` varchar(80) NOT NULL default '';

ALTER TABLE `rep_template_layouts` CHANGE COLUMN `mime_type` `mime_type` varchar(255) NOT NULL default ''; # was varchar(20) NOT NULL default ''

ALTER TABLE `sup_operator_links` 
	MODIFY `max_topup_amount` bigint(20) NOT NULL default '0',
	MODIFY `max_payment_amount` bigint(20) NOT NULL default '0';

ALTER TABLE `sup_subscriber_accounts` 
	MODIFY `account_id` varchar(80) NOT NULL default '',
	MODIFY `total_amount` bigint(20) NOT NULL default '0';

ALTER TABLE `sup_subscriber_profile_details` 
	MODIFY `from_amount` bigint(20) NOT NULL default '0',
	MODIFY `to_amount` bigint(20) NOT NULL default '0';
