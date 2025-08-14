ALTER TABLE policy_endpoint_map MODIFY COLUMN id INT;

DROP TABLE IF EXISTS `master_resource`;
-- Create syntax for TABLE 'master_resource'
CREATE TABLE `master_resource` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `resource`;
-- Create syntax for TABLE 'resource'
CREATE TABLE `resource` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `endpoints` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `resource_mapping`;
-- Create syntax for TABLE 'resource_mapping'
CREATE TABLE `resource_mapping` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `master_resource_id` smallint(6) NOT NULL,
  `resource_id` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resource_mapping_unique` (`master_resource_id`,`resource_id`),
  KEY `fk_resource_mapping_resource_id` (`resource_id`),
  CONSTRAINT `fk_resource_mapping_master_resource_id` FOREIGN KEY (`master_resource_id`) REFERENCES `master_resource` (`id`),
  CONSTRAINT `fk_resource_mapping_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

DROP TABLE IF EXISTS `policy_resource_mapping_applied`;
-- Create syntax for TABLE 'policy_resource_mapping_applied'
CREATE TABLE `policy_resource_mapping_applied` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `policy_id` smallint(6) NOT NULL,
  `master_resource_id` smallint(6) NOT NULL,
  `resource_id` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `policy_resource_mapping_applied_unique` (`policy_id`,`master_resource_id`,`resource_id`),
  KEY `fk_policy_resource_mapping_applied_master_resource_id` (`master_resource_id`),
  KEY `fk_policy_resource_mapping_applied_resource_id` (`resource_id`),
  CONSTRAINT `fk_policy_resource_mapping_applied_master_resource_id` FOREIGN KEY (`master_resource_id`) REFERENCES `master_resource` (`id`),
  CONSTRAINT `fk_policy_resource_mapping_applied_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `policy` (`id`),
  CONSTRAINT `fk_policy_resource_mapping_applied_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
