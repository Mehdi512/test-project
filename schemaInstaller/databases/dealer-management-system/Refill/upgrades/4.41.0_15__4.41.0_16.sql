CREATE TABLE IF NOT EXISTS `cluster_update_info` (
  `reseller_id` varchar(80) NOT NULL DEFAULT '',
  `reseller_msisdn` varchar(64) NOT NULL,
  `old_cluster_id` int(11) ,
  `new_cluster_id` int(11) ,
  `migration_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `fields` text NOT NULL,
  KEY `tmstmp_index` (`migration_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;