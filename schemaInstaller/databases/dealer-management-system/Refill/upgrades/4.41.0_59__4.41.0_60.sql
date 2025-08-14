CREATE TABLE `reseller_profile_id` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_name` varchar(45) DEFAULT NULL,
  `partner_name` varchar(45) DEFAULT NULL,
  `profile_id` int(11) DEFAULT NULL ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;