USE Refill;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE catalogue_addresses;
TRUNCATE TABLE catalogue_companies;
TRUNCATE TABLE catalogue_contacts;
TRUNCATE TABLE catalogue_persons;
TRUNCATE TABLE commission_receivers;
TRUNCATE TABLE commission_shop_settings;
TRUNCATE TABLE id_roles;
TRUNCATE TABLE id_users;
TRUNCATE TABLE extdev_classes;
TRUNCATE TABLE extdev_devices;
TRUNCATE TABLE id_applicationgroups;
TRUNCATE TABLE id_domains;
TRUNCATE TABLE id_password_policies;
TRUNCATE TABLE loc_currencies;
TRUNCATE TABLE loc_countries;
TRUNCATE TABLE loc_exchange_rate;
TRUNCATE TABLE loc_languages;
TRUNCATE TABLE pay_options;
TRUNCATE TABLE pay_prereg_accounts;
TRUNCATE TABLE reseller_account_template;
TRUNCATE TABLE reseller_account_types;
TRUNCATE TABLE reseller_accounts;
TRUNCATE TABLE reseller_allowed_types;
TRUNCATE TABLE reseller_extra_params;
TRUNCATE TABLE reseller_hierarchy;
TRUNCATE TABLE reseller_types;
TRUNCATE TABLE reseller_template_dropdown;
TRUNCATE TABLE reseller_type_children;
TRUNCATE TABLE reseller_type_prefixes;
TRUNCATE TABLE reseller_distributors;
TRUNCATE TABLE reseller_dynamic_data;
# Dump of table catalogue_addresses
# ------------------------------------------------------------

LOCK TABLES `catalogue_addresses` WRITE;
/*!40000 ALTER TABLE `catalogue_addresses` DISABLE KEYS */;

INSERT INTO `catalogue_addresses` (`owner_key`, `street`, `zip`, `city`, `country`, `purpose`, `care_of`, `last_modified`)
VALUES
	(1,'Bailey Road','','Dhaka','','company_info','','2024-11-05 13:10:16'),
	(2,'Motijheel','','Dhaka','','company_info','','2024-11-05 13:10:19'),
    (3, '', '', 'Dhaka', '', 'company_info', '', '2024-11-05 13:10:19'),
    (999999,'','','Dhaka','','company_info','','2024-11-05 13:11:35'),
    (256001025, 'Khan Arcade (2nd Floor), College Road, Gopalganj', '11987839', 'DHAKA', '', 'company_info', '', '2025-05-20 11:00:28'),
    (256001281, '215, Outer Circular Road, Boro Moghbazar, Dhaka-1217.', '11987839', 'DHAKA', '', 'company_info', '', '2025-05-20 11:11:41'),
    (256001537, 'A H Khan Tower(3rd Floor) Beside Fire service,Sreenagar,Munshigonj', '11987839', 'DHAKA', '', 'company_info', '', '2025-05-20 11:20:19'),
    (256001793, 'M. Rahman Mansion, Dakbanglow Road, Barlekha, Moulvibazar', '11980039', 'DHAKA', '', 'company_info', '', '2025-05-20 11:26:33'),
    (256002049, 'Pachbaria,Araihazar, Narayanganj', '', '', '', 'company_info', '', '2025-05-20 11:47:05'),
    (256002305, 'Gobindopur,Ujampur,1230,Uttar Khan,Dhaka', '', '', '', 'company_info', '', '2025-05-20 11:52:57'),
    (256002561, 'A 70, Shafipur Bazar, Kaliakair, Gazipur', '', '', '', 'company_info', '', '2025-05-20 11:55:44'),
    (256002817, 'Stockholm Street', '', '', '', 'company_info', '', '2025-05-20 11:56:07'),
    (256003073, 'Gaokhali Bazar,Nazirpur.', '', '', '', 'company_info', '', '2025-05-20 12:14:08'),
    (256003329, 'M. N. R Gait, Aspara, Sreepur, Gazipur', '', '', '', 'company_info', '', '2025-05-20 12:21:35'),
    (256003585, 'Lalur More,Bheramara.Kushtia', '', '', '', 'company_info', '', '2025-05-20 12:24:18');

/*!40000 ALTER TABLE `catalogue_addresses` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table catalogue_attachments
# ------------------------------------------------------------



# Dump of table catalogue_companies
# ------------------------------------------------------------

LOCK TABLES `catalogue_companies` WRITE;
/*!40000 ALTER TABLE `catalogue_companies` DISABLE KEYS */;

INSERT INTO `catalogue_companies` (`entry_key`, `org_nr`, `name`, `_dynamic`, `last_modified`)
VALUES
	(1,'','Distributor One','','2024-11-05 13:07:54'),
	(2,'','Distributor Two','','2024-11-05 13:07:57'),
    (3, '', 'Retailer One', X'', '2024-11-05 13:07:57'),
	(999999,'','Subscriber Entity','','2024-11-05 13:11:40'),
    (1000004, '', 'M/s Kazi Sayed Ali', X'', '2025-05-20 11:00:28'),
    (1000005, '', 'Pioneer Distribution Ltd-Moghbazar', X'', '2025-05-20 11:11:41'),
    (1000006, '', 'Sales Promotion Service Unit-3', X'', '2025-05-20 11:20:19'),
    (1000007, '', 'South Sylhet Telecom Unit-2', X'', '2025-05-20 11:26:33'),
    (1000008, '', 'Rahad Mullah', X'', '2025-05-20 11:47:05'),
    (1000009, '', 'Md. Shohel Ahmed SE 9', X'', '2025-05-20 11:52:57'),
    (1000010, '', 'Md. Majnu Mia', X'', '2025-05-20 11:55:44'),
    (1000011, '', 'dist121', X'', '2025-05-20 11:56:07'),
    (1000012, '', 'Ideal Laibary', X'', '2025-05-20 12:14:08'),
    (1000013, '', 'Babul Store', X'', '2025-05-20 12:21:35'),
    (1000014, '', 'Aslam Store', X'', '2025-05-20 12:24:18');


/*!40000 ALTER TABLE `catalogue_companies` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table catalogue_contacts
# ------------------------------------------------------------

LOCK TABLES `catalogue_contacts` WRITE;
/*!40000 ALTER TABLE `catalogue_contacts` DISABLE KEYS */;

INSERT INTO `catalogue_contacts` (`owner_key`, `purpose`, `email`, `phone`, `_dynamic`, `last_modified`)
VALUES
	(1,'company_info','distributor1@seamless.se','',NULL,'2024-11-05 13:03:43'),
	(2,'company_info','dist2@gmail.com','',NULL,'2024-11-05 13:10:39'),
	(3, 'primary', 'clm1@yopmail.com', '1712349991', X'', '2025-01-24 07:04:19'),
    (4, 'primary', 'clm2@yopmail.com', '1712349992', X'', '2025-01-24 07:09:03'),
    (5, 'primary', 'clm3@yopmail.com', '1712349993', X'', '2025-01-24 14:04:32'),
    (6, 'primary', 'retailer1@abc.com', '17123499934', X'', '2025-01-24 14:04:32'),
    (999999,'company_info','','',NULL,'2024-11-05 13:11:42'),
    (256001025, 'company_info', 'ksagopalganj@gmail.com', '', X'', '2025-05-20 11:00:28'),
    (256001281, 'company_info', 'pioneerdlm.dhk.gpd@gmail.com', '', X'', '2025-05-20 11:11:41'),
    (256001537, 'company_info', 'gmsps.gp@gmail.com', '', X'', '2025-05-20 11:20:19'),
    (256001793, 'company_info', 'southsylhet@gmail.com', '', X'', '2025-05-20 11:26:33'),
    (256002048, 'primary', 'ksagopalganj@gmail.com', '8801587687607', X'', '2025-05-20 11:00:37'),
    (256002049, 'company_info', 'mdrahad@gmail.com', '', X'', '2025-05-20 11:47:05'),
    (256002304, 'primary', 'pioneerdlm.dhk.gpd@gmail.com', '8801713010190', X'', '2025-05-20 11:11:42'),
    (256002305, 'company_info', 'BD10072072mubarak@gmail.com', '', X'', '2025-05-20 11:52:57'),
    (256002560, 'primary', 'gmsps.gp@gmail.com', '8801777122277', X'', '2025-05-20 11:20:20'),
    (256002561, 'company_info', 'bd10679589zamaddar@gmail.com', '', X'', '2025-05-20 11:55:44'),
    (256002816, 'primary', 'southsylhet@gmail.com', '8801788224565', X'', '2025-05-20 11:26:33'),
    (256002817, 'company_info', 'adhoc@user.com', '', X'', '2025-05-20 11:56:07'),
    (256003072, 'primary', 'mdrahad@gmail.com', '8801754872702', X'', '2025-05-20 11:47:05'),
    (256003073, 'company_info', 'IdealLaibary@gmail.com', '01710700109', X'', '2025-05-20 12:14:08'),
    (256003328, 'primary', 'BD10072072mubarak@gmail.com', '8801760762222', X'', '2025-05-20 11:52:57'),
    (256003329, 'company_info', 'Babul Store@gmail.com', '01710700109', X'', '2025-05-20 12:21:35'),
    (256003584, 'primary', 'bd10679589zamaddar@gmail.com', '8801711442823', X'', '2025-05-20 11:55:44'),
    (256003585, 'company_info', 'Aslam Store@gmail.com', '01710700109', X'', '2025-05-20 12:24:18'),
    (256003840, 'primary', 'adhoc@user.com', '8801383821221', X'', '2025-05-20 11:56:07'),
    (256004096, 'primary', 'IdealLaibary@gmail.com', '8801710700109', X'', '2025-05-20 12:14:08'),
    (256004352, 'primary', 'Babul Store@gmail.com', '8801794534518', X'', '2025-05-20 12:21:35'),
    (256004608, 'primary', 'Aslam Store@gmail.com', '8801744043945', X'', '2025-05-20 12:24:19');


/*!40000 ALTER TABLE `catalogue_contacts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table catalogue_persons
# ------------------------------------------------------------

LOCK TABLES `catalogue_persons` WRITE;
/*!40000 ALTER TABLE `catalogue_persons` DISABLE KEYS */;

INSERT INTO `catalogue_persons` (`entry_key`, `id_nr`, `name`, `_dynamic`, `primary_employer`, `last_modified`)
VALUES
	(1,'','Distributor One','',0,'2024-11-05 13:01:51'),
	(2,'','Distributor Two','',0,'2024-11-05 13:01:59'),
    (3, '', 'Retailer One', X'', '0', '2024-11-05 13:01:59'),
    (999999,'','Subscriber Entity','',0,'2024-11-05 13:11:44');

/*!40000 ALTER TABLE `catalogue_persons` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table commission_receivers
# ------------------------------------------------------------

LOCK TABLES `commission_receivers` WRITE;
/*!40000 ALTER TABLE `commission_receivers` DISABLE KEYS */;

