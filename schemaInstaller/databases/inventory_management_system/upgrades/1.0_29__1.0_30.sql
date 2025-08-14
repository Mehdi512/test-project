CREATE TABLE `lost_and_found` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(30) NOT NULL DEFAULT '',
  `current_status` varchar(15) NOT NULL DEFAULT '',
  `requested_status` varchar(15) NOT NULL DEFAULT '',
  `initiated_by` varchar(30) NOT NULL,
  `approved_by` varchar(30) NOT NULL,
  `gd_time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `gdr_fir_file_url` varchar(300) NOT NULL,
  `created_time_stamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `approved_time_stamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `inventory_list_json` varchar(1023) DEFAULT NULL,
  `status` varchar(25) DEFAULT 'PENDING',
  `failed_inventory` varchar(1023) DEFAULT NULL,
  PRIMARY KEY (`id`)
);