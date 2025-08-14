USE `inventory_management_system`;

INSERT INTO `box_type` (`id`, `name`, `parent`, `path`, `level`, `created_stamp`, `is_wrapper`)
VALUES
(1, 'pallete', NULL, 'pallete/', 1, '2023-07-10 09:51:57', 1),
(2, 'box', 1, 'pallete/box/', 2, '2023-07-10 09:51:57', 1),
(3, 'brick', 2, 'pallete/box/brick/', 3, '2023-07-10 09:51:57', 0),
(4, 'sim_box', NULL, 'sim_box/', 1, '2023-07-10 09:51:57', 0),
(5, 'system_box', NULL, 'system_box/', 1, '2023-07-10 09:51:57', 0);

INSERT INTO `owner` (`owner_id`, `name`, `description`, `type`, `data`, `reseller_path`, `created_stamp`, `updated_stamp`)
VALUES
	('DIST1', 'Distributor', '', 'DIST', '{}', 'Operator/DIST1', '2024-12-13 15:39:42', '2024-12-13 15:39:42'),
	('Operator', 'Operator', 'Operator', 'OPERATOR', '{}', 'Operator', '2025-02-12 11:06:35', '2025-02-12 11:06:35'),
	('Retailer1', 'Retailer1', '', 'RET', '{}', 'Operator/DIST1/Retailer1', '2025-02-27 01:08:15', '2025-02-27 01:08:15');


INSERT INTO `owner_address` (`owner_id`, `address_line1`, `address_line2`, `city`, `street`, `pincode`, `country`, `latitude`, `longitude`, `data`, `created_stamp`, `updated_stamp`)
VALUES
  ('DIST1', NULL, NULL, NULL, NULL, NULL, 'Bangladesh', '', '', '{}', '2025-02-12 11:06:36', '2025-02-12 11:06:36');


INSERT INTO `nonserialized_inventory` (`id`, `product_sku`, `quantity`, `location_id`, `owner_id`, `workflow_state_id`, `is_active`, `is_deleted`, `data`, `ref_no`, `update_reason`, `employee_id`, `created_stamp`, `updated_stamp`, `inventory_condition`)
VALUES
    (1, '500415434', '1000.00000', 'DIST1', 'DIST1', '1', '1', '0', '{}', NULL, NULL, NULL, '2025-05-11 14:03:02', '2025-05-11 14:13:30', NULL);



INSERT INTO `nonserialized_inventory` (`product_sku`, `quantity`, `location_id`, `owner_id`, `workflow_state_id`, `is_active`, `is_deleted`, `data`, `ref_no`, `update_reason`, `employee_id`, `created_stamp`, `updated_stamp`, `inventory_condition`)
VALUES
    ('3003393', '1000.00000', 'DIST1', 'DIST1', '1', '1', '0', '{}', NULL, NULL, NULL, '2025-05-11 14:03:02', '2025-05-11 14:13:30', NULL);


