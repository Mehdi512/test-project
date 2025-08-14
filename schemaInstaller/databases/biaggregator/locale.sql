use bi;

SET FOREIGN_KEY_CHECKS=0;

TRUNCATE TABLE report_list;
TRUNCATE TABLE report_metadata;
TRUNCATE TABLE report_channel_access_control;
TRUNCATE TABLE report_category_mapping;
TRUNCATE TABLE report_access_control;

ALTER TABLE report_access_control ADD COLUMN IF NOT EXISTS user_role VARCHAR(150) DEFAULT NULL;

INSERT INTO `report_list` (`id`, `name`, `grouping`, `query`, `data_source`, `extra_field_1`, `extra_field_2`)
VALUES
	(1, 'TFD_bank_info', 'Miscellaneous', 'TFDBankReport', 'groovy', NULL, NULL),
	(2, 'SE_profile_report', 'Profile', 'SEProfileReport', 'groovy', NULL, NULL),
	(3, 'Retailer_profile_report', 'Profile', 'RETProfileReport', 'groovy', NULL, NULL),
	(4, 'Detail_STR_Physical_Report', 'sales', 'DetailSTRPhysicalReport', 'groovy', NULL, NULL),
	(5, 'Retailer_Physical_Stock_Report', 'sales', 'RetailerPhysicalStockReport', 'groovy', NULL, NULL),
	(6, 'SE Stock in hand ', 'report', 'select  owner_id as PARTNER_CODE_DH,employee_id as USER_CODE,serial_number as SERIAL_NO,additional_reference as REFERENCE_NO ,IFNULL(DATE_FORMAT(allocation_time, \'%m/%d/%Y %r\'), \'N/A\') as \"ALLOCATION_DT\" from bi_se_stock where  (\"ALL\" in (:partner_code_dh) or owner_id in (:partner_code_dh)) and allocation_time between :fromDate and :toDate', 'mysql', NULL, NULL);
	
