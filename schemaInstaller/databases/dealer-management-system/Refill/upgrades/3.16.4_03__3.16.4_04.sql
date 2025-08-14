--
-- $Id$
--

CREATE TABLE `id_connection_profiles` (
  `profile_key` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `description` varchar(128) NOT NULL DEFAULT '',
  `ip_addresses` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`profile_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE id_users add column connection_profile_key int(4) NOT NULL default 0;