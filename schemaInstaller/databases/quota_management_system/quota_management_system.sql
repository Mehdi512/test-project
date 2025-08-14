CREATE DATABASE IF NOT EXISTS quotamanagement;
USE quotamanagement;

-- ------------------------------------
--  Table structure for `ersinstall`
-- ------------------------------------
DROP TABLE IF EXISTS `ersinstall`;
CREATE TABLE `ersinstall` (
  `versionKey` smallint(6) NOT NULL AUTO_INCREMENT,
  `version` varchar(20) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `Script` varchar(200) NOT NULL,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`VersionKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------------------------
--  Table structure for `quotamanagement` tables
-- ----------------------------------------------

Drop table if exists `quota`;
CREATE TABLE `quota` (
    id                  BIGINT         NOT NULL AUTO_INCREMENT,
    reseller_type       varchar(20)    NOT NULL,
    reseller_id         VARCHAR(20),
    product_sku         VARCHAR(50)   NOT NULL,
    quota_type          VARCHAR(10)     NOT NULL,
    quota_uom           VARCHAR(10)    NOT NULL,
    quota_value         DECIMAL(15, 2) NOT NULL,
    effective_date      DATETIME NULL,
    expiry_date         DATETIME NULL,
    payment_refund_date DATETIME NULL,
    creation_time       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updation_time       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
    remarks             VARCHAR(5) NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY unique_stock_allocation (reseller_type, reseller_id, product_sku, quota_type),
    KEY `idx_allocation_type_product_sku` (`quota_type`,`product_sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

Drop table if exists `utilization`;
CREATE TABLE `utilization` (
    id                  BIGINT         NOT NULL AUTO_INCREMENT,
    quota_id            BIGINT         NOT NULL,
    reseller_type       VARCHAR(20)    NOT NULL,
    reseller_id         VARCHAR(20)   NOT NULL,
    product_sku         VARCHAR(50)   NOT NULL,
    utilized            DECIMAL(15, 2) NOT NULL,
    remaining           DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`quota_id`) references quota(`id`),
    UNIQUE KEY unique_stock_allocation (quota_id, reseller_type, reseller_id, product_sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

Drop table if exists `quota_stage`;
CREATE TABLE `quota_stage` (
    quota_id            BIGINT         NOT NULL,
    import_id           BIGINT         NOT NULL,
    quota_value    DECIMAL(15, 2) NULL,
    effective_date DATETIME NULL,
    expiry_date    DATETIME NULL,
    payment_refund_date    DATETIME NULL,
    PRIMARY KEY (`quota_id`),
    FOREIGN KEY (`quota_id`) references quota(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
