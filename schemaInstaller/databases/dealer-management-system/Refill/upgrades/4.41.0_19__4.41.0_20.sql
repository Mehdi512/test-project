DROP TABLE IF EXISTS `principal_service_status`;

-- principal_type '1' represents Reseller and '2' represents Subscriber
-- service_status '0' means block and '1' means unblocked
CREATE TABLE `principal_service_status` (
  `principal_id` varchar(80) NOT NULL,
  `principal_type` tinyint(1) NOT NULL DEFAULT '0',
  `service_status` tinyint(1) NOT NULL DEFAULT '1',
  `service_name` varchar(32) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`principal_id`,`principal_type`,`service_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
