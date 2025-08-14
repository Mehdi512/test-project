CREATE TABLE `dwa_contract_margin_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `entry_key` int(11) DEFAULT NULL,
  `entry_range_key` int(11) DEFAULT NULL,
  `account_id` varchar(80) DEFAULT NULL,
  `account_type_id` int(11) DEFAULT NULL,
  `value_type_id` int(11) DEFAULT NULL,
  `value_expression` varchar(256) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dwa_contract_value_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dwa_contract_account_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `account_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dwa_contract_tags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `dwa_contract_value_type` (`id`, `value_type`)
VALUES
	(1, 'Absolute'),
	(2, 'Percentage'),
	(3, 'Expression');

INSERT INTO `dwa_contract_account_types` (`id`, `account_type`)
VALUES
	(1, 'Sender'),
	(2, 'Receiver'),
	(3, 'Fixed'),
	(4, 'ParentOfSender'),
	(5, 'ParentOfReceiver');

INSERT INTO `dwa_contract_tags` (`id`, `tag_name`)
VALUES
	(1, 'SENDER'),
	(2, 'RECEIVER'),
	(3, 'TRANSACTION_FEE'),
	(4, 'COMMISSION'),
	(5, 'ROYALTY'),
	(6, 'BONUS'),
	(7, 'TAX'),
	(8, 'MTN_MARGIN'),
	(9, 'SEAMLESS_MARGIN');

	
INSERT INTO `dwa_contract_margin_rules` (`id`, `entry_key`, `entry_range_key`, `account_id`, `account_type_id`, `value_type_id`, `value_expression`, `tag_id`)
VALUES
	(1, 12, 19, NULL, 1, 3, '-x', NULL),
	(2, 12, 19, NULL, 1, 1, '12350', 4),
	(3, 12, 19, NULL, 2, 3, 'x-20000', NULL),
	(4, 12, 19, NULL, 2, 1, '10000', NULL),
	(5, 12, 19, 'MTN_BONUS', 3, 1, '-10000', 0),
	(6, 12, 19, 'TAX', 3, 1, '3300', 0),
	(7, 12, 19, 'SEAMLESS', 3, 1, '800', 0),
	(8, 12, 19, NULL, 4, 1, '650', 0),
	(9, 12, 19, 'MTN_PROFIT', 3, 1, '2900', 0);