INSERT INTO `commission_receivers` (`receiver_key`, `contract_key`, `region_key`, `name`, `tag`, `description`, `logo_url`, `address_key`, `report_url`, `distributor_key`, `chain_key`, `rgroup`, `subrgroup`, `subsubrgroup`, `timezone`, `language`, `invoicing_type`, `status`, `country_key`, `subdevice_policy`, `time_created`, `time_first_terminal_activation`, `last_modified`, `custom_parameters`, `chain_store_id`, `domain_key`, `type_key`, `tax_group_key`, `reseller_path`, `fields`, `cluster_id`, `is_autotransfer`)
VALUES
	(1,1,0,'Operator','Operator','Operator','',0,'',1,2,'ers-std','','','Asia/Dhaka','en',0,0,1,0,'2022-04-05 12:53:25','2022-04-05 12:54:04','2024-11-05 13:06:59','','Operator',6,1,0,'Operator','\"#Thu Dec 01 14:40:56 UTC 2022\n\"\\#Thu=Dec 01 14\\:36\\:51 UTC 2022\n\"=\n\"',NULL,0),
	(2,3,0,'Distributor1','DIST1','','',1,'',1,2,'','','','Asia/Dhaka','',0,0,1,0,'2022-11-07 14:41:46','2022-11-07 14:41:46','2024-11-05 13:07:03','','',39,3,0,'Operator/DIST1','\"#Thu Dec 01 13:24:32 UTC 2022\n\"\\#Mon=Nov 07 14\\:41\\:46 UTC 2022\n\"\\#Wed=Nov 23 13\\:10\\:59 UTC 2022\n\"\\#Thu=Nov 24 07\\:01\\:39 UTC 2022\n\"=\n\"',NULL,0),
	(3,3,0,'Distributor2','DIST2','','',2,'',1,2,'','','','Asia/Dhaka','',0,0,1,0,'2022-11-07 16:18:19','2022-11-07 16:18:19','2024-11-05 13:07:05','','',40,3,0,'Operator/DIST2','\"#Thu Dec 01 13:25:38 UTC 2022\n\"\\#Mon=Nov 07 16\\:18\\:19 UTC 2022\n\"=\n\"',NULL,0),
    (4, 7, 0, 'Retailer1', 'Retailer1', '', '', 3, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2022-11-07 16:18:19', '2022-11-07 16:18:19', '2025-02-27 01:34:38', X'', '', 43, 7, 0, 'Operator/DIST1/Retailer1', '\"#Thu Dec 01 13:25:38 UTC 2022\n\"\\#Mon=Nov 07 16\\:18\\:19 UTC 2022\n\"=\n\"', NULL, 0),
	(999999,9,0,'SUBSCRIBER_ENTITY','SUBSCRIBER_ENTITY','','',999999,'',1,2,'','','','Asia/Dhaka','',0,0,1,1,'2022-11-15 14:46:24','2022-11-15 14:46:24','2024-11-05 13:11:29','','',63,13,0,'Operator/SUBSCRIBER_ENTITY','\"#Thu Dec 01 14:30:10 UTC 2022\n\"\\#Tue=Nov 15 14\\:46\\:24 UTC 2022\n\"\\#Thu=Nov 24 09\\:37\\:49 UTC 2022\n\"=\n\"',NULL,0),
	(1000004, 3, 0, 'M/s Kazi Sayed Ali', 'BD10000013', '', '', 256001025, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 11:00:32', '2025-05-20 11:00:32', '2025-05-20 11:00:57', X'23547565204D61792032302031313A30303A353720474D5420323032350A', '', 13, 3, 0, 'Operator/BD10000013', '#Tue May 20 11:00:57 GMT 2025\n', NULL, 0),
    (1000005, 3, 0, 'Pioneer Distribution Ltd-Moghbazar', 'BD10000014', '', '', 256001281, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 11:11:41', '2025-05-20 11:11:42', '2025-05-20 11:11:44', X'23547565204D61792032302031313A31313A343420474D5420323032350A', '', 14, 3, 0, 'Operator/BD10000014', '#Tue May 20 11:11:44 GMT 2025\n', NULL, 0),
    (1000006, 3, 0, 'Sales Promotion Service Unit-3', 'BD10000015', '', '', 256001537, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 11:20:20', '2025-05-20 11:20:20', '2025-05-20 11:20:24', X'23547565204D61792032302031313A32303A323420474D5420323032350A', '', 15, 3, 0, 'Operator/BD10000015', '#Tue May 20 11:20:24 GMT 2025\n', NULL, 0),
    (1000007, 3, 0, 'South Sylhet Telecom Unit-2', 'BD10000016', '', '', 256001793, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 11:26:33', '2025-05-20 11:26:33', '2025-05-20 11:26:34', X'23547565204D61792032302031313A32363A333420474D5420323032350A', '', 16, 3, 0, 'Operator/BD10000016', '#Tue May 20 11:26:34 GMT 2025\n', NULL, 0),
    (1000008, 2, 0, 'Rahad Mullah', 'SEDST000001', '', '', 256002049, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 11:47:05', '2025-05-20 11:47:05', '2025-05-20 11:47:06', X'23547565204D61792032302031313A34373A303620474D5420323032350A', '', 17, 6, 0, 'Operator/DIST1/SEDST000001', '#Tue May 20 11:47:06 GMT 2025\n', NULL, 0),
    (1000009, 2, 0, 'Md. Shohel Ahmed SE 9', 'SEDST000002', '', '', 256002305, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 11:52:57', '2025-05-20 11:52:57', '2025-05-20 11:52:58', X'23547565204D61792032302031313A35323A353820474D5420323032350A', '', 18, 6, 0, 'Operator/DIST1/SEDST000002', '#Tue May 20 11:52:58 GMT 2025\n', NULL, 0),
    (1000010, 2, 0, 'Md. Majnu Mia', 'SEDST000003', '', '', 256002561, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 11:55:44', '2025-05-20 11:55:44', '2025-05-20 11:55:45', X'23547565204D61792032302031313A35353A343520474D5420323032350A', '', 19, 6, 0, 'Operator/DIST1/SEDST000003', '#Tue May 20 11:55:45 GMT 2025\n', NULL, 0),
    (1000011, 1, 0, 'dist121', 'SEDST000007', '', '', 256002817, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 11:56:07', '2025-05-20 11:56:07', '2025-05-20 11:56:08', X'23547565204D61792032302031313A35363A303820474D5420323032350A', '', 20, 6, 0, 'Operator/DIST1/SEDST000007', '#Tue May 20 11:56:08 GMT 2025\n', NULL, 0),
    (1000012, 2, 0, 'Ideal Laibary', 'BD20000015', '', '', 256003073, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 12:14:08', '2025-05-20 12:14:08', '2025-05-20 12:14:09', X'23547565204D61792032302031323A31343A303920474D5420323032350A', '', 21, 7, 0, 'Operator/DIST1/BD20000015', '#Tue May 20 12:14:09 GMT 2025\n', NULL, 0),
    (1000013, 2, 0, 'Babul Store', 'BD20000016', '', '', 256003329, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 12:21:35', '2025-05-20 12:21:35', '2025-05-20 12:21:36', X'23547565204D61792032302031323A32313A333620474D5420323032350A', '', 22, 7, 0, 'Operator/DIST1/BD20000016', '#Tue May 20 12:21:36 GMT 2025\n', NULL, 0),
    (1000014, 2, 0, 'Aslam Store', 'BD20000017', '', '', 256003585, '', 1, 2, '', '', '', 'Asia/Dhaka', '', 0, 0, 1, 0, '2025-05-20 12:24:18', '2025-05-20 12:24:19', '2025-05-20 12:24:20', X'23547565204D61792032302031323A32343A323020474D5420323032350A', '', 23, 7, 0, 'Operator/DIST1/BD20000017', '#Tue May 20 12:24:20 GMT 2025\n', NULL, 0);



/*!40000 ALTER TABLE `commission_receivers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table commission_shop_settings
# ------------------------------------------------------------

LOCK TABLES `commission_shop_settings` WRITE;
/*!40000 ALTER TABLE `commission_shop_settings` DISABLE KEYS */;

INSERT INTO `commission_shop_settings` (`shop_key`, `reseller_key`, `shop_tag`, `shop_name`, `shop_type`, `product_selection_tag`, `payment_options_tag`, `application`, `default_language`, `custom_parameters`, `appearence_base`, `appearence_addition`, `receipt_template_key`, `product_range_key`, `last_modified`)
VALUES
	(2,35,'DIST1','','terminal','','','refill','',X'3133323132726563656970745F726F77333130323132726563656970745F726F77323130323132726563656970745F726F77313130','','',1,0,'2024-11-05 13:36:06'),
	(3,63,'DIST2','','terminal','','','refill','',X'3133323132726563656970745F726F77333130323132726563656970745F726F77323130323132726563656970745F726F77313130','','',1,0,'2024-11-05 13:36:04'),
    (4, 4, 'Retailer1', '', 'terminal', '', '', 'refill', '', X'3133323132726563656970745F726F77333130323132726563656970745F726F77323130323132726563656970745F726F77313130', '', '', 1, 0, '2024-11-05 13:36:04'),
	(999999,59,'SUBSCRIBER_ENTITY','','terminal','','','refill','',X'3133323132726563656970745F726F77333130323132726563656970745F726F77323130323132726563656970745F726F77313130','','',1,0,'2024-11-05 13:35:28');


/*!40000 ALTER TABLE `commission_shop_settings` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table extdev_classes
# ------------------------------------------------------------

LOCK TABLES `extdev_classes` WRITE;
/*!40000 ALTER TABLE `extdev_classes` DISABLE KEYS */;

INSERT INTO `extdev_classes` (`class_key`, `maint_server_key`, `id`, `name`, `description`, `manufacturer`, `serial_prefix`, `serial_digits`, `print_template_type_key`, `interaction_template_type_key`, `connection_pool_key`, `default_language`, `default_buffer_type`, `prepare_instructions`, `last_modified`, `init_data`, `allow_serial_select`, `activate_instructions`, `activation_code_type`, `default_signature_type`, `default_encryption_type`, `allow_remote_imprint`, `charset`, `supports_synchronization`, `supports_remote_upgrade`, `supports_service_code`, `supports_properties`, `properties_declarations`, `supports_buffering`, `supports_server_deactivation`, `address_mandatory`, `used`, `default_user_role_key`, `report_group`, `max_buffers`, `sync_window_start`, `sync_window_end`, `supports_ussd_push_service`, `default_user_id`)
VALUES
	(1,0,'Elite 510N','Elite 510N','Ingenico Elite 510N','Ingenico','',8,1,5,5,'en_ing',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',250,68400,18000,0,''),
	(2,0,'PC Arabic','Prepaid Client Arabic','Ingenico Elite 790 GSM','Seamless','462',3,1,5,3,'eg',0,'Prepare an new Arabic Prepaid client<br>','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>To activate the terminal, the reseller will need following codes.<br><br><table><tr><td><b>Host:</b></td><td>$host_address$</td></tr><tr><td><b>Store id:</b></td><td>$store_id$</td></tr><tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr></table></td></tr></table>',0,0,0,1,'UTF-8',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',10000,68400,18000,0,''),
	(3,0,'Trintech 9400 A','Trintech 9400','Trintech 9400','Trintech','26',6,1,5,1,'en',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',350,68400,18000,0,''),
	(4,0,'Trintech 9400 T','Trintech 9400 Ethernet','Trintech 9400 ISDN','Trintech','27',6,1,5,6,'en',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',350,68400,18000,0,''),
	(5,0,'Windows client','Windows client','PC client or Cashregister client','Seamless','4610',8,1,5,6,'en',0,'Prepare a new Windows client<br>','2024-10-01 09:56:49','',1,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',1000,68400,18000,0,''),
	(6,0,'Elite 710','Elite 710','Ingenico Elite 710-16','Ingenico','',8,1,5,1,'en_ingenico',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'0',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',250,68400,18000,0,''),
	(7,0,'S3000','Moneyline S3000','Moneyline S3000','Moneyline','',8,1,5,5,'en',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',200,68400,18000,0,''),
	(8,0,'Elite 500N','Elite 510N (old)','Elite 510N (old)','Ingenico','',8,1,5,1,'en',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'UTF-8',1,1,1,1,'',1,0,0,0,5,'POSInteractiveReport',200,68400,18000,0,''),
	(9,0,'Elite 730','Elite 730','Elite 730','Ingenico','',8,1,5,1,'en',0,'','2024-10-01 09:56:49','',0,'',0,0,0,0,'',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',250,68400,18000,0,''),
	(10,0,'VERIFONE VX A','Verifone Vx Analouge','PC client or Cashregister client (old)','Seamless','4612',8,1,5,8,'en',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',350,68400,18000,0,''),
	(12,0,'prepaid_client','Prepaid Client','Prepaid Client software','Seamless','8020',4,1,5,1,'en',0,'Prepare a new Windows client<br>','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>To activate the terminal, the reseller will need following codes.<br><br><table><tr><td><b>Host:</b></td><td>$host_address$</td></tr><tr><td><b>Store id:</b></td><td>$store_id$</td></tr><tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr></table></td></tr></table>',0,0,0,1,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',10000,68400,18000,0,''),
	(13,0,'prepaid_client_ssl','Prepaid Client (SSL)','Prepaid Client software','Seamless','461',3,1,5,3,'en',0,'Prepare a new Windows client<br>','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>To activate the terminal, the reseller will need following codes.<br><br><table><tr><td><b>Host:</b></td><td>$host_address$</td></tr><tr><td><b>Store id:</b></td><td>$store_id$</td></tr><tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr></table></td></tr></table>',0,0,0,1,'UTF-8',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',10000,68400,18000,0,''),
	(14,0,'STK_phone','STK phone','SIM toolkit phone','Seamless','720',3,1,5,3,'en',0,'Prepare a new STK phone<br>','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',0,0,0,0,'',0,1,1,1,5,'POSInteractiveReport',0,68400,18000,0,''),
	(15,0,'VERIFONE VX G','Verifone Vx Gprs','0','Verifone','4612',8,1,5,8,'en',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',350,68400,18000,0,''),
	(16,0,'VERIFONE VX W','Verifone Vx Wifi','0','Verifone','4612',8,1,5,8,'en',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',350,68400,18000,0,''),
	(17,0,'VERIFONE VX T','Verifone Vx Ethernet','0','Verifone','4612',8,1,5,8,'en',0,'','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',350,68400,18000,0,''),
	(18,0,'PC UTF8','Prepaid Client UTF8/en','PrepaidClient','Seamless','463',3,1,5,3,'en',0,'Prepare an new UTF8-English Prepaid client<br>','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>To activate the terminal, the reseller will need following codes.<br><br><table><tr><td><b>Host:</b></td><td>$host_address$</td></tr><tr><td><b>Store id:</b></td><td>$store_id$</td></tr><tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr></table></td></tr></table>',0,0,0,1,'UTF-8',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',10000,68400,18000,0,''),
	(19,0,'Trintech 9400 I','Trintech 9400 ISDN','','Trintech','',8,1,1,1,'d',0,'','2024-10-01 09:56:49','',1,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,1,0,'ISO-8859-1',1,0,1,0,'',1,0,0,1,5,'POSInteractiveReport',350,68400,18000,0,''),
	(20,0,'Phone','Phone','Normal phone without STK appliation','Seamless','720',3,1,5,3,'en',0,'Prepare a new phone<br>','2024-10-01 09:56:49','',0,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',0,0,0,0,'',0,1,1,1,5,'POSInteractiveReport',0,68400,18000,0,'9900'),
	(21,0,'Windows storage','Windows storage','PC client or Cashregister client','Seamless','4610',8,1,5,6,'en',0,'Prepare a new Windows client<br>','2024-10-01 09:56:49','',1,'<table style=\"border : 1px solid #FF0000;\"><tr><td>\r\nTo activate the terminal, the reseller will need following codes.<br>\r\n<br>\r\n<table>\r\n<tr><td><b>Start code:</b></td><td>$start_code$</td></tr>\r\n<tr><td><b>Activation code:</b></td><td>$activation_code$</td></tr>\r\n</table>\r\n</td></tr></table>',0,0,0,0,'ISO-8859-1',1,1,1,1,'',1,0,0,1,5,'POSInteractiveReport',0,68400,18000,0,'');

/*!40000 ALTER TABLE `extdev_classes` ENABLE KEYS */;
UNLOCK TABLES;



# Dump of table extdev_devices
# ------------------------------------------------------------

LOCK TABLES `extdev_devices` WRITE;
/*!40000 ALTER TABLE `extdev_devices` DISABLE KEYS */;

INSERT INTO `extdev_devices` (`device_key`, `class_key`, `name`, `serial`, `state`, `activation_code`, `owner_key`, `country_key`, `language_key`, `encryption_key`, `parameters`, `parameters2`, `type`, `address`, `compression_type`, `encryption_type`, `software_version`, `software_build`, `time_imprinted`, `time_assigned`, `time_activated`, `time_updated`, `signature_key`, `signature_type`, `note`, `position_status`, `primary_connection_point`, `secondary_connection_point`, `system_update_timestamp`, `products_update_timestamp`, `users_update_timestamp`, `last_syncronized`, `next_syncronize`, `sync_window_start`, `sync_window_end`, `sync_interval`, `download_status`, `next_software_download`, `last_syncronized_local`, `last_request_serial`, `device_buffer_type`, `last_state_change`, `max_buffers`, `max_categories`, `max_products`, `max_resources`, `max_users`, `last_software_download`, `receipt_template_type_key`, `interact_template_type_key`, `language`, `last_modified`, `activation_code_type`, `activation_instructions`, `address_lock`, `planned_deactivation_time`, `planned_activation_time`, `trace_level`, `default_user_key`)
VALUES
	(1,20,'','8801700000000',2,'',1,0,0,X'5B42403463363931343733','\"#Thu Dec 01 14:40:56 UTC 2022\n\"',NULL,'Phone','8801700000000',0,1,'','','2022-11-15 14:01:50','0000-00-00 00:00:00','1970-01-01 05:30:00','1970-01-01 05:30:00',X'5B424036653634633037',0,'',0,'','','2022-11-15 14:01:50','2022-11-15 14:01:50','2022-11-15 14:01:50','1970-01-01 05:30:00','1970-01-01 05:30:00',0,0,86400,0,'1970-01-01 05:30:00','1970-01-01 05:30:00',0,0,'2022-11-16 18:35:58',0,20,20,20,32,'0000-00-00 00:00:00',0,0,'','2023-03-14 04:05:37',0,'','8801700000000','1970-01-01 05:30:00','1970-01-01 05:30:00',0,3),
	(2,20,'','8801700000001',2,'',2,0,0,X'5B42403463363931343733','\"#Thu Dec 01 14:31:12 UTC 2022\n\"\\#Mon=Nov 07 14\\:41\\:46 UTC 2022\n\"=\n\"',NULL,'Phone','8801700000001',0,4,'','','2022-11-07 14:41:46','0000-00-00 00:00:00','2022-11-07 14:41:46','1970-01-01 00:00:00',X'5B424036653634633037',0,'',0,'','','2022-11-07 14:41:46','2022-11-07 14:41:46','2022-11-07 14:41:46','1970-01-01 00:00:00','1970-01-01 00:00:00',0,0,86400,0,'1970-01-01 00:00:00','1970-01-01 00:00:00',0,0,'2022-11-07 14:41:46',0,20,20,20,32,'0000-00-00 00:00:00',0,0,'','2024-11-05 13:39:43',0,'','8801700000099','1970-01-01 00:00:00','1970-01-01 00:00:00',0,66),
	(3,20,'','8801700000002',2,'',3,0,0,X'5B42403463363931343733','\"#Thu Dec 01 13:24:32 UTC 2022\n\"\\#Mon=Nov 07 14\\:41\\:46 UTC 2022\n\"=\n\"',NULL,'Phone','8801700000002',0,4,'','','2022-11-07 14:41:46','0000-00-00 00:00:00','2022-11-07 14:41:46','1970-01-01 00:00:00',X'5B424036653634633037',0,'',0,'','','2022-11-07 14:41:46','2022-11-07 14:41:46','2022-11-07 14:41:46','1970-01-01 00:00:00','1970-01-01 00:00:00',0,0,86400,0,'1970-01-01 00:00:00','1970-01-01 00:00:00',0,0,'2022-11-07 14:41:46',0,20,20,20,32,'0000-00-00 00:00:00',0,0,'','2024-11-05 13:39:44',0,'','8801700000001','1970-01-01 00:00:00','1970-01-01 00:00:00',0,68),
    (4,20,'','8801700000003',2,'',4,0,0,X'5B42403463363931343733','\"#Thu Dec 01 13:24:32 UTC 2022\n\"\\#Mon=Nov 07 14\\:41\\:46 UTC 2022\n\"=\n\"',NULL,'Phone','8801700000003',0,4,'','','2022-11-07 14:41:46','0000-00-00 00:00:00','2022-11-07 14:41:46','1970-01-01 00:00:00',X'5B424036653634633037',0,'',0,'','','2022-11-07 14:41:46','2022-11-07 14:41:46','2022-11-07 14:41:46','1970-01-01 00:00:00','1970-01-01 00:00:00',0,0,86400,0,'1970-01-01 00:00:00','1970-01-01 00:00:00',0,0,'2022-11-07 14:41:46',0,20,20,20,32,'0000-00-00 00:00:00',0,0,'','2024-11-05 13:39:44',0,'','8801700000003','1970-01-01 00:00:00','1970-01-01 00:00:00',0,8),
    (9, 20, '', '8801587687607', 2, '', 1000004, 0, 0, X'5B42403332613035623965', '#Tue May 20 11:00:37 GMT 2025\n', NULL, 'Phone', '8801587687607', 0, 4, '', '', '2025-05-20 11:00:37', '0000-00-00 00:00:00', '2025-05-20 11:00:37', '1970-01-01 00:00:00', X'5B42403264623138366461', 0, '', 0, '', '', '2025-05-20 11:00:37', '2025-05-20 11:00:37', '2025-05-20 11:00:37', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 11:00:37', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 11:00:37', 0, '', '8801587687607', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 19),
    (10, 20, '', '8801713010190', 2, '', 1000005, 0, 0, X'5B424035373665396134', '#Tue May 20 11:11:42 GMT 2025\n', NULL, 'Phone', '8801713010190', 0, 4, '', '', '2025-05-20 11:11:42', '0000-00-00 00:00:00', '2025-05-20 11:11:42', '1970-01-01 00:00:00', X'5B42403237333635313866', 0, '', 0, '', '', '2025-05-20 11:11:42', '2025-05-20 11:11:42', '2025-05-20 11:11:42', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 11:11:42', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 11:11:42', 0, '', '8801713010190', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 20),
    (11, 20, '', '8801777122277', 2, '', 1000006, 0, 0, X'5B424065323236653138', '#Tue May 20 11:20:20 GMT 2025\n', NULL, 'Phone', '8801777122277', 0, 4, '', '', '2025-05-20 11:20:20', '0000-00-00 00:00:00', '2025-05-20 11:20:20', '1970-01-01 00:00:00', X'5B42403338393061383336', 0, '', 0, '', '', '2025-05-20 11:20:20', '2025-05-20 11:20:20', '2025-05-20 11:20:20', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 11:20:20', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 11:20:20', 0, '', '8801777122277', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 21),
    (12, 20, '', '8801788224565', 2, '', 1000007, 0, 0, X'5B42403539623632376233', '#Tue May 20 11:26:33 GMT 2025\n', NULL, 'Phone', '8801788224565', 0, 4, '', '', '2025-05-20 11:26:33', '0000-00-00 00:00:00', '2025-05-20 11:26:33', '1970-01-01 00:00:00', X'5B42403336643865353638', 0, '', 0, '', '', '2025-05-20 11:26:33', '2025-05-20 11:26:33', '2025-05-20 11:26:33', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 11:26:33', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 11:26:33', 0, '', '8801788224565', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 22),
    (13, 20, '', '8801754872702', 2, '', 1000008, 0, 0, X'5B42403137393035303231', '#Tue May 20 11:47:05 GMT 2025\n', NULL, 'Phone', '8801754872702', 0, 4, '', '', '2025-05-20 11:47:05', '0000-00-00 00:00:00', '2025-05-20 11:47:05', '1970-01-01 00:00:00', X'5B424064366330333237', 0, '', 0, '', '', '2025-05-20 11:47:05', '2025-05-20 11:47:05', '2025-05-20 11:47:05', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 11:47:05', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 11:47:05', 0, '', '8801754872702', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 23),
    (14, 20, '', '8801760762222', 2, '', 1000009, 0, 0, X'5B42403438326433373939', '#Tue May 20 11:52:57 GMT 2025\n', NULL, 'Phone', '8801760762222', 0, 4, '', '', '2025-05-20 11:52:57', '0000-00-00 00:00:00', '2025-05-20 11:52:57', '1970-01-01 00:00:00', X'5B42403532326132383636', 0, '', 0, '', '', '2025-05-20 11:52:57', '2025-05-20 11:52:57', '2025-05-20 11:52:57', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 11:52:57', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 11:52:57', 0, '', '8801760762222', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 24),
    (15, 20, '', '8801711442823', 2, '', 1000010, 0, 0, X'5B42403534316265373036', '#Tue May 20 11:55:44 GMT 2025\n', NULL, 'Phone', '8801711442823', 0, 4, '', '', '2025-05-20 11:55:44', '0000-00-00 00:00:00', '2025-05-20 11:55:44', '1970-01-01 00:00:00', X'5B42403461316630343334', 0, '', 0, '', '', '2025-05-20 11:55:44', '2025-05-20 11:55:44', '2025-05-20 11:55:44', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 11:55:44', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 11:55:44', 0, '', '8801711442823', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 25),
    (16, 20, '', '8801383821221', 2, '', 1000011, 0, 0, X'5B42403233343635636663', '#Tue May 20 11:56:07 GMT 2025\n', NULL, 'Phone', '8801383821221', 0, 4, '', '', '2025-05-20 11:56:07', '0000-00-00 00:00:00', '2025-05-20 11:56:07', '1970-01-01 00:00:00', X'5B424065613838623361', 0, '', 0, '', '', '2025-05-20 11:56:07', '2025-05-20 11:56:07', '2025-05-20 11:56:07', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 11:56:07', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 11:56:07', 0, '', '8801383821221', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 26),
    (17, 20, '', '8801710700109', 2, '', 1000012, 0, 0, X'5B42403363396261366332', '#Tue May 20 12:14:09 GMT 2025\n', NULL, 'Phone', '8801710700109', 0, 4, '', '', '2025-05-20 12:14:09', '0000-00-00 00:00:00', '2025-05-20 12:14:09', '1970-01-01 00:00:00', X'5B42403731663839363466', 0, '', 0, '', '', '2025-05-20 12:14:09', '2025-05-20 12:14:09', '2025-05-20 12:14:09', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 12:14:09', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 12:14:09', 0, '', '8801710700109', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 27),
    (18, 20, '', '8801794534518', 2, '', 1000013, 0, 0, X'5B42403665343431303663', '#Tue May 20 12:21:35 GMT 2025\n', NULL, 'Phone', '8801794534518', 0, 4, '', '', '2025-05-20 12:21:35', '0000-00-00 00:00:00', '2025-05-20 12:21:35', '1970-01-01 00:00:00', X'5B42403630313737633366', 0, '', 0, '', '', '2025-05-20 12:21:35', '2025-05-20 12:21:35', '2025-05-20 12:21:35', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 12:21:35', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 12:21:35', 0, '', '8801794534518', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 28),
    (19, 20, '', '8801744043945', 2, '', 1000014, 0, 0, X'5B42403566313862366235', '#Tue May 20 12:24:19 GMT 2025\n', NULL, 'Phone', '8801744043945', 0, 4, '', '', '2025-05-20 12:24:19', '0000-00-00 00:00:00', '2025-05-20 12:24:19', '1970-01-01 00:00:00', X'5B42403262633064396439', 0, '', 0, '', '', '2025-05-20 12:24:19', '2025-05-20 12:24:19', '2025-05-20 12:24:19', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, 86400, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 0, '2025-05-20 12:24:19', 0, 20, 20, 20, 32, '0000-00-00 00:00:00', 0, 0, '', '2025-05-20 12:24:19', 0, '', '8801744043945', '1970-01-01 00:00:00', '1970-01-01 00:00:00', 0, 29);


/*!40000 ALTER TABLE `extdev_devices` ENABLE KEYS */;
UNLOCK TABLES;



# Dump of table id_applicationgroups
# ------------------------------------------------------------

LOCK TABLES `id_applicationgroups` WRITE;
/*!40000 ALTER TABLE `id_applicationgroups` DISABLE KEYS */;

INSERT INTO `id_applicationgroups` (`ApplicationGroupKey`, `ApplicationGroupName`, `last_modified`)
VALUES
	(1,'AdminGroup','2024-10-01 09:56:49'),
	(2,'Refill','2024-10-01 09:56:49');

/*!40000 ALTER TABLE `id_applicationgroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table id_domains
# ------------------------------------------------------------

LOCK TABLES `id_domains` WRITE;
/*!40000 ALTER TABLE `id_domains` DISABLE KEYS */;

INSERT INTO `id_domains` (`DomainKey`, `ParentDomainKey`, `PathName`, `DynamicData`, `CreatorUserKey`, `ApplicationGroupKey`, `last_modified`)
VALUES
	(1,0,'Super',NULL,0,1,'2022-11-02 09:42:30'),
	(2,0,'Super',NULL,1,2,'2022-11-02 09:42:30'),
	(3,2,'Super/Admin',NULL,1,2,'2022-11-02 09:42:30'),
	(4,2,'Super/Users',NULL,1,2,'2022-11-02 09:42:30'),
	(5,2,'Super/Partners',NULL,1,2,'2022-11-02 09:42:30'),
	(6,5,'Super/Partners/operator',NULL,0,2,'2022-11-03 07:56:24'),
	(7,5,'Super/Partners/DIST1',NULL,0,2,'2022-11-07 09:11:46'),
    (8,5,'Super/Partners/DIST2',NULL,0,2,'2022-11-07 09:20:26'),
    (13, 5, 'Super/Partners/BD10000013', NULL, 0, 2, '2025-05-20 11:00:32'),
    (14, 5, 'Super/Partners/BD10000014', NULL, 0, 2, '2025-05-20 11:11:42'),
    (15, 5, 'Super/Partners/BD10000015', NULL, 0, 2, '2025-05-20 11:20:20'),
    (16, 5, 'Super/Partners/BD10000016', NULL, 0, 2, '2025-05-20 11:26:33'),
    (17, 5, 'Super/Partners/SEDST000001', NULL, 0, 2, '2025-05-20 11:47:05'),
    (18, 5, 'Super/Partners/SEDST000002', NULL, 0, 2, '2025-05-20 11:52:57'),
    (19, 5, 'Super/Partners/SEDST000003', NULL, 0, 2, '2025-05-20 11:55:44'),
    (20, 5, 'Super/Partners/SEDST000007', NULL, 0, 2, '2025-05-20 11:56:07'),
    (21, 5, 'Super/Partners/BD20000015', NULL, 0, 2, '2025-05-20 12:14:08'),
    (22, 5, 'Super/Partners/BD20000016', NULL, 0, 2, '2025-05-20 12:21:35'),
    (23, 5, 'Super/Partners/BD20000017', NULL, 0, 2, '2025-05-20 12:24:19');

/*!40000 ALTER TABLE `id_domains` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table id_password_policies
# ------------------------------------------------------------

LOCK TABLES `id_password_policies` WRITE;
/*!40000 ALTER TABLE `id_password_policies` DISABLE KEYS */;

INSERT INTO `id_password_policies` (`policy_key`, `name`, `description`, `change_policy`, `visible_password`, `password_min_length`, `password_max_length`, `password_regexp`, `password_change_template_key`, `password_change_at_first_login`, `legal_characters`, `encryption_format`, `create_policy`, `create_message`, `create_template_key`, `password_expiry_period`, `password_control`, `banned_passwords`, `incorrectlogin_max_attempt`, `user_passwords_history`, `make_user_editable`, `dormancy_period`)
VALUES
	(1,'Default','Default password settings',0,1,4,32,'[a-zA-Z0-9]*',0,1,2,0,1,0,0,0,0,'1234',3,10,1,0),
	(2,'STK PIN code','Password is generated by system. Password is changed by using the reset function. Then a new password is generated by the system and sent out to the user.',0,1,4,4,'',170,0,0,0,1,1,169,0,1,'1234',3,10,1,0),
	(3,'Reseller web user','Password must be at least 6 characters. Digits and letters are valid password characters. No spaces or other special characters are valid.',0,1,2,20,'[a-zA-Z0-9]*',170,1,2,0,1,2,169,0,0,'1234',3,10,1,0),
	(4,'POS password','Password policy for POS terminal users.',0,1,4,4,'[a-zA-Z0-9]*',0,0,2,0,1,0,0,0,0,'1234',3,1,1,0);

/*!40000 ALTER TABLE `id_password_policies` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table id_roles
# ------------------------------------------------------------

LOCK TABLES `id_roles` WRITE;
/*!40000 ALTER TABLE `id_roles` DISABLE KEYS */;

INSERT INTO `id_roles` (`RoleKey`, `RoleName`, `RoleDescription`, `DynamicData`, `last_modified`, `password_policy_key`, `domain_key`, `import_id`, `terminal_user`, `web_user`, `address_lock`, `userid_regexp`, `parent_role_key`) VALUES
(1,'Agent Logistics','Agent Logistics User','','2024-11-05 13:43:45',1,5,'alog',0,1,'','',0),
(2,'Allocation Supply','Allocation Supply User','','2024-11-05 13:43:45',1,5,'als',0,1,'','',0),
(3,'Central Logistics','Central Logistics User','','2024-11-05 13:43:45',1,5,'clog',0,1,'','',0),
(4,'Circle Business Head','Circle Business Head User','','2024-11-05 13:43:45',1,5,'cbh',0,1,'','',0),
(5,'Circle Distribution','Circle Distribution User','','2024-11-05 13:43:45',1,5,'crd',0,1,'','',0),
(6,'Circle Marketing','Circle Marketing User','','2024-11-05 13:43:45',1,5,'crm',0,1,'','',0),
(7,'Cluster Manager','Cluster Manager User','','2024-11-05 13:43:45',1,5,'clm',0,1,'','',0),
(8,'Core User','Core User User','','2024-11-05 13:43:45',1,5,'core',0,1,'','',0),
(9,'DTR Compliance User','DTR Compliance User User','','2024-11-05 13:43:45',1,5,'dcu',0,1,'','',0),
(10,'DTR User','DTR User User','','2024-11-05 13:43:45',1,5,'dtu',0,1,'','',0),
(11,'Distributor Manager','Distributor Manager User','','2024-11-05 13:43:45',1,5,'dm',0,1,'','',0),
(12,'Finance','Finance User','','2024-11-05 13:43:45',1,5,'fin',0,1,'','',0),
(13,'Finance IR Sales report user','Finance IR Sales report user User','','2024-11-05 13:43:45',1,5,'irs',0,1,'','',0),
(14,'GPC Center Head','GPC Center Head User','','2024-11-05 13:43:45',1,5,'gpch',0,1,'','',0),
(15,'GPC Deputy Center Head','GPC Deputy Center Head User','','2024-11-05 13:43:45',1,5,'dch',0,1,'','',0),
(16,'GPC Jr. Trainee','GPC Jr. Trainee User','','2024-11-05 13:43:45',1,5,'gpjt',0,1,'','',0),
(17,'GPC Retail Head','GPC Retail Head User','','2024-11-05 13:43:45',1,5,'gprh',0,1,'','',0),
(18,'GPC Trainee','GPC Trainee User','','2024-11-05 13:43:45',1,5,'gpt',0,1,'','',0),
(19,'GPCF RMS User','GPCF RMS User User','','2024-11-05 13:43:45',1,5,'gfu',0,1,'','',0),
(20,'Head of Distribution','Head of Distribution User','','2024-11-05 13:43:45',1,5,'hod',0,1,'','',0),
(21,'LOG','LOG User','','2024-11-05 13:43:45',1,5,'log',0,1,'','',0),
(22,'Logistics','Logistics User','','2024-11-05 13:43:45',1,5,'gpl',0,1,'','',0),
(23,'Market Development Officer','Market Development Officer User','','2024-11-05 13:43:45',1,5,'mdo',0,1,'','',0),
(24,'National Quality Manager','National Quality Manager User','','2024-11-05 13:43:45',1,5,'nqm',0,1,'','',0),
(25,'RMS BI Users','RMS BI Users User','','2024-11-05 13:43:45',1,5,'rbi',0,1,'','',0),
(26,'RMS Core Admin','RMS Core Admin User','','2024-11-05 13:43:45',1,5,'rca',0,1,'','',0),
(27,'RMS Finance users','RMS Finance users User','','2024-11-05 13:43:45',1,5,'rfu',0,1,'','',0),
(28,'RMS Sale Service Expert','RMS Sale Service Expert User','','2024-11-05 13:43:45',1,5,'sep',0,1,'','',0),
(29,'RMS Tax Mgt users','RMS Tax Mgt users User','','2024-11-05 13:43:45',1,5,'ftx',0,1,'','',0),
(30,'Regional Head','Regional Head User','','2024-11-05 13:43:45',1,5,'rh',0,1,'','',0),
(31,'Report user_Retail','Report user_Retail User','','2024-11-05 13:43:45',1,5,'rpur',0,1,'','',0),
(32,'Retail Channel Manager','Retail Channel Manager User','','2024-11-05 13:43:45',1,5,'rcm',0,1,'','',0),
(33,'SE Supervisor','SE Supervisor User','','2024-11-05 13:43:45',1,5,'ses',0,1,'','',0),
(34,'Report User','Report User User','','2024-11-05 13:43:45',1,5,'rpu',0,1,'','',0),
(35,'Default Role', 'Default Role', X'', '2025-01-13 11:34:43', 3, 5, 'default_role', 1, 1, '', '', 0),
(36,'Default BCU','Default BCU','','2024-11-05 13:44:28',3,5,'default_bcu',0,1,'','',0),
(37,'Cockpit Role','Cockpit Role', X'','2024-11-05 13:44:28','3','5', 'cockpit','0','1','','','0');

/*!40000 ALTER TABLE `id_roles` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table id_users
# ------------------------------------------------------------

LOCK TABLES `id_users` WRITE;
/*!40000 ALTER TABLE `id_users` DISABLE KEYS */;

INSERT INTO `id_users` (`UserKey`, `UserId`, `Password`, `Status`, `IncorrectAttempts`, `LastIncorrectAttemptTime`, `LastLoginTime`, `CreationTime`, `TotalLogins`, `AddressKey`, `DomainKey`, `DynamicData`, `CreatorKey`, `password_expiry_period`, `password_expiry`, `password_format`, `last_modified`, `last_password_change_time`, `role_key`, `connection_profile_key`, `fields`, `time_in_mili_second`)
VALUES
	('1', 'Operator', X'32303233', '0', '0', '2024-10-13 13:18:16', '2024-11-04 13:31:03', '2022-08-25 12:53:25', '0', '1', '6', NULL, '0', '0', '1970-01-01 00:00:00', '0', '2025-05-12 09:00:13', '2022-11-03 07:53:55', '8', '0', '#Mon Apr 05 12:53:25 IST 2022', '1617607405'),
	('2', 'DIST1', X'32303233', 0, 0, '2023-03-14 08:23:35', '2025-05-16 10:57:23', '2022-11-07 14:41:46', 4, 1, 39, NULL, 0, 0, '1970-01-01 00:00:00', 0, '2025-05-16 11:10:59', '2022-11-23 13:10:59', 11, 0, '#Thu Dec 01 13:24:32 UTC 2022\nMSISDN=8801700000001\nEmail=DIST1@seamless.se\nuserName=DISTRIBUTOR1\n', 0),
	('3', 'DIST2', X'32303233', 0, 0, '1970-01-01 00:00:00', '2023-03-14 08:15:47', '2022-11-07 14:41:46', 0, 2, 40, NULL, 0, 0, '1970-01-01 00:00:00', 0, '2025-05-16 11:12:50', '2022-11-03 07:53:55', 11, 0, '#Thu Dec 01 13:24:37 UTC 2022\nMSISDN=467002\nEmail=FS1@seamless.se\nuserName=DISTRIBUTOR2\n', 0),
	('4', 'cm1', X'32303233', '0', '0', '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-01-24 07:04:19', '0', '3', '6', X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', '0', '0', '1970-01-01 00:00:00', '0', '2025-05-12 09:03:26', '0000-00-00 00:00:00', '7', '0', '#Fri Jan 24 07:04:19 GMT 2025\nFirstName=Cluster Manager1\nMSISDN=1712349991\nEmail=clm1@yopmail.com\n', '0'),
	('5', 'cm2', X'32303233', '0', '0', '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-01-24 07:09:03', '0', '4', '6', X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', '0', '0', '1970-01-01 00:00:00', '0', '2025-05-12 09:03:27', '0000-00-00 00:00:00', '7', '0', '#Fri Jan 24 07:09:03 GMT 2025\nFirstName=Cluster Manager2\nMSISDN=1712349992\nEmail=clm2@yopmail.com\n', '0'),
	('6', 'cm3', X'32303233', '0', '0', '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-01-24 14:04:32', '0', '5', '6', X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', '0', '0', '1970-01-01 00:00:00', '0', '2025-05-12 09:03:28', '0000-00-00 00:00:00', '7', '0', '#Fri Jan 24 14:04:32 GMT 2025\nFirstName=Cluster Manager3\nMSISDN=1712349993\nEmail=clm3@yopmail.com\n', '0'),
	('7', 'cockpit', X'32303233', '0', '0', '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-01-24 14:04:32', '0', '5', '6', X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', '0', '0', '1970-01-01 00:00:00', '0', '2025-01-24 14:04:32', '0000-00-00 00:00:00', '37', '0', '#Fri Jan 24 14:04:32 GMT 2025\nFirstName=Cockpit\nMSISDN=1712349993\nEmail=cockpit@yopmail.com\n', '0'),
	('8', 'ch1', X'32303233', '0', '0', '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-01-24 07:04:19', '0', '3', '6', X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', '0', '0', '1970-01-01 00:00:00', '0', '2025-05-12 09:08:23', '0000-00-00 00:00:00', '14', '0', '#Fri Jan 24 07:04:19 GMT 2025\nFirstName=Cluster Manager1\nMSISDN=1712349991\nEmail=center_head1@yopmail.com\n', '0'),
	('9', 'ch2', X'32303233', '0', '0', '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-01-24 07:04:19', '0', '3', '6', X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', '0', '0', '1970-01-01 00:00:00', '0', '2025-05-12 09:08:39', '0000-00-00 00:00:00', '15', '0', '#Fri Jan 24 07:04:19 GMT 2025\nFirstName=Cluster Manager1\nMSISDN=1712349991\nEmail=center_head2@yopmail.com\n', '0'),
	('10', 'op_rpm', X'32303233', '0', '0', '1970-01-01 00:00:00', '2025-05-08 12:57:59', '2025-01-24 07:04:19', '1', '3', '6', X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', '0', '0', '1970-01-01 00:00:00', '0', '2025-05-12 09:09:01', '0000-00-00 00:00:00', '28', '0', '#Fri Jan 24 07:04:19 GMT 2025\nFirstName=RMS Sale Service Expert 1\nMSISDN=1712349995\nEmail=op_rpm@yopmail.com\n', '0'),
	(19, 'BD10000013', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 11:00:37', 0, 256002048, 13, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 11:00:37', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 11:00:37 GMT 2025\n', 0),
    (20, 'BD10000014', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 11:11:42', 0, 256002304, 14, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 11:11:42', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 11:11:42 GMT 2025\n', 0),
    (21, 'BD10000015', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 11:20:20', 0, 256002560, 15, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 11:20:20', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 11:20:20 GMT 2025\n', 0),
    (22, 'BD10000016', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 11:26:33', 0, 256002816, 16, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 11:26:33', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 11:26:33 GMT 2025\n', 0),
    (23, 'SEDST000001', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 11:47:05', 0, 256003072, 17, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 11:47:05', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 11:47:05 GMT 2025\n', 0),
    (24, 'SEDST000002', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 11:52:57', 0, 256003328, 18, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 11:52:57', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 11:52:57 GMT 2025\n', 0),
    (25, 'SEDST000003', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 11:55:44', 0, 256003584, 19, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 11:55:44', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 11:55:44 GMT 2025\n', 0),
    (26, 'SEDST000007', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 11:56:07', 0, 256003840, 20, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 11:56:07', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 11:56:07 GMT 2025\n', 0),
    (27, 'BD20000015', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 12:14:08', 0, 256004096, 21, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 12:14:09', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 12:14:08 GMT 2025\n', 0),
    (28, 'BD20000016', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 12:21:35', 0, 256004352, 22, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 12:21:35', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 12:21:35 GMT 2025\n', 0),
    (29, 'BD20000017', X'32303233', 0, 0, '1970-01-01 00:00:00', '1970-01-01 00:00:00', '2025-05-20 12:24:19', 0, 256004608, 23, X'3133323138726566696C6C2E7465726D696E616C2E49503130323236726566696C6C2E7465726D696E616C2E757365725F67726F7570313155323239726566696C6C2E7465726D696E616C2E7465726D696E616C5F75736572313474727565', 0, 0, '1970-01-01 00:00:00', 0, '2025-05-20 12:24:19', '0000-00-00 00:00:00', 35, 0, '#Tue May 20 12:24:19 GMT 2025\n', 0);

/*!40000 ALTER TABLE `id_users` ENABLE KEYS */;
UNLOCK TABLES;



# Dump of table loc_countries
# ------------------------------------------------------------

LOCK TABLES `loc_countries` WRITE;
/*!40000 ALTER TABLE `loc_countries` DISABLE KEYS */;

INSERT INTO `loc_countries` (`country_key`, `abbreviation`, `name`, `system_primary`, `date_format`, `time_format`, `decimal_separator`, `thousands_separator`, `number_format`, `number_regexp`, `primary_currency_key`, `primary_language_key`, `last_modified`, `selectable`, `country_code`, `MSISDN_significant_digits`)
VALUES
	(1,'BDT','Bangladesh',1,'yyyy-MM-dd','HH:mm','.',',','','',1,0,'2022-12-05 03:33:56',1,'46',6);

/*!40000 ALTER TABLE `loc_countries` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table loc_currencies
# ------------------------------------------------------------

LOCK TABLES `loc_currencies` WRITE;
/*!40000 ALTER TABLE `loc_currencies` DISABLE KEYS */;

INSERT INTO `loc_currencies` (`currency_key`, `country_key`, `abbreviation`, `name`, `symbol`, `natural_format`, `minorcur_decimals`, `minorcur_name`, `last_modified`, `selectable`, `currency_code`)
VALUES
	(1,1,'BDT','BDT','BDT','{0}BDT',2,'cents','2022-11-17 06:57:42',1,978),
	(19,0,'%','Percent','%','{0}%',2,'','2022-11-03 01:20:06',0,0);

/*!40000 ALTER TABLE `loc_currencies` ENABLE KEYS */;
UNLOCK TABLES;



# Dump of table loc_languages
# ------------------------------------------------------------

LOCK TABLES `loc_languages` WRITE;
/*!40000 ALTER TABLE `loc_languages` DISABLE KEYS */;

INSERT INTO `loc_languages` (`language_key`, `country_key`, `abbreviation`, `name`, `native_name`, `last_modified`)
VALUES
	(1,1,'en','English','','2024-10-01 09:56:49');

/*!40000 ALTER TABLE `loc_languages` ENABLE KEYS */;
UNLOCK TABLES;



# Dump of table pay_options
# ------------------------------------------------------------

LOCK TABLES `pay_options` WRITE;
/*!40000 ALTER TABLE `pay_options` DISABLE KEYS */;

INSERT INTO `pay_options` (`account_type_key`, `id`, `name`, `url`, `status`, `description`, `balance_check`, `reseller_account_type`, `account_sharing_policy`, `last_modified`, `payment_currency_key`, `min_account_balance`, `max_account_balance`, `min_transaction_amount`, `max_transaction_amount`)
VALUES
	(1,'RESELLER','Reseller account','http://localhost:8092/accountsystem',0,'Reseller credit account',1,1,0,'2016-01-19 09:07:30',1,0,0,0,0),
	(2,'AIRTIME','Subscriber airtime account','http://localhost:8091/accountlinksimulator',0,'Subscriber prepaid airtime account',1,0,0,'2021-09-15 10:57:13',1,0,0,0,0),
	(3,'BOOKKEEPING','Book Keeping account','http://localhost:8092/accountsystem',0,'Book Keeping airtime account',1,1,0,'2021-09-15 10:57:13',1,0,0,0,0);

/*!40000 ALTER TABLE `pay_options` ENABLE KEYS */;
UNLOCK TABLES;



# Dump of table pay_prereg_accounts
# ------------------------------------------------------------

LOCK TABLES `pay_prereg_accounts` WRITE;
/*!40000 ALTER TABLE `pay_prereg_accounts` DISABLE KEYS */;

INSERT INTO `pay_prereg_accounts` (`account_key`, `payment_account_type_key`, `user_key`, `account_name`, `pay_limit_value`, `pay_limit_currency`, `transaction_limit_count`, `account_type`, `account_nr`, `account_expire_date`, `owner_type_key`, `owner_key`, `master_owner_key`, `account_type_key`, `issuer_key`, `pay_limit_period`, `issuer_name`, `issuer_account_name`, `prefix_key`, `account_provider_name`, `valid_from`, `valid_to`, `last_modified`, `min_account_balance`, `max_account_balance`, `min_transaction_amount`, `max_transaction_amount`, `default_pay_limit`)
VALUES
	(1,1,0,'',200,'BDT',25000,'','Operator','2023-12-05 23:59:59',-1,1,1,1,0,0,'','',0,'','2022-11-16 18:53:08','1970-01-01 05:30:00','2022-11-23 04:43:15',100,600000,15,35000,0),
	(11,1,0,'',11111110,'',11110,'','DIST1','2023-12-05 23:59:59',-1,35,0,1,0,0,'','',0,'','2022-11-06 14:41:46','1970-01-01 00:00:00','2022-11-07 09:11:46',10,10000000,1,10000000,0),
	(18,1,0,'',11111110,'',11110,'','DIST2','2023-12-05 23:59:59',-1,42,0,1,0,0,'','',0,'','2022-11-06 14:50:26','1970-01-01 00:00:00','2022-11-07 09:20:26',10,10000000,1,10000000,0),
	(19, 1, 0, '', 9999999, '', 99999, '', 'BD10000013', '0000-00-00 00:00:00', -1, 1000004, 0, 1, 0, 0, '', '', 0, '', '2025-05-19 11:00:31', '1970-01-01 00:00:00', '2025-05-20 11:00:37', 10, 10000000, 1, 10000000, 0),
    (20, 1, 0, '', 9999999, '', 99999, '', 'BD10000014', '0000-00-00 00:00:00', -1, 1000005, 0, 1, 0, 0, '', '', 0, '', '2025-05-19 11:11:41', '1970-01-01 00:00:00', '2025-05-20 11:11:42', 10, 10000000, 1, 10000000, 0),
    (21, 1, 0, '', 9999999, '', 99999, '', 'BD10000015', '0000-00-00 00:00:00', -1, 1000006, 0, 1, 0, 0, '', '', 0, '', '2025-05-19 11:20:20', '1970-01-01 00:00:00', '2025-05-20 11:20:20', 10, 10000000, 1, 10000000, 0),
    (22, 1, 0, '', 9999999, '', 99999, '', 'BD10000016', '0000-00-00 00:00:00', -1, 1000007, 0, 1, 0, 0, '', '', 0, '', '2025-05-19 11:26:33', '1970-01-01 00:00:00', '2025-05-20 11:26:33', 10, 10000000, 1, 10000000, 0);

/*!40000 ALTER TABLE `pay_prereg_accounts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_account_template
# ------------------------------------------------------------

LOCK TABLES `reseller_account_template` WRITE;
/*!40000 ALTER TABLE `reseller_account_template` DISABLE KEYS */;

INSERT INTO `reseller_account_template` (`reseller_type_key`, `account_type_key`, `account_type_prefix`, `account_type_mode`, `account_pay_limit_period`, `account_transaction_limit_count`, `account_pay_limit_value`, `account_credit_limit`, `min_account_balance`, `max_account_balance`, `min_transaction_amount`, `max_transaction_amount`)
VALUES
	(1,1,'',1,0,99999,9999999,100000,10,10000000,1,10000000),
	(3,1,'',1,0,99999,9999999,10000,10,10000000,1,10000000);

/*!40000 ALTER TABLE `reseller_account_template` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_account_types
# ------------------------------------------------------------

LOCK TABLES `reseller_account_types` WRITE;
/*!40000 ALTER TABLE `reseller_account_types` DISABLE KEYS */;

INSERT INTO `reseller_account_types` (`id`, `account_type_key`, `account_type_id`)
VALUES
	(1,1,'RESELLER'),
	(2,2,'AIRTIME');

/*!40000 ALTER TABLE `reseller_account_types` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_accounts
# ------------------------------------------------------------

LOCK TABLES `reseller_accounts` WRITE;
/*!40000 ALTER TABLE `reseller_accounts` DISABLE KEYS */;

INSERT INTO `reseller_accounts` (`id`, `reseller_id`, `account_id`)
VALUES
	(1,'Operator','Operator'),
	(2,'DIST1','DIST1'),
	(3,'DIST2','DIST2');

/*!40000 ALTER TABLE `reseller_accounts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_allowed_types
# ------------------------------------------------------------

LOCK TABLES `reseller_allowed_types` WRITE;
/*!40000 ALTER TABLE `reseller_allowed_types` DISABLE KEYS */;

INSERT INTO `reseller_allowed_types` (`type_key`, `allowed_type_key`)
VALUES
	(0,0),
	(1,2),
	(1,3),
	(1,4),
	(1,5),
	(1,6),
	(1,7),
	(1,8),
	(1,9),
	(1,10),
	(1,11),
	(1,12),
	(1,13),
	(1,14),
	(1,15),
	(1,16),
	(1,17),
	(1,18),
	(1,19),
	(1,20),
	(1,21),
	(2,9),
	(3,6),
	(3,7),
	(3,8),
	(3,21),
	(4,9),
	(5,8),
	(7,9),
	(10,16),
	(10,19),
	(14,18),
	(20,2),
	(20,3),
	(20,4),
	(20,5),
	(20,6),
	(20,7),
	(20,8),
	(20,10),
	(20,11),
	(20,12),
	(20,13),
	(20,14),
	(20,15),
	(20,16),
	(20,17),
	(20,18),
	(20,19),
	(20,21);

/*!40000 ALTER TABLE `reseller_allowed_types` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_extra_params
# ------------------------------------------------------------

LOCK TABLES `reseller_extra_params` WRITE;
/*!40000 ALTER TABLE `reseller_extra_params` DISABLE KEYS */;

INSERT INTO `reseller_extra_params` (`extra_paramId`, `parameter_key`, `parameter_value`, `receiver_key`)
VALUES
	(1,'juridicialName','Operator Jur Name',1),
	(2,'country','Bangladesh',1),
	(3,'contractId','1',1),
	(4,'one_time_password','false',1),
	(5,'motte_de_passe_flag','true',1),
	(6,'role','core',1),
	(7,'role','dm',2),
	(8,'motte_de_passe_flag','true',2),
	(9,'region','Dhaka',2),
	(10,'one_time_password','false',2),
	(11,'contractId','3',2),
	(12,'country','Bangladesh',2),
	(13,'country','Bangladesh',3),
	(14,'contractId','3',3),
	(15,'one_time_password','false',3),
	(16,'region','Dhaka',3),
	(17,'motte_de_passe_flag','true',3),
	(18,'role','dm',3),
    (19,'shortCode','DST', 2),
    (20, 'partyId', '300000004463971', 2),
    (21, 'customerAccountId', '100000012794706', 2),
    (22, 'partySiteId', '100000012921390', 2),
    (23, 'siteUseId', '100000012922783', 2),
    (24, 'vaNumber', '7810000084714', 2),
    (25, 'customerAccountNumber', '8822832334422', 2),
    (26, 'cluster', 'DTCLSBAR01', 1),
    (27, 'reportingManager', 'Operator', 2),
    (40, 'territoryName', 'BAKERGANJ TERRITORY', 1000004),
    (41, 'cluster', 'DTCLSBAR01', 1000004),
    (42, 'marketThanaName', 'Bakerganj', 1000004),
    (43, 'tlStartDate', '2025-05-03T10:50:00.000Z', 1000004),
    (44, 'mfsMsisdn', '1720730882', 1000004),
    (45, 'regionName', 'Barishal', 1000004),
    (46, 'autoPOFlag', 'true', 1000004),
    (47, 'difeIssueDate', '2025-05-02T10:50:00.000Z', 1000004),
    (48, 'adminDivision', 'BARISAL', 1000004),
    (49, 'clusterName', 'BARISHAL METRO CLUSTER', 1000004),
    (50, 'psrFiscalDate', '2023-2024', 1000004),
    (51, 'channelId', '2', 1000004),
    (52, 'shortCode', 'KAZ', 1000004),
    (53, 'reportingManager', 'cm1', 1000004),
    (54, 'marketThana', '11', 1000004),
    (55, 'difeRenewalDate', '2025-05-31T10:50:00.000Z', 1000004),
    (56, 'adminThanaName', 'Bakerganj', 1000004),
    (57, 'adminThana', 'ATHNBAKERNJ', 1000004),
    (58, 'tlEndDate', '2025-05-16T10:50:00.000Z', 1000004),
    (59, 'adminDistrict', 'Barisal', 1000004),
    (60, 'channelNameId', '2', 1000004),
    (61, 'channelName', 'Distributor Channel', 1000004),
    (62, 'region', 'DTREGBAR', 1000004),
    (63, 'circle', 'DTCRLKHU', 1000004),
    (64, 'ersMsisdn', '1720730882', 1000004),
    (65, 'circleName', 'KHULNA', 1000004),
    (66, 'territory', 'DTCTYBAR01', 1000004),
    (67, 'originId', 'BDDTBD', 1000004),
    (68, 'territoryName', 'BAKERGANJ TERRITORY', 1000005),
    (69, 'cluster', 'DTCLSBAR01', 1000005),
    (70, 'marketThanaName', 'Barisal Sadar', 1000005),
    (71, 'tlStartDate', '2025-05-03T10:50:00.000Z', 1000005),
    (72, 'mfsMsisdn', '1709552900', 1000005),
    (73, 'regionName', 'Barishal', 1000005),
    (74, 'autoPOFlag', 'true', 1000005),
    (75, 'difeIssueDate', '2025-05-02T10:50:00.000Z', 1000005),
    (76, 'adminDivision', 'BARISAL', 1000005),
    (77, 'clusterName', 'BARISHAL METRO CLUSTER', 1000005),
    (78, 'psrFiscalDate', '2023-2024', 1000005),
    (79, 'channelId', '2', 1000005),
    (80, 'shortCode', 'PDL', 1000005),
    (81, 'reportingManager', 'cm1', 1000005),
    (82, 'marketThana', '88', 1000005),
    (83, 'difeRenewalDate', '2025-05-31T10:50:00.000Z', 1000005),
    (84, 'adminThanaName', 'Barisal Sadar', 1000005),
    (85, 'adminThana', 'ATHNBARISSD', 1000005),
    (86, 'tlEndDate', '2025-05-16T10:50:00.000Z', 1000005),
    (87, 'adminDistrict', 'Barisal', 1000005),
    (88, 'channelNameId', '2', 1000005),
    (89, 'channelName', 'Distributor Channel', 1000005),
    (90, 'region', 'DTREGBAR', 1000005),
    (91, 'circle', 'DTCRLKHU', 1000005),
    (92, 'ersMsisdn', '1709552900', 1000005),
    (93, 'circleName', 'KHULNA', 1000005),
    (94, 'territory', 'DTCTYBAR01', 1000005),
    (95, 'originId', 'BDDTBD', 1000005),
    (96, 'territoryName', 'BAKERGANJ TERRITORY', 1000006),
    (97, 'cluster', 'DTCLSBAR01', 1000006),
    (98, 'marketThanaName', 'Barisal Sadar', 1000006),
    (99, 'tlStartDate', '2025-05-03T10:50:00.000Z', 1000006),
    (100, 'mfsMsisdn', '1709555083', 1000006),
    (101, 'regionName', 'Barishal', 1000006),
    (102, 'autoPOFlag', 'true', 1000006),
    (103, 'difeIssueDate', '2025-05-02T10:50:00.000Z', 1000006),
    (104, 'adminDivision', 'BARISAL', 1000006),
    (105, 'clusterName', 'BARISHAL METRO CLUSTER', 1000006),
    (106, 'psrFiscalDate', '2023-2024', 1000006),
    (107, 'channelId', '2', 1000006),
    (108, 'shortCode', 'SPS', 1000006),
    (109, 'reportingManager', 'cm1', 1000006),
    (110, 'marketThana', '88', 1000006),
    (111, 'difeRenewalDate', '2025-05-31T10:50:00.000Z', 1000006),
    (112, 'adminThanaName', 'Barisal Sadar', 1000006),
    (113, 'adminThana', 'ATHNBARISSD', 1000006),
    (114, 'tlEndDate', '2025-05-16T10:50:00.000Z', 1000006),
    (115, 'adminDistrict', 'Barisal', 1000006),
    (116, 'channelNameId', '2', 1000006),
    (117, 'channelName', 'Distributor Channel', 1000006),
    (118, 'region', 'DTREGBAR', 1000006),
    (119, 'circle', 'DTCRLKHU', 1000006),
    (120, 'ersMsisdn', '1709555083', 1000006),
    (121, 'circleName', 'KHULNA', 1000006),
    (122, 'territory', 'DTCTYBAR01', 1000006),
    (123, 'originId', 'BDDTBD', 1000006),
    (124, 'territoryName', 'BAKERGANJ TERRITORY', 1000007),
    (125, 'cluster', 'DTCLSBAR01', 1000007),
    (126, 'marketThanaName', 'Barisal Sadar', 1000007),
    (127, 'tlStartDate', '2025-05-03T10:50:00.000Z', 1000007),
    (128, 'mfsMsisdn', '1709725080', 1000007),
    (129, 'regionName', 'Barishal', 1000007),
    (130, 'autoPOFlag', 'true', 1000007),
    (131, 'difeIssueDate', '2025-05-02T10:50:00.000Z', 1000007),
    (132, 'adminDivision', 'BARISAL', 1000007),
    (133, 'clusterName', 'BARISHAL METRO CLUSTER', 1000007),
    (134, 'psrFiscalDate', '2023-2024', 1000007),
    (135, 'channelId', '2', 1000007),
    (136, 'shortCode', 'SST', 1000007),
    (137, 'reportingManager', 'cm1', 1000007),
    (138, 'marketThana', '88', 1000007),
    (139, 'difeRenewalDate', '2025-05-31T10:50:00.000Z', 1000007),
    (140, 'adminThanaName', 'Barisal Sadar', 1000007),
    (141, 'adminThana', 'ATHNBARISSD', 1000007),
    (142, 'tlEndDate', '2025-05-16T10:50:00.000Z', 1000007),
    (143, 'adminDistrict', 'Barisal', 1000007),
    (144, 'channelNameId', '2', 1000007),
    (145, 'channelName', 'Distributor Channel', 1000007),
    (146, 'region', 'DTREGBAR', 1000007),
    (147, 'circle', 'DTCRLKHU', 1000007),
    (148, 'ersMsisdn', '1709725080', 1000007),
    (149, 'circleName', 'KHULNA', 1000007),
    (150, 'territory', 'DTCTYBAR01', 1000007),
    (151, 'originId', 'BDDTBD', 1000007),
    (152, 'territoryName', 'BAKERGANJ TERRITORY', 1000008),
    (153, 'cluster', 'DTCLSBAR01', 1000008),
    (154, 'marketThanaName', 'Bakerganj', 1000008),
    (155, 'reportingManager', 'DIST1', 1000008),
    (156, 'mfsMsisdn', '1754872704', 1000008),
    (157, 'marketThana', '11', 1000008),
    (158, 'regionName', 'Barishal', 1000008),
    (159, 'adminThanaName', 'Bakerganj', 1000008),
    (160, 'adminThana', 'ATHNBAKERNJ', 1000008),
    (161, 'adminDivision', 'BARISAL', 1000008),
    (162, 'clusterName', 'BARISHAL METRO CLUSTER', 1000008),
    (163, 'adminDistrict', 'Barisal', 1000008),
    (164, 'channelNameId', '2', 1000008),
    (165, 'channelName', 'Distributor Channel', 1000008),
    (166, 'region', 'DTREGBAR', 1000008),
    (167, 'circle', 'DTCRLKHU', 1000008),
    (168, 'ersMsisdn', '1754872703', 1000008),
    (169, 'circleName', 'KHULNA', 1000008),
    (170, 'channelId', '2', 1000008),
    (171, 'territory', 'DTCTYBAR01', 1000008),
    (172, 'originId', 'BDDTBD', 1000008),
    (173, 'territoryName', 'BAKERGANJ TERRITORY', 1000009),
    (174, 'cluster', 'DTCLSBAR01', 1000009),
    (175, 'marketThanaName', 'Bakerganj', 1000009),
    (176, 'reportingManager', 'DIST1', 1000009),
    (177, 'mfsMsisdn', '1760762221', 1000009),
    (178, 'marketThana', '11', 1000009),
    (179, 'regionName', 'Barishal', 1000009),
    (180, 'adminThanaName', 'Bakerganj', 1000009),
    (181, 'adminThana', 'ATHNBAKERNJ', 1000009),
    (182, 'adminDivision', 'BARISAL', 1000009),
    (183, 'clusterName', 'BARISHAL METRO CLUSTER', 1000009),
    (184, 'adminDistrict', 'Barisal', 1000009),
    (185, 'channelNameId', '2', 1000009),
    (186, 'channelName', 'Distributor Channel', 1000009),
    (187, 'region', 'DTREGBAR', 1000009),
    (188, 'circle', 'DTCRLKHU', 1000009),
    (189, 'ersMsisdn', '1760762220', 1000009),
    (190, 'circleName', 'KHULNA', 1000009),
    (191, 'channelId', '2', 1000009),
    (192, 'territory', 'DTCTYBAR01', 1000009),
    (193, 'originId', 'BDDTBD', 1000009),
    (194, 'territoryName', 'BAKERGANJ TERRITORY', 1000010),
    (195, 'cluster', 'DTCLSBAR01', 1000010),
    (196, 'marketThanaName', 'Bakerganj', 1000010),
    (197, 'reportingManager', 'DIST1', 1000010),
    (198, 'mfsMsisdn', '1711442801', 1000010),
    (199, 'marketThana', '11', 1000010),
    (200, 'regionName', 'Barishal', 1000010),
    (201, 'adminThanaName', 'Bakerganj', 1000010),
    (202, 'adminThana', 'ATHNBAKERNJ', 1000010),
    (203, 'adminDivision', 'BARISAL', 1000010),
    (204, 'clusterName', 'BARISHAL METRO CLUSTER', 1000010),
    (205, 'adminDistrict', 'Barisal', 1000010),
    (206, 'channelNameId', '2', 1000010),
    (207, 'channelName', 'Distributor Channel', 1000010),
    (208, 'region', 'DTREGBAR', 1000010),
    (209, 'circle', 'DTCRLKHU', 1000010),
    (210, 'ersMsisdn', '1711442800', 1000010),
    (211, 'circleName', 'KHULNA', 1000010),
    (212, 'channelId', '2', 1000010),
    (213, 'territory', 'DTCTYBAR01', 1000010),
    (214, 'originId', 'BDDTBD', 1000010),
    (215, 'cluster', 'DTCLSBAR01', 1000011),
    (216, 'reportingManager', '', 1000011),
    (217, 'mfsMsisdn', '+8801712345678', 1000011),
    (218, 'marketThana', '11', 1000011),
    (219, 'adminThana', 'Bakerganj', 1000011),
    (220, 'adminDivision', 'BARISAL', 1000011),
    (221, 'adminDistrict', 'Barisal', 1000011),
    (222, 'channelNameId', '2', 1000011),
    (223, 'channelName', 'Distributor Channel', 1000011),
    (224, 'circle', 'DTCRLKHU', 1000011),
    (225, 'region', 'DTREGBAR', 1000011),
    (226, 'ersMsisdn', '+8801712345678', 1000011),
    (227, 'channelId', '2', 1000011),
    (228, 'territory', 'DTCTYBAR01', 1000011),
    (229, 'originId', 'BDDTBD', 1000011),
    (230, 'territoryName', 'BAKERGANJ TERRITORY', 1000012),
    (231, 'cluster', 'DTCLSBAR01', 1000012),
    (232, 'marketThanaName', 'Bakerganj', 1000012),
    (233, 'tlStartDate', '2025-05-08T12:06:00.000Z', 1000012),
    (234, 'mfsMsisdn', '01720770840', 1000012),
    (235, 'marketThana', '11', 1000012),
    (236, 'regionName', 'Barishal', 1000012),
    (237, 'directRetailingChannels', '', 1000012),
    (238, 'directRetailingEnabledFlag', 'no', 1000012),
    (239, 'adminThanaName', 'Bakerganj', 1000012),
    (240, 'adminThana', 'ATHNBAKERNJ', 1000012),
    (241, 'tlEndDate', '2025-05-30T12:06:00.000Z', 1000012),
    (242, 'adminDivision', 'BARISAL', 1000012),
    (243, 'clusterName', 'BARISHAL METRO CLUSTER', 1000012),
    (244, 'adminDistrict', 'Barisal', 1000012),
    (245, 'channelNameId', '2', 1000012),
    (246, 'channelName', 'Distributor Channel', 1000012),
    (247, 'region', 'DTREGBAR', 1000012),
    (248, 'circle', 'DTCRLKHU', 1000012),
    (249, 'ersMsisdn', '01720770840', 1000012),
    (250, 'circleName', 'KHULNA', 1000012),
    (251, 'channelId', '2', 1000012),
    (252, 'territory', 'DTCTYBAR01', 1000012),
    (253, 'originId', 'BDDTBD', 1000012),
    (254, 'territoryName', 'BAKERGANJ TERRITORY', 1000013),
    (255, 'cluster', 'DTCLSBAR01', 1000013),
    (256, 'marketThanaName', 'Bakerganj', 1000013),
    (257, 'tlStartDate', '2025-05-08T12:06:00.000Z', 1000013),
    (258, 'mfsMsisdn', '01720770840', 1000013),
    (259, 'marketThana', '11', 1000013),
    (260, 'regionName', 'Barishal', 1000013),
    (261, 'directRetailingChannels', '', 1000013),
    (262, 'directRetailingEnabledFlag', 'no', 1000013),
    (263, 'adminThanaName', 'Bakerganj', 1000013),
    (264, 'adminThana', 'ATHNBAKERNJ', 1000013),
    (265, 'tlEndDate', '2025-05-30T12:06:00.000Z', 1000013),
    (266, 'adminDivision', 'BARISAL', 1000013),
    (267, 'clusterName', 'BARISHAL METRO CLUSTER', 1000013),
    (268, 'adminDistrict', 'Barisal', 1000013),
    (269, 'channelNameId', '2', 1000013),
    (270, 'channelName', 'Distributor Channel', 1000013),
    (271, 'region', 'DTREGBAR', 1000013),
    (272, 'circle', 'DTCRLKHU', 1000013),
    (273, 'ersMsisdn', '01709571057', 1000013),
    (274, 'circleName', 'KHULNA', 1000013),
    (275, 'channelId', '2', 1000013),
    (276, 'territory', 'DTCTYBAR01', 1000013),
    (277, 'originId', 'BDDTBD', 1000013),
    (278, 'territoryName', 'BAKERGANJ TERRITORY', 1000014),
    (279, 'cluster', 'DTCLSBAR01', 1000014),
    (280, 'marketThanaName', 'Bakerganj', 1000014),
    (281, 'tlStartDate', '2025-05-08T12:06:00.000Z', 1000014),
    (282, 'mfsMsisdn', '', 1000014),
    (283, 'marketThana', '11', 1000014),
    (284, 'regionName', 'Barishal', 1000014),
    (285, 'directRetailingChannels', '', 1000014),
    (286, 'directRetailingEnabledFlag', 'no', 1000014),
    (287, 'adminThanaName', 'Bakerganj', 1000014),
    (288, 'adminThana', 'ATHNBAKERNJ', 1000014),
    (289, 'tlEndDate', '2025-05-30T12:06:00.000Z', 1000014),
    (290, 'adminDivision', 'BARISAL', 1000014),
    (291, 'clusterName', 'BARISHAL METRO CLUSTER', 1000014),
    (292, 'adminDistrict', 'Barisal', 1000014),
    (293, 'channelNameId', '2', 1000014),
    (294, 'channelName', 'Distributor Channel', 1000014),
    (295, 'region', 'DTREGBAR', 1000014),
    (296, 'circle', 'DTCRLKHU', 1000014),
    (297, 'ersMsisdn', '01744043945', 1000014),
    (298, 'circleName', 'KHULNA', 1000014),
    (299, 'channelId', '2', 1000014),
    (300, 'territory', 'DTCTYBAR01', 1000014),
    (301, 'originId', 'BDDTBD', 1000014),
    (302, 'cluster', 'DTCLSBAR01', 2),
    (303, 'cluster', 'DTCLSBAR01', 3);

/*!40000 ALTER TABLE `reseller_extra_params` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_hierarchy
# ------------------------------------------------------------

LOCK TABLES `reseller_hierarchy` WRITE;
/*!40000 ALTER TABLE `reseller_hierarchy` DISABLE KEYS */;

INSERT INTO `reseller_hierarchy` (`parent_key`, `child_key`)
VALUES
	(1,2),
	(1,3),
	(2,4),
	(1, 1000004),
    (1, 1000005),
    (1, 1000006),
    (1, 1000007),
    (2, 1000008),
    (2, 1000009),
    (2, 1000010),
    (2, 1000011),
    (2, 1000012),
    (2, 1000013),
    (2, 1000014);

/*!40000 ALTER TABLE `reseller_hierarchy` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `reseller_template_dropdown` WRITE;
/*!40000 ALTER TABLE `reseller_template_dropdown` DISABLE KEYS */;

INSERT INTO `reseller_template_dropdown` (`id`, `field_name`, `field_value`, `associated_field_name`, `associated_field_value`, `created_on`, `modified_on`)
VALUES
	(1,'logisticLocation','Stockholm Municipality','','',NULL,'2021-10-21 11:23:40'),
	(2,'logisticLocation','GÃ¶teborg Municipality','','',NULL,'2021-10-21 11:23:40'),
	(3,'logisticLocation','Huddinge Municipality','','',NULL,'2021-10-21 11:23:40'),
	(4,'logisticLocation','MalmÃ¶ Municipality','','',NULL,'2021-10-21 11:23:40');

/*!40000 ALTER TABLE `reseller_template_dropdown` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_type_children
# ------------------------------------------------------------

LOCK TABLES `reseller_type_children` WRITE;
/*!40000 ALTER TABLE `reseller_type_children` DISABLE KEYS */;

INSERT INTO `reseller_type_children` (`type_key`, `child_type_key`)
VALUES
	(1, 3),
	(1, 4),
	(1, 5),
	(1, 10),
	(1, 11),
	(1, 12),
	(1, 13),
	(1, 14),
	(1, 15),
	(1, 20),
	(3, 2),
	(3, 6),
	(3, 7),
	(5, 8),
	(10, 16),
	(10, 19),
	(11, 21),
	(12, 17),
	(14, 18);

/*!40000 ALTER TABLE `reseller_type_children` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_type_params
# ------------------------------------------------------------



# Dump of table reseller_type_prefixes
# ------------------------------------------------------------

LOCK TABLES `reseller_type_prefixes` WRITE;
/*!40000 ALTER TABLE `reseller_type_prefixes` DISABLE KEYS */;

INSERT INTO `reseller_type_prefixes` (`type_key`, `prefix`, `last_modified`)
VALUES
	(3,'','2024-11-05 12:04:13');

/*!40000 ALTER TABLE `reseller_type_prefixes` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table reseller_types
# ------------------------------------------------------------

LOCK TABLES `reseller_types` WRITE;
/*!40000 ALTER TABLE `reseller_types` DISABLE KEYS */;

INSERT INTO `reseller_types` (`type_key`, `id`, `name`, `description`, `allow_id_specification`, `id_regexp`, `allow_id_autogeneration`, `id_generator`, `used`, `allow_toplevel`, `allow_webshop`, `allow_terminals`, `allow_weblogin`, `allow_parentless`, `subdevice_policy`, `adminsite_supportreportgroup`, `default_tax_group_key`, `default_contract_key`, `default_product_range_key`, `default_receipt_template_key`, `RoleKey`)
VALUES
	('1', 'OPERATOR', 'Operator', '', '0', '', '0', '', '1', '1', '0', '1', '0', '1', '0', 'INTPasswordCreateMessages', '0', '1', '1', '1', '0'),
	('2', 'GPCF', 'GPCF', 'GPCF Reseller Type', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('3', 'DIST', 'Distributor', 'Distributor reseller Type ', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '3', '0', '1', '35'),
	('4', 'GPC', 'GPC', 'GPC reseller type', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('5', 'CDIST', 'CDIST', 'CDIST resellerType', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('6', 'SE', 'SalesExecutive', 'SalesExecutive reseller Type', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('7', 'RET', 'Retailer', 'Retailer Reseller Type', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('8', 'CRET', 'CRET', 'CRET Reseller Type', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('9', 'SUBSCRIBER_PROXY', 'SUBSCRIBER_PROXY', 'SUBSCRIBER_PROXY', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '1', '', '0', '0', '0', '1', '2'),
	('10', 'ODIST', 'ODIST', 'OWN DISTRIBUTOR', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('11', 'SDIST', 'SDIST', 'STRATEGIC DISTRIBUTOR', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('12', 'EADIST', 'EADIST', 'ALT DISTRIBUTOR', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('13', 'EUDIST', 'EUDIST', 'UNLIMITED ENTITY', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('14', 'ESDIST', 'ESDIST', 'SPECIAL ENTITY DISTRIBUTOR', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('15', 'ECDIST', 'ECDIST', 'CREDIT ENTITY', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('16', 'ORET', 'ORET', 'OWN RETAILER', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('17', 'ALTRET', 'ALTRET', 'ALTRET Reseller Type', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('18', 'ESRET', 'ESRET', 'SPECIAL ENTITY RETAILER', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('19', 'OSE', 'OSE', 'OWN SALES EXECUTIVE', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('20', 'BCU', 'BCU', 'CHANNEL ADMIN', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
	('21', 'SRET', 'SRET', 'STRATEGIC RETAILER', '0', '', '0', '', '1', '0', '0', '1', '1', '0', '0', 'INTPasswordCreateMessages', '0', '0', '0', '1', '35'),
    ('22', 'SYSTEM', 'System', '', '0', '', '0', '', '1', '1', '0', '1', '0', '1', '0', 'INTPasswordCreateMessages', '0', '1', '1', '1', '0');

/*!40000 ALTER TABLE `reseller_types` ENABLE KEYS */;

UNLOCK TABLES;
/*!40000 ALTER TABLE `reseller_distributors` DISABLE KEYS */;

# Dump of table reseller_distributors
#

LOCK TABLES `reseller_distributors` WRITE;
INSERT INTO `reseller_distributors` (`distributor_key`, `name`, `status`, `logon_domain_key`, `last_modified`, `id`) VALUES
    (1,'Default',1,0,NOW(),'');

/*!40000 ALTER TABLE `reseller_distributors` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `reseller_dynamic_data` WRITE;
INSERT INTO `reseller_dynamic_data` (`id`, `value`, `receiver_key`)
VALUES
    (1,'{\"vaNumber\":\"7810000084714\",\"siteUseId\":\"100000012922783\",\"customerAccountId\":\"100000012794706\",\"customerNumber\":\"DIST1\",\"partyId\":\"30000000446397\",\"partySiteId\":\"100000012921390\", \"contactPersonName\":\"ABCD\", \"contactPersonPhone\":\"8801700000003\"}', '2'),
    (2,X'7B226D656D6F5265664E6F223A2237383738373638373638373738373837363837363837373837383736383736383737383738373638373638373738373837363837363837373837383736383736383737383738373638373638373738373837363837363837222C2270726F66696C6550696346696C6550617468223A2237326466613436302D643039322D343631372D623937342D3935666264636433663566612E706E67222C22707265666978223A22222C22746C4E756D626572223A2235343635222C22616D6D656E646D656E7446696C6550617468223A2233656263633338302D363933372D343664652D623233622D3239316337376466356466662E706E67222C2262696E4E756D626572223A22313538222C22726573656C6C65725365727669636554797065223A22445344222C2272656E74616C41677265656D656E7446696C6550617468223A2231353437636536382D663364312D346431342D623130382D3864666631633834613961372E706E67222C227761726E696E674C65747465727346696C657350617468223A2263663163343535322D613831632D343562332D393666372D3537333262633065313738382E706E67222C22737470466C6167223A22796573222C226469666543657274696669636174654E756D626572223A2237365437222C227374617465223A224448414B41222C2270766346696C6550617468223A2237633765643437382D643634372D346366622D396564362D6132396237383232613062302E706E67222C226C6F6E676974756465223A2238392E383239333932222C227072696E636970616C41677265656D656E74537461727444617465223A22323032352D30352D3039222C227072696E636970616C41677265656D656E74456E6444617465223A22323032352D30352D3330222C227073724E756D626572223A223738363837222C2261677265656D656E7452656E6577616C537461727444617465223A22323032352D30352D3038222C226F66666963655072656D69736573537461727444617465223A22323032352D30352D3032222C226F66666963655072656D69736573456E6444617465223A22323032352D30352D3239222C22636F6E74616374506572736F6E4E616D65223A226B7361222C2270737246696C6550617468223A2231656232666162642D643434322D346230632D616366382D3232613936346165343435622E706E67222C2276656869636C654F776E6572466C6167223A22796573222C22646F62223A22313937302D30312D3031222C22726573656C6C6572547970654E616D65223A224469737472696275746F72222C226E616D65223A226B7361676F70616C67616E6A222C22636F6D70616E79547970657346696C657350617468223A2232623238333733352D383563342D346462642D386532392D6136373734623239356633662E706E67222C22706172746E657250726F70657274696573223A5B7B22706172746E657254797065223A224469737472696275746F72222C22706172746E657243617465676F7279223A22446973747269627574696F6E20486F757365222C22706172746E657256616C7565436C617373223A225365727669636520506F696E74222C227461626C65526F774964223A312E307D5D2C22636F6E74616374506572736F6E4E6964223A22313635363636222C2270766344617465223A22323032352D30352D3032222C226E69644E756D626572223A223137363537363738222C2267656E646572223A224D616C65222C2274696E497373756544617465223A22323032352D30352D3032222C2261677265656D656E7452656E6577616C46696C6550617468223A2239636338356432652D643731372D343064642D393261612D3963646165323335646330332E706E67222C226C61746974756465223A2232332E303037373538222C227076634E756D626572223A223735373637383637383537383638373837363838222C2276656869636C6573223A5B7B2276656869636C655265674E756D626572223A2231353634222C2276656869636C6552656744617465223A22323032352D30352D30325431303A35353A30302E3030305A222C2276656869636C65537461747573223A22416374697665222C2276656869636C6552656746696C6550617468223A2265653961366236352D653465662D346231382D613964622D3236623062323430343234622E706E67222C22767473496E666F223A2237363738222C227461626C65526F774964223A312E307D5D2C2274696E4E756D626572223A223134393630333131222C22636F6E74616374506572736F6E50686F6E65223A22222C2270726F766973696F6E616C41677265656D656E74537461727444617465223A22323032352D30352D3039222C227072696E636970616C41677265656D656E7446696C6550617468223A2236356262326532632D616534352D343763382D386630332D6534653937383237616539632E706E67222C2274696E46696C6550617468223A2262353138366535652D313332652D346533622D383539322D3936656165663937323061392E706E67222C226F66666963655072656D69736554797065223A2252656E74616C222C22636F6E74726163744E616D65223A225365636F6E646172792042414B455247414E4A205445525249544F5259222C226C6261466C6167223A22796573222C22636F6D70616E7954797065223A22436F6D70616E79204C7464222C22636F6E74616374506572736F6E446F62223A22323032352D30352D3031222C22636F6D6D697373696F6E50726F70657274696573223A5B7B22636F6D6D697373696F6E5061796D656E744D6F6465223A22657273222C22636F6D6D697373696F6E42616E6B223A225041444D412042414E4B222C22636F6D6D697373696F6E42616E6B4469737472696374223A225041444D41222C22636F6D6D697373696F6E42616E6B4272616E6368223A225041444D4120434F4D4D495353494F4E20434C454152494E4720484F555345222C22636F6D6D697373696F6E42616E6B526F7574696E674E756D626572223A22303235313530303031222C22636F6D6D697373696F6E42616E6B4163636F756E744E756D626572223A2232303830313030313437323131222C22636F6D6D697373696F6E4572734E756D626572223A2230303030333831353236222C2269735072696D617279466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C227265706F7274696E674D616E616765724E616D65223A22436C7573746572204D616E6167657231222C2264696665436572746966696361746546696C6550617468223A2238393565313634342D626164342D343765362D623531372D3830663663616330333436322E706E67222C2270726F766973696F6E616C41677265656D656E74456E6444617465223A22323032352D30352D3239222C22726573656C6C657247656F436C617373223A22727572616C222C22647263436F6D6D697373696F6E466C6167223A22796573222C2270726F766973696F6E616C41677265656D656E7446696C6550617468223A2238663734316230622D396461352D343330362D383431332D6261363135663432653465382E706E67222C2262696E46696C6550617468223A2261653166666136312D363739392D346466312D623232612D3062353631386162626463362E706E67222C22746C46696C6550617468223A2238336635333732652D373765342D343436362D613938642D3833343231636261646131362E706E67222C22636F6E74616374506572736F6E456D61696C223A22222C2261677265656D656E7452656E6577616C456E6444617465223A22323032352D30352D3330227D', 1000004),
    (3,X'7B226D656D6F5265664E6F223A2237383738373638373638373738373837363837363837373837383736383736383737383738373638373638373738373837363837363837373837383736383736383737383738373638373638373738373837363837363837222C2270726F66696C6550696346696C6550617468223A2237326466613436302D643039322D343631372D623937342D3935666264636433663566612E706E67222C22707265666978223A22222C22746C4E756D626572223A2235343635393030222C22616D6D656E646D656E7446696C6550617468223A2233656263633338302D363933372D343664652D623233622D3239316337376466356466662E706E67222C2262696E4E756D626572223A22323230222C22726573656C6C65725365727669636554797065223A22445344222C2272656E74616C41677265656D656E7446696C6550617468223A2231353437636536382D663364312D346431342D623130382D3864666631633834613961372E706E67222C227761726E696E674C65747465727346696C657350617468223A2263663163343535322D613831632D343562332D393666372D3537333262633065313738382E706E67222C22737470466C6167223A22796573222C226469666543657274696669636174654E756D626572223A2237365437373836222C2262616E6B50726F70657274696573223A5B7B2262616E6B5072696F72697479223A223636222C2262616E6B223A2242414E474C41444553482042414E4B222C2262616E6B4469737472696374223A22434849545441474F4E47222C2262616E6B4272616E6368223A22434849545441474F4E4720434C454152494E4720484F555345222C2262616E6B526F7574696E674E756D626572223A22303235313530303031222C2262616E6B4163636F756E744E756D626572223A2231303831303237353032222C2262616E6B4175746F6465626974466C6167223A2274727565222C2262616E6B4175746F6C6F616E466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C227374617465223A224448414B41222C2270766346696C6550617468223A2237633765643437382D643634372D346366622D396564362D6132396237383232613062302E706E67222C226C6F6E676974756465223A222039302E3430373433222C227072696E636970616C41677265656D656E74537461727444617465223A22323032352D30352D3039222C227072696E636970616C41677265656D656E74456E6444617465223A22323032352D30352D3330222C227073724E756D626572223A223534353738222C2261677265656D656E7452656E6577616C537461727444617465223A22323032352D30352D3038222C226F66666963655072656D69736573537461727444617465223A22323032352D30352D3032222C226F66666963655072656D69736573456E6444617465223A22323032352D30352D3239222C22636F6E74616374506572736F6E4E616D65223A225261686D616E222C2270737246696C6550617468223A2231656232666162642D643434322D346230632D616366382D3232613936346165343435622E706E67222C2276656869636C654F776E6572466C6167223A22796573222C22646F62223A22323032352D30352D3138222C22726573656C6C6572547970654E616D65223A224469737472696275746F72222C226E616D65223A224D64204D697A616E7572205261686D616E222C22636F6D70616E79547970657346696C657350617468223A2232623238333733352D383563342D346462642D386532392D6136373734623239356633662E706E67222C22706172746E657250726F70657274696573223A5B7B22706172746E657254797065223A224469737472696275746F72222C22706172746E657243617465676F7279223A22446973747269627574696F6E20486F757365222C22706172746E657256616C7565436C617373223A225365727669636520506F696E74222C227461626C65526F774964223A312E307D5D2C22636F6E74616374506572736F6E4E6964223A22313635363636222C2270766344617465223A22323032352D30352D3032222C226E69644E756D626572223A223137363537363738222C2267656E646572223A224D616C65222C2274696E497373756544617465223A22323032352D30352D3032222C2261677265656D656E7452656E6577616C46696C6550617468223A2239636338356432652D643731372D343064642D393261612D3963646165323335646330332E706E67222C226C61746974756465223A2232332E3734393735222C227076634E756D626572223A223232323237383637383537383638373837363838222C2276656869636C6573223A5B7B2276656869636C655265674E756D626572223A2231353634222C2276656869636C6552656744617465223A22323032352D30352D30325431303A35353A30302E3030305A222C2276656869636C65537461747573223A22416374697665222C2276656869636C6552656746696C6550617468223A2265653961366236352D653465662D346231382D613964622D3236623062323430343234622E706E67222C22767473496E666F223A2237363738222C227461626C65526F774964223A312E307D5D2C2274696E4E756D626572223A22333534363436222C22636F6E74616374506572736F6E50686F6E65223A22222C2270726F766973696F6E616C41677265656D656E74537461727444617465223A22323032352D30352D3039222C227072696E636970616C41677265656D656E7446696C6550617468223A2236356262326532632D616534352D343763382D386630332D6534653937383237616539632E706E67222C2274696E46696C6550617468223A2262353138366535652D313332652D346533622D383539322D3936656165663937323061392E706E67222C226F66666963655072656D69736554797065223A2252656E74616C222C22636F6E74726163744E616D65223A225365636F6E646172792042414B455247414E4A205445525249544F5259222C226C6261466C6167223A22796573222C22636F6D70616E7954797065223A22436F6D70616E79204C7464222C22636F6E74616374506572736F6E446F62223A22323032352D30352D3031222C22636F6D6D697373696F6E50726F70657274696573223A5B7B22636F6D6D697373696F6E5061796D656E744D6F6465223A22222C22636F6D6D697373696F6E42616E6B223A225041444D412042414E4B222C22636F6D6D697373696F6E42616E6B4469737472696374223A225041444D41222C22636F6D6D697373696F6E42616E6B4272616E6368223A225041444D4120434F4D4D495353494F4E20434C454152494E4720484F555345222C22636F6D6D697373696F6E42616E6B526F7574696E674E756D626572223A22303235313530303031222C22636F6D6D697373696F6E42616E6B4163636F756E744E756D626572223A223130383131303237353032222C22636F6D6D697373696F6E4572734E756D626572223A22373836222C2269735072696D617279466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C227265706F7274696E674D616E616765724E616D65223A22436C7573746572204D616E6167657231222C2264696665436572746966696361746546696C6550617468223A2238393565313634342D626164342D343765362D623531372D3830663663616330333436322E706E67222C2270726F766973696F6E616C41677265656D656E74456E6444617465223A22323032352D30352D3239222C22726573656C6C657247656F436C617373223A22757262616E222C22647263436F6D6D697373696F6E466C6167223A22796573222C2270726F766973696F6E616C41677265656D656E7446696C6550617468223A2238663734316230622D396461352D343330362D383431332D6261363135663432653465382E706E67222C2262696E46696C6550617468223A2261653166666136312D363739392D346466312D623232612D3062353631386162626463362E706E67222C22746C46696C6550617468223A2238336635333732652D373765342D343436362D613938642D3833343231636261646131362E706E67222C22636F6E74616374506572736F6E456D61696C223A22222C2261677265656D656E7452656E6577616C456E6444617465223A22323032352D30352D3330227D', 1000005),
    (4,X'7B226D656D6F5265664E6F223A2237383738373638373638373738373837363837363837373837383736383736383737383738373638373638373738373837363837363837373837383736383736383737383738373638373638373738373837363837363837222C2270726F66696C6550696346696C6550617468223A2237326466613436302D643039322D343631372D623937342D3935666264636433663566612E706E67222C22707265666978223A22222C22746C4E756D626572223A22313433222C22616D6D656E646D656E7446696C6550617468223A2233656263633338302D363933372D343664652D623233622D3239316337376466356466662E706E67222C2262696E4E756D626572223A22313433222C22726573656C6C65725365727669636554797065223A22445344222C2272656E74616C41677265656D656E7446696C6550617468223A2231353437636536382D663364312D346431342D623130382D3864666631633834613961372E706E67222C227761726E696E674C65747465727346696C657350617468223A2263663163343535322D613831632D343562332D393666372D3537333262633065313738382E706E67222C22737470466C6167223A22796573222C226469666543657274696669636174654E756D626572223A2237365437373836222C2262616E6B50726F70657274696573223A5B7B2262616E6B5072696F72697479223A223636222C2262616E6B223A2242414E474C41444553482042414E4B222C2262616E6B4469737472696374223A22434849545441474F4E47222C2262616E6B4272616E6368223A22434849545441474F4E4720434C454152494E4720484F555345222C2262616E6B526F7574696E674E756D626572223A22303235313530303031222C2262616E6B4163636F756E744E756D626572223A2231303739303030393531333933222C2262616E6B4175746F6465626974466C6167223A2274727565222C2262616E6B4175746F6C6F616E466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C227374617465223A224448414B41222C2270766346696C6550617468223A2237633765643437382D643634372D346366622D396564362D6132396237383232613062302E706E67222C226C6F6E676974756465223A2239302E323930323831222C227072696E636970616C41677265656D656E74537461727444617465223A22323032352D30352D3039222C227072696E636970616C41677265656D656E74456E6444617465223A22323032352D30352D3330222C227073724E756D626572223A223534353738222C2261677265656D656E7452656E6577616C537461727444617465223A22323032352D30352D3038222C226F66666963655072656D69736573537461727444617465223A22323032352D30352D3032222C226F66666963655072656D69736573456E6444617465223A22323032352D30352D3239222C22636F6E74616374506572736F6E4E616D65223A225261686D616E222C2270737246696C6550617468223A2231656232666162642D643434322D346230632D616366382D3232613936346165343435622E706E67222C2276656869636C654F776E6572466C6167223A22796573222C22646F62223A22323032352D30352D3138222C22726573656C6C6572547970654E616D65223A224469737472696275746F72222C226E616D65223A2241627520486F737361696E206B68616E222C22636F6D70616E79547970657346696C657350617468223A2232623238333733352D383563342D346462642D386532392D6136373734623239356633662E706E67222C22706172746E657250726F70657274696573223A5B7B22706172746E657254797065223A224469737472696275746F72222C22706172746E657243617465676F7279223A22446973747269627574696F6E20486F757365222C22706172746E657256616C7565436C617373223A225365727669636520506F696E74222C227461626C65526F774964223A312E307D5D2C22636F6E74616374506572736F6E4E6964223A22313635363636222C2270766344617465223A22323032352D30352D3032222C226E69644E756D626572223A223137363537363738222C2267656E646572223A224D616C65222C2274696E497373756544617465223A22323032352D30352D3032222C2261677265656D656E7452656E6577616C46696C6550617468223A2239636338356432652D643731372D343064642D393261612D3963646165323335646330332E706E67222C226C61746974756465223A2232332E353430353831222C227076634E756D626572223A223232323237383637383537383638373837363838222C2276656869636C6573223A5B7B2276656869636C655265674E756D626572223A2231353634222C2276656869636C6552656744617465223A22323032352D30352D30325431303A35353A30302E3030305A222C2276656869636C65537461747573223A22416374697665222C2276656869636C6552656746696C6550617468223A2265653961366236352D653465662D346231382D613964622D3236623062323430343234622E706E67222C22767473496E666F223A2237363738222C227461626C65526F774964223A312E307D5D2C2274696E4E756D626572223A223736303030323131222C22636F6E74616374506572736F6E50686F6E65223A22222C2270726F766973696F6E616C41677265656D656E74537461727444617465223A22323032352D30352D3039222C227072696E636970616C41677265656D656E7446696C6550617468223A2236356262326532632D616534352D343763382D386630332D6534653937383237616539632E706E67222C2274696E46696C6550617468223A2262353138366535652D313332652D346533622D383539322D3936656165663937323061392E706E67222C226F66666963655072656D69736554797065223A2252656E74616C222C22636F6E74726163744E616D65223A225365636F6E646172792042414B455247414E4A205445525249544F5259222C226C6261466C6167223A22796573222C22636F6D70616E7954797065223A22436F6D70616E79204C7464222C22636F6E74616374506572736F6E446F62223A22323032352D30352D3031222C22636F6D6D697373696F6E50726F70657274696573223A5B7B22636F6D6D697373696F6E5061796D656E744D6F6465223A22222C22636F6D6D697373696F6E42616E6B223A225041444D412042414E4B222C22636F6D6D697373696F6E42616E6B4469737472696374223A225041444D41222C22636F6D6D697373696F6E42616E6B4272616E6368223A225041444D4120434F4D4D495353494F4E20434C454152494E4720484F555345222C22636F6D6D697373696F6E42616E6B526F7574696E674E756D626572223A22303235313530303031222C22636F6D6D697373696F6E42616E6B4163636F756E744E756D626572223A223739303030393531333933222C22636F6D6D697373696F6E4572734E756D626572223A22373836222C2269735072696D617279466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C227265706F7274696E674D616E616765724E616D65223A22436C7573746572204D616E6167657231222C2264696665436572746966696361746546696C6550617468223A2238393565313634342D626164342D343765362D623531372D3830663663616330333436322E706E67222C2270726F766973696F6E616C41677265656D656E74456E6444617465223A22323032352D30352D3239222C22726573656C6C657247656F436C617373223A22757262616E222C22647263436F6D6D697373696F6E466C6167223A22796573222C2270726F766973696F6E616C41677265656D656E7446696C6550617468223A2238663734316230622D396461352D343330362D383431332D6261363135663432653465382E706E67222C2262696E46696C6550617468223A2261653166666136312D363739392D346466312D623232612D3062353631386162626463362E706E67222C22746C46696C6550617468223A2238336635333732652D373765342D343436362D613938642D3833343231636261646131362E706E67222C22636F6E74616374506572736F6E456D61696C223A22222C2261677265656D656E7452656E6577616C456E6444617465223A22323032352D30352D3330227D', 1000006),
    (5,X'7B226D656D6F5265664E6F223A2237383738373638373638373738373837363837363837373837383736383736383737383738373638373638373738373837363837363837373837383736383736383737383738373638373638373738373837363837363837222C2270726F66696C6550696346696C6550617468223A2237326466613436302D643039322D343631372D623937342D3935666264636433663566612E706E67222C22707265666978223A22222C22746C4E756D626572223A22303130303130313834303030222C22616D6D656E646D656E7446696C6550617468223A2233656263633338302D363933372D343664652D623233622D3239316337376466356466662E706E67222C2262696E4E756D626572223A22303130303130313834303030222C22726573656C6C65725365727669636554797065223A22445344222C2272656E74616C41677265656D656E7446696C6550617468223A2231353437636536382D663364312D346431342D623130382D3864666631633834613961372E706E67222C227761726E696E674C65747465727346696C657350617468223A2263663163343535322D613831632D343562332D393666372D3537333262633065313738382E706E67222C22737470466C6167223A22796573222C226469666543657274696669636174654E756D626572223A2237365437373836222C2262616E6B50726F70657274696573223A5B7B2262616E6B5072696F72697479223A223636222C2262616E6B223A2242414E474C41444553482042414E4B222C2262616E6B4469737472696374223A22434849545441474F4E47222C2262616E6B4272616E6368223A22434849545441474F4E4720434C454152494E4720484F555345222C2262616E6B526F7574696E674E756D626572223A22303235313530303031222C2262616E6B4163636F756E744E756D626572223A223030363830333230303030323038222C2262616E6B4175746F6465626974466C6167223A2274727565222C2262616E6B4175746F6C6F616E466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C227374617465223A224448414B41222C2270766346696C6550617468223A2237633765643437382D643634372D346366622D396564362D6132396237383232613062302E706E67222C226C6F6E676974756465223A2239322E313933323437222C227072696E636970616C41677265656D656E74537461727444617465223A22323032352D30352D3039222C227072696E636970616C41677265656D656E74456E6444617465223A22323032352D30352D3330222C227073724E756D626572223A223534353738222C2261677265656D656E7452656E6577616C537461727444617465223A22323032352D30352D3038222C226F66666963655072656D69736573537461727444617465223A22323032352D30352D3032222C226F66666963655072656D69736573456E6444617465223A22323032352D30352D3239222C22636F6E74616374506572736F6E4E616D65223A225261686D616E222C2270737246696C6550617468223A2231656232666162642D643434322D346230632D616366382D3232613936346165343435622E706E67222C2276656869636C654F776E6572466C6167223A22796573222C22646F62223A22323032352D30352D3138222C22726573656C6C6572547970654E616D65223A224469737472696275746F72222C226E616D65223A22486173696220486F737361696E204B68616E222C22636F6D70616E79547970657346696C657350617468223A2232623238333733352D383563342D346462642D386532392D6136373734623239356633662E706E67222C22706172746E657250726F70657274696573223A5B7B22706172746E657254797065223A224469737472696275746F72222C22706172746E657243617465676F7279223A22446973747269627574696F6E20486F757365222C22706172746E657256616C7565436C617373223A225365727669636520506F696E74222C227461626C65526F774964223A312E307D5D2C22636F6E74616374506572736F6E4E6964223A22313635363636222C2270766344617465223A22323032352D30352D3032222C226E69644E756D626572223A223137363537363738222C2267656E646572223A224D616C65222C2274696E497373756544617465223A22323032352D30352D3032222C2261677265656D656E7452656E6577616C46696C6550617468223A2239636338356432652D643731372D343064642D393261612D3963646165323335646330332E706E67222C226C61746974756465223A2232342E373036323537222C227076634E756D626572223A223232323237383637383537383638373837363838222C2276656869636C6573223A5B7B2276656869636C655265674E756D626572223A2231353634222C2276656869636C6552656744617465223A22323032352D30352D30325431303A35353A30302E3030305A222C2276656869636C65537461747573223A22416374697665222C2276656869636C6552656746696C6550617468223A2265653961366236352D653465662D346231382D613964622D3236623062323430343234622E706E67222C22767473496E666F223A2237363738222C227461626C65526F774964223A312E307D5D2C2274696E4E756D626572223A22343730353832343833363031222C22636F6E74616374506572736F6E50686F6E65223A22222C2270726F766973696F6E616C41677265656D656E74537461727444617465223A22323032352D30352D3039222C227072696E636970616C41677265656D656E7446696C6550617468223A2236356262326532632D616534352D343763382D386630332D6534653937383237616539632E706E67222C2274696E46696C6550617468223A2262353138366535652D313332652D346533622D383539322D3936656165663937323061392E706E67222C226F66666963655072656D69736554797065223A2252656E74616C222C22636F6E74726163744E616D65223A225365636F6E646172792042414B455247414E4A205445525249544F5259222C226C6261466C6167223A22796573222C22636F6D70616E7954797065223A22436F6D70616E79204C7464222C22636F6E74616374506572736F6E446F62223A22323032352D30352D3031222C22636F6D6D697373696F6E50726F70657274696573223A5B7B22636F6D6D697373696F6E5061796D656E744D6F6465223A22222C22636F6D6D697373696F6E42616E6B223A225041444D412042414E4B222C22636F6D6D697373696F6E42616E6B4469737472696374223A225041444D41222C22636F6D6D697373696F6E42616E6B4272616E6368223A225041444D4120434F4D4D495353494F4E20434C454152494E4720484F555345222C22636F6D6D697373696F6E42616E6B526F7574696E674E756D626572223A22303235313530303031222C22636F6D6D697373696F6E42616E6B4163636F756E744E756D626572223A223739303030393531333933222C22636F6D6D697373696F6E4572734E756D626572223A22373836222C2269735072696D617279466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C227265706F7274696E674D616E616765724E616D65223A22436C7573746572204D616E6167657231222C2264696665436572746966696361746546696C6550617468223A2238393565313634342D626164342D343765362D623531372D3830663663616330333436322E706E67222C2270726F766973696F6E616C41677265656D656E74456E6444617465223A22323032352D30352D3239222C22726573656C6C657247656F436C617373223A22757262616E222C22647263436F6D6D697373696F6E466C6167223A22796573222C2270726F766973696F6E616C41677265656D656E7446696C6550617468223A2238663734316230622D396461352D343330362D383431332D6261363135663432653465382E706E67222C2262696E46696C6550617468223A2261653166666136312D363739392D346466312D623232612D3062353631386162626463362E706E67222C22746C46696C6550617468223A2238336635333732652D373765342D343436362D613938642D3833343231636261646131362E706E67222C22636F6E74616374506572736F6E456D61696C223A22222C2261677265656D656E7452656E6577616C456E6444617465223A22323032352D30352D3330227D', 1000007),
    (6,X'7B22646C497373756544617465223A22323032352D30342D3330222C226E69644E756D626572223A2231373635363235373632222C2267656E646572223A224D616C65222C2270726F66696C6550696346696C6550617468223A2237653965363165332D343932302D346565392D613865342D3164356265626261356261302E706E67222C22707265666978223A224D72222C226C61746974756465223A2232332E3030303139222C226E696446696C6550617468223A2264333464613062642D393732612D346231612D623134392D3036303536646135396666332E706E67222C2273616C617279223A2237353030222C226E756D626572223A2253452D3330222C22636F6E74726163744E616D65223A225072696D6172792042414B455247414E4A205445525249544F5259222C226C6F6E676974756465223A2237382E393237393239222C22686864537461747573223A2274727565222C22646C5265674E6F223A2231222C2261737369676E6564427473223A22313231323132222C226C6261466C6167223A22796573222C22646C45787069727944617465223A22323032352D30352D3238222C227265706F7274696E674D616E616765724E616D65223A224449535452494255544F5231222C2276656869636C654F776E6572466C6167223A2259222C22646F62223A22323032352D30342D3330222C22726573656C6C6572547970654E616D65223A2253616C657320457865637574697665222C22726573656C6C657247656F436C617373223A22727572616C222C226170706F696E746D656E744C657474657246696C6550617468223A2237646263376231332D363236312D343139642D386666382D6265333366393963623135612E706E67222C22646C46696C6550617468223A2264653332363833342D323635392D346266302D393063352D3065353963386532323061632E706E67222C22656475636174696F6E5175616C696669636174696F6E223A22535343222C22696D6569223A2230376266623432323430383663663439222C22656475636174696F6E436572746966696361746546696C6550617468223A2235613932336363382D653465302D343264642D623563612D6637626137343163383538632E706E67222C226170706F696E746D656E7444617465223A22323032352D30342D3330227D', 1000008),
    (7,X'7B22646C497373756544617465223A22323032352D30342D3330222C226E69644E756D626572223A2231373630303235373632222C2267656E646572223A224D616C65222C2270726F66696C6550696346696C6550617468223A2237653965363165332D343932302D346565392D613865342D3164356265626261356261302E706E67222C22707265666978223A224D72222C226C61746974756465223A2232332E3030303139222C226E696446696C6550617468223A2264333464613062642D393732612D346231612D623134392D3036303536646135396666332E706E67222C2273616C617279223A2237363030222C226E756D626572223A2253452D3230222C22636F6E74726163744E616D65223A225072696D6172792042414B455247414E4A205445525249544F5259222C226C6F6E676974756465223A2237382E393237393239222C22686864537461747573223A2274727565222C22646C5265674E6F223A2231222C2261737369676E6564427473223A22313231323132222C226C6261466C6167223A22796573222C22646C45787069727944617465223A22323032352D30352D3238222C227265706F7274696E674D616E616765724E616D65223A224449535452494255544F5231222C2276656869636C654F776E6572466C6167223A2259222C22646F62223A22323032352D30342D3330222C22726573656C6C6572547970654E616D65223A2253616C657320457865637574697665222C22726573656C6C657247656F436C617373223A22727572616C222C226170706F696E746D656E744C657474657246696C6550617468223A2237646263376231332D363236312D343139642D386666382D6265333366393963623135612E706E67222C22646C46696C6550617468223A2264653332363833342D323635392D346266302D393063352D3065353963386532323061632E706E67222C22656475636174696F6E5175616C696669636174696F6E223A22535343222C22696D6569223A2231616139643435653136326565623662222C22656475636174696F6E436572746966696361746546696C6550617468223A2235613932336363382D653465302D343264642D623563612D6637626137343163383538632E706E67222C226170706F696E746D656E7444617465223A22323032352D30342D3330227D', 1000009),
    (8,X'7B22646C497373756544617465223A22323032352D30342D3330222C226E69644E756D626572223A2235303935313133303633222C2267656E646572223A224D616C65222C2270726F66696C6550696346696C6550617468223A2237653965363165332D343932302D346565392D613865342D3164356265626261356261302E706E67222C22707265666978223A224D72222C226C61746974756465223A2232332E3030303139222C226E696446696C6550617468223A2264333464613062642D393732612D346231612D623134392D3036303536646135396666332E706E67222C2273616C617279223A2237303030222C226E756D626572223A2253452D3230222C22636F6E74726163744E616D65223A225072696D6172792042414B455247414E4A205445525249544F5259222C226C6F6E676974756465223A2237382E393237393239222C22686864537461747573223A2274727565222C22646C5265674E6F223A2231222C2261737369676E6564427473223A22313231323132222C226C6261466C6167223A22796573222C22646C45787069727944617465223A22323032352D30352D3238222C227265706F7274696E674D616E616765724E616D65223A224449535452494255544F5231222C2276656869636C654F776E6572466C6167223A2259222C22646F62223A22313938372D30372D3032222C22726573656C6C6572547970654E616D65223A2253616C657320457865637574697665222C22726573656C6C657247656F436C617373223A22727572616C222C226170706F696E746D656E744C657474657246696C6550617468223A2237646263376231332D363236312D343139642D386666382D6265333366393963623135612E706E67222C22646C46696C6550617468223A2264653332363833342D323635392D346266302D393063352D3065353963386532323061632E706E67222C22656475636174696F6E5175616C696669636174696F6E223A22535343222C22696D6569223A2239383132623562613465613964653633222C22656475636174696F6E436572746966696361746546696C6550617468223A2235613932336363382D653465302D343264642D623563612D6637626137343163383538632E706E67222C226170706F696E746D656E7444617465223A22323032352D30342D3330227D', 1000010),
    (9,X'7B22646C497373756544617465223A22313937302D30312D3031222C226E69644E756D626572223A2231323334353637383930222C2267656E646572223A224D616C65222C2270726F66696C6550696346696C6550617468223A2262653638666230322D363531302D346135652D623936342D3638643264653466376164612E706E67222C22707265666978223A224D72222C226C61746974756465223A22222C226E696446696C6550617468223A2238346561353031362D633762302D346132382D383731352D3436336261636538333430662E706E67222C2273616C617279223A22222C226E756D626572223A22222C226C6F6E676974756465223A22222C22686864537461747573223A224E6F222C22646C5265674E6F223A22222C2261737369676E6564427473223A22222C226C6261466C6167223A22796573222C22646C45787069727944617465223A22313937302D30312D3031222C2276656869636C654F776E6572466C6167223A224E222C22646F62223A22323032352D30342D3330222C22726573656C6C6572547970654E616D65223A2253616C657320457865637574697665222C22726573656C6C657247656F436C617373223A22222C226170706F696E746D656E744C657474657246696C6550617468223A2235343436303338382D356664352D346133612D393239662D6461306237663630633230352E706E67222C22646C46696C6550617468223A22222C22656475636174696F6E5175616C696669636174696F6E223A22535343222C22696D6569223A22222C22656475636174696F6E436572746966696361746546696C6550617468223A2266316363343930342D386464642D343162372D616335372D3533386263626433663635642E706E67222C226170706F696E746D656E7444617465223A22323032352D30342D3330227D', 1000011),
    (10,X'7B226E6964417661696C61626C65466C6167223A226E6F222C226E69644E756D626572223A2236353736222C2267656E646572223A224D616C65222C226D656D6F5265664E6F223A22222C2270726F66696C6550696346696C6550617468223A2261303261633537362D383864302D346131362D623734632D6466383764336533366133342E706E67222C22707265666978223A224D72222C22746C4E756D626572223A2231333133222C226B7963466F726D50617468223A2236613236393164332D613566382D346538372D393138302D3035346536306631633135622E706E67222C2261677265656D656E7446696C65735061746873223A2230376331633361352D353031362D343161622D623637312D6232623936343737643164362E706E67222C226C61746974756465223A2232322E3739383833222C227076634E756D626572223A2231333133222C22746C417661696C61626C65466C6167223A226E6F222C2262696E4E756D626572223A22222C226E696446696C6550617468223A2262653939303931662D363463312D343635662D393731302D6662386563363662373731632E706E67222C2274696E4E756D626572223A2231323132222C22636F6E74616374506572736F6E50686F6E65223A22222C227363616E6E6572466C6167223A22796573222C22726573656C6C65725365727669636554797065223A22445344222C22737470466C6167223A22796573222C22637573746F6D6572417352657461696C6572466C6167223A22796573222C2274696E46696C6550617468223A22222C2261677265656D656E74417661696C61626C65466C6167223A226E6F222C22636F6E74726163744E616D65223A225072696D6172792042414B455247414E4A205445525249544F5259222C226E6964497373756544617465223A22323032352D30342D3330222C226C6F6E676974756465223A2239302E30303339222C227363616E6E65724E756D626572223A223837363837222C2261737369676E6564427473223A22222C227073724E756D626572223A2231333331222C226C6261466C6167223A22796573222C22636F6D6D697373696F6E50726F70657274696573223A5B7B22636F6D6D697373696F6E5061796D656E744D6F6465223A22657273222C22636F6D6D697373696F6E42616E6B223A225041444D412042414E4B222C22636F6D6D697373696F6E42616E6B4469737472696374223A225041444D41222C22636F6D6D697373696F6E42616E6B4272616E6368223A225041444D4120434F4D4D495353494F4E20434C454152494E4720484F555345222C22636F6D6D697373696F6E42616E6B526F7574696E674E756D626572223A22303235313530303031222C22636F6D6D697373696F6E42616E6B4163636F756E744E756D626572223A22323433353433222C22636F6D6D697373696F6E4572734E756D626572223A2238373638363837222C2269735072696D617279466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C226770436F6E74616374506572736F6E4E6964223A2236343536222C22656475636174696F6E4365727469666963617465417661696C61626C65466C6167223A226E6F222C22747261696E696E67436F6D706C65746564466C6167223A226E6F222C22636F6E74616374506572736F6E4E616D65223A22222C22646F62223A22323032352D30342D3330222C22726573656C6C6572547970654E616D65223A2252657461696C6572222C22726573656C6C657247656F436C617373223A22222C2272657461696C65724964417661696C61626C65466C6167223A226E6F222C226770436F6E74616374506572736F6E446F62223A22323032352D30342D3330222C226E616D65223A222C4A6577656C204D616E646F6C2C222C22647263436F6D6D697373696F6E466C6167223A22796573222C22696D6569223A22222C22656475636174696F6E436572746966696361746546696C6550617468223A2261373937666162342D383861622D346437312D613238632D6164623635356633663235312E706E67222C2273686F7054797065223A2252656368617267652053656C6C6572222C2262696E46696C6550617468223A22222C22746C46696C6550617468223A2236626534316134322D333161302D343035362D626338352D6339623936383338626566302E706E67222C22636F6E74616374506572736F6E456D61696C223A22222C22706172746E657250726F70657274696573223A5B7B22706172746E657254797065223A22455253222C22706172746E657243617465676F7279223A22455253222C22706172746E657256616C7565436C617373223A22414C4F222C22706172746E6572537461747573223A22616374697665222C227461626C65526F774964223A312E307D2C7B22706172746E657254797065223A224D4653222C22706172746E657243617465676F7279223A224D4653222C22706172746E657256616C7565436C617373223A22535250222C22706172746E6572537461747573223A22616374697665222C227461626C65526F774964223A322E307D2C7B22706172746E657254797065223A2254656C636F222C22706172746E657243617465676F7279223A224E65726F222C22706172746E657256616C7565436C617373223A22496E7465726E657420506F696E74222C22706172746E6572537461747573223A22616374697665222C227461626C65526F774964223A332E307D2C7B22706172746E657254797065223A225343222C22706172746E657243617465676F7279223A225343222C22706172746E657256616C7565436C617373223A225365727669636520506F696E74222C22706172746E6572537461747573223A22616374697665222C227461626C65526F774964223A342E307D5D7D', 1000012),
    (11,X'7B226E6964417661696C61626C65466C6167223A226E6F222C226E69644E756D626572223A2236353736222C2267656E646572223A224D616C65222C226D656D6F5265664E6F223A22222C2270726F66696C6550696346696C6550617468223A2261303261633537362D383864302D346131362D623734632D6466383764336533366133342E706E67222C22707265666978223A224D72222C22746C4E756D626572223A2231333133222C226B7963466F726D50617468223A2236613236393164332D613566382D346538372D393138302D3035346536306631633135622E706E67222C2261677265656D656E7446696C65735061746873223A2230376331633361352D353031362D343161622D623637312D6232623936343737643164362E706E67222C226C61746974756465223A2232342E31393437363336222C227076634E756D626572223A2231333133222C22746C417661696C61626C65466C6167223A226E6F222C2262696E4E756D626572223A22222C226E696446696C6550617468223A2262653939303931662D363463312D343635662D393731302D6662386563363662373731632E706E67222C2274696E4E756D626572223A2231323132222C22636F6E74616374506572736F6E50686F6E65223A22222C227363616E6E6572466C6167223A22796573222C22726573656C6C65725365727669636554797065223A22445344222C22737470466C6167223A226E6F222C22637573746F6D6572417352657461696C6572466C6167223A22796573222C2274696E46696C6550617468223A22222C2261677265656D656E74417661696C61626C65466C6167223A226E6F222C22636F6E74726163744E616D65223A225072696D6172792042414B455247414E4A205445525249544F5259222C226E6964497373756544617465223A22323032352D30342D3330222C226C6F6E676974756465223A2239302E34323038373738222C227363616E6E65724E756D626572223A223837363837222C2261737369676E6564427473223A22222C227073724E756D626572223A2231333331222C226C6261466C6167223A22796573222C22636F6D6D697373696F6E50726F70657274696573223A5B7B22636F6D6D697373696F6E5061796D656E744D6F6465223A22657273222C22636F6D6D697373696F6E42616E6B223A225041444D412042414E4B222C22636F6D6D697373696F6E42616E6B4469737472696374223A225041444D41222C22636F6D6D697373696F6E42616E6B4272616E6368223A225041444D4120434F4D4D495353494F4E20434C454152494E4720484F555345222C22636F6D6D697373696F6E42616E6B526F7574696E674E756D626572223A22303235313530303031222C22636F6D6D697373696F6E42616E6B4163636F756E744E756D626572223A22323433353433222C22636F6D6D697373696F6E4572734E756D626572223A2238373638363837222C2269735072696D617279466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C226770436F6E74616374506572736F6E4E6964223A2236343536222C22656475636174696F6E4365727469666963617465417661696C61626C65466C6167223A226E6F222C22747261696E696E67436F6D706C65746564466C6167223A226E6F222C22636F6E74616374506572736F6E4E616D65223A22222C22646F62223A22323032352D30342D3330222C22726573656C6C6572547970654E616D65223A2252657461696C6572222C22726573656C6C657247656F436C617373223A22222C2272657461696C65724964417661696C61626C65466C6167223A226E6F222C226770436F6E74616374506572736F6E446F62223A22323032352D30342D3330222C226E616D65223A224D642E20426162756C20486F737361696E222C22647263436F6D6D697373696F6E466C6167223A22796573222C22696D6569223A22222C22656475636174696F6E436572746966696361746546696C6550617468223A2261373937666162342D383861622D346437312D613238632D6164623635356633663235312E706E67222C2273686F7054797065223A2252656368617267652053656C6C6572222C2262696E46696C6550617468223A22222C22746C46696C6550617468223A2236626534316134322D333161302D343035362D626338352D6339623936383338626566302E706E67222C22636F6E74616374506572736F6E456D61696C223A22222C22706172746E657250726F70657274696573223A5B7B22706172746E657254797065223A22455253222C22706172746E657243617465676F7279223A22455253222C22706172746E657256616C7565436C617373223A22414C4F222C22706172746E6572537461747573223A22616374697665222C227461626C65526F774964223A312E307D2C7B22706172746E657254797065223A225343222C22706172746E657243617465676F7279223A225343222C22706172746E657256616C7565436C617373223A225365727669636520506F696E74222C22706172746E6572537461747573223A22616374697665222C227461626C65526F774964223A342E307D5D7D', 1000013),
    (12,X'7B226E6964417661696C61626C65466C6167223A226E6F222C226E69644E756D626572223A2236353736222C2267656E646572223A224D616C65222C226D656D6F5265664E6F223A22222C2270726F66696C6550696346696C6550617468223A2261303261633537362D383864302D346131362D623734632D6466383764336533366133342E706E67222C22707265666978223A224D72222C22746C4E756D626572223A2231333133222C226B7963466F726D50617468223A2236613236393164332D613566382D346538372D393138302D3035346536306631633135622E706E67222C2261677265656D656E7446696C65735061746873223A2230376331633361352D353031362D343161622D623637312D6232623936343737643164362E706E67222C226C61746974756465223A2232342E3032313234222C227076634E756D626572223A2231333133222C22746C417661696C61626C65466C6167223A226E6F222C2262696E4E756D626572223A22222C226E696446696C6550617468223A2262653939303931662D363463312D343635662D393731302D6662386563363662373731632E706E67222C2274696E4E756D626572223A2231323132222C22636F6E74616374506572736F6E50686F6E65223A22222C227363616E6E6572466C6167223A22796573222C22726573656C6C65725365727669636554797065223A22445344222C22737470466C6167223A226E6F222C22637573746F6D6572417352657461696C6572466C6167223A22796573222C2274696E46696C6550617468223A22222C2261677265656D656E74417661696C61626C65466C6167223A226E6F222C22636F6E74726163744E616D65223A225072696D6172792042414B455247414E4A205445525249544F5259222C226E6964497373756544617465223A22323032352D30342D3330222C226C6F6E676974756465223A2238382E3938353539222C227363616E6E65724E756D626572223A223837363837222C2261737369676E6564427473223A22222C227073724E756D626572223A2231333331222C226C6261466C6167223A22796573222C22636F6D6D697373696F6E50726F70657274696573223A5B7B22636F6D6D697373696F6E5061796D656E744D6F6465223A22657273222C22636F6D6D697373696F6E42616E6B223A225041444D412042414E4B222C22636F6D6D697373696F6E42616E6B4469737472696374223A225041444D41222C22636F6D6D697373696F6E42616E6B4272616E6368223A225041444D4120434F4D4D495353494F4E20434C454152494E4720484F555345222C22636F6D6D697373696F6E42616E6B526F7574696E674E756D626572223A22303235313530303031222C22636F6D6D697373696F6E42616E6B4163636F756E744E756D626572223A22323433353433222C22636F6D6D697373696F6E4572734E756D626572223A2238373638363837222C2269735072696D617279466C6167223A2274727565222C227461626C65526F774964223A312E307D5D2C226770436F6E74616374506572736F6E4E6964223A2236343536222C22656475636174696F6E4365727469666963617465417661696C61626C65466C6167223A226E6F222C22747261696E696E67436F6D706C65746564466C6167223A226E6F222C22636F6E74616374506572736F6E4E616D65223A22222C22646F62223A22323032352D30342D3330222C22726573656C6C6572547970654E616D65223A2252657461696C6572222C22726573656C6C657247656F436C617373223A22222C2272657461696C65724964417661696C61626C65466C6167223A226E6F222C226770436F6E74616374506572736F6E446F62223A22323032352D30342D3330222C226E616D65223A224D642E2048616C696D222C22647263436F6D6D697373696F6E466C6167223A22796573222C22696D6569223A22222C22656475636174696F6E436572746966696361746546696C6550617468223A2261373937666162342D383861622D346437312D613238632D6164623635356633663235312E706E67222C2273686F7054797065223A2252656368617267652053656C6C6572222C2262696E46696C6550617468223A22222C22746C46696C6550617468223A2236626534316134322D333161302D343035362D626338352D6339623936383338626566302E706E67222C22636F6E74616374506572736F6E456D61696C223A22222C22706172746E657250726F70657274696573223A5B7B22706172746E657254797065223A22455253222C22706172746E657243617465676F7279223A22455253222C22706172746E657256616C7565436C617373223A22414C4F222C22706172746E6572537461747573223A22616374697665222C227461626C65526F774964223A312E307D2C7B22706172746E657254797065223A225343222C22706172746E657243617465676F7279223A225343222C22706172746E657256616C7565436C617373223A225365727669636520506F696E74222C22706172746E6572537461747573223A22616374697665222C227461626C65526F774964223A342E307D5D7D', 1000014);



/*!40000 ALTER TABLE `reseller_dynamic_data` ENABLE KEYS */;
UNLOCK TABLES;

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;