CREATE TABLE `agent_supervisor_loc_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_region` varchar(64) NOT NULL,
  `agent_location` varchar(64) NOT NULL,
  `agent_cluster` varchar(64) NOT NULL,
  `agent_name` varchar(64) NOT NULL,
  `agent_msisdn` varchar(16) NOT NULL,
  `supervisor_name` varchar(64) NOT NULL,
  `supervisor_msisdn` varchar(16) NOT NULL,
  `manager_name` varchar(64) NOT NULL,
  `manager_msisdn` varchar(16) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `agent_info` (`agent_msisdn`, `agent_region`, `agent_location`, `agent_cluster`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
