CREATE TABLE `agent_target_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_msisdn` varchar(64) NOT NULL,
  `target` varchar(64) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
  ('?(Astd)/?(*)/?(OUTSpecifyImportParameters)/delimiter_option(OUTSelectDelimiterOption)/group(CompleteGroup)/w(Window)/appearance(StringResource)',	'<tr>\r\n<td>%|EDITBUTTON|%\r\n<b>§delimiter_option§</b></td>\r\n<td>\r\n%|{ALL}|%</td>\r\n</tr>\r\n',	'2017-03-05 12:10:00',	'?(RefillAdmin)',	'2017-03-05 12:10:00',	'2009-11-06 12:10:00',	'2017-03-05 12:10:00'),
  ('?(Astd)/?(*)/?(OUTSpecifyImportParameters)/delimiter_option(OUTSelectDelimiterOption)/delimiter_options(ElementChoiceOption)/group(CompleteGroup)/w(Window)/appearance(StringResource)',	'<select id=\"TextFieldNoWidth\" name=\"%|path|%\" cols=40>\r\n%|{ALL}|%\r\n</select>\r\n\r\n',	'2006-03-11 00:22:02',	'?(RefillAdmin)',	'2017-03-05 00:19:37',	'2017-03-05 00:22:02',	'2017-03-05 23:22:02'),
  ('?(Len)/?(*)/?(OUTSpecifyImportParameters)/delimiter_option(OUTSelectDelimiterOption)/group(CompleteGroup)/w(Window)/langmap(StringResource)',	'delimiter_option=Delimiter option',	'2017-03-05 00:23:09',	'?(RefillAdmin)',	'2017-03-05 00:19:37',	'2017-03-05 00:23:09',	'2017-03-05 23:23:09'),
  ('?(Len)/?(*)/?(OUTSpecifyImportParameters)/delimiter_option(OUTSelectDelimiterOption)/delimiter_options(ElementChoiceOption)/group(CompleteGroup)/w(Window)/langmap(StringResource)',	'delimiter_option=Delimiter option',	'2017-03-05 17:51:42',	'?(RefillAdmin)',	'2017-03-05 18:01:44',	'2017-03-05 18:06:43',	'2017-03-05 17:06:43');

INSERT INTO `resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
  ('?(Astd)/?(*)/?(OUTSpecifyImportParameters)/csv_import_type(OUTSelectCsvImportTypeOption)/group(CompleteGroup)/w(Window)/appearance(StringResource)',	'<tr>\r\n<td>%|EDITBUTTON|%\r\n<b>§csv_import_type§</b></td>\r\n<td>\r\n%|{ALL}|%</td>\r\n</tr>\r\n',	'2017-03-05 12:10:00',	'?(RefillAdmin)',	'2017-03-05 12:10:00',	'2009-11-06 12:10:00',	'2017-03-05 12:10:00'),
  ('?(Astd)/?(*)/?(OUTSpecifyImportParameters)/csv_import_type(OUTSelectCsvImportTypeOption)/import_type_options(ElementChoiceOption)/group(CompleteGroup)/w(Window)/appearance(StringResource)',	'<select id=\"TextFieldNoWidth\" name=\"%|path|%\" cols=40>\r\n%|{ALL}|%\r\n</select>\r\n\r\n',	'2006-03-11 00:22:02',	'?(RefillAdmin)',	'2017-03-05 00:19:37',	'2017-03-05 00:22:02',	'2017-03-05 23:22:02'),
  ('?(Len)/?(*)/?(OUTSpecifyImportParameters)/csv_import_type(OUTSelectCsvImportTypeOption)/group(CompleteGroup)/w(Window)/langmap(StringResource)',	'csv_import_type=Import type',	'2017-03-05 00:23:09',	'?(RefillAdmin)',	'2017-03-05 00:19:37',	'2017-03-05 00:23:09',	'2017-03-05 23:23:09'),
  ('?(Len)/?(*)/?(OUTSpecifyImportParameters)/csv_import_type(OUTSelectCsvImportTypeOption)/import_type_options(ElementChoiceOption)/group(CompleteGroup)/w(Window)/langmap(StringResource)',	'csv_import_type=Import type',	'2017-03-05 17:51:42',	'?(RefillAdmin)',	'2017-03-05 18:01:44',	'2017-03-05 18:06:43',	'2017-03-05 17:06:43');

INSERT INTO `resources` (`datakey`,`data`,`LastUpdated`,`ResourceGroup`,`startup`,`touched`,`last_modified`) VALUES
  ('?(Len)/?(*)/?(OUTSpecifyImportParameters)/csv_contains_header(OUTChooseBoolean)/w_selected(Window)/langmap(StringResource)','msg=Contains Header','2017-03-05 13:25:30','?(RefillAdmin)','2017-03-05 13:17:15','2017-03-05 13:25:30','2017-03-05 13:25:30'),
  ('?(Astd)/?(*)/?(OUTSpecifyImportParameters)/csv_contains_header(OUTChooseBoolean)/group(CompleteGroup)/w(Window)/appearance(StringResource)','<tr>\r\n<td>%|EDITBUTTON|%<b>§contains_header§</b></td>\r\n<td>%|{ALL}|%</td>\r\n</tr>','2008-12-31 14:12:21','?(RefillAdmin)','2017-03-05 22:07:45','2017-03-05 12:43:19','2017-03-05 12:43:19'),
  ('?(Astd)/?(*)/?(OUTSpecifyImportParameters)/csv_contains_header(OUTChooseBoolean)/group(CompleteGroup)/w(Window)/langmap(StringResource)','contains_header=Contains Header','2017-03-05 12:45:44','?(RefillAdmin)','2017-03-05 22:07:45','2017-03-05 12:45:44','2017-03-05 12:45:44'),
  ('?(Astd)/?(*)/?(OUTSpecifyImportParameters)/csv_contains_header(OUTChooseBoolean)/w_not_selected(Window)/langmap(StringResource)','msg=Contains Header','2017-03-05 22:04:59','?(RefillAdmin)','2017-03-05 21:55:46','2017-03-05 22:04:59','2017-03-05 21:04:59');


