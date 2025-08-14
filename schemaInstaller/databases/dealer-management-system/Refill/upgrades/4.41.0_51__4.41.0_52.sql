CREATE TABLE `reseller_short_code_generator_settings` (
  `reseller_type` varchar(80) NOT NULL DEFAULT '',
  `suffix_count` varchar(80) NOT NULL DEFAULT '0',
  PRIMARY KEY (`reseller_type`,`suffix_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `reseller_extra_params`
  ADD CONSTRAINT `constraint_reseller_extra_params_parameter_key_receiver_key` UNIQUE (parameter_key, receiver_key);
