ALTER TABLE `Refill`.`reseller_lifecycle`
ADD COLUMN `last_scratchcard_inactive` timestamp NULL,
ADD COLUMN `last_balance_inactive` timestamp NULL,
ADD COLUMN `newly_created` boolean NOT NULL DEFAULT TRUE;