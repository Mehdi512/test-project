USE `contractmanagement`;
ALTER TABLE `rules` ADD COLUMN `rule_type` varchar(40) DEFAULT NULL;
update rules r join rule_fields_association rfa on r.id = rfa.rule_id set r.rule_type = 'POS_TYPE_PRODUCT_RULE' where rfa.field_key = 'posValue';