Drop table IF EXISTS `prefix_counter`;

CREATE TABLE `prefix_counter` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `prefix` varchar(250) DEFAULT '',
  `counter` int(16) NOT NULL,
  `type` varchar(255) NOt NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_prefix_type` (`prefix`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;


 ALTER TABLE `reseller_customers` CHANGE `customer_id` `customer_id` VARCHAR(255) UNIQUE NOT NULL;
 ALTER TABLE `reseller_customers` DROP PRIMARY KEY;
 ALTER TABLE `reseller_customers` ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT,
 ADD PRIMARY KEY(`id`);


Alter table `reseller_extra_params` change `parameter_value` `parameter_value` VARCHAR(1000);

