CREATE TABLE `external_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(60) NOT NULL,
  `product_sku` varchar(255) NOT NULL,
  `quantity` double(20,5) NULL,
  `reserved_for_reseller_type` varchar(60) DEFAULT NULL,
  `reserved_for_reseller_id` varchar(60) DEFAULT NULL,
  `updated_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `owner` (`owner`,`product_sku`,`reserved_for_reseller_type`,`reserved_for_reseller_id`),
  CONSTRAINT `external_owner_fk` FOREIGN KEY (`owner`) REFERENCES `owner` (`owner_id`),
  CONSTRAINT `external_reserved_fk` FOREIGN KEY (`reserved_for_reseller_id`) REFERENCES `owner` (`owner_id`)
);