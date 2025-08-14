--
-- $Id$
--

ALTER TABLE pay_prereg_accounts ADD COLUMN master_owner_key int(11) NOT NULL AFTER owner_key, ADD INDEX master_owner (master_owner_key);

-- Assume all existing accounts are original accounts
UPDATE pay_prereg_accounts set master_owner_key=owner_key;
