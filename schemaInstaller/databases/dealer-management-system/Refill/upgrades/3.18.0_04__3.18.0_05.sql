--
-- $Id$
--
CREATE TABLE `reseller_account_template` (
  `reseller_type_key` INT(11) NOT NULL DEFAULT '0',
  `account_type_key` INT(11) NOT NULL DEFAULT '0',
  `account_type_prefix` VARCHAR(20) NOT NULL DEFAULT '',
  `account_type_mode` TINYINT(2) NOT NULL DEFAULT '0',
  KEY `reseller_type_key` (`reseller_type_key`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;