INSERT INTO `report_metadata` (`id`, `report_id`, `name`, `description`, `type`, `default_value`, `values`, `reg_ex`, `extra_field_1`, `extra_field_2`, `is_editable`, `is_mandatory`)
VALUES
	(1, '1', 'channel', NULL, 'channelSelector', NULL, NULL, NULL, NULL, NULL, 1, 1),
	(2, '1', 'circle', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CIRCLE\"}', NULL, 1, 0),
	(3, '1', 'region', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_REGION\"}', '{\"dependent_label\":\"circle\" , \"hideOnDependent\":\"true\" ,\"hideOnParentAll\":\"true\" }', 1, 0),
	(4, '1', 'cluster', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CLUSTER\"}', '{\"dependent_label\":\"region\",\"hideOnDependent\":\"true\",\"hideOnParentAll\":\"true\"}', 1, 0),
	(5, '1', 'territory', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_TERRITORY\"}', '{\"dependent_label\":\"cluster\",\"hideOnDependent\":\"true\",\"hideOnParentAll\":\"true\"}', 1, 0),
	(6, '1', 'partner_code_dh', NULL, 'regionResellerDropdown', 'ALL', NULL, NULL, '{\"hideOnDependent\":\"true\",\"permissionKey\":\"MULTI_SELECT_DH\"}', '{\"resellerTypeId\":\"DIST\" , \"dependent_label\":\"circle,region,cluster,territory\"}', 1, 0),
	(7, '2', 'channel', NULL, 'channelSelector', NULL, NULL, NULL, NULL, NULL, 1, 1),
	(8, '2', 'circle', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CIRCLE\"}', NULL, 1, 0),
	(9, '2', 'region', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_REGION\"}', '{\"dependent_label\":\"circle\" , \"hideOnDependent\":\"true\" ,\"hideOnParentAll\":\"true\" }', 1, 0),
	(10, '2', 'cluster', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CLUSTER\"}', '{\"dependent_label\":\"region\",\"hideOnDependent\":\"true\",\"hideOnParentAll\":\"true\"}', 1, 0),
	(11, '2', 'partner_code_dh', NULL, 'regionResellerDropdown', 'ALL', NULL, NULL, '{\"hideOnDependent\":\"true\",\"permissionKey\":\"MULTI_SELECT_DH\"}', '{\"resellerTypeId\":\"DIST\" , \"dependent_label\":\"circle,region,cluster\"}', 1, 0),
	(12, '2', 'partner_code_se', NULL, 'filteredResellerDropdown', 'ALL', NULL, NULL, NULL, '{\"dependent_label\":\"partner_code_dh\" ,\"resellerTypeId\":\"SE\" , \"hideOnDependent\":\"true\"}', 1, 0),
	(13, '2', 'status', NULL, 'multiselect', 'ALL', 'ACTIVE,INACTIVE,SUSPENDED', NULL, '{\"isAppendALL\":\"true\", \"overrideDefaultAll\":\"true\"}', NULL, 1, 0),
	(14, '3', 'channel', NULL, 'channelSelector', NULL, NULL, NULL, NULL, NULL, 1, 0),
	(15, '3', 'circle', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CIRCLE\"}', NULL, 1, 0),
	(16, '3', 'region', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_REGION\"}', '{\"dependent_label\":\"circle\" , \"hideOnDependent\":\"true\" ,\"hideOnParentAll\":\"true\" }', 1, 0),
	(17, '3', 'cluster', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CLUSTER\"}', '{\"dependent_label\":\"region\",\"hideOnDependent\":\"true\",\"hideOnParentAll\":\"true\"}', 1, 0),
	(18, '3', 'territory', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_TERRITORY\"}', '{\"dependent_label\":\"cluster\",\"hideOnDependent\":\"true\",\"hideOnParentAll\":\"true\"}', 1, 0),
	(19, '3', 'partner_code_dh', NULL, 'regionResellerDropdown', 'ALL', NULL, NULL, '{\"hideOnDependent\":\"true\",\"permissionKey\":\"MULTI_SELECT_DH\"}', '{\"resellerTypeId\":\"DIST\" , \"dependent_label\":\"circle,region,cluster,territory\"}', 1, 0),
	(20, '3', 'partner_code_rtr', NULL, 'text', 'ALL', NULL, NULL, NULL, NULL, 1, 0),
	(21, '3', 'status', NULL, 'multiselect', 'ALL', 'ACTIVE,DEBOARDED,FAILED,SUSPENDED', NULL, '{\"isAppendALL\":\"true\", \"overrideDefaultAll\":\"true\"}', NULL, 1, 0),
	(22, '4', 'fromDate', 'Sale start date', 'date', '', '', NULL, '{\"fieldLabel\":\"saleStartDate\"}', '{\"disableFuture\": \"true\"}', 1, 1),
	(23, '4', 'toDate', 'Sale end date', 'date', '', '', NULL, '{\"fieldLabel\":\"saleEndDate\"}', '{\"disableFuture\": \"true\"}', 1, 1),
	(24, '4', 'channel', NULL, 'channelSelector', NULL, NULL, NULL, '{\"multiSelect\":\"true\"}', NULL, 1, 0),
	(25, '4', 'circle', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CIRCLE\"}', NULL, 1, 0),
	(26, '4', 'region', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_REGION\"}', '{\"dependent_label\":\"circle\" , \"hideOnDependent\":\"true\" ,\"hideOnParentAll\":\"true\" }', 1, 0),
	(27, '4', 'cluster', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CLUSTER\"}', '{\"dependent_label\":\"region\",\"hideOnDependent\":\"true\",\"hideOnParentAll\":\"true\"}', 1, 0),
	(28, '4', 'territory', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_TERRITORY\"}', '{\"dependent_label\":\"cluster\",\"hideOnDependent\":\"true\",\"hideOnParentAll\":\"true\"}', 1, 0),
	(29, '4', 'partner_code_dh', NULL, 'regionResellerDropdown', 'ALL', NULL, NULL, '{\"hideOnDependent\":\"true\",\"permissionKey\":\"MULTI_SELECT_DH\"}', '{\"resellerTypeId\":\"DIST\" , \"dependent_label\":\"circle,region,cluster,territory\"}', 1, 0),
	(30, '4', 'partner_code_se', NULL, 'filteredResellerDropdown', 'ALL', NULL, NULL, NULL, '{\"dependent_label\":\"partner_code_dh\" ,\"resellerTypeId\":\"SE\" , \"hideOnDependent\":\"true\"}', 1, 0),
	(31, '4', 'posCode', NULL, 'text', 'ALL', NULL, NULL, NULL, NULL, 1, 0),
	(32, '4', 'productHeads', NULL, 'productsByLevel', 'ALL', NULL, NULL, '{\"productLevel\":\"1\", \"paginatedScroll\":\"false\"}', NULL, 1, 0),
	(33, '4', 'productGroups', NULL, 'productsByLevel', 'ALL', NULL, NULL, '{\"productLevel\":\"2\", \"paginatedScroll\":\"false\"}', '{\"dependent_label\":\"productHeads\" , \"hideOnDependent\":\"true\"}', 1, 0),
	(34, '4', 'itemName', NULL, 'productSKUList', 'ALL', NULL, NULL, '{\"dependent_label\":\"productGroups\",\"hideOnDependent\":\"true\"}', '{\"showNames\":\"true\",\"resetToDefault\":\"true\"}', 1, 0),
	(35, '4', 'productType', NULL, 'select', 'Physical', 'Physical', NULL, NULL, NULL, 1, 0),
	(36, '5', 'fromDate', 'Transaction start date', 'date', '', '', NULL, '{\"fieldLabel\":\"transactionStartDate\"}', '{\"disableFuture\": \"true\"}', 1, 1),
	(37, '5', 'toDate', 'Transaction end date', 'date', '', '', NULL, '{\"fieldLabel\":\"transactionEndDate\"}', '{\"disableFuture\": \"true\"}', 1, 1),
	(38, '5', 'circle', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CIRCLE\"}', NULL, 1, 0),
	(39, '5', 'region', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_REGION\"}', '{\"dependent_label\":\"circle\" , \"hideOnDependent\":\"true\" ,\"hideOnParentAll\":\"true\" }', 1, 0),
	(40, '5', 'cluster', NULL, 'AccessControlledRegions', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_CLUSTER\"}', '{\"dependent_label\":\"region\",\"hideOnDependent\":\"true\",\"hideOnParentAll\":\"true\"}', 1, 0),
	(41, '5', 'partner_code_dh', NULL, 'regionResellerDropdown', 'ALL', NULL, NULL, '{\"hideOnDependent\":\"true\",\"permissionKey\":\"MULTI_SELECT_DH\"}', '{\"resellerTypeId\":\"DIST\" , \"dependent_label\":\"circle,region,cluster\"}', 1, 0),
	(42, '5', 'partner_code_se', NULL, 'filteredResellerDropdown', 'ALL', NULL, NULL, NULL, '{\"dependent_label\":\"partner_code_dh\" ,\"resellerTypeId\":\"SE\" , \"hideOnDependent\":\"true\"}', 1, 0),
	(43, '5', 'productHeads', NULL, 'productsByLevel', 'ALL', NULL, NULL, '{\"productLevel\":\"1\", \"paginatedScroll\":\"false\"}', NULL, 1, 0),
	(44, '5', 'productGroups', NULL, 'productsByLevel', 'ALL', NULL, NULL, '{\"productLevel\":\"2\", \"paginatedScroll\":\"false\"}', '{\"dependent_label\":\"productHeads\" , \"hideOnDependent\":\"true\"}', 1, 0),
	(45, '5', 'itemName', NULL, 'productSKUList', 'ALL', NULL, NULL, '{\"dependent_label\":\"productGroups\",\"hideOnDependent\":\"true\"}', '{\"showNames\":\"true\",\"resetToDefault\":\"true\"}', 1, 0),
	(46, '5', 'posCode', NULL, 'text', 'ALL', NULL, NULL, NULL, NULL, 1, 0),
	(47, '6', 'fromDate', NULL, 'date', '', '', NULL, '{\"fieldLabel\":\"allocationStartDate\"}', '{\"disableFuture\": \"true\"}', 1, 1),
	(48, '6', 'toDate', NULL, 'date', '', '', NULL, '{\"fieldLabel\":\"allocationEndDate\"}', '{\"disableFuture\": \"true\"}', 1, 1),
	(49, '6', 'partner_code_dh', NULL, 'regionResellerDropdown', 'ALL', NULL, NULL, '{\"permissionKey\":\"MULTI_SELECT_DH\"}', '{\"resellerTypeId\":\"DIST\" }', 1, 0);

INSERT INTO `report_access_control` (`id`, `type_role`, `user_role`, `name`, `report_list_ids`, `dashboard_url_ids`, `status`, `settings`)
VALUES
	(1, 'OPERATOR', 'core', NULL, '1,2,3,4,5,6', '1', 'active', 1),
	(2, 'DIST', 'default_role', NULL, '1,2,3,4,5,6', '1', 'active', 1);

INSERT INTO `report_category_mapping` (`id`, `category_name`, `report_list_ids`)
VALUES
	(1, 'Report', '1,2,3,4,5,6');

INSERT INTO `report_channel_access_control` (`id`, `channel`, `report_list_ids`, `status`)
VALUES
	(1, 'web', '1,2,3,4,5,6', 'active');

SET FOREIGN_KEY_CHECKS=1;