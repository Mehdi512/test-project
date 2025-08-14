use groupmanagementsystem;
SET FOREIGN_KEY_CHECKS = 0;

-- TRUNCATE TABLE admin;
-- TRUNCATE TABLE ersinstall;
TRUNCATE TABLE `group_properties`;
TRUNCATE TABLE `group`;
TRUNCATE TABLE `group_admin_properties`;
-- TRUNCATE TABLE group_admin;
TRUNCATE TABLE `group_member`;
TRUNCATE TABLE group_relation;
TRUNCATE TABLE `member`;
TRUNCATE TABLE `keys_mapping`;
TRUNCATE TABLE operation;
-- TRUNCATE TABLE workflow;
-- TRUNCATE TABLE workflow_group_order;
-- TRUNCATE TABLE workflow_tracker;

INSERT INTO `group` (`group_id`, `name`, `description`, `status`, `minimum_members`, `maximum_members`, `effective_from`, `valid_until`, `created_by`, `created_at`, `last_modified`, `group_data`, `status_update_date`)
VALUES
	(1,'GPCF','GPCF Channel ','active',1,10,'2023-06-28 11:22:07','2100-01-30 18:30:00','operator','2022-06-28 11:27:46','2022-06-28 11:27:46',X'7B2267726F757054797065223A224558434C5553495645227D','2024-11-06 08:19:14'),
	(2,'DIST','Distributor Channel','active',1,10,'2023-06-28 11:22:07','2100-01-30 18:30:00','operator','2022-06-28 11:28:16','2022-06-28 11:28:16',X'7B2267726F757054797065223A224558434C5553495645227D','2024-11-06 08:19:14'),
	(3,'GPCC','GPC Channel','active',1,10,'2023-06-28 11:22:07','2100-01-30 18:30:00','operator','2022-06-28 11:29:03','2022-06-28 11:29:03',X'7B2267726F757054797065223A224558434C5553495645227D','2024-11-06 08:19:14'),
	(4,'MOTR','Modern Trade Channel','active',1,10,'2023-06-28 11:22:07','2100-01-30 18:30:00','operator','2022-06-28 11:29:41','2022-06-28 11:29:41',X'7B2267726F757054797065223A224558434C5553495645227D','2024-11-06 08:19:14'),
	(5,'KYC Approval', 'KYC Approal', 'active', 1, 10, '2023-06-28 11:22:07', '2100-06-28 11:22:07', 'operator', '2023-06-28 11:22:07', '2023-06-28 11:22:07', X'7B2267726F757054797065223A224558434C5553495645227D', '2023-06-28 11:22:07'),
	(6,'SE','SE Approval','active', 1, 10, '2023-06-28 11:22:07', '2100-06-28 11:22:07', 'operator', '2023-06-28 11:22:07', '2023-06-28 11:22:07', X'7B2267726F757054797065223A224558434C5553495645227D', '2023-06-28 11:22:07'),
    (7,'RET','RET Approval','active',1,10,'2023-06-28 11:22:07','2100-06-28 11:22:07','operator','2023-06-28 11:22:07', '2023-06-28 11:22:07', X'7B2267726F757054797065223A224558434C5553495645227D', '2023-06-28 11:22:07'),
    (8, 'NONGPUSER', 'NON GP USER', 'active', 1, 10, '2023-06-28 11:22:07', '2023-06-28 11:22:07', 'operator', '2023-06-28 11:22:07', '2023-06-28 11:22:07', X'7B2267726F757054797065223A224558434C5553495645227D', '2023-06-28 11:22:07');

