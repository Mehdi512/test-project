ALTER TABLE `Refill`.`id_audit_log` 
CHANGE COLUMN `description` `description` VARCHAR(1000) NOT NULL DEFAULT '' ;

REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchAuditLog)/search_group(CompleteGroup)/w(Window)/appearance(StringResource)',
'<table class=\"onepixelborderbott\" width=\"80%\">\r\n<tr><td colspan=\"4\" class=\"onepixelborderbott\">\r\n<span class=\"page_header\">§search_audit_log§</span>\r\n</td></tr>\r\n<tr><td>\r\n<span class=\"input_header\">§from_datetime§</span><br>\r\n%|{search_audit_log(OUTSearchAuditLog)/from_datetime(OUTChooseDateTime)/w(Window)}|%\r\n</td><td>\r\n<span class=\"input_header\">§to_datetime§</span><br>\r\n%|{search_audit_log(OUTSearchAuditLog)/to_datetime(OUTChooseDateTime)/w(Window)}|%\r\n</td><td valign=\"bottom\">\r\n<span class=\"input_header\">§action§</span><br>\r\n%|{action_choice(ElementChoiceOption)/group(CompleteGroup)/w(Window)}|%\r\n</td><td valign=\"bottom\">\r\n<span class=\"input_header\">§user_id§</span><br>\r\n%|{search_audit_log(OUTSearchAuditLog)/user_id(OUTChooseText)/w(Window)}|%\r\n</td><td valign=\"bottom\">\r\n<span class=\"input_header\">§mimetype§</span><br>\r\n%|{mimetype_choice(ElementChoiceOption)/group(CompleteGroup)/w(Window)}|%\r\n</td></tr>\r\n<tr><td colspan=\"4\">\r\n%|{do_search(FlowControl)/group(CompleteGroup)/w(Window)}|%<br>\r\n</td></tr><tr><td colspan=\"4\">\r\n%|{export_data(DODRawData)/group(CompleteGroup)/w(Window)}|%\r\n</td></tr>\r\n</table>\r\n\r\n',
'2008-08-19 14:15:54',
'?(RefillAdmin)',
'2008-08-19 15:40:04',
'2008-08-19 15:41:26',
'2008-08-19 15:41:26');

REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchAuditLog)/export_data(DODRawData)/w_popup(Window)/appearance(StringResource)',
'<table hspace=\"0\" vspace=\"0\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n<tr valign=\"top\" align=\"center\">\r\n<td width=1 align=\"right\" valign=\"top\">\r\n <img align=\"top\" src=\"/system/images/knapp_left.gif\">\r\n</td>\r\n<td align=\"center\" valign=\"top\" background=\"/system/images/knapp_middle.gif\" nowrap style=\"padding: 0px 2px 0px 0px;\">\r\n\r\n%|EDITBUTTON|%<a href=\"%|content|%\">Download export</a>\r\n </td>\r\n<td width=\"1\" valign=\"top\" align=\"left\">\r\n <img align=\"top\" src=\"/system/images/knapp_right.gif\">\r\n</td>\r\n</tr>\r\n</table>\r\n\r\n\r\n',
'2007-01-12 02:02:44',
'?(RefillAdmin)',
'2007-01-22 23:59:47',
'2007-01-23 09:49:57',
'2007-01-23 08:49:57');

REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(OUTSearchAuditLog)/search_group(CompleteGroup)/w(Window)/langmap(StringResource)',
'search_audit_log=Search audit log\r\nfrom_datetime=From\r\nto_datetime=To\r\naction=Action\r\nuser_id=User id\r\nmimetype=Mime Type',
'2008-08-19 14:14:17',
'?(RefillAdmin)',
'2008-08-19 13:59:36',
'2008-08-19 14:14:17',
'2008-08-19 14:14:17');

REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTCompleteSupportTransfer)/group(CompleteGroup)/w(Window)/appearance(StringResource)',
'<h1>%|{complete_transfer(OUTCompleteSupportTransfer)/failure(AtomicMessage)/w(Window)}|%\r\n%|{complete_transfer(OUTCompleteSupportTransfer)/success(AtomicMessage)/w(Window)}|%\r\n%|{complete_transfer(OUTCompleteSupportTransfer)/pending(AtomicMessage)/w(Window)}|%</h1>\r\n\r\n§result_message§: %|{complete_transfer(OUTCompleteSupportTransfer)/result_message(TextMessage)/w(Window)}|%\r\n<br><br>\r\n%|{close(FlowControl)/group(CompleteGroup)/w(Window)}|%\r\n',
'2011-06-07 19:03:44',
'?(RefillAdmin)',
'2011-06-07 19:30:27',
'2011-06-07 19:32:09',
'2011-06-07 19:32:09');


REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTCompleteSupportTransfer)/pending(AtomicMessage)/w(Window)/langmap(StringResource)',
'msg=Transaction successful\r\n',
'2011-06-07 19:02:11',
'?(RefillAdmin)',
'2011-06-07 18:56:24',
'2011-06-07 19:02:11',
'2011-06-07 19:02:11');

REPLACE INTO `id_audit_actions` (`action_key`, `action`, `description`) VALUES
(70,'PRODUCT PRICE ENTRY ADDED',''),
(86,'RESELLER USER RESET PASSWORD',''),
(87,'RESELLER CONTRACT UPDATED',''),
(88,'RESELLER CONTRACT ADDED',''),
(89,'USER PASSWORD CHANGED',''),
(91,'PRODUCT PRICE ENTRY REMOVED',''),
(92,'VOUCHER BATCHES EXTENDED',''),
(93,'RESELLER PARENT CHANGED','');

REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(OUTSearchAuditLog)/action_choice(ElementChoiceOption)/no_selection_selected_row_w(Window)/langmap(StringResource)',
'no_selection=Choose\r\n',
'2008-08-19 16:20:08',
'?(RefillAdmin)',
'2008-08-20 15:39:17',
'2008-08-20 15:40:11',
'2008-08-20 15:40:11');

REPLACE INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(OUTSearchAuditLog)/mimetype_choice(ElementChoiceOption)/no_selection_selected_row_w(Window)/langmap(StringResource)',
'no_selection=Choose\r\n',
'2008-08-19 16:20:08',
'?(RefillAdmin)',
'2008-08-20 15:39:17',
'2008-08-20 15:40:11',
'2008-08-20 15:40:11');

