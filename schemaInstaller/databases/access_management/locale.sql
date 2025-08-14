USE access_management;

SET FOREIGN_KEY_CHECKS = 0;

-- Use this in your ide to generate truncate statements for multiple tables as required
-- SELECT CONCAT('TRUNCATE TABLE ', table_name, ';')
-- FROM information_schema.tables
-- WHERE table_schema = 'access_management'
-- AND table_rows > 0;

TRUNCATE TABLE app_features_hierarchy;
TRUNCATE TABLE policy_endpoint_map;
TRUNCATE TABLE gateway_management;
TRUNCATE TABLE resellertype_policy_map;
TRUNCATE TABLE app_hierarchy;
TRUNCATE TABLE policy;
TRUNCATE TABLE module_endpoints;
TRUNCATE TABLE app_features;
TRUNCATE TABLE resource;
TRUNCATE TABLE master_resource;
TRUNCATE TABLE resource_mapping;
TRUNCATE TABLE policy_resource_mapping_applied;

INSERT INTO `module_endpoints` (`id`, `module`, `module_feature`, `component_name`, `channel`, `endpoint`, `http_method`, `content_type`, `description`, `available_from`, `available_until`, `default_flag`)
VALUES
	('1', 'ACCESS', 'v1policyPOST', 'access', 'ALL', 'v1/policy', 'POST', 'application/json', 'POST API call to add policy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('2', 'ACCESS', 'v1featuresGET1', 'access', 'ALL', 'v1/features', 'GET', 'application/json', 'GET API call to get features list', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('3', 'ACCESS', 'v1policyListGET', 'access', 'ALL', 'v1/policyList', 'GET', 'application/json', 'GET API call to get policy list', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('4', 'ACCESS', 'v1policyGET', 'access', 'ALL', 'v1/policy/.*', 'GET', 'application/json', 'GET API call to get policy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('5', 'ACCESS', 'v1mapFeaturesPOST', 'access', 'ALL', 'v1/mapFeatures', 'POST', 'application/json', 'POST API call to add features with policy id', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('6', 'ACCESS', 'v1mapFeaturesPUT', 'access', 'ALL', 'v1/mapFeatures', 'PUT', 'application/json', 'PUT API call to edit features with policy id', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('7', 'ACCESS', '', 'access', 'ALL', 'v1/features/resellerType/.*', 'GET', 'application/json', 'GET API call to get features list for resellerType with resellerType', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('8', 'ACCESS', 'v1featuresGET', 'access', 'ALL', 'v1/features/.*', 'GET', 'application/json', 'GET API call to get features with ID', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('9', 'ACCESS', 'v2policyPOST', 'access', 'ALL', 'v2/policy', 'POST', 'application/json', 'POST API call to add new Policy with endpoints', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('10', 'ACCESS', 'v2policyPUT', 'access', 'ALL', 'v2/policy', 'PUT', 'application/json', 'PUT API call to edit Policy details', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('11', 'ACCESS', 'v2policyListPOST', 'access', 'ALL', 'v2/policyList', 'POST', 'application/json', 'POST API call to get policies list', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('12', 'ACCESS', 'v2policyALLDELETE', 'access', 'ALL', 'v2/policy/.*', 'DELETE', 'application/json', 'DELETE API call to delete policy by Policy id', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('13', 'ACCESS', 'v2moduleGET', 'access', 'ALL', 'v2/module', 'GET', 'application/json', 'GET API call to get all modules', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('14', 'ACCESS', 'v2featuresmoduleALLGET', 'access', 'ALL', 'v2/features/module/.*', 'GET', 'application/json', 'GET API call to get features by module name', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('15', 'ACCESS', 'v2policyALLGET', 'access', 'ALL', 'v2/policy/.*', 'GET', 'application/json', 'GET API call to get policy details by policy id', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('16', 'ACCESS', 'CLONE', 'access', 'ALL', '', '', '', 'UI Acesss to get Clone featue', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('17', 'ACCESS', 'v2getEndpointsByModule', 'access', 'ALL', 'v2/getEndpointsByModule', 'POST', 'application/json', 'POST API call to get endpoints and channels against list of modules', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('18', 'ACCESS', 'v1policyPOST All', 'access', 'ALL', 'v1/policy', 'POST', 'application/json', 'POST API call to add policy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('19', 'ACCESS', 'policyList get', 'access', 'ALL', 'v1/policyList', 'GET', 'application/json', 'GET API call to get policy list', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('20', 'ACCESS', 'v1policyALLGET', 'access', 'ALL', 'v1/policy/.*', 'GET', 'application/json', 'GET API call to get policy with id', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('21', 'ACCESS', 'appfeature', 'access', 'ALL', 'app/feature/.*', 'GET', 'application/json', 'GET API call to get all app features', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('22', 'ACCESS', 'v2GetResellerMapping', 'access', 'ALL', 'v2/reseller.*', 'GET', 'application/json', 'GET API call to get reseller mapping', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('23', 'ACCESS', 'v2POSTResellerMapping', 'access', 'ALL', 'v2/reseller.*', 'POST', 'application/json', 'POST API call to add policy with resellers', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('24', 'ACCESS', 'v2PUTResellerMapping', 'access', 'ALL', 'v2/reseller.*', 'PUT', 'application/json', 'PUT API call to edit policy with reseller', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('25', 'ACCESS', 'v2DeleteResellerMapping', 'access', 'ALL', 'v2/reseller.*', 'DELETE', 'application/json', 'DELETE API call to delete reseller', '2021-02-18 18:46:02', '2099-02-18 18:46:02', '0'),
	('26', 'ACCESS', 'v1policyPOST App', 'access', 'APP', 'v1/policy', 'POST', 'application/json', 'POST API call to add policy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('27', 'ACCESS', 'v1policyPOST Portal ', 'access', 'PORTAL', 'v1/policy', 'POST', 'application/json', 'POST API call to add policy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('28', 'ACCESS', NULL, 'access', 'ALL', 'app/feature/hierarchy.*', 'GET', 'application/json', 'API to get mobile app featues', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('29', 'ACCOUNT', 'ACCOUNTTYPES', 'ams', 'ALL', '', '', '', 'account types', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('30', 'ACCOUNT', 'SEARCHTRANSACTIONS', 'ams', 'ALL', '', '', '', 'search', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('31', 'ACCOUNT', 'ACCOUNTS', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('32', 'ACCOUNT', 'CREATE_ACCOUNTTYPE', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('33', 'ACCOUNT', 'VIEW_ACCOUNTTYPE', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('34', 'ACCOUNT', 'EDIT_ACCOUNTTYPE', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('35', 'ACCOUNT', 'ACCOUNTTYPES_LISTING', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('36', 'ACCOUNT', 'SEARCH_TRANSACTIONS', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('37', 'ACCOUNT', 'CREATE_ACCOUNT', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('38', 'ACCOUNT', 'VIEW_ACCOUNT', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('39', 'ACCOUNT', 'SEARCH_ACCOUNTS', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('40', 'ACCOUNT', 'ACCOUNTS_LISTING', 'ams', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('41', 'ACCOUNT', 'v1servicesaccountTypePOST', 'ams', 'ALL', 'v1/services/accountType', 'POST', 'application/json', 'API to create a account type', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('42', 'ACCOUNT', 'v1servicesaccountTypePUT', 'ams', 'ALL', 'v1/services/accountType', 'PUT', 'application/json', 'API to update a account type', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('43', 'ACCOUNT', 'v1servicesaccountTypeGET', 'ams', 'ALL', 'v1/services/accountType', 'GET', 'application/json', 'API to get all account types', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('44', 'ACCOUNT', 'v1servicesaccountTypeGET', 'ams', 'ALL', 'v1/services/accountType/.*', 'GET', 'application/json', 'API to get a single account type', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('45', 'ACCOUNT', 'v1servicesaccountTypeDELETE', 'ams', 'ALL', 'v1/services/accountType/.*', 'DELETE', 'application/json', 'API to delete a account type', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('46', 'ACCOUNT', 'v1servicestopupPOST', 'ams', 'ALL', 'v1/services/topup', 'POST', 'application/json', 'API to will be used for topup', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('47', 'ACCOUNT', 'v1servicesdeactivateAccountPOST', 'ams', 'ALL', 'v1/services/deactivateAccount', 'POST', 'application/json', 'API to will be used to de Activate Account', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('48', 'ACCOUNT', 'v1servicesactivateAccountPOST', 'ams', 'ALL', 'v1/services/activateAccount', 'POST', 'application/json', 'API to will be used to Activate Account', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('49', 'ACCOUNT', 'v1servicesgenerateAccountPOST', 'ams', 'ALL', 'v1/services/generateAccount', 'POST', 'application/json', 'API to will be used to generate Account', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('50', 'ACCOUNT', 'v1servicesvalidateAccountPOST', 'ams', 'ALL', 'v1/services/validateAccount', 'POST', 'application/json', 'API to will be used to validate Account', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('51', 'ACCOUNT', 'v1servicesvalidateAccountPOST', 'ams', 'ALL', 'v1/services/validateAccount', 'POST', 'application/json', 'API to will be used to validate Account', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('52', 'ACCOUNT', 'v1servicescreateExpiryInfoPOST', 'ams', 'ALL', 'v1/services/createExpiryInfo', 'POST', 'application/json', 'API to will be used to create expiry info', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('53', 'ACCOUNT', 'v1managementaccountsPOST', 'ams', 'ALL', 'v1/management/accounts', 'POST', 'application/json', 'API to create a account ', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('54', 'ACCOUNT', 'v1managementaccountsPUT', 'ams', 'ALL', 'v1/management/accounts', 'PUT', 'application/json', 'API to update a account ', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('55', 'ACCOUNT', 'v1managementaccountsGET', 'ams', 'ALL', 'v1/management/accounts/.*', 'GET', 'application/json', 'API to get multiple accounts', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('56', 'ACCOUNT', 'v1managementaccountsGET', 'ams', 'ALL', 'v1/management/accounts/.*', 'GET', 'application/json', 'API to get a single account', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('57', 'ACCOUNT', 'v1managementaccountsDELETE', 'ams', 'ALL', 'v1/management/accounts/.*', 'DELETE', 'application/json', 'API to delete a account type', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('58', 'ACCOUNT', 'v1managementsearchAccountTransactionsPOST', 'ams', 'ALL', 'v1/management/searchAccountTransactions', 'POST', 'application/json', 'API to search account transaction ', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('59', 'ACCOUNT', 'v1operationsrequestPrincipalInformationPOST', 'ams', 'ALL', 'v1/operations/requestPrincipalInformation', 'POST', 'application/json', 'API to will used to get account account information ', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('60', 'ACCOUNT', 'v1operationsmakeAccountsTransactionsPUT', 'ams', 'ALL', 'v1/operations/makeAccountsTransactions', 'PUT', 'application/json', 'API to will be used to make transactions ', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('61', 'ACCOUNT', 'v1operationsmakeAccountsTransactionPUT', 'ams', 'ALL', 'v1/operations/makeAccountsTransaction', 'PUT', 'application/json', 'API to will be used to make transaction ', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('62', 'ACCOUNT', 'v1servicesaccountTypeGET', 'ams', 'ALL', 'v1/services/accountType', 'GET', 'application/json', 'list account types', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('63', 'ACCOUNT', 'v1servicesloanEnabledAccountsGET', 'ams', 'ALL', 'v1/services/loanEnabledAccounts', 'GET', 'application/json', 'API will be used to get loan enabled accounts', '2021-05-20 12:26:20', '2099-01-01 00:00:00', '0'),
	('64', 'ACCOUNT', '', 'ams', 'ALL', 'v1/management/searchAccounts', 'POST', 'application/json', 'searchAccounts', '2021-02-25 12:26:20', '2099-02-25 12:26:20', '0'),
	('65', 'ACCOUNT', 'v1managementsearchAccountsPOST', 'ams', 'ALL', 'v1/management/searchAccounts', 'POST', 'application/json', 'searchAccounts', '2021-02-25 12:26:20', '2022-02-25 12:26:20', '0'),
	('66', 'ACCOUNT', 'MANUALADJUSTMENT', 'ams', 'ALL', 'abcs', '', '', ' ', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('67', 'ACTIVITY', 'VIEW ACTIVITY', 'smas', 'ALL', '', '', '', 'street market activity\n', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('68', 'ACTIVITY', 'v1activityPOST', 'smas', 'ALL', 'v1/activity', 'POST', 'application/json', 'Add an activity', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('69', 'ACTIVITY', 'v1activityPUT', 'smas', 'ALL', 'v1/activity', 'PUT', 'application/json', 'Update an activity', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('70', 'ACTIVITY', 'v1activityPUT', 'smas', 'ALL', 'v1/activity/.*', 'PUT', 'application/json', 'Approve an activity', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('71', 'ACTIVITY', 'v1activityPUT', 'smas', 'ALL', 'v1/activity/.*/.*', 'PUT', 'application/json', 'Cancel an activity', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('72', 'ACTIVITY', 'v1activityGET', 'smas', 'ALL', 'v1/activity', 'GET', 'application/json', 'Fetch list of activities', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('73', 'ACTIVITY', 'v1activityGET', 'smas', 'ALL', 'v1/activity/.*', 'GET', 'application/json', 'Fetch activity details', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('74', 'ACTIVITY', 'v1activityziplocationGET', 'smas', 'ALL', 'v1/activity/zip-location/.*', 'GET', 'application/json', 'Fetch list of zip locations', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('75', 'ACTIVITY', 'v1activityregionGET', 'smas', 'ALL', 'v1/activity/region', 'GET', 'application/json', 'Fetch list of regions', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('76', 'ACTIVITY', 'v1activityreasonGET', 'smas', 'ALL', 'v1/activity/reason', 'GET', 'application/json', 'Fetch list of reasons', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('77', 'ACTIVITY', 'v1activityproductvariantGET', 'smas', 'ALL', 'v1/activity/product-variant/.*', 'GET', 'application/json', 'Fetch list of product variants', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('78', 'ACTIVITY', 'v1activityconceptGET', 'smas', 'ALL', 'v1/activity/concept', 'GET', 'application/json', 'Fetch list of concepts', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('79', 'ACTIVITY', 'v1activitychildresellerGET', 'smas', 'ALL', 'v1/activity/child-reseller/.*', 'GET', 'application/json', 'Fetch list of child resellers', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('80', 'ACTIVITY', 'v1activityactionGET', 'smas', 'ALL', 'v1/activity/action', 'GET', 'application/json', 'Fetch list of actions', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('81', 'BATCH', '', 'bss', 'ALL', 'v1/import/transaction', 'POST', 'application/json', 'Get Import info', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('82', 'BATCH', 'v1batchstatusGET', 'bss', 'ALL', 'v1/batch/.*/status', 'GET', 'application/json', 'Get batch info/status', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('83', 'BATCH', 'v1batchscheduledinfoGET', 'bss', 'ALL', 'v1/batch/scheduled/info', 'GET', 'application/json', 'Get scheduled batches', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('84', 'BATCH', 'v1importinventoryPOST', 'bss', 'ALL', 'v1/import/inventory', 'POST', 'application/json', 'Import inventory', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('85', 'BATCH', 'v1importresellerPOST', 'bss', 'ALL', 'v1/import/reseller', 'POST', 'application/json', 'Import Resellers', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('86', 'BATCH', 'v1importserviceinfoGET', 'bss', 'ALL', 'v1/import/service/info', 'GET', 'application/json', 'Get service configuration', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('87', 'BATCH', '', 'bss', 'ALL', 'v1/import/.*/info', 'GET', 'application/json', 'Get Import info', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('88', 'BULK', NULL, 'bss', 'ALL', 'v1/import/rateCard', 'POST', 'application/json', 'Get Import info', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('89', 'BULK', NULL, 'bss', 'ALL', 'v1/import/rateCard', 'POST', 'multipart/form-data', 'Get Import info', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('90', 'BULK', 'CREATE_BULK_IMPORT', 'bss', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('91', 'BULK', 'VIEW_BULK_IMPORT_DETAILS', 'bss', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('92', 'BULK', 'VIEW_BULK_IMPORT_LIST', 'bss', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('93', 'BULK', 'IMPORT', 'bss', 'ALL', '', '', '', '', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('94', 'BULK', '', 'bss', 'ALL', 'v1/batch/.*/status', 'GET', 'application/json', 'Get batch info/status', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('95', 'BULK', '', 'bss', 'ALL', 'v1/batch/scheduled/info', 'GET', 'application/json', 'Get scheduled batches', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('96', 'BULK', '', 'bss', 'ALL', 'v1/import/inventory', 'POST', 'multipart/form-data', 'Import inventory', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('97', 'BULK', '', 'bss', 'ALL', 'v1/import/reseller', 'POST', 'multipart/form-data', 'Import Resellers', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('98', 'BULK', '', 'bss', 'ALL', 'v1/import/order', 'POST', 'multipart/form-data', 'Import Orders', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('99', 'BULK', '', 'bss', 'ALL', 'v1/import/service/info', 'GET', 'application/json', 'Get service configuration', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('100', 'BULK', '', 'bss', 'ALL', 'v1/import/.*/info', 'GET', 'application/json', 'Get Import info', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('101', 'BULK', '', 'bss', 'ALL', 'v1/import/.*/resubmit', 'POST', 'application/json', 'Schedule retry job', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('102', 'BULK', '', 'bss', 'ALL', 'v1/import/notification', 'POST', 'application/json', 'Bulk notification', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('103', 'CAMPAIGN', 'CAMPAIGN', 'scc', 'ALL', 'CAMPAIGN Management Sidebar', '', '', '[UI] - Campaign management sidebar', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('104', 'CAMPAIGN', 'CREATE_CAMPAIGN', 'scc', 'ALL', 'FOR CREATE ACTION OF CAMPAIGN', '', '', '[UI] - Create action of campaign', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('105', 'CAMPAIGN', 'VIEW_CAMPAIGN', 'scc', 'ALL', 'FOR CREATE ACTION OF CAMPAIGN', '', '', '[UI] - View action of the campaign', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('106', 'CAMPAIGN', 'EDIT_CAMPAIGN', 'scc', 'ALL', 'FOR EDIT ACTION OF CAMPAIGN', '', '', '[UI] - Edit action of the campaign', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('107', 'CAMPAIGN', 'UPDATE_CAMPAIGN_STATUS', 'scc', 'ALL', 'FOR UPDATE HOLD-RESUME STATUS OF CAMPAIGN ACTION', '', '', '[UI] - Update status of campaign action', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('108', 'CAMPAIGN', 'PENDINGAPPROVAL', 'scc', 'ALL', 'Pending Approvals Management Sidebar', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('109', 'CAMPAIGN', 'CAMPAIGNDESIGN', 'scc', 'ALL', 'Pending Approvals -> Campaign Design Management Sidebar', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('110', 'CAMPAIGN', 'VIEW_ALL_CAMPAIGN_DESIGN', 'scc', 'ALL', 'Campaign Design Listing', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('111', 'CAMPAIGN', 'VIEW_CAMPAIGN_DESIGN', 'scc', 'ALL', 'Campaign Design Details', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('112', 'CAMPAIGN', 'APPROVE_CAMPAIGN_DESIGN', 'scc', 'ALL', 'Campaign Design Approval', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('113', 'CAMPAIGN', 'REJECT_CAMPAIGN_DESIGN', 'scc', 'ALL', 'Campaign Design Reject', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('114', 'CAMPAIGN', 'ADJUSTMENT', 'scc', 'ALL', 'ADJUSTMENT Module', '', '', '[UI] - Commission Adjustment sidebar', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('115', 'CAMPAIGN', 'COMMISSIONADJUSTMENT', 'scc', 'ALL', 'COMMISSION ADJUSTMENT SIDE MENU', '', '', '[UI] - Commission Adjustment SIDE MENU', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('116', 'CAMPAIGN', 'VIEW_COMMISSION_ADJUSTMENT', 'scc', 'ALL', 'View Commission Adjustment Detail Module', '', '', '[UI] - Listing Commission Adjustment', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('117', 'CAMPAIGN', 'COMMISSION_ADJUSTMENT_LIST', 'scc', 'ALL', 'View Commission Adjustment Listing Module', '', '', '[UI] - View Commission Adjustment', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('118', 'CAMPAIGN', 'COMMISSIONPAYOUT', 'scc', 'ALL', 'Commission Payout Sidebar', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('119', 'CAMPAIGN', 'VIEW_ALL_COMMISSION_PAYOUT', 'scc', 'ALL', 'Commission Payout Listing', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('120', 'CAMPAIGN', 'VIEW_COMMISSION_PAYOUT', 'scc', 'ALL', 'Commission Payout Details', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('121', 'CAMPAIGN', 'APPROVE_COMMISSION_PAYOUT', 'scc', 'ALL', 'Commission Payout Approval', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('122', 'CAMPAIGN', 'REJECT_COMMISSION_PAYOUT', 'scc', 'ALL', 'Commission Payout Reject', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('123', 'CAMPAIGN', 'CAMPAIGNS', 'scc', 'ALL', 'CAMPAIGN Module', '', '', '[UI] - Campaign management sidebar', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('124', 'CAMPAIGN', 'EDIT_COMMISSION_ADJUSTMENT', 'scc', 'ALL', 'View Commission Adjustment Detail Module', '', '', '[UI] - Edit Commission Adjustment', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('125', 'CAMPAIGN', 'CLONE_CAMPAIGN', 'scc', 'ALL', 'FOR CLONE ACTION OF CAMPAIGN', '', '', '[UI] - Clone action of the campaign', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('126', 'CONTRACT', NULL, 'acms', 'ALL', 'v2/rule-condition/.*', 'GET', 'application/json', 'Get rule condition', '2021-02-03 00:00:00', '2099-09-03 00:00:00', '0'),
	('127', 'CONTRACT', NULL, 'acms', 'ALL', 'bookkeeping-accounts', 'GET', 'application/json', 'Get bookkeeping accounts', '2021-02-03 00:00:00', '2099-09-03 00:00:00', '0'),
	('128', 'CONTRACT', '', 'acms', 'ALL', 'v2/contracts/clone', 'POST', 'application/json', 'Get commission span ', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('129', 'CONTRACT', NULL, 'acms', 'ALL', 'v2/compute-expression', 'POST', 'application/json', 'compute expression', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('130', 'CONTRACT', '', 'acms', 'ALL', 'v2/export-price-entry', 'GET', 'application/json', 'Export Contract', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('131', 'CONTRACT', NULL, 'acms', 'ALL', 'fetch-products-variants', 'GET', 'application/json', 'Get product variants', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('132', 'CONTRACT', 'CONTRACTS', 'acms', 'ALL', '', '', '', 'contract', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('133', 'CONTRACT', 'CREATE_CONTRACT', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('134', 'CONTRACT', 'UPDATE_CONTRACT', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('135', 'CONTRACT', 'VIEW_CONTRACTS', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('136', 'CONTRACT', 'VIEW_PRODUCTS_RULES', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('137', 'CONTRACT', 'CLONE_CONTRACT', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('138', 'CONTRACT', 'ADD_PRODUCT_RULES', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('139', 'CONTRACT', 'VIEW_PRODUCT_RANGE_RULES', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('140', 'CONTRACT', 'UPDATE_PRODUCT_RULES', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('141', 'CONTRACT', 'DELETE_PRODUCT_RULES', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('142', 'CONTRACT', 'UPDATE_PRODUCT_STATUS', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('143', 'CONTRACT', '', 'acms', 'ALL', 'v2/contracts', 'POST', 'application/json', 'Add contract', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('144', 'CONTRACT', '', 'acms', 'ALL', 'v2/contracts/.*', 'GET', 'application/json', 'Get contract by id', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('145', 'CONTRACT', '', 'acms', 'ALL', 'v2/contracts/.*', 'PUT', 'application/json', 'Put contract', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('146', 'CONTRACT', '', 'acms', 'ALL', 'v2/contracts.*', 'GET', 'application/json', 'Get contract ', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('147', 'CONTRACT', '', 'acms', 'ALL', 'country/', 'GET', 'application/json', 'Get country', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('148', 'CONTRACT', '', 'acms', 'ALL', 'reseller-type/', 'GET', 'application/json', 'Get reseller types ', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('149', 'CONTRACT', '', 'acms', 'ALL', 'v2/deferred-commission-spans', 'GET', 'application/json', 'Get deferred commission spans', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('150', 'CONTRACT', '', 'acms', 'ALL', 'v2/calculate-pricing', 'POST', 'application/json', 'Calculate pricing', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('151', 'CONTRACT', '', 'acms', 'ALL', 'v2/contract-price-entries', 'POST', 'application/json', 'Post contract price entries', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('152', 'CONTRACT', '', 'acms', 'ALL', 'contract-account-type/', 'GET', 'application/json', 'Get contract account type', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('153', 'CONTRACT', NULL, 'acms', 'ALL', 'contract-tag/', 'GET', 'application/json', 'Get contract tag', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('154', 'CONTRACT', NULL, 'acms', 'ALL', 'wallet-type/', 'GET', 'application/json', 'Get wallet type', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('155', 'CONTRACT', '', 'acms', 'ALL', 'contract-value-type/', 'GET', 'application/json', 'Get contract value type', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('156', 'CONTRACT', '', 'acms', 'ALL', 'v2/contract-price-entries', 'GET', 'application/json', 'Get contract price entries', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('157', 'CONTRACT', '', 'acms', 'ALL', 'v2/contract-price-entries/.*', 'PUT', 'application/json', 'Update contract price entries', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('158', 'CONTRACT', '', 'acms', 'ALL', 'v2/contract-price-entries/.*', 'DELETE', 'application/json', 'Delete contract price entries', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('159', 'CONTRACT', '', 'acms', 'ALL', 'v2/product-status-update/.*', 'PUT', 'application/json', 'Update product status', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('160', 'CONTRACT', '', 'acms', 'ALL', 'v2/fetch-product-range/.*', 'GET', 'application/json', 'Get product range', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('161', 'CONTRACT', 'CREATE_CONTRACT_ACTIVE_STATUS', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('162', 'CONTRACT', 'VIEW_CONTRACT', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('163', 'CONTRACT', 'EDIT_CONTRACT', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('164', 'CONTRACT', 'CONTRACT_PRICE', 'acms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('165', 'DASHBOARD', 'STOCK_AS_PER_REGION_DEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('166', 'DASHBOARD', 'STOCK_AS_PER_REGION', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('167', 'DASHBOARD', 'STOCK_AS_PER_HIERARCHY_DEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('168', 'DASHBOARD', 'STOCK_AS_PER_HIERARCHY', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('169', 'DASHBOARD', 'REGIONALDASHBOARD', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('170', 'DASHBOARD', 'REGIONAL', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('171', 'DASHBOARD', 'PERFORMANCE_EMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('172', 'DASHBOARD', 'PERFORMANCE_DEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('173', 'DASHBOARD', 'PERFORMANCEDASHBOARDEMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('174', 'DASHBOARD', 'PERFORMANCEDASHBOARDDEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('175', 'DASHBOARD', 'ORDER_TRACKER_EMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('176', 'DASHBOARD', 'ORDER_TRACKER_DEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('177', 'DASHBOARD', 'ORDER_EMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('178', 'DASHBOARD', 'ORDER_DEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('179', 'DASHBOARD', 'ORDERDASHBOARDEMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('180', 'DASHBOARD', 'ORDERDASHBOARDDEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('181', 'DASHBOARD', 'DASHBOARD', 'dashboard', 'ALL', '', '', '', 'Dashboard Main sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('182', 'DASHBOARD', 'DAILYORDERTRACKERDASHBOARDEMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('183', 'DASHBOARD', 'DAILYORDERTRACKERDASHBOARDDEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('184', 'DASHBOARD', 'CURRENTSTOCKASPERREGIONEMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Current stock as per region sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('185', 'DASHBOARD', 'CURRENTSTOCKASPERREGIONDEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('186', 'DASHBOARD', 'CURRENTSTOCKASPERHIERARCHYEMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('187', 'DASHBOARD', 'CURRENTSTOCKASPERHIERARCHYDEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('188', 'DASHBOARD', 'CHART_PERFORMANCE_EMPLOYEE', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('189', 'DASHBOARD', 'CHART_PERFORMANCE_DEALER', 'dashboard', 'ALL', '', '', '', 'Dashboard Regional sidebar option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('190', 'External-Logistics', NULL, 'els', 'ALL', 'v1/ratecard', 'GET', 'application/json', 'API to get a single product', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('191', 'External-Logistics', NULL, 'els', 'ALL', 'v1/vendor/fare-analytics', 'GET', 'application/json', 'Import rate card', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('192', 'External-Logistics', NULL, 'els', 'ALL', 'v1/ratecard', 'POST', 'application/json', 'API to get a single product', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('193', 'GROUP', 'EDIT_BUTTON', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('194', 'GROUP', 'DELETE_BUTTON', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('195', 'GROUP', 'CREATE_GROUP_BUTTON', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('196', 'GROUP', 'GROUPS', 'gms', 'ALL', '', '', '', 'groups', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('197', 'GROUP', 'OPERATIONS', 'gms', 'ALL', '', '', '', 'groups', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('198', 'GROUP', 'RELATIONS', 'gms', 'ALL', '', '', '', 'groups', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('199', 'GROUP', 'CREATE_GROUP', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('200', 'GROUP', 'VIEW_GROUP', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('201', 'GROUP', 'EDIT_GROUP', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('202', 'GROUP', 'GROUPS_LISTING', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('203', 'GROUP', 'CREATE_OPERATION', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('204', 'GROUP', 'VIEW_OPERATION', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('205', 'GROUP', 'EDIT_OPERATION', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('206', 'GROUP', 'OPERATIONS_LISTING', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('207', 'GROUP', 'RELATIONS_LISTING', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('208', 'GROUP', '', 'groupmanagementsystem', 'ALL', 'v1/group.*', 'GET', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('209', 'GROUP', 'v1groupPOST', 'groupmanagementsystem', 'ALL', 'v1/group', 'POST', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('210', 'GROUP', 'v1grouprelationPOST', 'groupmanagementsystem', 'ALL', 'v1/group/relation', 'POST', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('211', 'GROUP', 'v1grouprelationPUT', 'groupmanagementsystem', 'ALL', 'v1/group/relation', 'PUT', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('212', 'GROUP', 'v1groupDELETE', 'groupmanagementsystem', 'ALL', 'v1/group/.*', 'DELETE', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('213', 'GROUP', 'v1groupPUT', 'groupmanagementsystem', 'ALL', 'v1/group', 'PUT', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('214', 'GROUP', 'v1groupPOST', 'groupmanagementsystem', 'ALL', 'v1/group/.*/.*', 'POST', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('215', 'GROUP', 'v1groupoperationPUT', 'groupmanagementsystem', 'ALL', 'v1/group/operation', 'PUT', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('216', 'GROUP', 'v1groupoperationPOST', 'groupmanagementsystem', 'ALL', 'v1/group/operation', 'POST', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('217', 'GROUP', NULL, 'groupmanagementsystem', 'ALL', 'v1/group/.*/member', 'POST', 'application/json', 'POST API call to add member endpoint', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('218', 'GROUP', 'MEMBERS_LIST_ACTIONS_COLUMN', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('219', 'GROUP', 'ADMINS_LIST_ACTIONS_COLUMN', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('220', 'GROUP', 'EDIT_GROUP_UPDATE_BUTTON', 'gms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('221', 'IMS bridge', 'changePasswordPOST', 'imsbridge', 'ALL', 'changePassword', 'POST', 'application/json', 'change password', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('222', 'INVENTORY', 'search', 'ims', 'ALL', 'v1/inventory-count-reseller-all', 'POST', 'application/json', 'Export inventory', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('223', 'INVENTORY', 'DETAILEDINVENTORY', 'ims', 'ALL', '', '', '', 'import', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('224', 'INVENTORY', 'v2inventroiesPOST', 'ims', 'ALL', 'v2/inventories', 'POST', 'application/json', '', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('225', 'INVENTORY', NULL, 'ims', 'ALL', 'v2/inventories', 'POST', 'application/json', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('226', 'INVENTORY', 'IMPORTINVENTORY', 'ims', 'ALL', '', '', '', 'import', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('227', 'INVENTORY', NULL, 'ims', 'ALL', 'v1/stock-ownership-report', 'GET', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('228', 'INVENTORY', NULL, 'ims', 'ALL', 'v1/inventory/update/bulk-import.*', 'PUT', 'application/json', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('229', 'INVENTORY', NULL, 'ims', 'ALL', 'v2/products/.*/inventories/boxes', 'POST', 'application/json', 'list inventory box item', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('230', 'INVENTORY', NULL, 'ims', 'ALL', 'v1/box/.*/export.*', 'POST', 'application/json', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('231', 'INVENTORY', 'v1inventoriesGET', 'ims', 'ALL', 'v1/inventories/.*', 'GET', 'application/json', 'This is sample', '2020-02-23 19:33:03', '2099-02-23 19:33:03', '0'),
	('232', 'INVENTORY', 'v1ownerinventoryGET', 'ims', 'ALL', 'v1/owner/.*/inventory', 'GET', 'application/json', 'This is sample', '2021-02-23 14:54:05', '2099-02-24 14:54:05', '0'),
	('233', 'INVENTORY', 'v1inventoryimportGET', 'ims', 'ALL', 'v1/inventory/import', 'GET', 'application/json', 'IMPORT LIST\n', '2021-03-03 19:13:23', '2099-01-01 00:00:00', '0'),
	('234', 'INVENTORY', 'v1inventoryimportGET', 'ims', 'ALL', 'v1/inventory/import/.*', 'GET', 'application/json', 'IMPORT LIST\n', '2021-03-03 19:13:23', '2099-01-01 00:00:00', '0'),
	('235', 'INVENTORY', 'v1inventoryimportPOST', 'ims', 'ALL', 'v1/inventory/import', 'POST', 'multipart/form-data', 'IMPORT LIST\n', '2021-03-03 19:13:23', '2099-01-01 00:00:00', '0'),
	('236', 'INVENTORY', 'v1inventoryimportactionAPPROVEPATCH', 'ims', 'ALL', 'v1/inventory/import/.*/action/APPROVE', 'PATCH', 'application/json', 'API to get a product variant', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('237', 'INVENTORY', 'v1inventoryimportactionREJECTPATCH', 'ims', 'ALL', 'v1/inventory/import/.*/action/REJECT', 'PATCH', 'application/json', 'API to get a product variant', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('238', 'INVENTORY', 'v1inventorytransferGET', 'ims', 'ALL', 'v1/inventory/transfer/', 'GET', 'application/json', 'GET ALL TRANSFER LIST', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('239', 'INVENTORY', 'v1inventorytransferGET', 'ims', 'ALL', 'v1/inventory/transfer/.*', 'GET', 'application/json', 'GET ALL TRANSFER LIST', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('240', 'INVENTORY', 'v1productsinventoriesboxesPOST', 'ims', 'ALL', 'v1/products/.*/inventories/boxes', 'POST', 'application/json', 'list inventories', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('241', 'INVENTORY', 'v1boxGET', 'ims', 'ALL', 'v1/box/.*', 'GET', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('242', 'INVENTORY', 'v1inventorycountallGET', 'ims', 'ALL', 'v1/inventory-count-all', 'GET', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('243', 'INVENTORY', 'v1boxGET', 'ims', 'ALL', 'v1/box', 'GET', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('244', 'INVENTORY', 'v1inventoryimportGET', 'ims', 'ALL', 'v1/inventory/import.*', 'GET', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('245', 'INVENTORY', 'v1inventoryserialGET', 'ims', 'ALL', 'v1/inventory/serial/.*', 'GET', 'application/json', 'search inventory by serial no', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('246', 'INVENTORY', 'v1inventorycountallGET', 'ims', 'ALL', 'v1/inventory-count-all/.*', 'GET', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('247', 'INVENTORY', 'v1productsinventorycreateboxPOST', 'ims', 'ALL', 'v1/products/.*/inventory/create-box', 'POST', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('248', 'INVENTORY', 'v1productsinventoryserialnoGET', 'ims', 'ALL', 'v1/products/.*/inventory/serialno/.*', 'GET', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('249', 'INVENTORY', 'v1inventoryupdatePATCH', 'ims', 'ALL', 'v1/inventory/update/', 'PATCH', 'application/json', 'Update inventory items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('250', 'INVENTORY', 'MANUAL_ADJUSTMENT', 'ims', 'ALL', '', '', '', 'manual adjustment', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('251', 'INVENTORY', 'v1bulkimportPOST', 'ims', 'ALL', 'v1/bulk-import', 'POST', 'application/json', '', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('252', 'INVENTORY', 'SPLIT_BOX', 'ims', 'ALL', '', '', '', 'split inventory box', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('253', 'INVENTORY', 'INVENTORIES', 'ims', 'ALL', '', '', '', 'view', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('254', 'INVENTORY', 'v1inventorycountPOST', 'ims', 'ALL', 'v1/inventory-count', 'POST', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('255', 'INVENTORY', 'IMPORT', 'ims', 'ALL', '', '', '', 'import', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('256', 'INVENTORY', 'CREATE_IMPORT', 'ims', 'ALL', '', '', '', 'create import', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('257', 'INVENTORY', 'IMPORT_LIST', 'ims', 'ALL', '', '', '', 'import list', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('258', 'INVENTORY', 'UPDATE_INVENTORY', 'ims', 'ALL', '', '', '', 'update inventory', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('259', 'INVENTORY', 'BOXES_INVENTORY', 'ims', 'ALL', '', '', '', 'boxes inventory', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('260', 'INVENTORY', 'PRODUCT_INVENTORY', 'ims', 'ALL', '', '', '', 'product inventory', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('261', 'INVENTORY', 'v1productsinventoriesboxesexportPOST', 'ims', 'ALL', 'v1/products/.*/inventories/boxes/export', 'POST', 'application/json', 'Export inventory', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('262', 'INVENTORY', '', 'ims', 'ALL', 'v1/external/bulk-update', 'PUT', 'application/json', 'Bulk External update', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('263', 'INVENTORY', '', 'ims', 'ALL', 'v1/external/inventory.*', 'GET', 'application/json', 'list External inventory\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('264', 'IPRS', NULL, 'iprs', 'ALL', 'iprs-complete-check', 'POST', 'application/json', NULL, '2021-02-14 12:28:21', '2099-02-14 12:28:21', '0'),
	('265', 'KYC', 'EDIT_KYC_RECORD', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('266', 'KYC', 'EDIT_KYC_RECORD_IN_APPROVAL_VIEW', 'kyc', 'ALL', '', '', '', 'Edit KYC in APPROVE ', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('267', 'KYC', '', 'kyc', 'ALL', 'v2/kyc/history', 'GET', 'application/json', 'This is an API call to fetch history records of KYC', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('268', 'KYC', '', 'kyc', 'ALL', 'v2/kyc/history.*', 'GET', 'application/json', 'This is an API call to fetch history records of KYC', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('269', 'KYC', '', 'kyc', 'ALL', 'v2/kyc/documents', 'GET', 'application/json', 'This is an API call to fetch a kyc document by document id', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('270', 'KYC', '', 'kyc', 'ALL', 'v2/kyc/documents.*', 'GET', 'application/json', 'This is an API call to fetch a kyc document by document id', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('271', 'KYC', 'v2kycPOST', 'kyc', 'ALL', 'v2/kyc', 'POST', 'application/json', 'This is a sample call to showcase v2/addKYC', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('272', 'KYC', 'v2kycPUT', 'kyc', 'ALL', 'v2/kyc', 'PUT', 'application/json', 'This is a sample call to showcase v2/updateKYC', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('273', 'KYC', 'v2kycGET', 'kyc', 'ALL', 'v2/kyc', 'GET', 'application/json', 'v2 search KYC call', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('274', 'KYC', 'v2kycpendingGET', 'kyc', 'ALL', 'v2/kyc/pending', 'GET', 'application/json', 'This is a sample call to showcase v2/onlineKYCSync', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('275', 'KYC', 'v2kycapprovePOST', 'kyc', 'ALL', 'v2/kyc/approve', 'POST', 'application/json', 'This is a sample call to showcase v2/approveKYC', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('276', 'KYC', 'v2kycrejectPOST', 'kyc', 'ALL', 'v2/kyc/reject', 'POST', 'application/json', 'This is a sample call to showcase v2/rejectKYC', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('277', 'KYC', 'v2kycofflinePOST', 'kyc', 'ALL', 'v2/kyc/offline', 'POST', 'application/json', 'This is a sample call to showcase v2/offlineKYC', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('278', 'KYC', 'v2kyconlinesyncPOST', 'kyc', 'ALL', 'v2/kyc/onlinesync', 'POST', 'application/json', 'This is a sample call to showcase v2/onlineKYCSync', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('279', 'KYC', 'v2kyctunisiaverifyPOST', 'kyc', 'ALL', 'v2/kyc/tunisia/verify', 'POST', 'application/json', 'This is a sample call to showcase v2/verifyIdentity', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('280', 'KYC', 'REGISTER', 'kyc', 'ALL', '', '', '', 'register', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('281', 'KYC', 'SEARCH', 'kyc', 'ALL', '', '', '', 'search', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('282', 'KYC', 'APPROVE', 'kyc', 'ALL', '', '', '', 'approve', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('283', 'KYC', 'SEARCH_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('284', 'KYC', 'APPROVE_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('285', 'KYC', 'REGISTER_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('286', 'KYC', 'VIEW_PENDING_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('287', 'KYC', 'EDIT_PENDING_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('288', 'KYC', 'VIEW_APPROVED_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('289', 'KYC', 'EDIT_APPROVED_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('290', 'KYC', 'EDIT_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('291', 'KYC', 'VIEW_KYC', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('292', 'KYC', 'APPROVE_KYC_RECORD', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('293', 'KYC', 'REJECT_KYC_RECORD', 'kyc', 'ALL', '', '', '', '', '2021-02-12 11:11:11', '2099-01-01 11:11:11', '0'),
	('294', 'LIVEMAP', NULL, 'location-service', 'ALL', 'location', 'GET', 'application/json', '', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('295', 'LIVEMAP', 'DASHBOARD', 'location-service', 'ALL', 'entity/types', 'GET', 'application/json', 'This is sample', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('296', 'LOGISTICS', 'VIEW_TRIPS', 'billing', 'ALL', 'v1/trip', 'GET', 'application/json', 'API to get trip info from billing and settlement', '2022-01-04 16:38:04', '2049-01-04 16:38:04', '0'),
	('297', 'LOGISTICS', 'VIEW_INVOICES', 'billing', 'ALL', 'v1/invoice', 'GET', 'application/json', 'API to get all invoices from billing and settlement', '2022-01-04 17:48:33', '2099-01-04 17:19:26', '0'),
	('298', 'LOGISTICS', NULL, 'billing', 'ALL', 'v1/invoice', 'PUT', 'application/json', 'API to modify the invoices in billing and settlement', '2022-01-04 17:50:21', '2099-01-04 17:21:12', '0'),
	('299', 'LOGISTICS', 'VIEW_INVOICE_BY_ID', 'billing', 'ALL', 'v1/invoice/.*', 'GET', 'application/json', 'API to get invoice details from billing and settlement', '2022-01-04 17:24:08', '2099-01-04 17:53:11', '0'),
	('300', 'LOGISTICS', 'REQUEST_INVOICE', 'billing', 'ALL', 'v1/requestInvoice', 'GET', 'application/json', 'API to request invoice from billing and settlement ', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('301', 'LOGISTICS', 'VIEW_TRIPS', 'billing', 'ALL', 'v1/tripData', 'GET', 'application/json', 'API to get trip data by status', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('302', 'LOGISTICS', 'BILLING', 'billing', 'ALL', '', '', '', '', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('303', 'LOGISTICS', 'SETTLEMENT', 'billing', 'ALL', '', '', '', '', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('304', 'NOTIFICATION', 'MESSAGE', 'nms', 'ALL', 'api/messages.*', 'GET', 'application/json', 'Get messages', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('305', 'NOTIFICATION', 'GET_STATUS', 'nms', 'ALL', 'api/status', 'GET', 'application/json', 'Get the status', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('306', 'NOTIFICATION', 'GET_RECIPIENT', 'nms', 'ALL', 'api/recipients', 'GET', 'application/json', 'Get the recipient', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('307', 'NOTIFICATION', 'GET_MESSAGESTYPE', 'nms', 'ALL', 'api/messageTypes', 'GET', 'application/json', 'Get message types', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('308', 'NOTIFICATION', 'GET_LANGUAGES', 'nms', 'ALL', 'api/languages', 'GET', 'application/json', 'Get all the languages', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('309', 'NOTIFICATION', 'CREATE_MESSAGE', 'nms', 'ALL', 'api/classifiers/.*/messages', 'POST', 'application/json', 'Create a message', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('310', 'NOTIFICATION', 'DELETE_MESSAGE', 'nms', 'ALL', 'api/messages/.*', 'DELETE', 'application/json', 'Delete an existing message', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('311', 'NOTIFICATION', 'EDIT_MESSAGE', 'nms', 'ALL', 'api/messages/.*', 'PUT', 'application/json', 'Edit an existing message', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('312', 'NOTIFICATION', 'VIEW_MESSAGE', 'nms', 'ALL', 'api/messages/.*', 'GET', 'application/json', 'View the message', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('313', 'NOTIFICATION', 'GET_CATEGORY', 'nms', 'ALL', 'api/search/categories.*', 'GET', 'application/json', 'Get an existing category', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('314', 'NOTIFICATION', 'Create_Keyword', 'nms', 'ALL', 'api/categories/.*/keywords', 'POST', 'application/json', 'Create keywords', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('315', 'NOTIFICATION', 'Edit_Keyword', 'nms', 'ALL', 'api/keywords/.*', 'PUT', 'application/json', 'Edit an existing keyword', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('316', 'NOTIFICATION', 'UTILITYMESSAGE', 'nms', 'ALL', '', '', 'application/json', '[UI] - Utility message', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('317', 'NOTIFICATION', 'ADHOC_BASED', 'nms', 'ALL', 'action/sendmessage', 'POST', 'application/json', 'Send a message (adhoc based)', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('318', 'NOTIFICATION', 'TRANSACTION_BASED', 'nms', 'ALL', 'action/send-txe-notification.*', 'POST', 'application/json', 'Send a txe-message (transaction based)', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('319', 'NOTIFICATION', '', 'nms', 'ALL', 'api/keywords.*', 'GET', 'application/json', 'Find all keywords', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('320', 'NOTIFICATION', '', 'nms', 'ALL', 'api/keywords.*', 'GET', 'application/json', 'Find all keywords', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('321', 'NOTIFICATION', '', 'nms', 'ALL', 'api/classifiers', 'GET', 'application/json', 'Find all classifiers', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('322', 'NOTIFICATION', '', 'nms', 'ALL', 'api/conditions.*', 'GET', 'application/json', 'Find all conditions', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('323', 'NOTIFICATION', 'CREATE_CONDITION', 'nms', 'ALL', 'api/conditions', 'POST', 'application/json', 'Create a condition', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('324', 'NOTIFICATION', 'EDIT_CONDITION', 'nms', 'ALL', 'api/conditions/.*', 'PUT', 'application/json', 'Edit an existing condition', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('325', 'NOTIFICATION', 'CONDITION_BY_ID', 'nms', 'ALL', 'api/conditions/.*', 'GET', 'application/json', 'Get a condition by id', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('326', 'NOTIFICATION', '', 'nms', 'ALL', 'api/classifiers.*', 'GET', 'application/json', 'Get a classifier', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('327', 'NOTIFICATION', '', 'nms', 'ALL', 'api/classifiers.*', 'PUT', 'application/json', 'Update an existing classifier', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('328', 'NOTIFICATION', '', 'nms', 'ALL', 'api/classifiers', 'POST', 'application/json', 'Create a classifier', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('329', 'NOTIFICATION', 'MESSAGE', 'nms', 'ALL', 'api/messageTemplateTypes', 'GET', 'application/json', 'Find all message types (paginated output)', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('330', 'NOTIFICATION', 'MESSAGE', 'nms', 'ALL', 'api/messageTemplateType/.*/messages', 'GET', 'application/json', 'Find messages by message template type', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('331', 'NOTIFICATION', 'MESSAGE', 'nms', 'ALL', 'api/messages/updateDeleteFlag', 'PUT', 'application/json', 'Enable/Disable the sms/email templates isDeletable flag ', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('332', 'NOTIFICATION', 'MESSAGE', 'nms', 'ALL', 'api/search/messagesByQueryCriteria', 'GET', 'application/json', 'Search messages by query criteria (paginated output)', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('333', 'NOTIFICATION', 'CREATE_MESSAGE', 'nms', 'ALL', '', '', 'application/json', '[UI] - Create a message', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('334', 'NOTIFICATION', 'DELETE_MESSAGE', 'nms', 'ALL', '', '', 'application/json', '[UI] - Delete a message', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('335', 'NOTIFICATION', 'CLONE_MESSAGE', 'nms', 'ALL', '', '', 'application/json', '[UI] - Clone a message', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('336', 'NOTIFICATION', 'VIEW_MESSAGE', 'nms', 'ALL', '', '', 'application/json', '[UI] - View a message', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('337', 'NOTIFICATION', 'EDIT_MESSAGE', 'nms', 'ALL', '', '', 'application/json', '[UI] - Edit a message', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('338', 'NOTIFICATION', 'MESSAGE', 'nms', 'ALL', '', '', 'application/json', '[UI] - Message', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('339', 'NOTIFICATION', 'CREATE_CLASSIFIER', 'nms', 'ALL', '', '', 'application/json', '[UI] - Create a classifier', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('340', 'NOTIFICATION', 'EDIT_CLASSIFIER', 'nms', 'ALL', '', '', 'application/json', '[UI] - Edit a classifier', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('341', 'NOTIFICATION', 'VIEW_CLASSIFIER', 'nms', 'ALL', '', '', 'application/json', '[UI] - View a classifier', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('342', 'NOTIFICATION', 'CLASSIFIER', 'nms', 'ALL', '', '', 'application/json', '[UI] - Classifier', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('343', 'NOTIFICATION', 'CREATE_CONDITION', 'nms', 'ALL', '', '', 'application/json', '[UI] - Create a condition', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('344', 'NOTIFICATION', 'EDIT_CONDITION', 'nms', 'ALL', '', '', 'application/json', '[UI] - Edit a condition', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('345', 'NOTIFICATION', 'VIEW_CONDITION', 'nms', 'ALL', '', '', 'application/json', '[UI] - View a condition', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('346', 'NOTIFICATION', 'CONDITION', 'nms', 'ALL', '', '', 'application/json', '[UI] - Condition', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('347', 'NOTIFICATION', 'CREATE_KEYWORD', 'nms', 'ALL', '', '', 'application/json', '[UI] - Create a keyword', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('348', 'NOTIFICATION', 'VIEW_KEYWORD', 'nms', 'ALL', '', '', 'application/json', '[UI] - View a keyword', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('349', 'NOTIFICATION', 'EDIT_KEYWORD', 'nms', 'ALL', '', '', 'application/json', '[UI] - Edit a keyword', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('350', 'NOTIFICATION', 'KEYWORD', 'nms', 'ALL', '', '', 'application/json', '[UI] - Keyword', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('351', 'NOTIFICATION', 'ADHOC_BASED', 'nms', 'ALL', '', '', 'application/json', '[UI] - Adhoc based', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('352', 'NOTIFICATION', 'TRANSACTION_BASED', 'nms', 'ALL', '', '', 'application/json', '[UI] - Transaction based', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('353', 'NOTIFICATION', 'UTILITY_MESSAGE', 'nms', 'ALL', '', '', 'application/json', '[UI] - Utility message', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('354', 'NOTIFICATION', '', 'notificationmanager', 'ALL', 'register-generic-notification', 'POST', 'application/json', 'Send a message (generic)', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('355', 'NOTIFICATION', '', 'notificationmanager', 'ALL', 'register', 'POST', 'application/json', 'Send a message (adhoc based)', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('356', 'Object Storage', 'v1uploadPOST', 'osm', 'ALL', 'v1/upload', 'POST', 'application/json', 'This is a sample call to showcase product', '2021-03-12 17:46:02', '2099-01-01 00:00:00', '0'),
	('357', 'Object Storage', 'v1uploadPOST', 'osm', 'ALL', 'v1/upload.*', 'POST', 'application/json', 'This is a sample call to showcase product', '2021-03-12 17:46:02', '2099-01-01 00:00:00', '0'),
	('358', 'Object Storage', 'v1resourceagentPOST', 'osm', 'ALL', 'v1/resource/agent', 'POST', 'application/json', 'This is a sample call to showcase product', '2021-03-12 17:46:02', '2099-01-01 00:00:00', '0'),
	('359', 'Object Storage', NULL, 'osm', 'ALL', 'v1/resource/.*', 'GET', 'application/json', 'This is a sample call to showcase product', '2021-03-12 17:46:02', '2099-01-01 00:00:00', '0'),
	('360', 'Object Storage', NULL, 'osm', 'ALL', 'v1/resource/.*/.*', 'GET', 'application/json', 'This is a sample call to showcase product', '2021-03-12 17:46:02', '2099-01-01 00:00:00', '0'),
	('361', 'Object Storage', 'viResourceInventory', 'osm', 'ALL', 'v1/resource/inventory', 'POST', 'application/json', 'This is a sample call to showcase product', '2021-03-12 17:46:02', '2099-01-01 00:00:00', '0'),
	('362', 'Object Storage', 'viResourceInventory', 'osm', 'ALL', 'v1/resource/inventory/.*', 'GET', 'application/json', 'This is a sample call to showcase product', '2021-03-12 17:46:02', '2099-01-01 00:00:00', '0'),
	('363', 'ORDER', 'v2invoiceconfirmpaymentPOST', 'oms', 'ALL', 'v2/invoice/.*/confirm-payment', 'POST', 'application/json', 'confirm payment', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('364', 'ORDER', '', 'oms', 'ALL', 'v2/order-payment-types', 'GET', 'application/json', 'get payment types', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('365', 'ORDER', 'v2ordersGET', 'oms', 'ALL', 'v2/orders', 'GET', 'application/json', 'API to get details of all orders.', '2021-02-15 14:08:50', '2099-02-15 14:08:50', '0'),
	('366', 'ORDER', 'v2ordersPOST', 'oms', 'ALL', 'v2/orders', 'POST', 'multipart/form-data', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('367', 'ORDER', 'v2ordersPATCH', 'oms', 'ALL', 'v2/orders/.*/.*', 'PATCH', 'application/json', 'API to update order action (CONFIRM/REJECT).', '2021-02-15 14:11:00', '2099-02-15 14:11:00', '0'),
	('368', 'ORDER', 'v2orderstypePATCH', 'oms', 'ALL', 'v2/orders/type/.*/.*', 'PATCH', 'application/json', 'API to update order status.', '2021-02-15 14:12:00', '2099-02-15 14:12:00', '0'),
	('369', 'ORDER', 'v2orderstypeinternalPATCH', 'oms', 'ALL', 'v2/orders/type/.*/internal/.*', 'PATCH', 'application/json', 'API for internal use to create internal orders out of primary order.', '2021-02-15 14:13:09', '2099-02-15 14:13:09', '0'),
	('370', 'ORDER', 'v2ordersGET', 'oms', 'ALL', 'v2/orders/.*', 'GET', 'application/json', 'API to get details of an order.', '2021-02-15 14:14:50', '2099-02-15 14:14:50', '0'),
	('371', 'ORDER', 'v2ordertypesGET', 'oms', 'ALL', 'v2/order-types', 'GET', 'application/json', 'API to fetch all order types.', '2021-02-15 14:15:19', '2099-02-15 14:15:19', '0'),
	('372', 'ORDER', 'v2ordersGET', 'oms', 'ALL', 'v2/orders', 'GET', 'application/json', 'This is sample', '2021-02-23 19:08:48', '2099-02-23 19:08:48', '0'),
	('373', 'ORDER', 'v2ordertypesGET', 'oms', 'ALL', 'v2/order-types', 'GET', 'application/json', 'This is sample', '2021-02-26 18:12:03', '2099-02-26 18:12:03', '0'),
	('374', 'ORDER', 'v1uploadPOST', 'osm', 'ALL', 'v1/upload', 'POST', 'application/json', 'GET ALL TRANSFER LIST', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('375', 'ORDER', 'v2orderreasonsGET', 'oms', 'ALL', 'v2/order-reasons', 'GET', 'application/json', 'reject reasons', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('376', 'ORDER', 'v2ordertypesGET', 'oms', 'ALL', 'v2/order-types', 'GET', 'application/json', 'order types', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('377', 'ORDER', 'v1ordersPOST', 'oms', 'ALL', 'v1/orders', 'POST', 'multipart/form-data', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('378', 'ORDER', 'v2ordersinvoicesPOST', 'oms', 'ALL', 'v2/orders/invoices', 'POST', 'application/json', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('379', 'ORDER', 'v2ordersPOST', 'oms', 'ALL', 'v2/orders', 'POST', 'application/json', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('380', 'ORDER', 'ORDERS', 'oms', 'ALL', '', '', '', 'fetch order', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('381', 'ORDER', 'RAISE_ORDER', 'oms', 'ALL', '', '', '', 'raise order', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('382', 'ORDER', 'VIEW_ORDER', 'oms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('383', 'ORDER', 'ORDER_LIST', 'oms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('384', 'ORDER', 'STOCK TRANSFER', 'oms', 'ALL', '', '', '', 'stock transfer', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('385', 'ORDER', 'RETURN', 'oms', 'ALL', '', '', '', 'reversal', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('386', 'ORDER', 'REVERSAL', 'oms', 'ALL', '', '', '', 'reversal', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('387', 'ORDER', 'RAISEORDER', 'oms', 'ALL', '', '', '', 'raise order', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('388', 'ORDER', 'MANUALADJUSTMENT', 'oms', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('389', 'ORDER', 'MANUAL_ADJUSTMENT', 'oms', 'ALL', '', '', '', 'accounts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('390', 'ORDER', 'v2ordersinvoicesGET', 'oms', 'ALL', 'v2/orders/invoices', 'GET', 'application/json', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('391', 'ORDER', 'v2ordersinvoiceGET', 'oms', 'ALL', 'v2/orders/.*/invoice', 'GET', 'application/json', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('392', 'ORDER', NULL, 'oms', 'ALL', 'v2/order-product-quota-rules', 'GET', 'application/json', 'API to fetch of all order product quota rule.', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('393', 'ORDER', NULL, 'oms', 'ALL', 'v2/order-product-quota-rules', 'POST', 'multipart/form-data', 'API to create order product quota rule.', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('394', 'ORDER', NULL, 'oms', 'ALL', 'v2/order-product-quota-rules/.*', 'PATCH', 'application/json', 'API to update order product quota rule.', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('395', 'ORDER', NULL, 'oms', 'ALL', 'v2/order-product-quota-rules/.*', 'GET', 'application/json', 'API to fetch detail of order product quota rule.', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('396', 'ORDER', NULL, 'oms', 'ALL', 'v2/order-product-quota-rules/.*', 'DELETE', 'application/json', 'API to fetch detail of order product quota rule.', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('397', 'ORDER', NULL, 'oms', 'ALL', 'v2/settle-invoice', 'POST', 'application/json', 'API to create an settle an invoice', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('398', 'ORDER', 'v2/preorders', 'oms', 'ALL', 'v2/preorders', 'POST', 'application/json', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('399', 'ORDER', NULL, 'oms', 'ALL', 'v2/orders/.*/reverse', 'POST', 'application/json', '', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('400', 'ORDER', NULL, 'oms', 'ALL', 'v2/order/.*/returnableitems', 'GET', 'application/json', 'get returnable order item list', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('401', 'ORDER', NULL, 'oms', 'ALL', 'v2/payments/external/.*', 'GET', 'application/json', 'get external payment status', '2021-10-18 08:57:51', '2099-10-18 08:57:51', '0'),
	('402', 'ORDER', 'DUE_UNUSED_PAYMENTS', 'oms', 'ALL', 'v2/due-unused-payments', 'POST', 'application/json', 'get due unused payments', '2021-10-18 09:48:06', '2099-10-18 09:48:06', '0'),
	('403', 'ORDER', 'SETTLE INVOICE', 'oms', 'ALL', '', '', '', 'settle existing payments with pending invoices', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('404', 'ORDER', 'SETTLEINVOICE', 'oms', 'ALL', '', '', '', 'settle existing payments with pending invoices', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('405', 'ORDER', 'SETTLE_INVOICE', 'oms', 'ALL', '', '', '', 'settle existing payments with pending invoices', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('406', 'ORDER', 'SETTEL_INVOICE_BUTTON', 'oms', 'ALL', '', '', '', 'For Settle Invoice Button', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('407', 'ORDER', NULL, 'oms', 'ALL', 'v2/orders/rescheduleDeliveryOrder', 'PUT', 'application/json', 'API for creation of new deliver order for some existing order against lost or stolen items', '2021-02-15 14:13:09', '2099-02-15 14:13:09', '0'),
	('408', 'ORDER', 'RESCHEDULE_DELIVERY', 'oms', 'ALL', '', '', '', 'RESCHEDULE_DELIVERY', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('409', 'ORDER', 'RESCHEDULE DELIVERY', 'oms', 'ALL', '', '', '', 'RESCHEDULE_DELIVERY', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('410', 'ORDER', 'RESCHEDULEDELIVERY', 'oms', 'ALL', '', '', '', 'RESCHEDULE_DELIVERY', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('411', 'ORDER', '', 'oms', 'ALL', 'v2/orders/getInternalOrderView', 'PUT', 'application/json', 'Delivery', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('412', 'ORDER', '', 'oms', 'ALL', 'v2/sfc/fetch-dealer-balance', 'POST', 'application/json', 'Calling dealer balance', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('413', 'ORDER', 'PRODUCTQUOTA', 'oms', 'ALL', '', '', '', 'fetch order product quota rules', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('414', 'ORDER', 'PRODUCT QUOTA', 'oms', 'ALL', '', '', '', 'fetch order product quota rules', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('415', 'ORDER', 'PRODUCT_QUOTA', 'oms', 'ALL', '', '', '', 'fetch order product quota rules', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('416', 'ORDER', 'CREATE_PRODUCT_QUOTA', 'oms', 'ALL', '', '', '', 'create order product quota rule', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('417', 'ORDER', 'EDIT_PRODUCT_QUOTA', 'oms', 'ALL', '', '', '', 'edit order product quota rule', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('418', 'ORDER', 'VIEW_PRODUCT_QUOTA', 'oms', 'ALL', '', '', '', 'view order product quota rule', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('419', 'ORDER', 'DELETE_PRODUCT_QUOTA', 'oms', 'ALL', '', '', '', 'delete order product quota rule', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('420', 'ORDER', 'CREATEBARCODE', 'oms', 'ALL', '', '', '', 'Create Barcode Menu option', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('421', 'ORDER', 'SCAN_BOX', 'oms', 'ALL', '', '', '', 'Scan Box Barcode functionality\n', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('422', 'ORDER', 'v2ordersGET', 'oms', 'ALL', 'v2/order-states', 'GET', 'application/json', 'API to get details of all orders.', '2021-02-15 14:08:50', '2099-02-15 14:08:50', '0'),
	('423', 'PORTAL', 'PROFILE_MENU', 'portal', 'ALL', '', '', '', 'profileview ', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('424', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/filter', 'POST', 'application/json', 'API to add supplier', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('425', 'PRODUCT', '', 'pms', 'ALL', 'v1/productCategory/inventory-count', 'POST', 'application/json', 'API to add supplier', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('426', 'PRODUCT', 'VIEWCATEGORIES', 'pms', 'ALL', '', '', '', 'categories', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('427', 'PRODUCT', 'VIEWPRODUCTS', 'pms', 'ALL', '', '', '', 'products', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('428', 'PRODUCT', 'VIEW_PRODUCT', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('429', 'PRODUCT', 'CREATE_PRODUCT', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('430', 'PRODUCT', 'PRODUCT_LIST', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('431', 'PRODUCT', 'EDIT_PRODUCT', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('432', 'PRODUCT', 'VIEW_PRODUCT_VARIANT', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('433', 'PRODUCT', 'CREATE_PRODUCT_VARIANT', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('434', 'PRODUCT', 'PRODUCT_VARIANT_LIST', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('435', 'PRODUCT', 'EDIT_PRODUCT_VARIANT', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('436', 'PRODUCT', 'VIEW_PRODUCT_CATEGORY', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('437', 'PRODUCT', 'CREATE_PRODUCT_CATEGORY', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('438', 'PRODUCT', 'PRODUCT_CATEGORY_LIST', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('439', 'PRODUCT', 'EDIT_PRODUCT_CATEGORY', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('440', 'PRODUCT', '', 'pms', 'ALL', 'v1/product', 'POST', 'application/json', 'API to create a product', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('441', 'PRODUCT', '', 'pms', 'ALL', 'v1/product', 'PUT', 'application/json', 'API to update a product', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('442', 'PRODUCT', '', 'pms', 'ALL', 'v1/product', 'GET', 'application/json', 'API to get all products', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('443', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/.*', 'GET', 'application/json', 'API to get a single product', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('444', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/.*', 'DELETE', 'application/json', 'API to delete a product', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('445', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/search', 'POST', 'application/json', 'API to search a product by a list of SKUs', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('446', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/sku/.*', 'GET', 'application/json', 'API to get a product by sku', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('447', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/.*/variant', 'POST', 'application/json', 'API to create a product variant', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('448', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/.*/variant', 'PUT', 'application/json', 'API to update a product variant', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('449', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/.*/variant', 'GET', 'application/json', 'API to return all product variants given a product', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('450', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/.*/variant/.*', 'DELETE', 'application/json', 'API to delete a product variant by id', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('451', 'PRODUCT', '', 'pms', 'ALL', 'v1/productCategory', 'POST', 'application/json', 'API to create a product category', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('452', 'PRODUCT', '', 'pms', 'ALL', 'v1/productCategory', 'PUT', 'application/json', 'API to update a product category', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('453', 'PRODUCT', '', 'pms', 'ALL', 'v1/productCategory', 'GET', 'application/json', 'API to get all product categories', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('454', 'PRODUCT', '', 'pms', 'ALL', 'v1/productCategory/.*', 'DELETE', 'application/json', 'API to delete a product category', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('455', 'PRODUCT', '', 'pms', 'ALL', 'v1/productCategory/.*', 'GET', 'application/json', 'API to get a product category by id', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('456', 'PRODUCT', '', 'pms', 'ALL', 'v1/tax', 'POST', 'application/json', 'API to create a new tax', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('457', 'PRODUCT', '', 'pms', 'ALL', 'v1/tax', 'PUT', 'application/json', 'API to update an existing tax', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('458', 'PRODUCT', '', 'pms', 'ALL', 'v1/tax', 'GET', 'application/json', 'API to get all taxes', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('459', 'PRODUCT', '', 'pms', 'ALL', 'v1/tax/.*', 'DELETE', 'application/json', 'API to delete a tax by id', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('460', 'PRODUCT', '', 'pms', 'ALL', 'v1/tax/.*', 'GET', 'application/json', 'API to get a tax by id', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('461', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow', 'POST', 'application/json', 'API to create a workflow', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('462', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow', 'PUT', 'application/json', 'API to update a workflow', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('463', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow', 'GET', 'application/json', 'API to get all workflows', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('464', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/.*', 'GET', 'application/json', 'API to get a workflow by id', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('465', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/.*', 'DELETE', 'application/json', 'API to delete a workflow by id', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('466', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/search', 'POST', 'application/json', 'API to search workflows', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('467', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/state', 'POST', 'application/json', 'API to create a new workflow state', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('468', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/state', 'GET', 'application/json', 'API to fetch all workflow states', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('469', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/state/.*', 'PUT', 'application/json', 'API to update a workflow state', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('470', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/operation', 'POST', 'application/json', 'API to create a new workflow operation', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('471', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/operation/.*', 'PUT', 'application/json', 'API to update a workflow operation', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('472', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/operation/.*', 'DELETE', 'application/json', 'API to delete a new workflow operation', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('473', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/transition', 'POST', 'application/json', 'API to create a new workflow state transition', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('474', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/transition', 'GET', 'application/json', 'API to get all workflow state transitions', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('475', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/transition/.*', 'PUT', 'application/json', 'API to update a workflow state transition', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('476', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/transition/.*', 'DELETE', 'application/json', 'API to delete a workflow transition', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('477', 'PRODUCT', '', 'pms', 'ALL', 'v1/workflow/transition/.*', 'GET', 'application/json', 'API to get a workflow transition by id', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('478', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/variant/.*', 'POST', 'application/json', 'API to create a product variant', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('479', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/code/.*', 'GET', 'application/json', 'Get a product by code', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('480', 'PRODUCT', '', 'pms', 'ALL', 'v1/relatedProduct/.*', 'GET', 'application/json', 'Get related products', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('481', 'PRODUCT', '', 'pms', 'ALL', 'v1/relatedProduct/.*', 'POST', 'application/json', 'Add related products', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('482', 'PRODUCT', '', 'pms', 'ALL', 'v1/supplier', 'GET', 'application/json', 'API to fetch all suppliers', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('483', 'PRODUCT', '', 'pms', 'ALL', 'v1/supplier', 'POST', 'application/json', 'API to add supplier', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('484', 'PRODUCT', '', 'pms', 'ALL', 'v1/supplier', 'PUT', 'application/json', 'API to update supplier', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('485', 'PRODUCT', '', 'pms', 'ALL', 'v1/supplier/.*', 'GET', 'application/json', 'API to fetch specified supplier', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('486', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/variant/inventory-count/export', 'POST', 'application/json', 'export product variants', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('487', 'PRODUCT', '', 'pms', 'ALL', 'v1/product/variant/inventory-count', 'POST', 'application/json', 'fetch product variants', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('488', 'PRODUCT', '', 'pms', 'ALL', 'v1/relatedProduct/.*', 'POST', 'application/json', 'Add related products', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('489', 'PRODUCT', '', 'pms', 'ALL', 'v1/supplier', 'GET', 'application/json', 'API to fetch all suppliers', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('490', 'PRODUCT', '', 'pms', 'ALL', 'v1/supplier', 'POST', 'application/json', 'API to add supplier', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('491', 'PRODUCT', '', 'pms', 'ALL', 'v1/supplier', 'PUT', 'application/json', 'API to update supplier', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('492', 'PRODUCT', 'ADD_UNIT_PRODUCT', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('493', 'PRODUCT', '', 'pms', 'ALL', 'v1/supplier/.*', 'GET', 'application/json', 'API to fetch specified supplier', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('494', 'PRODUCT', 'DELETE_PRODUCT', 'pms', 'ALL', '', '', '', 'ACL rule for delete product', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('495', 'PRODUCT', 'DELETE_PRODUCT_VARIANT', 'pms', 'ALL', '', '', '', 'ACL rule for delete product variant', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('496', 'PRODUCT', 'DELETE_PRODUCT_CATEGORY', 'pms', 'ALL', '', '', '', 'ACL rule for delete product category', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('497', 'PRODUCT', 'VIEW_TAXES', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('498', 'PRODUCT', 'VIEW_TAX', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('499', 'PRODUCT', 'CREATE_TAX', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('500', 'PRODUCT', 'EDIT_TAX', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('501', 'PRODUCT', 'VIEWTAXES', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('502', 'PRODUCT', 'DELETE_TAX', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('503', 'PRODUCT', NULL, 'pms', 'ALL', 'v1/productVariant.*', 'POST', 'application/json', 'get all product variants', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('504', 'PRODUCT', NULL, 'pms', 'ALL', 'v1/productCategory/search', 'POST', 'application/json', 'get categories/sub-categories by level and ancestor id if provided', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('505', 'PRODUCT', '', 'pms', 'ALL', 'v1/products', 'PUT', 'application/json', 'API to update a products in bulk', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('506', 'PRODUCT', '', 'pms', 'ALL', 'v1/productCategoryChildren', 'GET', 'application/json', 'API to get the immediate children of a given product category', '2021-02-25 12:26:20', '2099-01-01 00:00:00', '0'),
	('507', 'REGION', 'REGION_VIEW', 'rgms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('508', 'REGION', 'REGION_TYPE_VIEW', 'rgms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('509', 'REGION', 'REGION_TYPE_UPDATE', 'rgms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('510', 'REGION', 'REGION_TYPE_LIST', 'rgms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('511', 'REGION', 'REGION_TYPE_CREATE', 'rgms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('512', 'REGION', 'REGION_TYPES', 'rgms', 'ALL', 'v2/region-type.*', 'GET', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('513', 'REGION', 'REGION_TYPES', 'rgms', 'ALL', 'v2/region-type.*', 'POST', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('514', 'REGION', 'REGION_TYPES', 'rgms', 'ALL', 'v2/region-type.*', 'PUT', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('515', 'REGION', 'REGION_TYPES', 'rgms', 'ALL', 'v2/region-type.*', 'DELETE', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('516', 'REGION', 'REGION_LIST', 'rgms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('517', 'REGION', 'REGION_CREATE', 'rgms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('518', 'REGION', 'REGIONTYPES', 'rgms', 'ALL', '', ' ', ' ', ' ', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('519', 'REGION', 'REGIONS', 'rgms', 'ALL', 'v2/region.*', 'POST', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('520', 'REGION', 'REGIONS', 'rgms', 'ALL', 'v2/region.*', 'PUT', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('521', 'REGION', 'GET REGION', 'rgms', 'ALL', 'v2/region/.*', 'GET', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('522', 'REGION', 'CREATE REGION', 'rgms', 'ALL', 'v2/region/', 'POST', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('523', 'REGION', 'VIEW ALL CATEGORY', 'rgms', 'ALL', 'v2/region-category.*', 'GET', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('524', 'REGION', 'GET REGIONS', 'rgms', 'ALL', 'v2/region.*', 'GET', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('525', 'REGION', 'REGION_UPDATE', 'rgms', 'ALL', 'v2/region/.*', 'PUT', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('526', 'REGION', 'REGION_TYPES', 'rgms', 'ALL', 'v2/region-type', 'GET', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('527', 'REPORT', 'DOWNLOAD_REPORT', 'bi', 'ALL', '', '', '', 'reports', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('528', 'REPORT', 'API_V1-METADATA_GET', 'bi-engine', 'ALL', 'downloadPDF', 'POST', 'application/json', 'POST API call to download report in PDF', '2021-03-01 17:06:20', '2029-03-02 17:06:20', '0'),
	('529', 'REPORT', 'API_V1-METADATA_GET', 'bi-engine', 'ALL', 'downloadXLS', 'POST', 'application/json', 'POST API call to download report in XLS', '2021-03-01 17:06:20', '2029-03-02 17:06:20', '0'),
	('530', 'REPORT', 'REPORT', 'bi', 'ALL', '', '', '', 'reports', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('531', 'REPORT', 'AUDIT', 'bi', 'ALL', '', '', '', 'reports', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('532', 'REPORT', 'SEARCH', 'bi', 'ALL', '', '', '', 'reports', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('533', 'REPORT', 'EXTRA', 'bi', 'ALL', '', '', '', 'reports', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('534', 'REPORT', '', 'biengine', 'ALL', 'metadataWithToken', 'GET', 'application/json', 'GET API call for metadata with token', '2021-02-23 14:11:00', '2099-02-24 14:11:00', '0'),
	('535', 'REPORT', '', 'bi-engine', 'ALL', 'metadataWithToken', 'GET', 'application/json', 'GET API call for metadata with token', '2021-02-23 14:11:00', '2099-02-24 14:11:00', '0'),
	('536', 'REPORT', '', 'bi-engine', 'ALL', 'fetch', 'POST', 'application/json', 'POST API call to fetch report data', '2021-03-01 17:06:20', '2099-03-02 17:06:20', '0'),
	('537', 'REPORT', '', 'bi-engine', 'ALL', 'v1/metadata/.*', 'GET', 'application/json', 'GET API call to get metadata with filter (V1)', '2021-03-01 17:06:20', '2099-03-02 17:06:20', '0'),
	('538', 'REPORT', '', 'bi-engine', 'ALL', 'v1/metadata', 'GET', 'application/json', 'GET API call to get metadata (V1)', '2021-03-01 17:06:20', '2099-03-02 17:06:20', '0'),
	('539', 'REPORT', 'API_LOGINDASHBOARD_GET', 'bi-engine', 'ALL', 'loginDashboard', 'GET', 'application/json', 'GET API call for login dashboard', '2021-02-23 14:11:00', '2099-02-24 14:11:00', '0'),
	('540', 'REPORT', NULL, 'bi-engine', 'ALL', 'metadata.*', 'GET', 'application/json', 'GET API call to get metadata with filter', '2021-03-01 17:06:20', '2029-03-02 17:06:20', '0'),
	('541', 'REPORT', 'API_V1-METADATA_GET', 'bi-engine', 'ALL', 'downloadCSV', 'POST', 'application/json', 'POST API call to download report in CSV', '2021-03-01 17:06:20', '2029-03-02 17:06:20', '0'),
	('542', 'RESELLER', 'CREATE_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('543', 'RESELLER', 'ADVANCED_SEARCH_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('544', 'RESELLER', 'RESET_PASSWORD', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('545', 'RESELLER', 'EXPIRED_PASSWORD', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('546', 'RESELLER', 'forgetPassword', 'dms', 'ALL', 'auth/forgetPassword', 'POST', 'application/json', 'POST API call for forget password', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('547', 'RESELLER', NULL, 'dms', 'ALL', 'auth/getResellerBasicInfo', 'POST', 'application/json', 'POST API call to get reseller basic info', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('548', 'RESELLER', NULL, 'dms', 'ALL', 'v1/template/dropdown', 'POST', 'application/json', 'POST API call to add dropdown template (V1)', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('549', 'RESELLER', NULL, 'dms', 'ALL', 'v1/template/dropdown/.*', 'GET', 'application/json', 'GET API call to fetch dropdown template (V1)', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('550', 'RESELLER', 'RESET_WRONG_PASSWORD_ATTEMPTS', 'dms', 'ALL', '', '', '', 'resetWrongPasswordAttempts', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('551', 'RESELLER', 'RESELLER_WALLET_CARD', 'dms', 'ALL', '', '', '', 'ACL rule for advance search', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('552', 'RESELLER', NULL, 'dms', 'ALL', 'v1/resellers/updatePayLimit', 'PUT', 'application/json', 'PUT API call to update pay limit', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('553', 'RESELLER', 'UPDATE_PAY_LIMIT', 'dms', NULL, '', '', '', 'updatePayLimit', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('554', 'RESELLER', NULL, 'dms', 'ALL', 'auth/searchResellerBasicInfoByAttribute', 'POST', 'application/json', 'POST API call to search reseller basic info by attribute', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('555', 'RESELLER', NULL, 'dms', 'ALL', 'v1/resellers/types/all', 'GET', 'application/json', 'GET API call to fetch all reseller types (V1)', '2021-02-22 17:28:41', '2099-02-23 17:28:41', '0'),
	('556', 'RESELLER', 'v1passwordpoliciesGET', 'dms', 'ALL', 'v1/password/policies', 'GET', 'application/json', 'GET API call to fetch password policies (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('557', 'RESELLER', NULL, 'dms', 'ALL', 'v1/resellers', 'POST', 'application/json', 'POST API call to add reseller data (V1)', '2021-02-26 18:16:37', '2099-02-26 18:16:37', '0'),
	('558', 'RESELLER', 'v1resellersresellerDataGET', 'dms', 'ALL', 'v1/resellers/.*/resellerData', 'GET', 'application/json', 'GET API call to fetch reseller data (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('559', 'RESELLER', 'v1resellerstypescreatePOST', 'dms', 'ALL', 'v1/resellers/types/create', 'POST', 'application/json', 'POST API call to create reseller type (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('560', 'RESELLER', 'v1resellerstypesupdatePUT', 'dms', 'ALL', 'v1/resellers/types/update', 'PUT', 'application/json', 'PUT API call to update reseller type (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('561', 'RESELLER', NULL, 'dms', 'ALL', 'v1/resellers/.*/types', 'GET', 'application/json', 'GET API call to get reseller type (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('562', 'RESELLER', NULL, 'dms', 'ALL', 'v1/resellers/.*/types/.*', 'GET', 'application/json', 'GET API call to get reseller type with filter (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('563', 'RESELLER', 'v1passwordpoliciesPOST', 'dms', 'ALL', 'v1/password/policies', 'POST', 'application/json', 'POST API call to add password policy (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('564', 'RESELLER', 'v1passwordpoliciesGET', 'dms', 'ALL', 'v1/password/policies/.*', 'GET', 'application/json', 'GET API call to get password policy (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('565', 'RESELLER', 'v1passwordpoliciesPUT', 'dms', 'ALL', 'v1/password/policies/.*', 'PUT', 'application/json', 'PUT API call to update password policy (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('566', 'RESELLER', 'v1passwordpoliciesDELETE', 'dms', 'ALL', 'v1/password/policies/.*', 'DELETE', 'application/json', 'DELETE API call to remove password policy (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('567', 'RESELLER', NULL, 'dms', 'ALL', 'v1/resellers/types/.*', 'GET', 'application/json', 'GET API call to fetch reseller types (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('568', 'RESELLER', 'CHANGE_RESELLER_PASSWORD', 'dms', 'ALL', 'v2/auth/changePassword', 'POST', 'application/json', 'POST API call to update resellers password', '2021-02-26 18:16:37', '2099-02-26 18:16:37', '0'),
	('569', 'RESELLER', NULL, 'dms', 'ALL', 'v1/resellers/resellerChildren/.*', 'GET', 'application/json', 'GET API call to get reseller children (V1)', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('570', 'RESELLER', '', 'dms', 'ALL', 'v1/resellers', 'GET', 'application/json', 'GET API call to fetch resellers (V1)', '2021-02-26 18:16:37', '2099-02-26 18:16:37', '0'),
	('571', 'RESELLER', '', 'dms', 'ALL', 'auth/userAlreadyExists', 'POST', 'application/json', 'POST API call to check user already exists', '2021-02-26 18:16:37', '2099-02-26 18:16:37', '0'),
	('572', 'RESELLER', 'v1rolesGET', 'dms', 'ALL', 'v1/roles/', 'GET', 'application/json', 'GET API call to get reseller roles (V1)', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('573', 'RESELLER', '', 'dms', 'ALL', 'v1/template/dropdown.*', 'GET', '', 'GET API call to fetch dropdown template', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('574', 'RESELLER', 'v1rolesPOST', 'dms', 'ALL', 'v1/roles/.*', 'POST', 'application/json', 'POST API call to add reseller role (V1)', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('575', 'RESELLER', 'v1rolesPUT', 'dms', 'ALL', 'v1/roles/.*', 'PUT', 'application/json', 'PUT API call to update reseller role (V1)', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('576', 'RESELLER', '', 'dms', 'ALL', 'v1/template/dropdown.*', 'POST', '', 'POST API call to add dropdown template', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('577', 'RESELLER', 'v1rolesDELETE', 'dms', 'ALL', 'v1/roles/.*', 'DELETE', 'application/json', 'DELETE API call to reseller role (V1)', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('578', 'RESELLER', '', 'dms', 'ALL', 'v1/template/dropdown.*', 'DELETE', '', 'DELETE API call to remove dropdown template', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('579', 'RESELLER', 'RESELLER_GET_INFO', 'dms', 'ALL', 'auth/getResellerInfo', 'POST', 'application/json', 'POST API call to get reseller info', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('580', 'RESELLER', '', 'dms', 'ALL', 'v1/template/dropdown.*', 'PUT', '', 'PUT API call to update dropdown template', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('581', 'RESELLER', 'authv1resellerChangeStatePOST', 'dms', 'ALL', 'auth/v1/resellerChangeState', 'POST', 'application/json', 'POST API call to change reseller state', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('582', 'RESELLER', 'CREATE_RESELLER_TEMPLATE_DROPDOWN', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('583', 'RESELLER', 'authupdateResellerPOST', 'dms', 'ALL', 'auth/updateReseller', 'POST', 'application/json', 'POST API call to update reseller', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('584', 'RESELLER', 'VIEW_RESELLER_TEMPLATE_DROPDOWN', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('585', 'RESELLER', 'authchangeParentPOST', 'dms', 'ALL', 'auth/changeParent', 'POST', 'application/json', 'POST API call to change parent', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('586', 'RESELLER', 'EDIT_RESELLER_TEMPLATE_DROPDOWN', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('587', 'RESELLER', 'authaddResellerPOST', 'dms', 'ALL', 'auth/addReseller', 'POST', 'application/json', 'POST API call to add reseller', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('588', 'RESELLER', 'DELETE_RESELLER_TEMPLATE_DROPDOWN', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('589', 'RESELLER', 'v1dmsauthv1resellerChangeStatePOST', 'dms', 'ALL', 'v1/dms/auth/v1/resellerChangeState', 'POST', 'application/json', 'POST API call to change reseller state via DMS (V1)', '2021-02-26 18:16:37', '2099-02-26 18:16:37', '0'),
	('590', 'RESELLER', 'TEMPLATEDROPDOWNS', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('591', 'RESELLER', 'v1resellerstypesDELETE', 'dms', 'ALL', 'v1/resellers/types/.*', 'DELETE', 'application/json', 'DELETE API call to remove reseller type (V1)', '2021-02-26 18:16:37', '2099-02-26 18:16:37', '0'),
	('592', 'RESELLER', 'RESELLERDROPDOWNS', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('593', 'RESELLER', 'RESELLER_BY_ATTRIBUTE', 'dms', 'ALL', 'auth/searchResellersByAttribute', 'POST', 'application/json', 'POST API call to search resellers by attribute', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('594', 'RESELLER', 'v1resellerscreatePOST', 'dms', 'ALL', 'v1/resellers/create', 'POST', 'application/json', 'POST API call to create resellers', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('595', 'RESELLER', 'authfetchPickupLocationsPOST', 'dms', 'ALL', 'auth/fetchPickupLocations', 'POST', 'application/json', 'POST API call to fetch pickup locations', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('596', 'RESELLER', 'VIEW_HIERARCHY', 'dms', 'ALL', '', '', '', 'View hierarchy chart', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('597', 'RESELLER', 'RESELLERS', 'dms', 'ALL', '', '', '', 'view resellers', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('598', 'RESELLER', 'RESELLERHIERARCHY', 'dms', 'ALL', '', '', '', 'Reseller hierarchy menu option', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('599', 'RESELLER', 'RESELLERTYPES', 'dms', 'ALL', '', '', '', 'resellers types', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('600', 'RESELLER', 'UPDATE_RESELLER_USER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('601', 'RESELLER', 'RESELLERROLES', 'dms', 'ALL', '', '', '', 'reseller roles', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('602', 'RESELLER', '', 'dms', 'ALL', 'auth/updateResellerUsers', 'PUT', 'application/json', 'PUT API call to update reseller users', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('603', 'RESELLER', 'PASSWORDPOLICIES', 'dms', 'ALL', '', '', '', 'password policies', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('604', 'RESELLER', 'ADD_RESELLER_USER', 'dms', 'ALL', '', '', 'application/json', '', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('605', 'RESELLER', 'CREATE_RESELLER_TYPE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('606', 'RESELLER', '', 'dms', 'ALL', 'auth/addResellerUsers', 'POST', 'application/json', 'POST API call to add reseller users', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('607', 'RESELLER', 'EDIT_RESELLER_TYPE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('608', 'RESELLER', 'DELETE_RESELLER_USER', 'dms', 'ALL', '', '', 'application/json', '', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('609', 'RESELLER', 'VIEW_RESELLER_TYPE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('610', 'RESELLER', '', 'dms', 'ALL', 'auth/deleteResellerUsers', 'DELETE', 'application/json', 'DELETE API call to remove reseller users', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('611', 'RESELLER', 'DELETE_RESELLER_TYPE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('612', 'RESELLER', NULL, 'dms', 'ALL', 'v2/auth/bulkUpdate', 'POST', 'application/json', 'POST API call to Update Bulk Reseller', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('613', 'RESELLER', 'VIEW_PARENT_RESELLER_TYPE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('614', 'RESELLER', NULL, 'dms', 'ALL', 'auth/getBulkResellerInfo', 'POST', 'application/json', 'POST API call to get bulk reseller info', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('615', 'RESELLER', 'VIEW_CHILD_RESELLER_TYPE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('616', 'RESELLER', 'CREATE_PASSWORD_POLICY', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('617', 'RESELLER', 'VIEW_PASSWORD_POLICY', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('618', 'RESELLER', 'EDIT_PASSWORD_POLICY', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('619', 'RESELLER', 'DELETE_PASSWORD_POLICY', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('620', 'RESELLER', 'CREATE_ROLE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('621', 'RESELLER', 'VIEW_ROLE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('622', 'RESELLER', 'EDIT_ROLE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('623', 'RESELLER', 'DELETE_ROLE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('624', 'RESELLER', 'VIEW_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('625', 'RESELLER', 'EDIT_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('626', 'RESELLER', 'CHANGE_PARENT_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('627', 'RESELLER', 'VIEW_CHILDREN_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('628', 'RESELLER', 'ACTIVATE_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('629', 'RESELLER', 'DEACTIVATE_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('630', 'RESELLER', 'BLOCK_RESELLER', 'dms', 'ALL', 'secure/api/rest/v1.0.0/resellerInfoService/blockReseller', '', '', 'API call to block reseller', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('631', 'RESELLER', 'UNBLOCK_RESELLER', 'dms', 'ALL', 'secure/api/rest/v1.0.0/resellerInfoService/unBlockReseller', '', '', 'API call to unblock reseller', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('632', 'RESELLER', 'FREEZE_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('633', 'RESELLER', 'UNFREEZE_RESELLER', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('634', 'RESELLER', 'authexpirePasswordPOST', 'dms', 'ALL', 'auth/expirePassword', 'POST', 'application/json', 'POST API call for expire password', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('635', 'RESELLER', 'CHANGE_RESELLER_TYPE', 'dms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('636', 'RESELLER', 'authchangeResellerTypePOST', 'dms', 'ALL', 'auth/changeResellerType', 'POST', 'application/json', 'POST API call to change reseller type', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('637', 'RESELLER', 'VIEW_RESELLER_REGION', 'dms', 'ALL', '', '', '', 'location based reseller list', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('638', 'RESELLER', 'ACTIVATE_RESELLER_LIST', 'dms', 'ALL', '', '', '', 'ACTIVATE_RESELLER_LIST', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('639', 'RESELLER', 'DEACTIVATE_RESELLER_LIST', 'dms', 'ALL', '', '', '', 'DEACTIVATE_RESELLER_LIST', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('640', 'RESELLER', 'BLOCK_RESELLER_LIST', 'dms', 'ALL', '', '', '', 'BLOCK_RESELLER_LIST', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('641', 'RESELLER', 'FREEZE_RESELLER_LIST', 'dms', 'ALL', '', '', '', 'FREEZE_RESELLER_LIST', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('642', 'RESELLER', 'UNFREEZE_RESELLER_LIST', 'dms', 'ALL', '', '', '', 'UNFREEZE_RESELLER_LIST', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('643', 'RESELLER', 'UNBLOCK_RESELLER_LIST', 'dms', 'ALL', '', '', '', 'BLOCK_RESELLER_LIST', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('644', 'RESELLER', NULL, 'dms', 'ALL', 'auth/bulkSearchResellersByAttribute', 'POST', 'application/json', 'POST API call to bulk search resellers by attribute', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('645', 'RESELLER', 'v1resellersbulkAddResellerUsersPOST', 'dms', 'ALL', 'v1/resellers/bulkAddResellerUsers', 'POST', 'application/json', 'POST API call to Bulk Add Reseller User', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('646', 'RESELLER', 'v1resellersbulkDeleteResellerUsersPOST', 'dms', 'ALL', 'v1/resellers/bulkDeleteResellerUsers', 'POST', 'application/json', 'POST API call to Bulk Delete Reseller User', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('647', 'RESELLER', 'v1resellersbulkUpdateResellerUsersPOST', 'dms', 'ALL', 'v1/resellers/bulkUpdateResellerUsers', 'POST', 'application/json', 'POST API call to Bulk Update Reseller User', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('648', 'RESELLER', 'LINK_DELINK_SUBRESELLER', 'dms', 'ALL', '', '', '', 'Link Unlink Reseller', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('649', 'RESELLER', 'RESELLERLINKDELINK', 'dms', 'ALL', '', '', '', 'Link Unlink Reseller', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('650', 'RESELLER', 'v1resellersgetResellerChildrenByFilterPOST', 'dms', 'ALL', 'v1/resellers/getResellerChildrenByFilter', 'POST', 'application/json', 'POST API call to get reseller children by filter (V1)', '2021-02-22 17:28:41', '2099-02-23 17:28:41', '0'),
	('651', 'RESELLER', 'Delete Reseller', 'dms', 'ALL', 'auth/deleteReseller', 'DELETE', 'application/json', 'DELETE API call to remove reseller', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('652', 'RESELLER', NULL, 'dms', 'ALL', 'auth/getResellerInfo', 'POST', 'application/json', 'POST API call to get reseller info', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('653', 'RESELLER', NULL, 'dms', 'ALL', 'auth/getResellerInfo', 'GET', 'application/json', 'GET API call to get reseller info', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('654', 'SETTINGS', 'OPENAPI', 'access', 'ALL', '', '', '', 'Open API Menu', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('655', 'SETTINGS', 'POLICY', 'settings', 'ALL', 'abcs', '', '', '', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('656', 'SETTINGS', 'POLICYMAPPING', 'settings', 'ALL', 'NA', '', '', NULL, '2021-02-12 12:12:12', '2099-01-01 11:11:11', '0'),
	('657', 'SETTINGS', 'ACCESSMANAGEMENT', 'settings', 'ALL', 'NA', '', '', NULL, '2021-02-12 12:12:12', '2099-01-01 11:11:11', '0'),
	('658', 'SETTINGS', 'ACCESS MANAGEMENT1', 'settings', 'ALL', 'v2/policy/.*', 'GET', 'application/json', 'This is a sample call to showcase v2/policy/', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('659', 'SETTINGS', 'ACCESSMANAGEMENT', 'settings', 'ALL', 'NA', '', '', NULL, '2021-02-12 12:12:12', '2099-01-01 11:11:11', '0'),
	('660', 'SETTINGS', 'SETTINGS', 'settings', 'ALL', '', '', '', '', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('661', 'SFC', 'fetch dealer balance', 'sfc', 'ALL', 'fetch-dealer-balance', 'POST', 'application/json', 'fetch dealer balance from erp', '2022-03-07 10:25:42', '2099-01-01 00:00:00', '0'),
	('662', 'SFC', 'fetch pretups balance', 'sfc', 'ALL', 'pretups-fetch-balance', 'POST', 'application/json', 'fetch pretups balance from erp', '2022-03-07 10:25:42', '2099-01-01 00:00:00', '0'),
	('663', 'SFC', 'fetch dealer balance', 'sfc', 'ALL', 'fetch-dealer-balance', 'POST', 'application/json', 'fetch dealer balance from erp', '2022-03-07 10:25:42', '2099-01-01 00:00:00', '0'),
	('664', 'SFC', 'fetch pretups balance', 'sfc', 'ALL', 'pretups-fetch-balance', 'POST', 'application/json', 'fetch pretups balance from erp', '2022-03-07 10:25:42', '2099-01-01 00:00:00', '0'),
	('665', 'SFC', 'invoice-settle', 'sfc', 'ALL', 'invoice-settle', 'POST', 'application/json', 'settle invoice for 3pl agents', '2022-03-07 10:25:42', '2099-01-01 00:00:00', '0'),
	('666', 'SFC', 'stk-success-callback', 'sfc', 'ALL', 'stk-push-result', 'POST', 'application/json', 'mpesa callback for success', '2022-03-07 10:25:42', '2099-01-01 00:00:00', '0'),
	('667', 'SFC', 'stk-timeout-callback', 'sfc', 'ALL', 'stk-push-timeout', 'POST', 'application/json', 'mpesa callback for timeout', '2022-03-07 10:25:42', '2099-01-01 00:00:00', '0'),
	('668', 'Template Management', 'v1componenttypeGET', 'template', 'ALL', 'v1/component/.*/type/.*', 'GET', 'application/json', 'This is a sample call to showcase v1/component/.*/type/.*', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('669', 'Template Management', NULL, 'template', 'ALL', 'v1/component/.*/type/.*', 'GET', 'application/json', 'This is a sample call to showcase v1/component/.*/type/.*', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('670', 'Template Management', NULL, 'template', 'ALL', 'v1/component/DMS/type/.*', 'GET', 'application/json', 'This is a sample call to showcase v1/component/.*/type/.*', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('671', 'THRESHOLDS', 'DELETELOWSTOCK', 'alertapp', 'ALL', 'threshold/.*', 'DELETE', 'application/json', 'API to delete threshold ', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('672', 'THRESHOLDS', 'CREATE_THRESHOLDS', 'alertapp', 'ALL', 'threshold', 'POST', 'application/json', 'API to create threshold ', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('673', 'THRESHOLDS', 'GET_THRESHOLD', 'alertapp', 'ALL', 'threshold/.*', 'GET', 'application/json', 'API to Get threshold by id', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('674', 'THRESHOLDS', 'EDIT_THRESHOLDS', 'alertapp', 'ALL', 'threshold', 'PUT', 'application/json', 'API to edit threshold ', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('675', 'THRESHOLDS', 'GET_THRESHOLDs', 'alertapp', 'ALL', 'thresholds/.*', 'GET', 'application/json', 'API to Get threshold by owner', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('676', 'THRESHOLDS', NULL, 'alertapp', 'ALL', 'threshold/trip', 'POST', 'application/json', 'trip based threshold', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('677', 'THRESHOLDS', 'THRESHOLDS', 'alertapp', 'ALL', 'threshold', 'GET', 'application/json', 'API to get threshold list', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('678', 'THRESHOLDS', 'CREATE_LOW_INVENTORY_THRESHOLDS', 'alertapp', 'ALL', '', 'GET', 'application/json', 'API to get threshold list', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('679', 'THRESHOLDS', 'UPDATE_LOW_INVENTORY_THRESHOLDS', 'alertapp', 'ALL', '', 'GET', 'application/json', 'API to get threshold list', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('680', 'THRESHOLDS', 'DELETE_LOW_INVENTORY_THRESHOLDS', 'alertapp', 'ALL', '', 'GET', 'application/json', 'API to get threshold list', '2022-01-04 17:56:41', '2099-01-04 17:27:26', '0'),
	('681', 'TRANSACTION', 'AIRTIMESTOCK', 'txe', 'ALL', 'v1/requestTransfer', 'POST', 'application/json', 'POST API call to request transfer (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('682', 'TRANSACTION', 'TRANSATION_REVERSAL', 'txe', 'ALL', 'v1/requestTransactionReversal', 'POST', 'application/json', 'POST API call to request transaction reversal (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('683', 'TRANSACTION', 'TOPUP', 'txe', 'ALL', 'v1/requestTopup', 'POST', 'application/json', 'POST API call to request TOPUP (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('684', 'TRANSACTION', 'SUPPORT_TRANSFER', 'txe', 'ALL', 'v1/requestSupportTransfer', 'POST', 'application/json', 'POST API call to request support transfer (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('685', 'TRANSACTION', 'PURCHASE', 'txe', 'ALL', 'v1/requestPurchase', 'POST', 'application/json', 'POST API call to request purchase (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('686', 'TRANSACTION', 'CANCEL_TRANSACTION', 'txe', 'ALL', 'v1/cancelTransaction', 'POST', 'application/json', 'POST API call to cancel transaction (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('687', 'TRANSACTION', 'APPROVE_TRANSACTION', 'txe', 'ALL', 'v1/approveTransaction', 'POST', 'application/json', 'POST API call to approve transaction (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('688', 'TRANSACTION', 'SEARCH_ARCHIVED_TRANSACTION', 'txe', 'ALL', 'v1/searchArchivedTransaction/.*', 'POST', 'application/json', 'POST API call to search transaction from transaction log (V1)', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('689', 'TRANSACTION', 'SEARCH TRANSACTION', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('690', 'TRANSACTION', 'VIEW_TRANSACTION', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('691', 'TRANSACTION', 'RESELLER_PRODUCTS', 'txe', 'ALL', 'v1/getResellerProducts', 'POST', 'application/json', 'POST API call to get reseller products (V1)', '2021-02-12 12:26:20', '2099-02-12 12:26:20', '0'),
	('692', 'TRANSACTION', 'AIRTIME_POSTPAID', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('693', 'TRANSACTION', 'SEARCH_HIERARCHY', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('694', 'TRANSACTION', 'HIERARCHY SEARCH', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('695', 'TRANSACTION', 'AIRTIME STOCK', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('696', 'TRANSACTION', 'AIRTIME POSTPAID', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('697', 'TRANSACTION', 'SEARCH', 'txe', 'ALL', 'bi-engine/fetch', 'POST', 'application/json', 'POST API call to bi-engine to search transaction', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('698', 'TRANSACTION', 'abcs', 'txe', 'ALL', 'v1/getResellerInfo', 'POST', 'application/json', 'POST API call to get reseller info (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('699', 'TRANSACTION', 'abcs', 'txe', 'ALL', 'v2/requestTransferV2', 'POST', 'application/json', 'POST API call to request transfer (V2)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('700', 'TRANSACTION', 'TOPUP', 'txe', 'API', 'v1/requestTopup', 'POST', 'application/json', 'POST API call to request TOPUP (V1)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('701', 'TRANSACTION', 'MANUAL ADJUSTMENT', 'txe', 'ALL', '', '', '', '', '2021-12-09 12:10:20', '2099-01-01 00:00:00', '0'),
	('702', 'TRANSACTION', 'TRANSATION_REVERSAL', 'txe', 'ALL', 'v2/requestTransactionReversalV2', 'POST', 'application/json', 'POST API call to request transaction reversal (V2)', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('703', 'TRANSACTION', 'PENDING TRANSACTIONS', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('704', 'TRANSACTION', 'PENDING_TRANSACTIONS', 'txe', 'ALL', 'bi-engine/fetch', 'POST', 'application/json', 'POST API call to bi-engine to fetch pending transactions', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('705', 'TRANSACTION', '', 'txe', 'ALL', 'reseller/deLinkSubReseller', 'POST', 'application/json', 'POST API call to de-link sub-reseller', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('706', 'TRANSACTION', '', 'txe', 'ALL', 'reseller/linkSubReseller', 'POST', 'application/json', 'POST API call to link sub-reseller', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('707', 'TRANSACTION', 'STANDARD_BUNDLE_LIST', 'txe', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('708', 'TRANSACTION', 'ACTIVATE_BUNDLE', 'txe', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('709', 'TRANSACTION', 'STANDARDBUNDLE', 'txe', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('710', 'TRANSACTION', 'MANUAL_ADJUSTMENT', 'txe', 'ALL', '', '', '', '', '2022-03-17 12:14:15', '2099-01-01 00:00:00', '0'),
	('711', 'TXE', NULL, 'txe', NULL, 'v1/requestTransfer', 'POST', 'application/json', '', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('712', 'WALLET', 'MONEY_WALLET', 'wallet', 'ALL', '', '', '', '', '2021-02-01 18:26:11', '2099-02-01 18:26:11', '0'),
	('713', 'WALLET', 'AIRTIME_WALLET', 'wallet', 'ALL', '', '', '', '', '2021-02-01 18:26:11', '2099-02-01 18:26:11', '0'),
	('714', 'WORKFLOWS', 'CREATE WORKFLOW', 'groupmanagementsystem', 'ALL', 'v1/workflow', 'POST', 'application/json', 'Create a workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('715', 'WORKFLOWS', 'VIEW WORKFLOW', 'groupmanagementsystem', 'ALL', 'v1/workflow.*', 'GET', 'application/json', 'View existing workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('716', 'WORKFLOWS', 'DELETE WORKFLOW', 'groupmanagementsystem', 'ALL', 'v1/workflow.*', 'DELETE', 'application/json', 'Delete an existing workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('717', 'WORKFLOWS', 'VIEW WORKFLOWS', 'groupmanagementsystem', 'ALL', 'v1/workflow', 'GET', 'application/json', 'View workflow listing', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('718', 'WORKFLOWS', 'UPDATE WORKFLOW', 'groupmanagementsystem', 'ALL', 'v1/updateWorkflow', 'PUT', 'application/json', 'Edit an existing workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('719', 'WORKFLOWS', 'VIEW_ALL_WORKFLOWS', 'groupmanagementsystem', 'ALL', '', '', '[UI] - View all workflows', 'View workflow listing', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('720', 'WORKFLOWS', 'CREATE_WORKFLOW', 'groupmanagementsystem', 'ALL', '', '', '[UI] - Create a workflow', 'create a workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('721', 'WORKFLOWS', 'EDIT_WORKFLOW', 'groupmanagementsystem', 'ALL', '', '', '[UI] - Edit an existing workflow', 'edit an existing workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('722', 'WORKFLOWS', 'DELETE_WORKFLOW', 'groupmanagementsystem', 'ALL', '', '', '[UI] - Delete an existing workflow', 'delete an existing workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('723', 'WORKFLOWS', 'VIEW_WORKFLOW_DETAILS', 'groupmanagementsystem', 'ALL', '', '', '[UI] - View an existing workflow', 'view details of an existing workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('724', 'WORKFLOWS', 'WORKFLOWS', 'groupmanagementsystem', 'ALL', '', '', '', 'View workflow listing', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('725', 'WORKFLOWS', 'WORKFLOW CREATION', 'groupmanagementsystem', 'ALL', '', '', '', '[UI] - View workflow listing submenu', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('726', 'WORKFLOWS', 'WORKFLOWS', 'groupmanagementsystem', 'ALL', 'v1/workflow.*', 'PUT', 'application/json', 'Reject Approve campaign design workflow', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('727', 'WORKFLOWS', 'GET WORKFLOW GROUP DETAILS', 'groupmanagementsystem', 'ALL', 'v1/workflow/reference-id/.*', 'GET', 'application/json', 'Get Workflow Approval Groups details', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('728', 'REGION', 'THANAMAPPING', 'rgms', 'ALL', '', '', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('729', 'REGION', 'VIEW_THANA_MAPPINGS', 'rgms', 'ALL', '', '', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('730', 'REGION', 'CREATE_THANA_MAPPING', 'rgms', 'ALL', '', '', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('731', 'REGION', 'ADD_THANA_MAPPING', 'rgms', 'ALL', '/v2/region-mapping', 'POST', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('732', 'REGION', 'UPDATE_THANA_MAPPING', 'rgms', 'ALL', '/v2/region-mapping.*', 'PUT', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('733', 'REGION', 'SEARCH_THANA_MAPPING', 'rgms', 'ALL', '/v2/region-mapping/search', 'POST', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('734', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota.*', 'GET', 'application/json', 'View all stock allocations', '2024-03-27 13:16:37', '2099-01-01 00:00:00', '0'),
	('735', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota/.*', 'GET', 'application/json', 'fetch stock allocation by id', '2024-03-27 13:16:37', '2099-01-01 00:00:00', '0'),
	('736', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota', 'POST', 'application/json', 'create single stock allocations', '2024-03-27 13:16:37', '2099-01-01 00:00:00', '0'),
	('737', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota/.*', 'PUT', 'application/json', 'update stock allocation by id', '2024-03-27 13:16:37', '2099-01-01 00:00:00', '0'),
	('738', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota/.*', 'DELETE', 'application/json', 'delete stock allocation by id', '2024-03-27 13:16:37', '2099-01-01 00:00:00', '0'),
	('739', 'ORDER', 'CREATE_PRODUCT_QUOTA_VIA_FILE', 'quota-management-system', 'ALL', '', '', '', 'create order product quota rule', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('740', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota/downloadCSV', 'POST', 'application/json', 'download csv file with prouct quota information', '2024-03-27 13:16:37', '2099-01-01 00:00:00', '0'),
	('741', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota/bulk', 'POST', 'application/json', 'delete stock allocation by id', '2024-03-27 13:16:37', '2099-01-01 00:00:00', '0'),
	('742', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota/revert/.*', 'PUT', '', 'api to revert any product quota rules created by the bulk api using the import id as input', '2022-03-03 12:26:20', '2099-01-01 00:00:00', '0'),
	('743', 'ORDER', '', 'quota-management-system', 'ALL', 'v1/quota/keep/.*', 'PUT', 'application/json', 'api to keep any product quota rules created by the bulk api using the import id as input', '2024-03-27 13:16:37', '2099-01-01 00:00:00', '0'),
	('744', 'ORDER', 'PURCHASE ORDER', 'oms', 'ALL', '', '', '', 'purchase order', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('745', 'ORDER', 'v2/preorders', 'oms', 'ALL', 'v2/preorders', 'GET', 'application/json', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
	('746', 'BATCH', 'v1importstockallocationPOST', 'bss', 'ALL', 'v1/import/stockAllocation', 'POST', 'application/json', 'Import stock allocation', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('747', 'RESELLER', 'CHANNELS', 'dms', 'ALL', '', '', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('748', 'RESELLER', 'DOMAINS_LISTING', 'dms', 'ALL', '', '', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('749', 'RESELLER', 'CREATE_DOMAIN', 'dms', 'ALL', '', '', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('750', 'RESELLER', 'EDIT_DOMAIN', 'dms', 'ALL', '', '', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('751', 'RESELLER', 'VIEW_DOMAIN', 'dms', 'ALL', '', '', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('752', 'ROUTE', 'ROUTE', 'groupmanagementsystem', 'ALL', '', '', '', '', '2024-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('753', 'ROUTE', 'VIEW_ALL_ROUTE', 'groupmanagementsystem', 'ALL', '', '', '', '', '2024-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('754', 'ROUTE', 'DELETE_ROUTE', 'groupmanagementsystem', 'ALL', '', '', '', '', '2024-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('755', 'ROUTE', 'VIEW_ROUTE_DETAILS', 'groupmanagementsystem', 'ALL', 'v1/group/.*', 'GET', 'application/json', 'API to fetch route detail', '2024-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('756', 'ROUTE', 'CREATE_ROUTE', 'groupmanagementsystem', 'ALL', 'v1/groupdetail', 'POST', 'application/json', 'lis box items\n', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('757', 'RESELLER', '', 'dms', 'ALL', 'v2/auth/bulkUpdateResellerExtraParams', 'POST', 'application/json', 'POST API call to Update Bulk Reseller extra param', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('758', 'RESELLER', 'RESELLER_TEMPLATE_VIEW', 'dms', 'ALL', '', '', '', 'BLOCK_RESELLER_LIST', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('759', 'PRODUCT', 'CREATE_POS_TYPE_RULE', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('760', 'PRODUCT', 'POSTYPERULES', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('761', 'PRODUCT', 'VIEW_ALL_POS_TYPE_RULES', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('762', 'CONTRACT', 'POSTYPERULES', 'acms', 'ALL', 'v2/concerted-rule-info.*', 'GET', 'application/json', 'Get all pos type product rules', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('763', 'CONTRACT', '', 'acms', 'ALL', 'concerted-rule-info', 'GET', 'application/json', 'C2SRULES', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('764', 'CONTRACT', '', 'acms', 'ALL', 'concerted-rule-info', 'GET', 'application/json', 'C2SRULES', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('765', 'CONTRACT', '', 'acms', 'ALL', 'concerted-rule-info', 'POST', 'application/json', 'CREATE_C2SRULES', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('766', 'CONTRACT', '', 'acms', 'ALL', 'concerted-rule-info.*', 'GET', 'application/json', 'VIEW_C2S', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('767', 'CONTRACT', '', 'acms', 'ALL', 'concerted-rule-info', 'GET', 'application/json', 'C2SRULES', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('768', 'CONTRACT', '', 'acms', 'ALL', 'concerted-rule-info', 'GET', 'application/json', 'C2SRULES', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('769', 'CONTRACT', '', 'acms', 'ALL', 'concerted-rule-info', 'GET', 'application/json', 'Get C2S rules', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('770', 'CONTRACT', '', 'acms', 'ALL', 'v2/concerted-rule-info.*', 'GET', 'application/json', 'VIEW_C2S', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('771', 'PRODUCT', 'VIEW_POS_TYPE_RULE', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('772', 'PRODUCT', 'EDIT_POS_TYPE_RULE', 'pms', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('773', 'CONTRACT', '', 'acms', 'ALL', 'update-product-rule-association/.*', 'PUT', 'application/json', 'UPDATE_C2S', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('774', 'INVENTORY', '', 'ims', 'ALL', 'v1/inventories/search', 'POST', 'application/json', 'Get inventory for particular serial range', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('775', 'ACCESS', '', 'access', 'ALL', 'v3/resources', 'GET', 'application/json', 'Get policy resources', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('776', 'ACCESS', '', 'access', 'ALL', 'v3/resources/policy/.*', 'GET', 'application/json', 'Get Policy By Id', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('777', 'ACCESS', NULL, 'access', 'ALL', 'v1/features/resellerType/.*', 'GET', 'application/json', 'This is a sample call to showcase v1/policy/', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('778', 'ACCESS', 'DELETE_POLICY', 'access', 'ALL', 'v3/policy/.*', 'DELETE', 'application/json', 'DELETE policy resources', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('779', 'ACCESS', 'CREATE_POILCY', 'access', 'ALL', 'v3/policy/save', 'POST', 'application/json', 'Create policy api', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('780', 'ACCESS', '', 'access', 'ALL', 'v2/reseller-roles', 'PUT', 'application/json', 'UpdatePolicy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('781', 'RESELLER', NULL, 'dms', 'ALL', 'v1/resellers/types/.*/allowedTypes', 'GET', 'application/json', 'This is for allowed types', '2021-02-25 18:05:52', '2099-02-26 18:05:52', '0'),
	('782', 'RESELLER', 'RESELLER_ADDRESS_INFO', 'dms', 'ALL', '', '', '', 'RESELLER_ADDRESS_INFO', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('783', 'RESELLER', 'RESELLER_USER_INFO', 'dms', 'ALL', '', '', '', 'RESELLER_USER_INFO', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('784', 'RESELLER', 'RESELLER_ACCOUNT_INFO', 'dms', 'ALL', '', '', '', 'RESELLER_ACCOUNT_INFO', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('785', 'RESELLER', 'RESELLER_ADDITIONAL_INFO', 'dms', 'ALL', '', '', '', 'RESELLER_ADDITIONAL_INFO', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('786', 'RESELLER', 'RESELLER_CONTRACT_INFO', 'dms', 'ALL', '', '', '', 'RESELLER_CONTRACT_INFO', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('787', 'ROUTE', 'EDIT_ROUTE', 'groupmanagementsystem', 'ALL', 'v1/group', 'PUT', 'application/json', 'API to edit a route', '2024-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('788', 'ROUTE', 'CREATE_ROUTE_PARTNER_NAME', 'groupmanagementsystem', 'ALL', '', '', '', 'Toggle option to show partner name dropdwon in the create route page', '2024-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('789', 'ACCESS', '', 'access', 'ALL', 'v2/reseller-roles', 'GET', 'application/json', 'UpdatePolicy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('790', 'ACCESS', '', 'access', 'ALL', 'v2/reseller-roles/policy', 'GET', 'application/json', 'UpdatePolicy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('791', 'ACCESS', '', 'access', 'ALL', 'v2/reseller-roles', 'POST', 'application/json', 'UpdatePolicy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('792', 'ACCESS', '', 'access', 'ALL', 'v2/reseller-roles/.*', 'DELETE', 'application/json', 'UpdatePolicy', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('793', 'RESELLER', 'MEMBERS_LIST_ACTIONS_COLUMN', '', 'ALL', '', '', '', '', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('794', 'ORDER', 'GRN', 'oms', 'ALL', '', '', '', 'purchase order', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('795', 'ORDER', 'PAYMENTS', 'oms', 'ALL', '', '', '', 'payment declaration', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('796', 'ORDER', 'CANCEL_ORDER', 'oms', 'ALL', '', '', '', 'CANCEL ORDER', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
    ('797', 'ORDER', 'v2ordersGET', 'oms', 'ALL', 'v2/orders', 'GET', 'application/json', 'API to get details of all orders.', '2021-02-15 14:08:50', '2099-02-15 14:08:50', '0'),
    ('798', 'HELPER_LINK', 'captureRequestPOST', 'helper-link', 'ALL', 'capture-request', 'POST', 'application/json', 'POST API call to publish event to helper-link', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('799', 'HELPER_LINK', 'processRequestPOST', 'helper-link', 'ALL', 'process-request', 'POST', 'application/json', 'POST API call to publish event to helper-link synchronously', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('800', 'ROUTE', 'FETCH_ALL_ROUTE_DETAILS', 'groupmanagementsystem', 'ALL', 'v1/groups/allinfo.*', 'POST', 'application/json', 'API to fetch route all detail including member ids', '2024-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
    ('801', 'ORDER', 'v2orderpaymenttypesGET', 'oms', 'ALL', 'v2/order-payment-types', 'GET', 'application/json', 'get payment types', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
    ('802', 'ASSETMANAGEMENT', 'v1SearchAssetByType', 'assetmanagement', 'ALL', 'v1/asset/search/.*', 'GET', 'application/json', 'GET API call to get asset by asset type', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('803', 'ASSETMANAGEMENT', 'v1assetByIdGET', 'assetmanagement', 'ALL', 'v1/asset/id/.*', 'GET', 'application/json', 'GET API call to get asset by asset type', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('804', 'ASSETMANAGEMENT', 'v1assetByTypeGET', 'assetmanagement', 'ALL', 'v1/asset/type/.*', 'GET', 'application/json', 'GET API call to get asset by asset type', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('805', 'ORDER', '', 'oms', 'ALL', 'v2/make-payment', 'POST', 'application/json', 'API to create an order.', '2021-02-15 14:09:26', '2099-02-15 14:09:26', '0'),
    ('810', 'ORDER', 'STOCKALLOCATION', 'oms', 'ALL', '', '', '', 'Stock Allocation Module', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('811', 'ORDER', 'SECONDARYSALESORDER', 'oms', 'ALL', '', '', '', 'Secondary Sales Order Module', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
	('812', 'CONTRACT', '', 'acms', 'ALL', 'v2/contracts/pricing-list/import', 'POST', 'application/json', 'PRICING_LIST_IMPORT', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
    ('813', 'BULK', '', 'bss', 'ALL', 'v1/import/contract', 'POST', 'multipart/form-data', 'Import pricing list', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
    ('814', 'TERTIARY', 'SEARCHINVOICE', 'oms', 'ALL', '', '', '', 'Search Invoice module', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('815', 'TERTIARY', 'SEARCH_INVOICE', 'oms', 'ALL', 'v2/orders/invoices.*', 'GET', 'application/json', 'Search Invoice list', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('816', 'ASSETMANAGEMENT', 'v1createAssetPOST', 'assetmanagement', 'ALL', 'v1/asset/createAsset.*', 'POST', 'application/json', 'Create asset', '2025-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('817', 'ASSETMANAGEMENT', 'v1getAssetByTypesPOST', 'assetmanagement', 'ALL', 'v1/asset/types.*', 'POST', 'application/json', 'resources list view', '2025-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('818', 'ASSETMANAGEMENT', 'v1bulkAddAssetMetaDataPOST', 'assetmanagement', 'ALL', 'v1/asset/bulkAddAssetMetaData.*', 'POST', 'application/json', 'update asset meta data', '2025-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('819', 'ASSETMANAGEMENT', 'v1bulkCreateAssetPOST', 'assetmanagement', 'ALL', 'v1/asset/bulkCreateAsset.*', 'POST', 'application/json', 'Bulk create assets', '2025-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('820', 'ASSETMANAGEMENT', 'v1getAllAssetsGET', 'assetmanagement', 'ALL', 'v1/asset/getAllAssets.*', 'GET', 'application/json', 'GET API call to get all  assets', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('821', 'ASSETMANAGEMENT', 'v1updateAssetStatusPOST', 'assetmanagement', 'ALL', 'v1/asset/updateAssetStatus/.*', 'POST', 'application/json', 'Update asset status', '2025-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
    ('822', 'ASSETMANAGEMENT', 'v1deleteAssetByIdDELETE', 'assetmanagement', 'ALL', 'v1/asset/.*', 'DELETE', 'application/json', 'GET API call to get asset by asset type', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('823', 'GRN', 'v1SalesOrdersGET', 'grn', 'ALL', 'v1/salesOrders?.*', 'GET', 'application/json', 'GET API call for grn', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('824', 'GRN', '', 'grn', 'ALL', 'api/initiate-grn', 'POST', 'application/json', 'POST API call for initiate-grn', '2025-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('825', 'INVENTORY', 'v2lost-and-found-inventoryPOST', 'ims', 'ALL', 'v2/lost-and-found-inventory.*', 'POST', 'application/json', 'Lost and found inventory approval or rejection', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
	('826', 'INVENTORY', 'INVENTORYLOSTANDFOUND', 'ims', 'ALL', '', 'GET', 'application/json', 'Inventory lost and found module', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
	('827', 'INVENTORY', 'ADD_INVENTORY_LOST_AND_FOUND', 'ims', 'ALL', '', 'POST', 'application/json', 'Add Inventory lost and found action', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
	('828', 'INVENTORY', 'VIEW_INVENTORY_LOST_AND_FOUND', 'ims', 'ALL', '', 'GET', 'application/json', 'View Inventory lost and found action', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
	('829', 'INVENTORY', 'APPROVE_INVENTORY_LOST_AND_FOUND', 'ims', 'ALL', '', 'POST', 'application/json', 'Approve Inventory lost and found action', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
	('830', 'INVENTORY', 'REJECT_INVENTORY_LOST_AND_FOUND', 'ims', 'ALL', '', 'POST', 'application/json', 'Reject Inventory lost and found action', '2024-02-12 12:26:20', '2099-01-01 00:00:00', 0),
	('831', 'REPORT', 'MULTI_SELECT', 'bi-engine', 'ALL', '', '', '', 'Indicator for UI if the user will see multi select drop down or simply a pre-populated text field.', '2021-03-01 17:06:20', '2029-03-02 17:06:20', 0),
	('832', 'REGION', 'SEARCH_REGIONS', 'rgms', 'ALL', 'v1/region/searchRegionsByAttribute', 'POST', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', 0),
	('833', 'ORDER', 'MOVE ORDER', 'oms', 'ALL', '', '', '', 'move order', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('834', 'INVENTORY', 'v2lost-and-found-inventoryPUT', 'ims', 'ALL', 'v2/lost-and-found-inventory', 'PUT', 'application/json', 'Create new Lost and Found Inventory', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
	('835', 'BATCH', 'addAssetMetaData', 'bss', 'ALL', 'v1/import/addAssetMetaData.*', 'POST', 'multipart/form-data', 'Import asset meta data', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
    ('836', 'ASSETMANAGEMENT', 'importBulkCreateAssetPost', 'assetmanagement', 'ALL', 'v1/asset/importBulkCreateAsset.*', 'POST', 'application/json', 'Import asset meta data', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
    ('837', 'ASSETMANAGEMENT', 'updateAssetPut', 'assetmanagement', 'ALL', 'v1/asset/updateAsset.*', 'PUT', 'application/json', 'Update asset with meta data', '2021-02-01 18:26:11', '2099-01-01 00:00:00', '0'),
	('838', 'REGION', '', 'rgms', 'ALL', 'v1/region/.*', 'GET', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('839', 'REGION', '', 'rgms', 'ALL', 'v1/region/.*', 'POST', 'application/json', NULL, '2022-04-07 18:00:00', '2099-02-07 18:00:00', '0'),
	('840', 'RESELLER', 'v1getAllResellerUsersGET', 'dms', 'ALL', 'v1/users/getAllResellerUsers.*', 'GET', 'application/json', 'GET API call to get all reseller users', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('841', 'RESELLER', 'USERS', 'dms', 'ALL', '', '', '', 'view users', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('842', 'REGION', NULL, 'rgms', 'ALL', 'v2/region.*', 'GET', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('843', 'RESELLER', NULL, 'dms', 'ALL', 'auth/searchResellersByAttribute', 'POST', 'application/json', 'POST API call to search resellers by attribute', '2021-02-01 18:26:11', '2099-03-01 18:26:11', '0'),
	('844', 'BPRS_LINK', '', 'bprslink', 'ALL', 'ws', 'POST', 'application/json', 'POST API call to confirm payment via BPRS link', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('845', 'POL_LINK', '', 'pollink', 'ALL', 'thirdParty/gppl/.*', 'POST', 'application/json', 'POST API call to confirm payment via POL link', '2021-02-18 18:46:02', '2099-01-01 00:00:00', '0'),
	('846', 'RESELLER', 'EDIT_USER', 'dms', 'ALL', '', '', '', 'Edit user', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('847', 'RESELLER', 'VIEW_USER', 'dms', 'ALL', '', '', '', 'View user', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('848', 'RESELLER', 'SUSPEND_USER', 'dms', 'ALL', '', '', '', 'Suspend user', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('849', 'RESELLER', 'ACTIVATE_USER', 'dms', 'ALL', '', '', '', 'Activate user', '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('850', 'REPORT', 'MULTI_SELECT_CIRCLE', 'bi-engine', 'ALL', '', '', '', 'Indicator for UI if the user will see multi select drop down for CIRCLE or simply a pre-populated text field.', '2021-03-01 17:06:20', '2029-03-02 17:06:20', 0),
	('851', 'REPORT', 'MULTI_SELECT_REGION', 'bi-engine', 'ALL', '', '', '', 'Indicator for UI if the user will see multi select drop down for REGION or simply a pre-populated text field.', '2021-03-01 17:06:20', '2029-03-02 17:06:20', 0),
	('852', 'REPORT', 'MULTI_SELECT_CLUSTER', 'bi-engine', 'ALL', '', '', '', 'Indicator for UI if the user will see multi select drop down for CLUSTER or simply a pre-populated text field.', '2021-03-01 17:06:20', '2029-03-02 17:06:20', 0),
	('853', 'REPORT', 'MULTI_SELECT_TERRITORY', 'bi-engine', 'ALL', '', '', '', 'Indicator for UI if the user will see multi select drop down for TERRITORY or simply a pre-populated text field.', '2021-03-01 17:06:20', '2029-03-02 17:06:20', 0),
	('854', 'REPORT', 'MULTI_SELECT_DH', 'bi-engine', 'ALL', '', '', '', 'Indicator for UI if the user will see multi select drop down for DH or simply a pre-populated text field.', '2021-03-01 17:06:20', '2029-03-02 17:06:20', 0),
	('855', 'STORE', 'VAULTREGISTER', 'vault', 'ALL', '\n', '', '\n', 'Vault register sidebar', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
	('856', 'STORE', 'VAULTWITHDRAWAL', 'vault', 'ALL', '\n', '', '\n', 'Vault withdrawal sidebar', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
    ('857', 'RESELLER', '', 'dms', 'ALL', 'auth/IDMareaDemarcation', 'POST', 'application/json', 'AreaDemarcation', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
	('858', 'RESELLER', 'ERSMFS', 'dms', 'ALL', '', '', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('859', 'RESELLER', 'ERS_MFS', 'dms', 'ALL', '', '', 'application/json', NULL, '2021-02-12 12:26:20', '2099-01-01 00:00:00', '0'),
	('866', 'BULK', '', 'bss', 'ALL', 'v1/import/demarcation', 'POST', 'application/json', 'AreaDemarcation', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
    ('867', 'RESELLER', '', 'dms', 'ALL', 'auth/areaDemarcation', 'POST', 'application/json', 'AreaDemarcation', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
    ('868', 'REGION', '', 'rgms', 'ALL', 'v1/region/.*/level/.*', 'GET', 'application/region-v1+json', 'FetchRegionLevel', '2021-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('869', 'REGION', '', 'rgms', 'ALL', 'v1/region/boundary', 'POST', 'application/region-v1+json', 'CreateRegionBoundary', '2021-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('870', 'REGION', '', 'rgms', 'ALL', 'v1/region/cell/.*', 'GET', 'application/region-v1+json', 'FetchRegionCell', '2021-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('871', 'REGION', '', 'rgms', 'ALL', 'v1/region/lat/.*/long/.*', 'GET', 'application/region-v1+json', 'FetchRegionLatLong', '2021-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('872', 'REGION', '', 'rgms', 'ALL', 'v1/region/owner', 'PUT', 'application/region-v1+json', 'UpdateRegionOwner', '2021-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('873', 'REGION', '', 'rgms', 'ALL', 'v1/region/owner', 'DELETE', 'application/region-v1+json', 'DeleteRegionOwner', '2021-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('874', 'REGION', '', 'rgms', 'ALL', 'v1/region/owner/.*', 'GET', 'application/region-v1+json', 'GetRegionOwner', '2021-02-12 12:26:20', '2099-01-01 00:00:00', 0),
    ('875', 'REGION', '', 'rgms', 'ALL', 'v1/region/subregion.*', 'GET', 'application/json', 'FetchRegionSubRegion', '2022-03-17 12:14:15', '2099-01-01 00:00:00', 0),
    ('876', 'REGION', '', 'rgms', 'ALL', 'v1/region/subregion/.*', 'GET', 'application/json', 'FetchRegionSubRegion', '2022-03-17 12:14:15', '2099-01-01 00:00:00', 0),
    ('877', 'BULK', 'updateResellerParam', 'bss', 'ALL', 'v1/import/updateResellerParam.*', 'POST', 'multipart/form-data', 'Import asset meta data', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
    ('878', 'BULK', 'updateResellerChannels', 'bss', 'ALL', 'v1/import/updateResellerChannels.*', 'POST', 'multipart/form-data', 'Import reseller direct retailing', '2021-02-01 18:26:11', '2099-01-01 00:00:00', 0),
    ('879', 'INVENTORY', 'inventoryDetails', 'ims', 'ALL', 'v1/inventoryDetails', 'POST', 'application/json', 'Export inventory', '2021-02-01 18:26:11', '2099-03-01 18:26:11', 0);




INSERT INTO `master_resource` (`id`, `name`, `description`)
VALUES
	('1', 'DEFAULT', 'Collection of all default features'),
	('2', 'PARTNERS', 'Collection of all reseller related features'),
	('3', 'PARTNER TYPES', 'Collection of all reseller type related features'),
	('4', 'PARTNER ROLES', 'Collection of all reseller role related features'),
	('5', 'PASSWORD POLICIES', 'Collection of all password policy related features'),
	('6', 'TEMPLATE DROPDOWNS', 'Collection of all template related features'),
	('7', 'CHANNELS', 'Collection of all Channel related features'),
	('8', 'PRODUCT CATEGORIES', 'Collection of all product category related features'),
	('9', 'PRODUCTS', 'Collection of all product related features'),
	('10', 'TAXES', 'Collection of all product TAX related features'),
	('11', 'POSPRODUCTRULES', 'Collection of all POS product restriction rule related features'),
	('12', 'PRODUCT QUATA', 'Collection of all PRODUCT QUATA related features'),
	('13', 'ROUTE', 'Collection of all Route related features'),
	('14', 'REPORT', 'Collection of all REPORT related features'),
	('15', 'AUDIT', 'Collection of all AUDIT related features'),
	('16', 'ACCOUNT TYPES', 'Collection of all ACCOUNT TYPES related features'),
	('17', 'ACCOUNTS', 'Collection of all ACCOUNTS related features'),
	('18', 'CONTRACTS', 'Collection of all CONTRACTS related features'),
	('19', 'BULK IMPORT', 'Collection of all BULK IMPORT related features'),
	('20', 'POLICY', 'Collection of all POLICY related features'),
	('21', 'POLICY MAPPINGS', 'Collection of all VIEW & MANAGE POLICY MAPPINGS related features'),
	('22', 'GATEWAY', 'Collection of all GATEWAY related features'),
	('23', 'SEARCH KYC', 'Collection of all Partner KYC related features'),
	('24', 'APPROVE-REJECT KYC', 'Collection of all Search Partner KYC related features'),
	('25', 'REGISTER PARTNERS', 'Collection of all Partner KYC related features'),
	('26', 'REGISTER USERS', 'Collection of all Partner User KYC related features'),
	('27', 'ORDERS', 'Collection of all ORDERS related features'),
	('28', 'STOCK TRANSFERS', 'Collection of all STOCK TRANSFERS related features'),
	('29', 'PURCHASE ORDERS', 'Collection of all PURCHASE ORDERS related features'),
	('30', 'LOCATIONS', 'Collection of all Regions or Locations related features'),
	('31', 'LOCATION TYPES', 'Collection of all LOCATION TYPES related features'),
	('32', 'THANA MAPPING', 'Collection of all Business THANA vs Admin THANA Mapping related features'),
	('33', 'STOCK ALLOCATION', 'Collection of all Stock Allocation related features'),
    ('34', 'SECONDARY SALES ORDER', 'Collection of all Secondary Sales Order related features'),
    ('35', 'TERTIARY', 'Collection of all Invoice Generation related features'),
	('36', 'LOST AND FOUND INVENTORY', 'Collection of all Lost and Found Inventory related features'),
	('37', 'MOVE ORDERS', 'Collection of all MOVE ORDER related features'),
	('38', 'Users', 'Collection of all reseller related features'),
	('39', 'STORE MANAGEMENT', 'Collection of all store management related features'),
	('41', 'ERS MFS', 'Collection of all ERS MFS features');



INSERT INTO `resource` (`id`, `name`, `description`, `endpoints`)
VALUES
	('1', 'View All Partners', 'Resource to view only resellers page', '569,570,597,624,670'),
	('2', 'Create Partners', 'Resource to create a reseller', '542,146,208,520,521,572,567,594,668,587'),
	('3', 'Search Partners', 'Resource to search resellers', '593,624,543'),
	('4', 'Update Partners', 'Resource to update from list resellers and reseller info page', '625,583,542,146,208,520,521,572,567,594,668,587'),
	('5', 'Partner Parent Change', 'Resource to change parent of a reseller', '626,627,568,586,651,650,585'),
	('6', 'Partner Type Change', 'Resource to change type of a reseller', '627,636,573,580,637,668'),
	('7', 'Add Partners Users', 'Resource to approve/reject reseller auto transfer', '604,624'),
	('8', 'View Partners', 'Resource to view a reseller information', '542,146,208,520,521,572,567'),
	('9', 'Block/Unblock Partners', 'Resource to block/unblock reseller', '630,631,581'),
	('10', 'Freeze/Unfreeze Partners', 'Resource to freeze/unfreeze reseller', '632,633,581'),
	('11', 'Active/Deactive Partners', 'Resource to active/deactive reseller', '628,629,581'),
	('12', 'Expire password', 'Resource to expire current password of a reseller user', '545,634'),
	('13', 'Reset Password Attempts', 'Resource to reset password wrong attempts', '550,602'),
	('14', 'Reset Password', 'Resource to reset the current password', '544,546'),
	('15', 'Update Partners Users', 'Resource to edit reseller user informations', '600,572,602'),
	('16', 'Delete Partners Users', 'Resource to delete reseller user', '608,610'),
	('17', 'View All Partner Types', 'Resource to view all reseller types', '555,599'),
	('18', 'View Partner Type', 'Resource to view all reseller types', '609,567'),
	('19', 'Create Partner Type', 'Resource to create reseller type', '609,572,555,559,44'),
	('20', 'Update Partner Types', 'Resource to update reseller/reseller parent type informations', '607,560,44'),
	('21', 'View All Partner Roles', 'Resource to view all reseller roles list', '601,621,572'),
	('22', 'View Partner Role', 'Resource to view role information', '601,621,572,556'),
	('23', 'Create Partner Role', 'Resource to create a reseller role', '620,621,572,556,574'),
	('24', 'Update Partner Role', 'Resource to update a reseller role', '620,622,572,556,575'),
	('25', 'Delete Partner Role', 'Resource to delete a reseller role', '620,623,572,556,577'),
	('26', 'View All Password Policies', 'Resource to view password policies', '603,617,556,564'),
	('27', 'View Password Policy', 'Resource to view password policy', '603,617,556,564'),
	('28', 'Create Password Policy', 'Resource to create a password policy', '616,563'),
	('29', 'Update Password Policy', 'Resource to update a password policy', '618,565'),
	('30', 'Delete Password Policy', 'Resource to delete a password policy', '619,566'),
	('31', 'View All Template Dropdowns', 'Resource to view template dropdowns', '590,549,573,584'),
	('32', 'View Template Dropdown', 'Resource to view template dropdown', '584,549,573'),
	('33', 'Create Template Dropdown', 'Resource to create a template dropdown', '582,548,576'),
	('34', 'Update Template Dropdown', 'Resource to update a template dropdown', '586,580'),
	('35', 'Delete Template Dropdown', 'Resource to delete a template dropdown', '588,578'),
	('36', 'View All Product Catogories', 'Resource to view all product catogories', '426,438,453'),
	('37', 'View Product Catogory', 'Resource to view a specific product catogory', '426,438,436,453,455'),
	('38', 'Create Product Category', 'Resource to create a product category', '437,451,463,451'),
	('39', 'Edit Product Category', 'Resource to edit / upate a product category', '439,452,463'),
	('40', 'Delete Product Category', 'Resource to delete a product category', '439,454,463,799'),
	('41', 'View all Products', 'Resource to view all products', '427,430,443,424'),
	('42', 'View Product', 'Resource to view a specific product', '428,430,443,424,463'),
	('43', 'Create Product', 'Resource to create a product', '429,440,482,504,503,441,434,799'),
	('44', 'Edit Product', 'Resource to edit / update a product', '431,440,482,504,503,441,434,799'),
	('45', 'View Product Variants', 'Resource to view product variants of a product', '432,434'),
	('46', 'View Product Variant', 'Resource to view a specific product variants of a product', '432,434'),
	('47', 'Create Product Variant', 'Resource to create a product variant of a product', '432,446,447,799'),
	('48', 'Edit Product Variant', 'Resource to edit / update a product variant of a product', '435,434,448,799'),
	('51', 'View all Channels', 'Resource to view all Channels', '747,748,208'),
	('52', 'View Channel', 'Resource to view a specific channel', '747,748,208'),
	('53', 'Create Channel', 'Resource to create a Channel', '747,748,751,209'),
	('54', 'Edit Channel', 'Resource to edit / update a Channel', '750,217,212,793'),
	('55', 'View All Reports', 'Resource to view all reports', '527,528,529,530,541,208,214,532,534,536,537,538,539,556,570,781'),
	('56', 'View Audit', 'Resource to view audit', '531,532,533,539'),
	('57', 'View All Account Types', 'Resource to view all account types', '29,35,43,62'),
	('58', 'View Account Type', 'Resource to view account type', '33,44'),
	('59', 'Create Account Type', 'Resource to create account type', '32,41'),
	('60', 'Update Account Type', 'Resource to update account type information', '34,42'),
	('61', 'Delete Account Type', 'Resource to delete account type', '45'),
	('62', 'View All Accounts', 'Resource to view all accounts', '31,40,55,56'),
	('63', 'View Account', 'Resource to view account information', '38,55,56'),
	('64', 'Search Account', 'Resource to search accounts', '39,64,65'),
	('65', 'Create Account', 'Resource to create account', '37,53'),
	('66', 'Update Account', 'Resource to update account', '54'),
	('67', 'Delete Account', 'Resource to delete account', '57'),
	('70', 'View All Contracts', 'Resource to view all contracts', '132,135,146,147,148,149'),
	('71', 'View Contract', 'Resource to view contract information', '162,144,146,147,148,149'),
	('72', 'Create Contract', 'Resource to create contract', '133,161,143,146,147,148,149,653,521'),
	('73', 'Search Contract', 'Resource to search contract', '144,147,148'),
	('74', 'Update Contract', 'Resource to update contract', '134,163,145,126,143,146,147,148,149,653,521'),
	('75', 'Clone Contract', 'Resource to clone an existing contract', '137,128,126,653,521'),
	('76', 'Export Contract', 'Resource to export contract', '789,130'),
	('77', 'View All Product Range & Rules', 'Resource to view all price rules defined in a contract', '139,152,153,154,155,156,127,144,146'),
	('78', 'View Product Range & Rules', 'Resource to view price rules information', '139,152,153,154,155,156,127,144,146'),
	('79', 'View Range & Rules Information', 'Resource to view product range & rules', '139,152,153,154,155,156,127,144,146'),
	('80', 'Update Margin', 'Resource to update margin rule', '140,127,129,144,152,153,154,155,156,157'),
	('81', 'Export Margin', 'Resource to export margin rule', '130'),
	('82', 'Delete Margin', 'Resource to delete margin rule', '141,158'),
	('83', 'Active/Deactive Margin', 'Resource to active/deactive margin rule', '142,159'),
	('84', 'Add Margin', 'Resource to add new margin rule', '138,144,424,453,455,151,152,153,154,155,156,127,129'),
	('85', 'Approve/Reject Contract', 'Resource to approve/reject a contract', '791,145'),
	('86', 'View margin and rules', 'Resource to view margin rules in contract', '136,144,146'),
	('90', 'View All POS Type Rules', 'Resource to view all POSTypes rules', '760,761,762'),
	('91', 'View POS Type Rule', 'Resource to view POSTypes rule', '771,761,766'),
	('92', 'Create POS Type rule', 'Resource to create POS Types rule', '759,765,131'),
	('93', 'Update POS Type rule', 'Resource to update POS Types rule', '772,773'),
	('94', 'Delete POS Type Rule', 'Resource to remove POS Type rules', NULL),
	('95', 'View All Import Jobs', 'Resource to view all import jobs', '92,93,83,95'),
	('96', 'View Import Job', 'Resource to view all import job', '91,82,87,94,100'),
	('97', 'Submit Import Job', 'Resource to import job', '90,99,81,84,86,96,98,582,590,595,758,799,813'),
	('98', 'Approve/Reject Import Jobs', 'Resource to approve/Reject import job', '795,796,797'),
	('99', 'Resubmit Import Job', 'Resource to resubmit import job', '798,101'),
	('100', 'View All Policies', 'Resource to view all policies', '660,657,655,11,776'),
	('101', 'View Policy', 'Resource to view policy information', '655,11,776'),
	('102', 'Create Policy', 'Resource to create new policy', '779,775'),
	('103', 'Update Policy', 'Resource to update policy', '779,775'),
	('104', 'Clone Policy', 'Resource to clone an existing policy', '16,776,775'),
	('105', 'Delete Policy', 'Resource to delete policy', '778'),
	('106', 'View & Manage All Policy Mappings', 'Resource to view and manage all policy mappings', '660,657,655,780,789'),
	('107', 'View & Manage Policy Mappings', 'Resource to view and manage policy mapping', '660,657,655,780,789,790'),
	('108', 'Create Policy Mappings', 'Resource to crete policy mappings', '660,657,655,780,789,555,572,11,791'),
	('109', 'Update Policy Mappings', 'Resource to update policy mappings', '780'),
	('110', 'Delete Policy Mappings', 'Resource to delete policy mappings', '792'),
	('111', 'Search KYC', 'Resource Search the KYC data by some params to view', '281,283,273'),
	('112', 'View KYC Data', 'Resource to view the KYC data', '282,284,274'),
	('113', 'Edit KYC Data', 'Resource to view the KYC data', '803,807'),
	('114', 'View ALL Pending KYC', 'Resource to view the KYC data', '282,284,274'),
	('115', 'Approve/Reject ALL Pending KYC', 'Resource to Approve the KYC data', '803,807'),
	('116', 'Edit Pending KYC Data', 'Resource to Edit the KYC data', '803,807'),
	('117', 'Register Partner KYC', 'Resource to Register the KYC data', '280,285,208,755,668,755,653,521,567,593,146,271'),
	('118', 'Register Partner User KYC', 'Resource to Register the KYC data', '803,807'),
	('125', 'View ALL Orders', 'Resource to view the order list data', '380,383,364,375,422,365'),
	('126', 'Search Orders', 'Resource to search the order data by search params', '380,383,364,375,422,365'),
	('127', 'View Order Data', 'Resource to view the KYC data', '803,807'),
	('128', 'Orders Action2', 'Resource to view the KYC data', '803,807'),
	('129', 'Orders Action3', 'Resource to view the KYC data', '803,807'),
	('130', 'Stock Transfer', 'Resource to view the KYC data', '803,807'),
	('131', 'Stock Transfer Action1', 'Resource to view the KYC data', '803,807'),
	('132', 'Stock Transfer Action2', 'Resource to view the KYC data', '803,807'),
	('133', 'Stock Transfer Action3', 'Resource to view the KYC data', '803,807'),
	('134', 'Purchase Orders', 'Resource to view the KYC data', '744,364,458,734,653,572,668,453,506,503,446,735,487,745,398,379'),
	('135', 'Orders PO Payments', 'Module feature mapping for PO payments', '795,364,365,391,801,802,803,804,805'),
	('136', 'Orders cancel order', 'Mappings for cancel order', '796'),
	('137', 'Orders GRN', 'Mappings for order grn', '794,453,506,442'),
	('138', 'Purchase Orders Action4', 'Resource to view the KYC data', '803,807'),
	('139', 'Purchase Orders Action5', 'Resource to view the KYC data', '803,807'),
	('145', 'View All Locations', 'Resource to view all the Location/Region data list', '512,516,521,523,526,519'),
	('146', 'Search Location', 'Resource to search the Location/Region data', '512,516,521,523,524,526'),
	('147', 'View Location Data', 'Resource to view the Location/Region data', '512,516,521,523,524,526,519'),
	('148', 'Create Location', 'Resource to create a Location/Region data', '517,522,523'),
	('149', 'Edit Location', 'Resource to Edit a Location/Region data', '525'),
	('150', 'Bulk Location', 'Resource to Add/Update bulk Location/Region data', '803,807'),
	('151', 'View All Location Types', 'Resource to view all Location Types data', '510,512,513,518'),
	('152', 'View Location Type', 'Resource to view Location Type data', '505510,512,513,518'),
	('153', 'Ctreate Location Type', 'Resource to Create Location Type data', '511,513,523'),
	('154', 'Edit Location Type', 'Resource to Edit Location Type data', '509,514'),
	('155', 'View Thana Mapping', 'Resource to view Thana mapping data', '728,729'),
	('156', 'Create Thana Mapping', 'Resource to create Thana mapping data', '730,731'),
	('157', 'Edit Thana Mapping', 'Resource to edit Thana mapping data', '732'),
	('160', 'View All Routes', 'Resource to View Route data list', '752,753,208'),
	('161', 'Search Route', 'Resource to Search Route data', '752,753,208'),
	('162', 'View Route Detail', 'Resource to view Route detail data', '755,208'),
	('163', 'Create Route', 'Resource to Create Route data', '756,593,788'),
	('164', 'Edit Route', 'Resource to Edit Route data', '756,593,787,213'),
	('165', 'Delete Route', 'Resource to Delete Route data', '756,212'),
	('166', 'Add SE and POS to Route', 'Resource to Add POS Route data', '217'),
	('167', 'Bulk Add/Edit Route', 'Resource to Add/Edit Bulk POS Route data', '803,807'),
	('168', 'View All Taxes', 'Resource to view All Taxes', '458,460,501'),
	('169', 'View Tax', 'Resource to view tax', '458,460,501,498'),
	('170', 'Create Tax', 'Resource to create tax', '499,456'),
	('171', 'Update Tax', 'Resource to update tax', '500,457'),
	('172', 'Delete Tax', 'Resource to delete tax', '502,459'),
	('173', 'View All Product Quata', 'Resource to view All Product Quata', '413,734,418'),
	('174', 'View Product Quata', 'Resource to view Product Quata', '735,418'),
	('175', 'Create Product Quata', 'Resource to create Product Quata', '416,555,504,554,503,736'),
	('176', 'Update Product Quata', 'Resource to update Product Quata', '417,555,504,554,503'),
	('177', 'Bulk Upload Product Quata', 'Resource to upload Product Quata in bulk', '739,746'),
	('178', 'Download Product Quata', 'Resource to download Product Quata', '740'),
	('179', 'Delete Product Quata', 'Resource to delete Product Quata', '419,738'),
	('180', 'Delete Partner Types', 'Resources to Delete Partner Types', '611,591'),
	('300', 'Login', 'Resource required for user login', '7,579,652,653,364,537,538'),
	('301', 'View Profile', 'Resource required for viewing profile', '579,652,653,670,423'),
	('302', 'Change Password', 'Resource required for change password', '221,568'),
	('303', 'Third Party Integrations For Route', 'Third Party Integrations For Route', '800'),
    ('304', 'Third Party Integrations For Product', 'Third Party Integrations For Product', '445,453'),
    ('305', 'Raise Order', 'Raise Order for Stock Allocation', '593,487,503,504,379,810,554'),
    ('306', 'Raise Order', 'Raise Order for Secondary Sales Order (SSO)', '593,487,208,504,503,379,745,811'),
    ('307', 'Search Invoice', 'Search Invoice feature for Tertiary module', '814,815'),
    ('308', 'Third Party Integrations For Order', 'Third Party Integrations For Order', '366,378'),
	('309', 'Lost And Found Inventory Approval or Rejection', 'Approval or Rejection of Lost And Found Inventory Request', '825, 826, 827, 828, 829, 830, 834'),
	('310', 'Move Order', 'Resource to view the KYC data', '744,364,458,734,653,572,668,453,506,503,446,735,487,745,398,379,833'),
	('311', 'View Users', 'Resource to view the lists of users', '841,840'),
	('312', 'View User', 'Resource to view a particular user', '847,840,669'),
	('313', 'Edit User', 'Resource to edit a particular user', '846,840,669,602,583'),
	('314', 'Activate User', 'Resource to Activate an user', '849,847,840,847,602,583'),
	('315', 'Suspend User', 'Resource to Suspend an user', '848,847,602,583'),
	('316', 'Reset Password User', 'Resource to reset password of an user', '847,546,544'),
	('317', 'Expire Password User', 'Resource to expire of an user', '634,847,545'),
	('318', 'Reset Wrong Password Attempts', 'Resource to reset wrong password attempts of an user', '847,602,550'),
	('319', 'Vault Register', 'Vault register related features', '855'),
	('320', 'Vault Withdrawal', 'Vault withdrawal related features', '856'),
	('326', 'View ERS MFS page', 'Resource to view ERS MFS ', '858,859');





INSERT INTO `resource_mapping` (`id`, `master_resource_id`, `resource_id`)
VALUES
	('1', '1', '300'),
	('2', '1', '301'),
	('3', '1', '302'),
	('4', '2', '1'),
	('5', '2', '2'),
	('6', '2', '3'),
	('7', '2', '4'),
	('8', '2', '5'),
	('9', '2', '6'),
	('10', '2', '7'),
	('11', '2', '8'),
	('12', '2', '9'),
	('13', '2', '10'),
	('14', '2', '11'),
	('15', '2', '12'),
	('16', '2', '13'),
	('17', '2', '14'),
	('18', '2', '15'),
	('19', '2', '16'),
	('20', '3', '17'),
	('21', '3', '18'),
	('22', '3', '19'),
	('23', '3', '20'),
	('24', '4', '21'),
	('25', '4', '22'),
	('26', '4', '23'),
	('27', '4', '24'),
	('28', '4', '25'),
	('29', '5', '26'),
	('30', '5', '27'),
	('31', '5', '28'),
	('32', '5', '29'),
	('33', '5', '30'),
	('34', '6', '31'),
	('35', '6', '32'),
	('36', '6', '33'),
	('37', '6', '34'),
	('38', '6', '35'),
	('39', '7', '51'),
	('40', '7', '52'),
	('41', '7', '53'),
	('42', '7', '54'),
	('43', '8', '36'),
	('44', '8', '37'),
	('45', '8', '38'),
	('46', '8', '39'),
	('47', '8', '40'),
	('48', '9', '41'),
	('49', '9', '42'),
	('50', '9', '43'),
	('51', '9', '44'),
	('52', '9', '45'),
	('53', '9', '46'),
	('54', '9', '47'),
	('55', '9', '48'),
	('56', '10', '168'),
	('57', '10', '169'),
	('58', '10', '170'),
	('59', '10', '171'),
	('60', '10', '172'),
	('61', '11', '90'),
	('62', '11', '91'),
	('63', '11', '92'),
	('64', '11', '93'),
	('65', '11', '94'),
	('66', '12', '173'),
	('67', '12', '174'),
	('68', '12', '175'),
	('69', '12', '176'),
	('70', '12', '177'),
	('71', '12', '178'),
	('72', '12', '179'),
	('73', '13', '160'),
	('74', '13', '161'),
	('75', '13', '162'),
	('76', '13', '163'),
	('77', '13', '164'),
	('78', '13', '165'),
	('79', '13', '166'),
	('80', '14', '55'),
	('81', '15', '56'),
	('82', '16', '57'),
	('83', '16', '58'),
	('84', '16', '59'),
	('85', '16', '60'),
	('86', '16', '61'),
	('87', '17', '62'),
	('88', '17', '63'),
	('89', '17', '64'),
	('90', '17', '65'),
	('91', '17', '66'),
	('92', '17', '67'),
	('93', '18', '70'),
	('94', '18', '71'),
	('95', '18', '72'),
	('96', '18', '73'),
	('97', '18', '74'),
	('98', '18', '75'),
	('99', '18', '76'),
	('100', '18', '77'),
	('101', '18', '78'),
	('102', '18', '79'),
	('103', '18', '80'),
	('104', '18', '81'),
	('105', '18', '82'),
	('106', '18', '83'),
	('107', '18', '84'),
	('108', '18', '85'),
	('109', '18', '86'),
	('110', '19', '95'),
	('111', '19', '96'),
	('112', '19', '97'),
	('113', '19', '98'),
	('114', '19', '99'),
	('115', '20', '100'),
	('116', '20', '101'),
	('117', '20', '102'),
	('118', '20', '103'),
	('119', '20', '104'),
	('120', '20', '105'),
	('121', '21', '106'),
	('122', '21', '107'),
	('123', '21', '108'),
	('124', '21', '109'),
	('125', '21', '110'),
	('126', '23', '111'),
	('127', '23', '112'),
	('128', '23', '113'),
	('129', '24', '114'),
	('130', '24', '115'),
	('131', '24', '116'),
	('132', '25', '117'),
	('133', '26', '118'),
	('147', '27', '125'),
	('148', '27', '126'),
	('149', '27', '127'),
	('150', '27', '128'),
	('151', '27', '129'),
	('152', '28', '130'),
	('153', '28', '131'),
	('154', '28', '132'),
	('155', '28', '133'),
	('156', '29', '134'),
	('157', '29', '135'),
	('158', '29', '136'),
	('159', '29', '137'),
	('160', '29', '138'),
	('161', '29', '139'),
	('134', '30', '145'),
	('135', '30', '146'),
	('136', '30', '147'),
	('137', '30', '148'),
	('138', '30', '149'),
	('139', '30', '150'),
	('140', '31', '151'),
	('141', '31', '152'),
	('142', '31', '153'),
	('143', '31', '154'),
	('144', '32', '155'),
	('145', '32', '156'),
	('146', '32', '157'),
	('162', '27', '135'),
	('163', '27', '136'),
	('164', '27', '137'),
	('165', '13', '303'),
    ('166', '9', '304'),
    ('167', '33', '305'),
    ('168', '34', '306'),
    ('169', '35', '307'),
    ('170', '27', '308'),
	('171', '36', '309'),
	('172', '37', '311'),
	('173', '38', '312'),
	('174', '38', '313'),
	('175', '38', '314'),
	('176', '38', '315'),
	('177', '38', '316'),
	('178', '38', '317'),
	('179', '38', '318'),
	('180', '39', '319'),
	('181', '39', '320'),
	('187', '41', '326');



    INSERT INTO `policy` (`id`, `name`, `description`, `available_from`, `available_until`)
    VALUES
        (1, 'Operator Core User Policy', 'This is a Operator Core User Policy', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
        (2, 'Distributor Manager Policy', 'This is policy related to Distributor Manager', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
	    (3, 'GPC Policy', 'This is policy related to GPC', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
	    (4, 'KYC ALL policy', 'This is kyc all policy', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
        (5, 'KYC Search Policy', 'This is KYC Search Policy', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
        (6, 'KYC Register Policy', 'This is a KYC register Policy', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
        (7, 'KYC Search and Register Policy', 'This is a KYC Search and Register Policy', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
        (8, 'RMS Core Admin Policy', 'RMS Core Admin can update BCU, GPC, and GPCF (Non GP)', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
        (9, 'Cluster Manager Policy', 'Cluster Manager can update Non GP users under Distributor hierarchy', '2021-02-12 11:51:14', '2099-01-01 00:00:00'),
        (10, 'Centre Head Policy', 'Centre Head can add Non GP users for GPC and GPCF centres', '2021-02-12 11:51:14', '2099-01-01 00:00:00');

INSERT INTO `policy_resource_mapping_applied` (`policy_id`, `master_resource_id`, `resource_id`)
VALUES
	('1', '1', '300'),
	('1', '1', '301'),
	('1', '1', '302'),
	('1', '2', '1'),
	('1', '2', '2'),
	('1', '2', '3'),
	('1', '2', '4'),
	('1', '2', '5'),
	('1', '2', '6'),
	('1', '2', '7'),
	('1', '2', '8'),
	('1', '2', '9'),
	('1', '2', '10'),
	('1', '2', '11'),
	('1', '2', '12'),
	('1', '2', '13'),
	('1', '2', '14'),
	('1', '2', '15'),
	('1', '2', '16'),
	('1', '3', '17'),
	('1', '3', '18'),
	('1', '3', '19'),
	('1', '3', '20'),
	('1', '4', '21'),
	('1', '4', '22'),
	('1', '4', '23'),
	('1', '4', '24'),
	('1', '4', '25'),
	('1', '5', '26'),
	('1', '5', '27'),
	('1', '5', '28'),
	('1', '5', '29'),
	('1', '5', '30'),
	('1', '6', '31'),
	('1', '6', '32'),
	('1', '6', '33'),
	('1', '6', '34'),
	('1', '6', '35'),
	('1', '7', '51'),
	('1', '7', '52'),
	('1', '7', '53'),
	('1', '7', '54'),
	('1', '8', '36'),
	('1', '8', '37'),
	('1', '8', '38'),
	('1', '8', '39'),
	('1', '8', '40'),
	('1', '9', '41'),
	('1', '9', '42'),
	('1', '9', '43'),
	('1', '9', '44'),
	('1', '9', '45'),
	('1', '9', '46'),
	('1', '9', '47'),
	('1', '9', '48'),
	('1', '10', '168'),
	('1', '10', '169'),
	('1', '10', '170'),
	('1', '10', '171'),
	('1', '10', '172'),
	('1', '11', '90'),
	('1', '11', '91'),
	('1', '11', '92'),
	('1', '11', '93'),
	('1', '11', '94'),
	('1', '12', '173'),
	('1', '12', '174'),
	('1', '12', '175'),
	('1', '12', '176'),
	('1', '12', '177'),
	('1', '12', '178'),
	('1', '12', '179'),
	('1', '13', '160'),
	('1', '13', '161'),
	('1', '13', '162'),
	('1', '13', '163'),
	('1', '13', '164'),
	('1', '13', '165'),
	('1', '13', '166'),
	('1', '14', '55'),
	('1', '15', '56'),
	('1', '16', '57'),
	('1', '16', '58'),
	('1', '16', '59'),
	('1', '16', '60'),
	('1', '16', '61'),
	('1', '17', '62'),
	('1', '17', '63'),
	('1', '17', '64'),
	('1', '17', '65'),
	('1', '17', '66'),
	('1', '17', '67'),
	('1', '18', '70'),
	('1', '18', '71'),
	('1', '18', '72'),
	('1', '18', '73'),
	('1', '18', '75'),
	('1', '18', '76'),
	('1', '18', '77'),
	('1', '18', '78'),
	('1', '18', '79'),
	('1', '18', '81'),
	('1', '18', '85'),
	('1', '18', '86'),
	('1', '19', '95'),
	('1', '19', '96'),
	('1', '19', '97'),
	('1', '19', '98'),
	('1', '19', '99'),
	('1', '20', '100'),
	('1', '20', '101'),
	('1', '20', '102'),
	('1', '20', '103'),
	('1', '20', '104'),
	('1', '20', '105'),
	('1', '21', '106'),
	('1', '21', '107'),
	('1', '21', '108'),
	('1', '21', '109'),
	('1', '21', '110'),
	('1', '23', '111'),
	('1', '23', '112'),
	('1', '24', '115'),
	('1', '24', '116'),
	('1', '25', '117'),
	('1', '26', '118'),
	('1', '27', '125'),
	('1', '27', '126'),
	('1', '27', '127'),
	('1', '27', '128'),
	('1', '27', '129'),
	('1', '28', '130'),
	('1', '28', '131'),
	('1', '28', '132'),
	('1', '28', '133'),
	('1', '29', '134'),
	('1', '29', '135'),
	('1', '29', '136'),
	('1', '29', '137'),
	('1', '29', '138'),
	('1', '29', '139'),
	('1', '30', '145'),
	('1', '30', '146'),
	('1', '30', '147'),
	('1', '30', '148'),
	('1', '30', '149'),
	('1', '30', '150'),
	('1', '31', '151'),
	('1', '31', '152'),
	('1', '31', '153'),
	('1', '32', '155'),
	('1', '32', '156'),
	('1', '32', '157'),
	('1', '13', '303'),
    ('1', '9', '304'),
    ('2', '35', '307'),
    ('1', '27', '308'),
	('2' , '8' ,  '36'),
	('2' , '8' ,  '37'),
	('2' , '9' ,  '41'),
	('2' , '9' ,  '42'),
	('2' , '9' ,  '45'),
	('2' , '9' ,  '46'),
	('2' , '18' , '70'),
	('2' , '18' , '71'),
	('2' , '18' , '73'),
	('2' , '18' , '76'),
	('2' , '18' , '77'),
	('2' , '18' , '78'),
	('2' , '18' , '79'),
	('2' , '18' , '81'),
	('2' , '18' , '86'),
	('2' , '27' , '125'),
	('2' , '27' , '126'),
	('2' , '28' , '130'),
	('2' , '28' , '131'),
	('2' , '28' , '132'),
	('2' , '28' , '133'),
	('2' , '13' , '160'),
	('2' , '13' , '161'),
	('2' , '13' , '162'),
	('2' , '13' , '163'),
	('2' , '13' , '164'),
	('2' , '13' , '165'),
	('2' , '13' , '166'),
	('2' , '12' , '173'),
	('2' , '12' , '174'),
	('2' , '1' ,  '300'),
	('2' , '1' ,  '301'),
	('2' , '1' ,  '302'),
	('2' , '13' , '303'),
	('2' , '33' , '305'),
	('2' , '34' , '306'),
	('3', '37', '310');

INSERT INTO `resellertype_policy_map` (`reseller_type`, `user_role`, `policy_id`)
VALUES
    ('OPERATOR', 'core', 1),
    ('DIST', 'dm', 2),
    ('OPERATOR', NULL, 1),
    ('GPC', NULL, '3'),
    ('BCU', 'core', 1),
    ('BCU', 'clm', 9),
    ('BCU', 'rca', 8),
    ('DIST', 'dtu', 7),
    ('DIST', 'log', 4),
	('BCU', 'gpch', 10);

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('Operator Core User Policy')
    and (me.`module_feature` NOT IN ('REGION_TYPE_UPDATE', 'RESELLER_ADDRESS_INFO', 'RESELLER_CONTRACT_INFO', 'RESELLER_ADDITIONAL_INFO','RESELLER_USER_INFO','RESELLER_ACCOUNT_INFO', 'ADD_UNIT_PRODUCT','EDIT_KYC_RECORD','EDIT_KYC_RECORD_IN_APPROVAL_VIEW','ADD_PRODUCT_RULES','DELETE_PRODUCT_RULES','EDIT_CONTRACT','UPDATE_CONTRACT','UPDATE_PRODUCT_RULES') OR me.module_feature IS NULL );


INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('Distributor Manager Policy')
    and ( me.`module_feature` NOT IN ('REGION_TYPE_UPDATE','REGION_VIEW','REGION_TYPE_VIEW','REGION_TYPE_LIST','REGION_TYPE_CREATE','REGION_LIST','REGION_CREATE',
    'VIEW_THANA_MAPPINGS','CREATE_THANA_MAPPING','REGION_UPDATE','UPDATE_THANA_MAPPING','v1importstockallocationPOST','EDIT_PRODUCT', 'EDIT_PRODUCT_VARIANT','DELETE_PRODUCT','DELETE_PRODUCT_VARIANT','RESELLER_ADDRESS_INFO', 'RESELLER_CONTRACT_INFO', 'RESELLER_ADDITIONAL_INFO','RESELLER_USER_INFO','RESELLER_ACCOUNT_INFO', 'ADD_UNIT_PRODUCT','EDIT_KYC_RECORD','EDIT_KYC_RECORD_IN_APPROVAL_VIEW','ADD_PRODUCT_RULES','DELETE_PRODUCT_RULES','EDIT_CONTRACT','UPDATE_CONTRACT','UPDATE_PRODUCT_RULES','CREATE_CONTRACT','CLONE_CONTRACT','CREATE_CONTRACT_ACTIVE_STATUS','CREATE_PRODUCT_QUOTA_VIA_FILE','EDIT_PRODUCT_QUOTA','CREATE_PRODUCT_QUOTA','DELETE_PRODUCT_QUOTA', 'APPROVE_INVENTORY_LOST_AND_FOUND', 'REJECT_INVENTORY_LOST_AND_FOUND') OR me.module_feature IS NULL );

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('GPC Policy')
    and ( me.`module_feature` NOT IN ('REGION_TYPE_UPDATE','REGION_VIEW','REGION_TYPE_VIEW','REGION_TYPE_LIST','REGION_TYPE_CREATE','REGION_LIST','REGION_CREATE',
    'VIEW_THANA_MAPPINGS','CREATE_THANA_MAPPING','REGION_UPDATE','UPDATE_THANA_MAPPING','v1importstockallocationPOST','EDIT_PRODUCT', 'EDIT_PRODUCT_VARIANT','DELETE_PRODUCT','DELETE_PRODUCT_VARIANT','RESELLER_ADDRESS_INFO', 'RESELLER_CONTRACT_INFO', 'RESELLER_ADDITIONAL_INFO','RESELLER_USER_INFO','RESELLER_ACCOUNT_INFO', 'ADD_UNIT_PRODUCT','EDIT_KYC_RECORD','EDIT_KYC_RECORD_IN_APPROVAL_VIEW','ADD_PRODUCT_RULES','DELETE_PRODUCT_RULES','EDIT_CONTRACT','UPDATE_CONTRACT','UPDATE_PRODUCT_RULES','CREATE_CONTRACT','CLONE_CONTRACT','CREATE_CONTRACT_ACTIVE_STATUS','CREATE_PRODUCT_QUOTA_VIA_FILE','EDIT_PRODUCT_QUOTA','CREATE_PRODUCT_QUOTA','DELETE_PRODUCT_QUOTA', 'APPROVE_INVENTORY_LOST_AND_FOUND', 'REJECT_INVENTORY_LOST_AND_FOUND') OR me.module_feature IS NULL );



INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'kyc' );

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'dms' and me.`endpoint` ='v1/resellers/types/.*' and module_feature is null);

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'dms' and me.`endpoint` ='auth/getResellerInfo' and module_feature is null and http_method='POST');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'template' and me.`endpoint` ='v1/component/.*/type/.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'rgms' and me.`endpoint` ='v2/region.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'dms' and me.`endpoint` ='auth/searchResellersByAttribute' and module_feature is null and http_method='POST');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'access' and me.`endpoint` ='v1/features/resellerType/.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'groupmanagementsystem' and me.`endpoint` ='v1/group.*' and module_feature ='' and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'assetmanagement' and me.`endpoint` ='v1/asset/type/.*'  and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC ALL policy')
    and (me.`component_name` = 'acms' and me.`endpoint` ='v2/contracts.*'  and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search Policy')
    and (me.`component_name` = 'access' and me.`endpoint` ='v1/features/resellerType/.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search Policy')
    and (me.`component_name` = 'dms' and me.`endpoint` ='auth/getResellerInfo' and module_feature is null and http_method='POST');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search Policy')
    and (me.`component_name` = 'kyc'  and module_feature ='SEARCH');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search Policy')
    and (me.`component_name` = 'kyc'  and module_feature ='SEARCH_KYC');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search Policy')
    and (me.`component_name` = 'kyc' and me.`endpoint` ='v2/kyc'  and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register Policy')
    and (me.`component_name` = 'access' and me.`endpoint` ='v1/features/resellerType/.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register Policy')
    and (me.`component_name` = 'dms' and me.`endpoint` ='auth/getResellerInfo' and module_feature is null and http_method='POST');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register Policy')
    and (me.`component_name` = 'kyc'  and module_feature ='REGISTER');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register Policy')
    and (me.`component_name` = 'kyc'  and module_feature ='REGISTER_KYC');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register Policy')
    and (me.`component_name` = 'kyc' and me.`endpoint` ='v2/kyc'  and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register policy')
    and (me.`component_name` = 'groupmanagementsystem' and me.`endpoint` ='v1/group.*' and module_feature ='' and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register policy')
    and (me.`component_name` = 'template' and me.`endpoint` ='v1/component/.*/type/.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register policy')
    and (me.`component_name` = 'assetmanagement' and me.`endpoint` ='v1/asset/type/.*'  and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register policy')
    and (me.`component_name` = 'rgms' and me.`endpoint` ='v2/region.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register policy')
    and (me.`component_name` = 'dms' and me.`endpoint` ='v1/resellers/types/.*' and module_feature is null);

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Register policy')
    and (me.`component_name` = 'acms' and me.`endpoint` ='v2/contracts.*'  and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'access' and me.`endpoint` ='v1/features/resellerType/.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'dms' and me.`endpoint` ='auth/getResellerInfo' and module_feature is null and http_method='POST');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'kyc'  and module_feature ='SEARCH');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'kyc'  and module_feature ='SEARCH_KYC');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'kyc' and me.`endpoint` ='v2/kyc'  and http_method='GET');





INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'kyc'  and module_feature ='REGISTER');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'kyc'  and module_feature ='REGISTER_KYC');



INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'groupmanagementsystem' and me.`endpoint` ='v1/group.*' and module_feature ='' and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'template' and me.`endpoint` ='v1/component/.*/type/.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'assetmanagement' and me.`endpoint` ='v1/asset/type/.*'  and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'rgms' and me.`endpoint` ='v2/region.*' and module_feature is null and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'dms' and me.`endpoint` ='v1/resellers/types/.*' and module_feature is null);

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'acms' and me.`endpoint` ='v2/contracts.*'  and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'kyc'  and module_feature='v2kycPOST' and http_method='POST');


INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'imsbridge'  and module_feature='changePasswordPOST' and http_method='POST');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'dms'  and module_feature='v1rolesGET' and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'dms'  and me.`endpoint` ='auth/searchResellersByAttribute' and http_method='POST');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'dms'  and me.`endpoint` ='v1/resellers/resellerChildren/.*' and http_method='GET');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'dms'  and module_feature='USERS');

INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
    SELECT  p.`id`, me.`id` FROM `policy` p, `module_endpoints` me  WHERE p.`name` IN ('KYC Search and Register Policy')
    and (me.`component_name` = 'dms'  and module_feature='v1getAllResellerUsersGET' and http_method='GET');


-- RMS Core Admin Policy: Administrative access for RMS core admins
INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
SELECT p.`id`, me.`id` 
FROM `policy` p, `module_endpoints` me  
WHERE p.`name` IN ('RMS Core Admin Policy')
AND (
    -- Access Control: View reseller type features
    (me.`component_name` = 'access' AND me.`endpoint` = 'v1/features/resellerType/.*' AND me.`http_method` = 'GET')
    
    -- DMS: Extended reseller management access
    OR (me.`component_name` = 'dms' AND (
        me.`endpoint` IN (
            'auth/getResellerInfo',
            'v1/resellers/types/.*',
            'auth/searchResellersByAttribute',
            'v1/resellers/resellerChildren/.*',
            'v2/auth/changePassword'
        )
        OR me.`module_feature` IN ('v1rolesGET', 'USERS', 'v1getAllResellerUsersGET', 'RESELLER_GET_INFO', 'CHANGE_RESELLER_PASSWORD')
    ))
    
    -- KYC: Extended KYC operations access
    OR (me.`component_name` = 'kyc' AND (
        me.`module_feature` IN ('SEARCH', 'SEARCH_KYC', 'REGISTER', 'REGISTER_KYC', 'v2kycPOST')
        OR (me.`endpoint` = 'v2/kyc' AND me.`http_method` = 'GET')
    ))
    
    -- Group Management: View group data
    OR (me.`component_name` = 'groupmanagementsystem' AND me.`endpoint` = 'v1/group.*' AND me.`http_method` = 'GET')
    
    -- Template: Access to all component templates
    OR (me.`component_name` = 'template' AND (
        me.`endpoint` IN ('v1/component/.*/type/.*', 'v1/component/DMS/type/.*') 
        AND me.`http_method` = 'GET'
    ))
    
    -- Asset Management: View asset types
    OR (me.`component_name` = 'assetmanagement' AND me.`endpoint` = 'v1/asset/type/.*' AND me.`http_method` = 'GET')
    
    -- Region Management: View region data
    OR (me.`component_name` = 'rgms' AND me.`endpoint` = 'v2/region.*' AND me.`http_method` = 'GET')
    
    -- Contract Management: View contracts
    OR (me.`component_name` = 'acms' AND me.`endpoint` = 'v2/contracts.*' AND me.`http_method` = 'GET')
    
    -- Order Management: View order payment types
    OR (me.`component_name` = 'oms' AND me.`endpoint` = 'v2/order-payment-types')
    
    -- Business Intelligence: View metadata
    OR (me.`component_name` = 'bi-engine' AND me.`endpoint` IN ('v1/metadata/.*', 'v1/metadata'))
    
    -- Portal: Access profile menu
    OR (me.`component_name` = 'portal' AND me.`endpoint` = '' AND me.`module_feature` = 'PROFILE_MENU')
    
    -- Password Management: Change password
    OR (me.`component_name` = 'imsbridge' AND me.`module_feature` = 'changePasswordPOST' AND me.`http_method` = 'POST')
)
AND (
    me.`module_feature` IS NULL 
    OR me.`module_feature` = ''
    OR me.`module_feature` IN (
        'SEARCH', 'SEARCH_KYC', 'REGISTER', 'REGISTER_KYC', 'v2kycPOST',
        'v1rolesGET', 'USERS', 'v1getAllResellerUsersGET', 'changePasswordPOST',
        'RESELLER_GET_INFO', 'CHANGE_RESELLER_PASSWORD', 'PROFILE_MENU'
    )
);

-- Cluster Manager Policy: Access for cluster managers
INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
SELECT p.`id`, me.`id` 
FROM `policy` p
INNER JOIN `module_endpoints` me ON 1=1
WHERE p.`name` = 'Cluster Manager Policy'
AND (
    -- Access Control: View reseller type features
    (me.`component_name` = 'access' AND me.`endpoint` = 'v1/features/resellerType/.*' AND me.`module_feature` = '' AND me.`http_method` = 'GET')
    
    -- DMS: View reseller information
    OR (me.`component_name` = 'dms' AND me.`endpoint` = 'auth/getResellerInfo' 
        AND me.`http_method` IN ('POST', 'GET')
        AND (me.`module_feature` = 'RESELLER_GET_INFO' OR me.`module_feature` IS NULL))
    
    -- Order Management: View order payment types
    OR (me.`component_name` = 'oms' AND me.`endpoint` = 'v2/order-payment-types' AND me.`module_feature` = '')
    
    -- Business Intelligence: View metadata
    OR (me.`component_name` = 'bi-engine' 
        AND me.`endpoint` IN ('v1/metadata/.*', 'v1/metadata')
        AND me.`module_feature` = '')
    
    -- Template: View DMS component types
    OR (me.`component_name` = 'template' 
        AND me.`endpoint` = 'v1/component/DMS/type/.*' 
        AND me.`http_method` = 'GET')
    
    -- Portal: Access profile menu
    OR (me.`component_name` = 'portal' 
        AND me.`endpoint` = '' 
        AND me.`module_feature` = 'PROFILE_MENU')
    
    -- Password Management: Change password via IMS Bridge
    OR (me.`component_name` = 'imsbridge' 
        AND me.`module_feature` = 'changePasswordPOST' 
        AND me.`http_method` = 'POST')
    
    -- DMS: Change reseller password
    OR (me.`component_name` = 'dms' 
        AND me.`endpoint` = 'v2/auth/changePassword' 
        AND me.`module_feature` = 'CHANGE_RESELLER_PASSWORD')
);

-- Centre Head Policy: Access for centre heads
INSERT INTO `policy_endpoint_map` (`policy_id`, `endpoint_id`)
SELECT p.`id`, me.`id` 
FROM `policy` p
INNER JOIN `module_endpoints` me ON 1=1
WHERE p.`name` = 'Centre Head Policy'
AND (
    -- Access Control: View reseller type features
    (me.`component_name` = 'access' 
        AND me.`endpoint` = 'v1/features/resellerType/.*' 
        AND me.`module_feature` = '' 
        AND me.`http_method` = 'GET')
    
    -- DMS: View reseller information via GET/POST
    OR (me.`component_name` = 'dms' 
        AND me.`endpoint` = 'auth/getResellerInfo' 
        AND (
            (me.`http_method` = 'POST' AND me.`module_feature` = 'RESELLER_GET_INFO')
            OR (me.`http_method` = 'POST' AND me.`module_feature` IS NULL)
            OR (me.`http_method` = 'GET' AND me.`module_feature` IS NULL)
        ))
    
    -- Order Management: View order payment types
    OR (me.`component_name` = 'oms' 
        AND me.`endpoint` = 'v2/order-payment-types' 
        AND me.`module_feature` = '')
    
    -- Business Intelligence: View metadata and reports
    OR (me.`component_name` = 'bi-engine' 
        AND me.`endpoint` IN ('v1/metadata/.*', 'v1/metadata')
        AND me.`module_feature` = '')
    
    -- Template: View DMS component types
    OR (me.`component_name` = 'template' 
        AND me.`endpoint` = 'v1/component/DMS/type/.*' 
        AND me.`http_method` = 'GET')
    
    -- Portal: Access profile menu
    OR (me.`component_name` = 'portal' 
        AND me.`endpoint` = '' 
        AND me.`module_feature` = 'PROFILE_MENU')
    
    -- Password Management: Change password via IMS Bridge
    OR (me.`component_name` = 'imsbridge' 
        AND me.`module_feature` = 'changePasswordPOST' 
        AND me.`http_method` = 'POST')
    
    -- DMS: Change reseller password
    OR (me.`component_name` = 'dms' 
        AND me.`endpoint` = 'v2/auth/changePassword' 
        AND me.`module_feature` = 'CHANGE_RESELLER_PASSWORD')
);

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;