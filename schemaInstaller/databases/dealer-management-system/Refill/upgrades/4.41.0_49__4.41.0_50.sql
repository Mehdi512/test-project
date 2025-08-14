CREATE TABLE `reseller_extra_params` (
  `extra_paramId` int(11) NOT NULL AUTO_INCREMENT,
  `parameter_key` varchar(45) DEFAULT NULL,
  `parameter_value` varchar(45) DEFAULT NULL,
  `receiver_key` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`extra_paramId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;