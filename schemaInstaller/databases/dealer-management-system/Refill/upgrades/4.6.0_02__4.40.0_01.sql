ALTER TABLE dwa_deliveryformats
ADD COLUMN `scheduled_time` timestamp NOT NULL,
DROP KEY `class_type_purpose`, 
ADD KEY `class_type_purpose` (`product_group_key`,`template_type_key`,`purpose`,`scheduled_time`);