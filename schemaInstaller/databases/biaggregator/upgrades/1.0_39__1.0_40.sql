DROP TABLE IF EXISTS `bi`.`bi_se_stock`;
CREATE TABLE `bi_se_stock` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `owner_id` varchar(60) NOT NULL,
  `employee_id` varchar(60) DEFAULT NULL,
  `serial_number` varchar(40) DEFAULT NULL,
  `additional_reference` varchar(100) DEFAULT NULL,
  `allocation_time` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_allocation_time` (`allocation_time`)
) ENGINE=InnoDB CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

