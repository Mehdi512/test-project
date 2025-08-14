--
-- $Id$
--
ALTER TABLE `Refill`.`reseller_types`
	ADD `default_contract_key` int(11) NOT NULL default '0',
	ADD `default_product_range_key` int(11) NOT NULL default '0',
	ADD `default_receipt_template_key` int(11) NOT NULL default '0';