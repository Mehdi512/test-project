SET FOREIGN_KEY_CHECKS = 0;

USE accountmanagement;
TRUNCATE TABLE accountmanagement.accounttypes;


INSERT INTO accountmanagement.accounttypes (accountTypeId, createDate, lastModifiedDate, expiryDate, minAccountBalance, maxAccountBalance, minTransactionAmt, maxTransactionAmt, creditLimit, payLimit, countLimit, currency, url, accountSharingPolicy, description, extraFields) VALUES ('AIRTIME', '2022-11-14 10:41:58', '2022-11-14 10:41:58', '2023-11-14 00:00:00', 0.00000, 100000.00000, 0.00000, 1000000.00000, 0.00000, 0.00000, 0.00000, '', '', null, 'AIRTIME', null);
INSERT INTO accountmanagement.accounttypes (accountTypeId, createDate, lastModifiedDate, expiryDate, minAccountBalance, maxAccountBalance, minTransactionAmt, maxTransactionAmt, creditLimit, payLimit, countLimit, currency, url, accountSharingPolicy, description, extraFields) VALUES ('BOOKKEEPING', '2022-11-21 12:17:46', '2022-11-21 12:17:46', '2091-11-21 00:00:00', 100.00000, 10000000.00000, 0.00000, 10000000.00000, 999999999999.00000, 0.00000, 0.00000, '', '', null, 'BOOKKEEPING', null);
INSERT INTO accountmanagement.accounttypes (accountTypeId, createDate, lastModifiedDate, expiryDate, minAccountBalance, maxAccountBalance, minTransactionAmt, maxTransactionAmt, creditLimit, payLimit, countLimit, currency, url, accountSharingPolicy, description, extraFields) VALUES ('RESELLER', '2021-07-22 15:54:59', '2021-07-29 00:00:00', '2029-07-22 05:30:00', 10.00000, 10000000.00000, 1.00000, 10000000.00000, 100.00000, 11111110.00000, 11110.00000, '', '', null, 'reseller', null);

INSERT INTO `accounts` (`accountTypeId`, `accountId`, `owner`, `masterOwner`, `accountName`, `currency`, `balance`, `creditLimit`, `version`, `status`, `password`, `createDate`, `expiryDate`, `extraFields`, `loanEnable`, `loanAmount`, `loanPenaltyAmount`, `minAccountBalance`, `maxAccountBalance`, `minTransactionAmt`, `maxTransactionAmt`, `payLimit`, `availableAmount`, `reservedAmount`, `periodicCreditLimit`, `transactionsLimitCount`, `payLimitPeriod`, `accountValidFrom`, `description`, `loanDate`)
VALUES
	('BOOKKEEPING', 'OPERATOR_BOOKKEEPING', 'OPERATOR', NULL, NULL, 'BDT', 10000000.00000, 0.00000, 0, 'Active', NULL, '2022-08-16 01:32:56', '2022-08-16 01:32:56', '#\n#Tue Aug 16 05:32:56 UTC 2022\n', '1', 999999999.00000, 0.00000, 0.00000, NULL, 0.00000, NULL, 0.00000, 0.00000, 0.00000, NULL, 0, 0, '2022-08-16 01:32:56', NULL, '2022-08-16 01:32:56');


SET FOREIGN_KEY_CHECKS = 1;

