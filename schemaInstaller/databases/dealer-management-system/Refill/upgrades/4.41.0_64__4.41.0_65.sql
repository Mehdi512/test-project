CREATE TABLE `reseller_customers` (
  `customer_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_national_identification_id` varchar(40) NOT NULL,
  `customer_name` varchar(40) NULL,
  `contact_msisdn` varchar(40) NULL,
  `email` varchar(40) NULL,
  `facebook` varchar(40) NULL,
  `is_tax_payer` boolean NULL,
  `tax_payer_type` varchar(40) NULL,
  `tax_payer_name` varchar(40) NULL,
  `tax_payer_id` varchar(40) NULL,
  `is_tax_vat_enabled` boolean NULL,
  `created_on` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` DATETIME NULL ON update CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `reseller_extra_param_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter_key` varchar(40) NULL,
  `is_unique` boolean NULL,
  `is_mutable` boolean NULL,
  `widget_type` varchar(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `reseller_type_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_key` varchar(40) NULL,
  `parameter_key` varchar(40) NULL,
  `is_mandatory` varchar(40) NULL,
  `default_value` varchar(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;