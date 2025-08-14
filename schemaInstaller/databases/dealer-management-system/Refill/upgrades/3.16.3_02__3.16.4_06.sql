--
-- $Id$
--

-- copied from /ers-core/database/Refill/upgrades/3.16.0_05__3.16.4_01.sql
ALTER TABLE dwa_items 
  ADD ownerId varchar(40),
  ADD reservationRef varchar(25),
  ADD reservationTime datetime,
  ADD INDEX reservationIndex(reservationRef); 

-- copied from  /ers-core/database/Refill/upgrades/3.16.4_01__3.16.4_02.sql 
insert into id_audit_actions set action_key=18, action='RESELLER REGISTERED', description='';
insert into id_audit_actions set action_key=19, action='RESELLER APPROVED', description='';
insert into id_audit_actions set action_key=20, action='RESELLER DENIED', description='';  

-- copied from  /ers-core/database/Refill/upgrades/3.16.4_02__3.16.4_03.sql
ALTER TABLE extdev_classes ADD supports_ussd_push_service tinyint(4) NOT NULL DEFAULT '0';

-- copied from /ers-core/database/Refill/upgrades/3.16.4_04__3.16.4_05.sql
ALTER TABLE `Refill`.`pay_prereg_accounts` 
	ADD COLUMN `transaction_limit_count` INT(11) DEFAULT '0' NULL AFTER `pay_limit_currency`;