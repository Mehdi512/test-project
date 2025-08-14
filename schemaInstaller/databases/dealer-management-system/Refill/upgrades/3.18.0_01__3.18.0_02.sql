--
-- $Id$
--
ALTER TABLE dwa_etopup_products 
   add column sender_account_type_key int(11) DEFAULT '0' NOT NULL after denomination_list, 
   add column receiver_account_type_key int(11) DEFAULT '0' NULL after sender_account_type_key;
