REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTManageGroupManagement)/group(CompleteGroup)/w(Window)/appearance(StringResource)','<IFRAME SRC=\"%|{manage_groups(OUTManageGroupManagement)/group_management_system_url(TextMessage)/w(Window)}|%\" WIDTH=\"100%\" HEIGHT=\"100%\" frameborder=\"0\">\r\nIf you can see this, it means that your browser doesn\'t \r\nsupport IFRAME tags.  Click on the \r\n<A id="186" HREF=\"%|{manage_groups(OUTManageGroupManagement)/group_management_system_url(TextMessage)/w(Window)}|%\">link</A> \r\nto visit the group management page.\r\n</IFRAME>\r\n\r\n\r\n','2010-05-10 16:18:17','?(RefillAdmin)','2011-02-01 11:30:28','2011-02-01 11:58:51','2011-02-01 11:58:51'),
('?(Len)/?(*)/?(StaticMenu)/manage_groups(FlowControl)/?(Window)/langmap(StringResource)','msg=Group Management','2010-03-31 15:53:12','?(RefillAdmin)','2010-03-31 15:50:51','2010-03-31 15:53:13','2010-03-31 15:53:13');
CREATE TABLE `reseller_lifecycle` (
  `reseller_id` varchar(80) NOT NULL,
  `balance_lifeline` timestamp NULL,
  `balance_status` varchar(50) NULL,
  `scratchcard_lifeline` timestamp NULL,
  `scratchcard_status` varchar(50) NULL,
  `has_grace_period` boolean NOT NULL DEFAULT FALSE,
  `remaining_inventory` int NULL,
  PRIMARY KEY (`reseller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;