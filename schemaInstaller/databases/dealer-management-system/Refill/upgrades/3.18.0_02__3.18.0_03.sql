--
-- $Id$
--

CREATE TABLE `dwa_product_denominations` (
  `product_key` INT(11) NOT NULL DEFAULT '0',
  `denomination` INT(11) NOT NULL DEFAULT '0',
  `parameters` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`product_key`,`denomination`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;