use kyc;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `kyc_operations`;
INSERT INTO `kyc_operations` (`id`, `initial_state_id`, `code`, `name`, `description`, `criteria`)
VALUES
	(1, 2, 'ADD_KYC', 'ADD KYC', 'Add Kyc for first time', NULL),
	(2, NULL, 'UPDATE_KYC', 'UPDATE KYC', 'UPDATE KYC details', NULL),
	(3, 8, 'VALIDATE_KYC', 'VALIDATE_KYC', 'VALIDATE_KYC', NULL),
	(4, NULL, 'APPROVE_KYC', 'APPROVE_KYC', 'APPROVE_KYC', NULL),
	(5, NULL, 'REJECT_KYC', 'REJECT_KYC', 'REJECT_KYC', NULL),
	(6, 1, 'OFFLINE_KYC', 'OFFLINE_KYC', 'OFFLINE_KYC', NULL),
	(7, NULL, 'ONLINE_SYNC_KYC', 'ONLINE_SYNC_KYC', 'ONLINE_SYNC_KYC', NULL),
	(8, NULL, 'GRACE_CHECK', 'GRACE_CHECK', 'This is grace check exceeded operation', NULL),
	(9, 2, 'SELF_ADD_KYC', 'SELF_ADD_KYC', 'This is self add kyc operation', NULL);

