--
-- $Id$
--

ALTER TABLE commission_receivers add column time_first_terminal_activation datetime NOT NULL default '0000-00-00 00:00:00' AFTER time_created;