# Dump of table group_member
# ------------------------------------------------------------
INSERT INTO `group_member` (`group_id`, `member_id`, `effective_from`, `effective_until`, `member_type`, `status`, `created_at`)
VALUES
	(1,1,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(2,2,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(2,5,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(2,6,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(3,3,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,4,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,7,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,9,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,10,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,11,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,12,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,13,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,14,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,15,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,16,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,17,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,18,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(4,19,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
    (5,8,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(6,5,'2024-07-11 00:00:01','2044-06-11 00:00:01','member','active','2024-06-10 00:00:01'),
	(7,6,'2025-02-28 07:25:02','2099-12-30 18:30:00','member','active','2025-02-28 07:25:06'),
	(8,20,'2020-01-01 00:00:00','2099-01-01 00:00:00','member','active','2020-01-01 00:00:00'),
	(5, 21, '2024-07-11 00:00:01', '2044-06-11 00:00:01', 'member', 'active', '2024-06-10 00:00:01');


# Dump of table member
# ------------------------------------------------------------

INSERT INTO `member` (`member_id`, `user_id`, `id_type`, `name`, `extra_params`)
VALUES
	(1,'GPCF','RESELLERID','GPCF',X'7B7D'),
	(2,'DIST','RESELLERID','Distributor',X'7B7D'),
	(3,'GPC','RESELLERID','GPC',X'7B7D'),
	(4,'CDIST','RESELLERID','CDIST',X'7B7D'),
	(5,'SE','RESELLERID','Sales Executive',X'7B7D'),
	(6,'RET','RESELLERID','Retailer',X'7B7D'),
	(7,'CRET','RESELLERID','CRET',X'7B7D'),
    (8,'operator', 'RESELLERID', 'OPERATOR', X'7B7D'),
    (9,'ODIST', 'RESELLERID', 'OWN DISTRIBUTOR', X'7B7D'),
    (10,'EADIST', 'RESELLERID', 'ALT DISTRIBUTOR', X'7B7D'),
    (11,'SDIST', 'RESELLERID', 'STRATEGIC DISTRIBUTOR', X'7B7D'),
	(12,'EUDIST','RESELLERID','UNLIMITED ENTITY',X'7B7D'),
	(13,'ESDIST','RESELLERID','SPECIAL ENTITY DISTRIBUTOR',X'7B7D'),
	(14,'ECDIST','RESELLERID','CREDIT ENTITY',X'7B7D'),
	(15,'ORET','RESELLERID','OWN RETAILER',X'7B7D'),
	(16,'ALTRET','RESELLERID','ALT RETAILER',X'7B7D'),
	(17,'ESRET','RESELLERID','SPECIAL ENTITY RETAILER',X'7B7D'),
	(18,'SRET','RESELLERID','STRATEGIC RETAILER',X'7B7D'),
	(19,'OSE','RESELLERID','OWN SALES EXECUTIVE',X'7B7D'),
	(20, 'NONGP', 'RESELLERID', 'Non GP Users', X'7B7D'),
	(21, 'BCU', 'RESELLERID', 'BCU', X'7B7D');


INSERT INTO `keys_mapping` (`key_name`)
VALUES
	('GROUP_TYPE'),
	('ADMIN_TYPE');

INSERT INTO `group_properties` (`group_id`, `key_id`, `value_type`, `value_int`, `value_text`)
select group_id,(select key_id from keys_mapping where key_name like 'GROUP_TYPE') as 'key_id',1 as 'value_type', 0 as 'value_int', 'RESELLER_CHANNEL' as 'value_text'   from `group` where `name` in ('GPCF','DIST','GPCC','MOTR');


INSERT INTO `operation` (`operation_id`, `code`, `module`, `operation_name`, `operation_type`, `from_state`, `to_state`)
VALUES
	(1, 'ADD_KYC', 'kyc', 'ADD_KYC', 'Adding customer', '', '');

INSERT INTO `group_relation` (`id`, `from_group_id`, `operation_id`, `to_group_id`)
VALUES
	(1, 6, 1, 5),
	(2, 7, 1, 5),
	(3, 8, 1, 5),
	(4, 2, 1, 5);



SET FOREIGN_KEY_CHECKS = 1;