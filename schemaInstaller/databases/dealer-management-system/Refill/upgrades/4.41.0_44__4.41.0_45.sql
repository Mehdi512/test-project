CREATE TABLE `subscriber_bonus_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bonus_type` VARCHAR(40) NOT NULL,
  `bonus_amount` DECIMAL (11,2) NOT NULL,
  `valid_from` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `valid_till` timestamp NOT NULL,
  `amount_from` DECIMAL (11,2) NOT NULL DEFAULT 0,
  `amount_till` DECIMAL (11,2) NOT NULL,
  `criteria_type` VARCHAR(80) NOT NULL,
  `criteria_value` VARCHAR(200) NOT NULL,
  `bonus_validity_duration` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `eligible_sub_Index` (`criteria_value`, `amount_from`, `amount_till`, `valid_from`, `valid_till`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;