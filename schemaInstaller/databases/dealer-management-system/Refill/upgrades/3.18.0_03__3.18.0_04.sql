--
-- $Id$
--

ALTER TABLE pay_prereg_accounts
CHANGE COLUMN payment_option_key payment_account_type_key int(11) NOT NULL DEFAULT '0';