TRUNCATE TABLE `kyc_states`;
INSERT INTO `kyc_states` (`id`, `code`, `name`, `description`, `available_from`, `available_until`)
VALUES
	(1, 'OFFLINE_PENDING_APPROVAL', 'OFFLINE PENDING APPROVAL', 'initial state for offline kyc', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(2, 'PENDING_APPROVAL', 'PENDING APPROVAL', 'initial state for online kyc', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(3, 'PRE_APPROVED', 'PRE APPROVED', 'pre-approval by back-office', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(4, 'APPROVED', 'APPROVED', 'kyc Approved', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(5, 'REJECTED', 'REJECTED', 'kyc rejected', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(6, 'EXPIRED', 'EXPIRED', 'new kyc for re-cycled product/account then expire previous record', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(7, 'GRACE_PERIOD_EXCEEDED', 'GRACE_PERIOD_EXCEEDED', 'This state is for Grace_Check operation.', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(8, 'VALIDATE', 'VALIDATE', 'This state is for validate operation.', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(9, 'SEMI_PRE_APPROVED', 'SEMI_PRE_APPROVED', 'pre-approval by back-office', '2021-02-09 16:58:27', '2099-01-01 00:00:00');

TRUNCATE TABLE `kyc_state_transitions`;
INSERT INTO `kyc_state_transitions` (`id`, `from_state_id`, `operation_id`, `to_state_id`, `business_rules`, `mandatory_business_actions`, `business_actions`, `available_from`, `available_until`)
VALUES
	(1, 2, 1, 4, NULL, 'DMSAction', 'ADD_KYC_INITIATOR_EMAIL_NOTIFICATION, SEND_CREATOR_SMS_NOTIFICATION_AFTER_RESELLER_ADDED', '2021-02-09 18:16:07', NULL),
	(2, 2, 1, 2, NULL, NULL, 'FallbackApprovalAction,ADD_KYC_INITIATOR_EMAIL_NOTIFICATION,ADD_KYC_APPROVAL_EMAIL_NOTIFICATION,ADD_KYC_INITIATOR_SMS_NOTIFICATION,ADD_KYC_APPROVAL_SMS_NOTIFICATION', '2021-02-09 18:16:07', NULL),
	(3, 2, 1, 2, NULL, 'DMSAction,GPApprovalGMSAction', '', '2021-02-09 18:16:07', NULL),
	(4, 2, 2, 2, NULL, NULL, NULL, '2021-02-09 18:16:07', NULL),
	(5, 2, 2, 2, NULL, 'DMSUpdateResellerAction', NULL, '2021-02-09 18:16:07', NULL),
	(6, 2, 4, 4, NULL, 'DMSAction', 'SEND_APPROVER_SMS_NOTIFICATION_AFTER_RESELLER_ADDED, CREATOR_EMAIL_NOTIFICATION_ON_KYC_APPROVAL, APPROVER_EMAIL_NOTIFICATION_ON_KYC_APPROVAL', '2021-02-09 18:16:07', NULL),
	(7, 2, 4, 4, NULL, NULL, NULL, '2021-02-09 18:16:07', NULL),
	(8, 2, 5, 5, NULL, NULL, NULL, '2021-09-01 18:16:07', NULL),
	(9, 2, 5, 5, NULL, 'DealerStatusRejectAction', NULL, '2021-02-09 18:16:07', NULL),
	(10, 2, 1, 2, NULL, 'NonGpUserAction,GPApprovalGMSAction', NULL, '2021-02-09 18:16:07', NULL),
    (11, 2, 4, 4, NULL, 'NonGpUserAction', NULL, '2021-02-09 18:16:07', NULL),
    (12, 2, 1, 4, NULL, 'NonGpUserAction', NULL, '2021-02-09 18:16:07', NULL);


TRUNCATE TABLE `kyc_state_transition_permissions`;
INSERT INTO `kyc_state_transition_permissions` (`id`, `state_transition_id`, `reseller_type`, `role_id`, `criteria`)
VALUES
	(1, 1, 'Operator', 'core', '<#if kycTransaction.customer.roleId?has_content>12<#else>1</#if>'),
	(2, 1, 'Distributor', NULL, '<#if kycTransaction.customer.customerType="SubDistributor">2</#if>'),
	(3, 1, 'SubDistributor', NULL, '<#if kycTransaction.customer.customerType="Agent">2</#if>'),
	(4, 1, 'Agent', NULL, '<#if kycTransaction.customer.customerType="POS">2</#if>'),
	(5, 4, 'Operator', NULL, NULL),
	(6, 6, 'Operator', 'core', '<#if kycTransaction.customer.roleId?has_content>11<#else>6</#if>'),
	(7, 8, 'Operator', 'core', NULL),
    (8, 12, 'Operator', 'rca', '<#if kycTransaction.customer.roleId?has_content && ((kycTransaction.customer.customerType==\"GPC\" &&  kycTransaction.customer.roleId == \"gpt\")|| (kycTransaction.customer.customerType==\"GPCF\" &&  kycTransaction.customer.roleId == \"gfu\"))>12<#else><#if kycTransaction.customer.customerType==\"GPC\" || kycTransaction.customer.customerType==\"GPCF\">1<#else>-1</#if></#if>'),
	(9, 10, 'DIST', 'dm', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "DIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(10, 10, 'DIST', 'dtu', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "DIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(11, 10, 'CDIST', 'dm', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "CDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(12, 10, 'ODIST', 'dm', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "ODIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(13, 10, 'SDIST', 'dm', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "SDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(14, 10, 'EADIST', 'dm', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "EADIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(15, 10, 'EUDIST', 'dm', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "EUDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(16, 10, 'ESDIST', 'dm', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "ESDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(17, 10, 'ECDIST', 'dm', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "ECDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(18, 10, 'CDIST', 'dtu', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "CDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(19, 10, 'ODIST', 'dtu', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "ODIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(20, 10, 'SDIST', 'dtu', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "SDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(21, 10, 'EADIST', 'dtu', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "EADIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(22, 10, 'EUDIST', 'dtu', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "EUDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(23, 10, 'ESDIST', 'dtu', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "ESDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(24, 10, 'ECDIST', 'dtu', '<#if kycTransaction.customer.roleId?has_content><#if (["dm", "log", "dcu", "dtu", "mdo", "ses"]?seq_contains(kycTransaction.customer.roleId)) && kycTransaction.customer.customerType == "ECDIST">10<#else>-1</#if><#else><#if kycTransaction.customer.customerType=="SE"|| kycTransaction.customer.customerType=="RET">3<#else>-1</#if></#if>'),
	(25, 1, 'BCU', 'core', '<#if kycTransaction.customer.roleId?has_content>12<#else>1</#if>'),
	(26, 11, 'BCU', 'clm', '<#if ["DIST", "CDIST", "ODIST", "EADIST", "ESDIST", "ECDIST", "EUDIST", "SDIST", "SE", "OSE", "RET", "CRET", "ORET", "ALTRET", "ESRET", "SRET"]?seq_contains(kycTransaction.customer.customerType)><#if kycTransaction.customer.roleId?has_content>11<#else>1</#if><#else>-1</#if>'),
	(27, 11, 'Operator', 'clm', '<#if ["DIST", "CDIST", "ODIST", "EADIST", "ESDIST", "ECDIST", "EUDIST", "SDIST", "SE", "OSE", "RET", "CRET", "ORET", "ALTRET", "ESRET", "SRET"]?seq_contains(kycTransaction.customer.customerType)><#if kycTransaction.customer.roleId?has_content>11<#else>1</#if><#else>-1</#if>'),
	(28, 12, 'Operator', 'clm', '<#if ["DIST", "CDIST", "ODIST", "EADIST", "ESDIST", "ECDIST", "EUDIST", "SDIST", "SE", "OSE", "RET", "CRET", "ORET", "ALTRET", "ESRET", "SRET"]?seq_contains(kycTransaction.customer.customerType)><#if kycTransaction.customer.roleId?has_content>12<#else>1</#if><#else>-1</#if>'),
	(29, 6, 'BCU', 'core', '<#if kycTransaction.customer.roleId?has_content>11<#else>6</#if>'),
	(30, 12, 'BCU', 'clm', '<#if ["DIST", "CDIST", "ODIST", "EADIST", "ESDIST", "ECDIST", "EUDIST", "SDIST", "SE", "OSE", "RET", "CRET", "ORET", "ALTRET", "ESRET", "SRET"]?seq_contains(kycTransaction.customer.customerType)><#if kycTransaction.customer.roleId?has_content>12<#else>1</#if><#else>-1</#if>'),
    (31, 12, 'BCU', 'rca', '<#if kycTransaction.customer.roleId?has_content && ((kycTransaction.customer.customerType==\"GPC\" &&  kycTransaction.customer.roleId == \"gpt\")|| (kycTransaction.customer.customerType==\"GPCF\" &&  kycTransaction.customer.roleId == \"gfu\"))>12<#else><#if kycTransaction.customer.customerType==\"GPC\" || kycTransaction.customer.customerType==\"GPCF\">1<#else>-1</#if></#if>'),
	(32, 8, 'BCU', 'core', NULL),
    (33, 8, 'Operator', 'clm', NULL),
    (34, 8, 'BCU', 'clm', NULL);

TRUNCATE TABLE `kyc_templates`;
INSERT INTO `kyc_templates` (`template_name`, `template_value`)
VALUES
	('Direct_sales', '{\n\"problems\": [{\n    \"Diabetes\":[{\n        \"medications\":[{\n            \"medicationsClasses\":[{\n                \"className\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }],\n                \"className2\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }]\n            }]\n        }],\n        \"labs\":[{\n            \"missing_field\": \"missing_value\"\n        }]\n    }],\n    \"Asthma\":[{}]\n}]}'),
	('Indirect_sales', '{\n\"problems\": [{\n    \"Diabetes\":[{\n        \"medications\":[{\n            \"medicationsClasses\":[{\n                \"className\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }],\n                \"className2\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }]\n            }]\n        }],\n        \"labs\":[{\n            \"missing_field\": \"missing_value\"\n        }]\n    }],\n    \"Asthma\":[{}]\n}]}'),
	('Direct_distributor', '{\n\"problems\": [{\n    \"Diabetes\":[{\n        \"medications\":[{\n            \"medicationsClasses\":[{\n                \"className\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }],\n                \"className2\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }]\n            }]\n        }],\n        \"labs\":[{\n            \"missing_field\": \"missing_value\"\n        }]\n    }],\n    \"Asthma\":[{}]\n}]}');

SET FOREIGN_KEY_CHECKS = 1;
