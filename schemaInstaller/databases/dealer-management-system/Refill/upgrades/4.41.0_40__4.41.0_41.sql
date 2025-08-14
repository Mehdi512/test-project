
DELETE FROM `resources` WHERE datakey IN (
'?(Len)/?(*)/?(StaticMenu)/reseller_reports(FlowControl)/?(Window)/langmap(StringResource)',
'?(Len)/?(*)/?(StaticMenu)/support_reports(FlowControl)/?(Window)/langmap(StringResource)'
);

REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(OUTManagePasswordPolicy)/messages(OUMessageGroup)/illegal_max_login_attempts(DODMessage)/group(CompleteGroup)/w(Window)/langmap(StringResource)','msg=Max Incorrect Logins cannot be blank and must be a valid number','2008-11-06 16:03:37','?(RefillAdmin)','2008-11-06 10:07:17','2008-11-06 16:03:37','2008-11-06 16:03:37'),
('?(Len)/?(*)/?(OUTManagePasswordPolicy)/messages(OUMessageGroup)/illegal_passowrds_history_limit(DODMessage)/group(CompleteGroup)/w(Window)/langmap(StringResource)','msg=Password History Limit cannot be blank and must be a valid number','2008-11-06 16:03:37','?(RefillAdmin)','2008-11-06 10:07:17','2008-11-06 16:03:37','2008-11-06 16:03:37');