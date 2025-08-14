CREATE TABLE `reseller_account_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_type_key` int(11) NULL,
  `account_type_id` varchar(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `reseller_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reseller_id` varchar(40) NULL,
  `account_id` varchar(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;