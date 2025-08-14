CREATE TABLE `dwa_contract_audit_entries` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `contract_key` int(11) DEFAULT '0',
  `product_key` int(11) DEFAULT '0',
  `entry_key` int(11) DEFAULT NULL,
  `entry_range_key` int(11) DEFAULT NULL,
  `from_amount` bigint(20) DEFAULT '0',
  `to_amount` bigint(20) DEFAULT '0',
  `valid_from` datetime DEFAULT '0000-00-00 00:00:00',
  `valid_until` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `margin_rule_key` int(11) DEFAULT '0',
  `account_id` varchar(80) DEFAULT NULL,
  `pay_options_account_type_id` int(11) DEFAULT NULL,
  `contract_account_type_id` int(11) DEFAULT NULL,
  `value_type_id` int(11) DEFAULT NULL,
  `value_expression` varchar(256) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;