CREATE TABLE if not exists `reseller_template_dropdown` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(250) NOT NULL,
  `field_value` varchar(250) NOT NULL,
  `associated_field_name` varchar(250) DEFAULT NULL,
  `associated_field_value` varchar(250) DEFAULT NULL,
  `created_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` DATETIME NULL ON update CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;