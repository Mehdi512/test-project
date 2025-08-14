DROP TABLE IF EXISTS `cluster`;

CREATE TABLE `cluster` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cluster` varchar(40) NOT NULL DEFAULT '',
  `subcluster` varchar(255) NOT NULL DEFAULT '',
  `rank` int(11) NOT NULL DEFAULT 0,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tmstmp_index` (`last_modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `commission_receivers`
ADD `cluster_id` int(11), ADD CONSTRAINT `fk_cluster_id`
FOREIGN KEY (`cluster_id`)
REFERENCES `cluster`(`id`);

INSERT INTO `id_scenarios` (`ScenarioKey`, `ScenarioName`, `ScenarioDescription`, `ScenarioGroup`, `last_modified`, `domain_key`) VALUES
(209,'Cluster management','Cluster management for resellers','Admin/Cluster management',NOW(),3);
  
  
INSERT INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTManageClusterManagement)/group(CompleteGroup)/w(Window)/appearance(StringResource)','<IFRAME SRC=\"%|{manage_cluster(OUTManageClusterManagement)/cluster_management_url(TextMessage)/w(Window)}|%\" WIDTH=1500 HEIGHT=\"500\" frameborder=\"0\">\r\nIf you can see this, it means that your browser doesn\'t \r\nsupport IFRAME tags.  Click on the \r\n<A HREF=\"%|{manage_cluster(OUTManageClusterManagement)/cluster_management_url(TextMessage)/w(Window)}|%\">link</A> \r\nto visit the Cluster management page.\r\n</IFRAME>\r\n\r\n\r\n','2010-05-10 16:18:17','?(RefillAdmin)','2011-02-01 11:30:28','2011-02-01 11:58:51','2011-02-01 11:58:51'),
('?(Len)/?(*)/?(StaticMenu)/manage_cluster(FlowControl)/?(Window)/langmap(StringResource)','msg=Cluster management','2010-03-31 15:53:12','?(RefillAdmin)','2010-03-31 15:50:51','2010-03-31 15:53:13','2010-03-31 15:53:13');
