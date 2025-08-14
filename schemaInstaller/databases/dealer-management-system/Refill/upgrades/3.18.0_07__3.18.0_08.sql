--
-- $Id$
--

ALTER TABLE pay_prereg_accounts 
   CHANGE `valid_from` `valid_from` datetime default '1970-01-01 01:00:00' NOT NULL;
