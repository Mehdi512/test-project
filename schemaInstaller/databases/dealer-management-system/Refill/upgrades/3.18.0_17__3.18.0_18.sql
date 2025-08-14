CREATE TABLE `reseller_id_generator_settings` (
  `prefix` varchar(80) NOT NULL DEFAULT '',
  `suffix_count` varchar(80) NOT NULL DEFAULT '0',
  `suffix_digits` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;