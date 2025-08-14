ALTER TABLE `Refill`.`reseller_profile_id`
ADD COLUMN `credit_limit` bigint(20) NOT NULL DEFAULT 0 AFTER `profile_id`,
ADD COLUMN `credit_limit_period` bigint(20) NOT NULL DEFAULT 0 AFTER `profile_id`;

CREATE TABLE `reseller_allowed_types` (
  `type_key` int(11) NOT NULL DEFAULT '0',
  `allowed_type_key` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`type_key`,`allowed_type_key`),
  KEY `type_key` (`type_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