INSERT INTO `serialized_inventory` (`id`, `product_sku`, `serial_text`, `serial_number`, `inventory_condition`, `workflow_state_id`, `location_id`, `batch_id`, `box_history`, `inventory_id_type`, `owner_id`, `is_active`, `is_deleted`, `resource_id`, `ref_no`, `data`, `update_reason`, `employee_id`, `owner_history`, `created_stamp`, `updated_stamp`)
VALUES
    (1, '1000697', NULL, '10000000000001000000003440', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001250\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (2, '1000697', NULL, '10000000000001000000003441', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001251\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (3, '1000697', NULL, '10000000000001000000003442', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001252\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (4, '1000697', NULL, '10000000000001000000003443', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001253\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (5, '1000697', NULL, '10000000000001000000003444', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001254\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (6, '1000697', NULL, '10000000000001000000003445', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001255\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (7, '1000697', NULL, '10000000000001000000003446', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001256\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (8, '1000697', NULL, '10000000000001000000003447', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001257\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (9, '1000697', NULL, '10000000000001000000003448', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001258\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:45', '2025-05-06 08:18:45'),
    (10, '1000697', NULL, '10000000000001000000003449', NULL, '8', 'DIST1', '1', NULL, 'SERIAL', 'DIST1', '1', '0', '1', 'NULL', '{\"additional_reference_no\":\"8801710001259\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 08:18:46', '2025-05-06 08:18:46'),
    (11, '1000697', NULL, '10000000000001000000003450', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001260\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (12, '1000697', NULL, '10000000000001000000003451', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001261\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (13, '1000697', NULL, '10000000000001000000003452', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001262\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (14, '1000697', NULL, '10000000000001000000003453', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001263\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (15, '1000697', NULL, '10000000000001000000003454', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001264\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (16, '1000697', NULL, '10000000000001000000003455', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001265\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (17, '1000697', NULL, '10000000000001000000003456', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001266\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (18, '1000697', NULL, '10000000000001000000003457', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001267\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (19, '1000697', NULL, '10000000000001000000003458', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001268\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (20, '1000697', NULL, '10000000000001000000003459', NULL, '1', 'DIST1', '2', NULL, 'SERIAL', 'DIST1', '1', '0', '2', 'NULL', '{\"additional_reference_no\":\"8801710001269\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-06 09:08:43', '2025-05-06 09:08:43'),
    (21, '1000697', NULL, '10000000000001000000003460', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001270\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (22, '1000697', NULL, '10000000000001000000003461', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001271\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (23, '1000697', NULL, '10000000000001000000003462', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001272\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (24, '1000697', NULL, '10000000000001000000003463', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001273\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (25, '1000697', NULL, '10000000000001000000003464', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001274\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (26, '1000697', NULL, '10000000000001000000003465', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001275\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (27, '1000697', NULL, '10000000000001000000003466', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001276\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (28, '1000697', NULL, '10000000000001000000003467', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001277\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (29, '1000697', NULL, '10000000000001000000003468', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001278\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (30, '1000697', NULL, '10000000000001000000003469', NULL, '1', 'DIST1', '3', NULL, 'SERIAL', 'DIST1', '1', '0', '3', 'NULL', '{\"additional_reference_no\":\"8801710001279\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 06:54:45', '2025-05-07 06:54:45'),
    (31, '1000697', NULL, '10000000000001000000003470', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001280\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (32, '1000697', NULL, '10000000000001000000003471', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001281\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (33, '1000697', NULL, '10000000000001000000003472', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001282\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (34, '1000697', NULL, '10000000000001000000003473', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001283\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (35, '1000697', NULL, '10000000000001000000003474', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001284\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (36, '1000697', NULL, '10000000000001000000003475', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001285\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (37, '1000697', NULL, '10000000000001000000003476', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001286\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (38, '1000697', NULL, '10000000000001000000003477', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001287\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (39, '1000697', NULL, '10000000000001000000003478', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001288\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (40, '1000697', NULL, '10000000000001000000003479', NULL, '1', 'DIST1', '4', NULL, 'SERIAL', 'DIST1', '1', '0', '4', 'NULL', '{\"additional_reference_no\":\"8801710001289\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 07:30:45', '2025-05-07 07:30:45'),
    (41, '1000697', NULL, '10000000000001000000003480', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001290\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 17:34:45', '2025-05-07 17:34:45'),
    (42, '1000697', NULL, '10000000000001000000003481', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001291\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-07 17:34:45', '2025-05-07 17:34:45'),
    (43, '1000697', NULL, '10000000000001000000003482', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001292\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:03', '2025-05-08 03:39:03'),
    (44, '1000697', NULL, '10000000000001000000003483', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001293\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:04', '2025-05-08 03:39:04'),
    (45, '1000697', NULL, '10000000000001000000003484', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001294\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:04', '2025-05-08 03:39:04'),
    (46, '1000697', NULL, '10000000000001000000003485', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001295\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:04', '2025-05-08 03:39:04'),
    (47, '1000697', NULL, '10000000000001000000003486', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001296\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:04', '2025-05-08 03:39:04'),
    (48, '1000697', NULL, '10000000000001000000003487', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001297\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:04', '2025-05-08 03:39:04'),
    (49, '1000697', NULL, '10000000000001000000003488', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001298\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:05', '2025-05-08 03:39:05'),
    (50, '1000697', NULL, '10000000000001000000003489', NULL, '1', 'DIST1', '5', NULL, 'SERIAL', 'DIST1', '1', '0', '5', 'NULL', '{\"additional_reference_no\":\"8801710001299\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:05', '2025-05-08 03:39:05'),
    (51, '1000697', NULL, '10000000000001000000003490', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001300\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:05', '2025-05-08 03:39:05'),
    (52, '1000697', NULL, '10000000000001000000003491', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001301\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:05', '2025-05-08 03:39:05'),
    (53, '1000697', NULL, '10000000000001000000003492', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001302\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:05', '2025-05-08 03:39:05'),
    (54, '1000697', NULL, '10000000000001000000003493', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001303\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 03:39:05', '2025-05-08 03:39:05'),
    (55, '1000697', NULL, '10000000000001000000003494', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001304\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (56, '1000697', NULL, '10000000000001000000003495', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001305\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (57, '1000697', NULL, '10000000000001000000003496', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001306\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (58, '1000697', NULL, '10000000000001000000003497', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001307\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (59, '1000697', NULL, '10000000000001000000003498', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001308\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (60, '1000697', NULL, '10000000000001000000003499', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001309\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (61, '1000697', NULL, '10000000000001000000003500', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001310\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (62, '1000697', NULL, '10000000000001000000003501', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001311\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (63, '1000697', NULL, '10000000000001000000003502', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001312\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (64, '1000697', NULL, '10000000000001000000003503', NULL, '1', 'DIST1', '6', NULL, 'SERIAL', 'DIST1', '1', '0', '6', 'NULL', '{\"additional_reference_no\":\"8801710001313\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 09:26:57', '2025-05-08 09:26:57'),
    (65, '1000697', NULL, '10000000000001000000003504', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001314\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:56', '2025-05-08 11:34:56'),
    (66, '1000697', NULL, '10000000000001000000003505', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001315\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:56', '2025-05-08 11:34:56'),
    (67, '1000697', NULL, '10000000000001000000003506', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001316\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:56', '2025-05-08 11:34:56'),
    (68, '1000697', NULL, '10000000000001000000003507', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001317\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:56', '2025-05-08 11:34:56'),
    (69, '1000697', NULL, '10000000000001000000003508', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001318\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:57', '2025-05-08 11:34:57'),
    (70, '1000697', NULL, '10000000000001000000003509', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001319\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:57', '2025-05-08 11:34:57'),
    (71, '1000697', NULL, '10000000000001000000003510', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001320\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:57', '2025-05-08 11:34:57'),
    (72, '1000697', NULL, '10000000000001000000003511', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001321\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:57', '2025-05-08 11:34:57'),
    (73, '1000697', NULL, '10000000000001000000003512', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001322\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:57', '2025-05-08 11:34:57'),
    (74, '1000697', NULL, '10000000000001000000003513', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '{\"additional_reference_no\":\"8801710001323\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-08 11:34:57', '2025-05-08 11:34:57'),
    (75, '1000697', NULL, '10000000000001000000003514', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '\"additional_reference_no\":\"8801710001324\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:10:56', '2025-05-08 14:10:56'),
    (76, '1000697', NULL, '10000000000001000000003515', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '\"additional_reference_no\":\"8801710001325\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:10:56', '2025-05-08 14:10:56'),
    (77, '1000697', NULL, '10000000000001000000003516', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '\"additional_reference_no\":\"8801710001326\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:10:56', '2025-05-08 14:10:56'),
    (78, '1000697', NULL, '10000000000001000000003517', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '\"additional_reference_no\":\"8801710001327\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:10:56', '2025-05-08 14:10:56'),
    (79, '1000697', NULL, '10000000000001000000003518', NULL, '1', 'DIST1', '7', NULL, 'SERIAL', 'DIST1', '1', '0', '7', 'NULL', '\"additional_reference_no\":\"8801710001328\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:10:56', '2025-05-08 14:10:56'),
    (80, '1000697', NULL, '10000000000001000000003519', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001329\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (81, '1000697', NULL, '10000000000001000000003520', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001330\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (82, '1000697', NULL, '10000000000001000000003521', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001331\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (83, '1000697', NULL, '10000000000001000000003522', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001332\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (84, '1000697', NULL, '10000000000001000000003523', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001333\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (85, '1000697', NULL, '10000000000001000000003524', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001334\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (86, '1000697', NULL, '10000000000001000000003525', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001335\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (87, '1000697', NULL, '10000000000001000000003526', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001336\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (88, '1000697', NULL, '10000000000001000000003527', NULL, '1', 'DIST1', '8', NULL, 'SERIAL', 'DIST1', '1', '0', '8', 'NULL', '\"additional_reference_no\":\"8801710001337\",\"serials\":[]', NULL, NULL, NULL, '2025-05-08 14:16:56', '2025-05-08 14:16:56'),
    (89, '1000697', NULL, '10000000000001000000003528', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '\"additional_reference_no\":\"8801710001338\",\"serials\":[]', NULL, NULL, NULL, '2025-05-09 07:42:57', '2025-05-09 07:42:57'),
    (90, '1000697', NULL, '10000000000001000000003529', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '\"additional_reference_no\":\"8801710001339\",\"serials\":[]', NULL, NULL, NULL, '2025-05-09 07:42:57', '2025-05-09 07:42:57'),
    (91, '1000697', NULL, '10000000000001000000003530', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001340\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (92, '1000697', NULL, '10000000000001000000003531', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001341\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (93, '1000697', NULL, '10000000000001000000003532', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001342\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (94, '1000697', NULL, '10000000000001000000003533', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001343\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (95, '1000697', NULL, '10000000000001000000003534', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001344\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (96, '1000697', NULL, '10000000000001000000003535', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001345\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (97, '1000697', NULL, '10000000000001000000003536', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001346\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (98, '1000697', NULL, '10000000000001000000003537', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001347\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (99, '1000697', NULL, '10000000000001000000003538', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001348\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02'),
    (100, '1000697', NULL, '10000000000001000000003539', NULL, '1', 'DIST1', '9', NULL, 'SERIAL', 'DIST1', '1', '0', '9', 'NULL', '{\"additional_reference_no\":\"8801710001349\",\"serials\":[]}', NULL, NULL, NULL, '2025-05-11 17:11:02', '2025-05-11 17:11:02');



INSERT INTO `external_inventory` (`id`, `owner`, `product_sku`, `quantity`, `reserved_for_reseller_type`, `reserved_for_reseller_id`, `updated_stamp`)
VALUES
    ('1', 'Operator', '3003393', '5000.00000', 'DIST', NULL, '2025-05-09 11:46:54'),
    ('2', 'Operator', '1011882', '5000.00000', 'GPC', NULL, '2025-05-05 11:38:54'),
    ('3', 'Operator', '1000697', '5000.00000', 'DIST', NULL, '2025-05-11 07:00:01'),
    ('4', 'Operator', '1000697', '5000.00000', 'GPC', NULL, '2025-05-09 12:45:22'),
    ('5', 'Operator', '500415434', '5000.00000', 'DIST', NULL, '2025-05-11 09:30:12');
