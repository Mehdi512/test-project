ALTER TABLE `Refill`.`dwa_contract_margin_rules` ADD pay_options_account_type_id VARCHAR(80) DEFAULT NULL AFTER account_id;
ALTER TABLE `Refill`.`dwa_contract_margin_rules` CHANGE COLUMN account_type_id contract_account_type_id int(11) DEFAULT NULL;

CREATE TABLE `reseller_link_kyc` (
  `reseller_type_key` int(11) NOT NULL,
  `kyc_id` int(11) NOT NULL,
  PRIMARY KEY (`reseller_type_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `reseller_kyc` (
  `kyc_id` int(11) NOT NULL,
  `kyc_property` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL,
  PRIMARY KEY (`kyc_id`,`kyc_property`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;