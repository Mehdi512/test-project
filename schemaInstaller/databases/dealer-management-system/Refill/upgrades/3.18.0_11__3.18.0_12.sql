--
-- $Id$
--

-- Set valid_from to a sane value for rows where it is null
UPDATE pay_prereg_accounts SET valid_from = last_modified WHERE ISNULL(valid_from);

-- Change definition of valid_from column so null is not allowed
ALTER TABLE pay_prereg_accounts CHANGE COLUMN valid_from valid_from datetime NOT NULL DEFAULT '2001-01-01';   
