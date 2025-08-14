CREATE TABLE `pay_account_limits` (
    `account_key` int (11)  not null,
    `owner_key` INT(11) NOT NULL DEFAULT 0,
    `receiver_daily_pay_limit` BIGINT(20) DEFAULT 0,
    `receiver_weekly_pay_limit` BIGINT(20) DEFAULT 0,
    `receiver_monthly_pay_limit` BIGINT(20) DEFAULT 0,
    `sender_daily_pay_limit` BIGINT(20) DEFAULT 0,
    `sender_weekly_pay_limit` BIGINT(20) DEFAULT 0,
    `sender_monthly_pay_limit` BIGINT(20) DEFAULT 0,
    `enable_min_transfer` TINYINT(1) DEFAULT 0,
    `enable_max_transfer` TINYINT(1) DEFAULT 0,
    `enable_receiver_daily_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_receiver_weekly_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_receiver_monthly_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_sender_daily_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_sender_weekly_pay_limit` TINYINT(1) DEFAULT 0,
    `enable_sender_monthly_pay_limit` TINYINT(1) DEFAULT 0,
    PRIMARY KEY (`account_key`),
    FOREIGN KEY (`account_key`) REFERENCES pay_prereg_accounts(`account_key`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

ALTER TABLE Refill.reseller_extra_params MODIFY parameter_value VARCHAR(100);

ALTER TABLE Refill.catalogue_addresses MODIFY street VARCHAR(100);
