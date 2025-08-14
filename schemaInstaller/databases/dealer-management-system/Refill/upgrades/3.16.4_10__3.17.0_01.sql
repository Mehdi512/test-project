--
-- $Id$
--

ALTER TABLE id_audit_log add index date_user (action_date, user_key);
