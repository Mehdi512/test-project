ALTER TABLE `Refill`.`counting` 
ADD PRIMARY KEY (`category_key`, `type_key`);

ALTER TABLE `Refill`.`dwa_import_logs` 
ADD PRIMARY KEY (`import_key`, `status`);

ALTER TABLE `Refill`.`dwa_order_log_reason_codes` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `system`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`dwa_price_entry_ranges`
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`dwa_product_denominations` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `parameters`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`extdev_buffers_history` 
ADD PRIMARY KEY (`device_key`);

ALTER TABLE `Refill`.`extdev_history` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `last_modified`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`extdev_session_logs` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `last_modified`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`extdev_subdevice_history` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `note`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`extdev_transaction_result_codes` 
ADD PRIMARY KEY (`transaction_type`, `result_code`);


ALTER TABLE `Refill`.`imp_import_files` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `data`,
ADD PRIMARY KEY (`id`);


ALTER TABLE `Refill`.`imp_import_logs` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `message`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`imp_imported_log_rows` 
ADD PRIMARY KEY (`log_key`);

ALTER TABLE `Refill`.`loc_exchange_rate` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `last_modified`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`log_benchmarks` 
ADD PRIMARY KEY (`id`, `grp`);

ALTER TABLE `Refill`.`log_entries` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `last_modified`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`pay_invoice_log` 
ADD PRIMARY KEY (`time_of_change`, `invoice_key`);

ALTER TABLE `Refill`.`rep_exported_batch_report_queries` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `result`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`reseller_account_template` 
ADD PRIMARY KEY (`account_type_key`, `reseller_type_key`);

ALTER TABLE `Refill`.`reseller_hierarchy` 
ADD PRIMARY KEY (`parent_key`, `child_key`);

ALTER TABLE `Refill`.`reseller_id_generator_settings` 
ADD PRIMARY KEY (`prefix`, `suffix_count`);

ALTER TABLE `Refill`.`reseller_type_children` 
ADD PRIMARY KEY (`type_key`, `child_type_key`);

ALTER TABLE `Refill`.`sup_subscriber_profile_details` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `service_fee_expiry_days`,
ADD PRIMARY KEY (`id`);

ALTER TABLE `Refill`.`sup_supplier_users` 
ADD PRIMARY KEY (`supplier_key`, `user_key`);

ALTER TABLE `Refill`.`sup_suppliers_info` 
ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT AFTER `last_modified`,
ADD PRIMARY KEY (`id`);