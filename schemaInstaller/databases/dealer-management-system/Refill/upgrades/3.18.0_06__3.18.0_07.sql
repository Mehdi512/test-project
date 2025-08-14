--
-- $Id$
--

ALTER TABLE dwa_etopup_products
 ADD COLUMN denomination_list TEXT AFTER denomination_multiple,
 ADD COLUMN denomination_type TINYINT(2) NOT NULL DEFAULT '1' AFTER max_levels,
 ADD COLUMN denomination_face_value_source TINYINT(2) DEFAULT '0' AFTER denomination_type;
 
ALTER TABLE dwa_product_denominations
 ADD COLUMN sender_amount BIGINT(20) NOT NULL DEFAULT '0' AFTER product_key,
 ADD COLUMN receiver_amount BIGINT(20) NOT NULL DEFAULT '0' AFTER sender_amount,
 ADD COLUMN receiver_price BIGINT(20) NOT NULL DEFAULT '0' AFTER receiver_amount,
 DROP PRIMARY KEY,
 DROP COLUMN denomination;