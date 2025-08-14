REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(StaticMenu)/search_users(FlowControl)/?(Window)/langmap(StringResource)','msg=Search Users','2022-10-15 13:43:01','?(RefillAdmin)','2022-10-15 13:40:12','2022-10-15 13:43:01','2022-10-15 13:43:01');

REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/group(CompleteGroup)/w(Window)/appearance(StringResource)',
'<div class="container">
   <div class="pageHeader">
      <h4>Search Users</h4>
      <p>Specify search parameters using one of the forms below. A list with users matching your search criteria will be displayed below.</p>
   </div>
   <div class="row" id="searchByNameOrId">
      <div class="columns four" id="userId"> <label for="">§userId§ <span class="helpQuestionMark" title="Enter the name or Id of the user">?</span> </label> <label for="">%|{user_id(TextChoice)/w(Window)}|%</label></div>



<div id="userStatus" class="columns four">
         <label for="" id="userStatusLabel">§user_status§<span class="helpQuestionMark" title="select user status">?</span></label>%|{user_status(OUTSelectUserStatus)/group(CompleteGroup)/w(Window)}|%
      </div>


      <div id="userRole" class="columns four">
         <label for="" id="userRoleLabel">§user_role§<span class="helpQuestionMark" title="select user role">?</span></label>%|{roles(ElementChoiceOption)/group(CompleteGroup)/w(Window)}|%
      </div>

   </div>
   <div class="row" id="searchByPersonalDataButton">
      <div class="row"> %|{do_search(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
   </div>
   %|{reseller_users_choice(ElementChoiceList)/group(CompleteGroup)/w(Window)}|%%|{messages(OUMessageGroup)/group(CompleteGroup)/w(Window)}|%

   <hr>

   %|{edit_user_information(EditUserInformation)/group(CompleteGroup)/w(Window)}|%

</div>
</div>','2022-10-15 13:43:01','?(RefillAdmin)','2022-10-15 13:40:12','2022-10-15 13:43:01','2022-10-15 13:43:01');

REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/group(CompleteGroup)/w(Window)/langmap(StringResource)','userId=User ID\r\nuser_status=Status\r\nuser_role=Role\r\n','2022-07-06 17:29:54','?(RefillAdmin)','2022-07-08 13:35:16','2022-07-08 13:43:04','2022-07-08 13:43:04');

REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(OUTSearchResellerUsers)/do_search(FlowControl)/?(Window)/langmap(StringResource)','msg=Search','2022-12-08 20:38:24','?(RefillAdmin)','2022-12-08 21:05:46','2022-12-08 21:06:27','2022-12-08 21:06:27');


REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/user_roles(ElementChoiceOption)/row_w(Window)/appearance(StringResource)','<!-- %|EDITBUTTON|% --> <option value="%|tag|%">%|role_name|%</option>','2022-12-08 20:38:24','?(RefillAdmin)','2022-12-08 21:05:46','2022-12-08 21:06:27','2022-12-08 21:06:27');

REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/user_roles(ElementChoiceOption)/selected_row_w(Window)/appearance(StringResource)','<option value="%|tag|%" selected>%|role_name|%</option>','2022-12-08 20:38:24','?(RefillAdmin)','2022-12-08 21:05:46','2022-12-08 21:06:27','2022-12-08 21:06:27');


REPLACE INTO `Refill`.`resources` (`datakey`,`data`,`LastUpdated`,`ResourceGroup`,`startup`,`touched`,`last_modified`) VALUES
('?(Len)/?(*)/?(OUMessageGroup)/no_user_match(DODMessage)/group(CompleteGroup)/w(Window)/langmap(StringResource)','msg=No user found that match the given search options.','2022-01-24 15:41:01','?(RefillAdmin)','2022-02-21 23:10:57','2022-02-21 23:33:47','2022-02-21 22:33:47');


REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/reseller_users_choice(ElementChoiceList)/even_w(Window)/appearance(StringResource)','<tr class=\"refill_list_odd\"><td class=\"left_padding\">\r\n%|EDITBUTTON|%<a id="466" href=\"\" onClick=\"return lsf(\'z%|path|%\',\'%|tag|%\')\" class=list>%|user_id|% </td></a>\r\n</td>\r\n<td>\r\n%|role_name|% \r\n</td>\r\n<td>\r\n%|user_name|% \r\n</td></tr>\r\n','2010-07-08 14:47:56','?(RefillAdmin)','2010-07-08 14:52:21','2010-07-08 15:20:50','2010-07-08 15:20:50');

REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/reseller_users_choice(ElementChoiceList)/odd_w(Window)/appearance(StringResource)','<tr class=\"refill_list_odd\"><td class=\"left_padding\">\r\n%|EDITBUTTON|%<a id="466" href=\"\" onClick=\"return lsf(\'z%|path|%\',\'%|tag|%\')\" class=list>%|user_id|% </td></a>\r\n</td>\r\n<td>\r\n%|role_name|% \r\n</td>\r\n<td>\r\n%|user_name|% \r\n</td></tr>\r\n','2007-01-22 15:24:52','?(RefillAdmin)','2007-01-22 23:59:47','2007-01-23 09:53:02','2007-01-23 08:53:02');


REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/reseller_users_choice(ElementChoiceList)/selected_w(Window)/appearance(StringResource)','<tr class=\"refill_list_selected\">\r\n<td class=\"left_padding\">%|EDITBUTTON|%<a id="467" href=\"\" onClick=\"return lsf(\'z%|path|%\',\'%|tag|%\')\" class=list>%|user_id|% </a></td> \r\n<td>\r\n%|role_name|% \r\n</td>\r\n<td>\r\n%|user_name|% \r\n</td></tr>\r\n','2007-01-22 15:25:27','?(RefillAdmin)','2007-01-22 22:28:10','2007-01-22 22:30:15','2007-01-22 21:30:15');


REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/reseller_users_choice(ElementChoiceList)/group(CompleteGroup)/w(Window)/appearance(StringResource)','<div class="row table-overflow"> <div class="row"> <table class="refill_list_table u-full-width"> <tr class="refill_list_header"> <th class="left_padding">§user_id§</th><th>§role_name§</th><th>§user_name§</th></tr>%|{(ElementChoiceList)/w(Window)}|% </table> </div> <div class="row searchResellerUserPagination"> <div class="row lineCount"> <label class="columns six" for="" id="lineCount">§line_count§:%|{(ElementChoiceList)/line_count(TextMessage)/w(Window)}|%</label> </div> <div class="row pagination"> <div class="columns four previous"><span>%|{first_page(FlowControl)/group(CompleteGroup)/w(Window)}|% %|{previous(FlowControl)/group(CompleteGroup)/w(Window)}|%</span> </div> <div class="columns four page">%|{set_page(FlowControl)/group(CompleteGroup)/w(Window)}|% %|{(ElementChoiceList)/current_page(TextChoice)/w(Window)}|%%|{(ElementChoiceList)/total_page_count(TextMessage)/w(Window)}|% </div> <div class="columns four nextLast">%|{next(FlowControl)/group(CompleteGroup)/w(Window)}|%%|{last_page(FlowControl)/group(CompleteGroup)/w(Window)}|% </div> </div> </div> </div>','2007-01-22 15:26:21','?(RefillAdmin)','2007-01-22 22:28:10','2007-01-22 22:30:12','2007-01-22 21:30:12');


REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTSearchResellerUsers)/reseller_users_choice(ElementChoiceList)/nof_rows(StringResource)','40','2006-01-26 14:25:01','?(RefillAdmin)','2006-01-26 14:45:17','2006-01-26 15:09:36','2006-01-26 14:09:36');

REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(OUTSearchResellerUsers)/reseller_users_choice(ElementChoiceList)/group(CompleteGroup)/w(Window)/langmap(StringResource)','line_count=Lines\r\nuser_id=User id\r\nuser_created=User created\r\nrole_name=Role\r\nuser_name=User name\r\nuser_status=Status','2011-03-11 09:29:59','?(RefillAdmin)','2011-03-11 13:53:45','2011-03-11 13:56:35','2011-03-11 13:56:35');

REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(EditUserInformation)/user_info(CompleteGroup)/w(Window)/appearance(StringResource)','<div class="row" id="editUserInformationSection">
   <div class="row" id="passwordChangeInitiated">%|{password_change_initiated(AtomicMessage)/w(Window)}|%</div>
   <div class="row" id="passwordChangeInitiated">%|{activation_code_sent(AtomicMessage)/w(Window)}|%</div>
   <div class="row" id="blockUserMsg">%|{user_blocked(AtomicMessage)/w(Window)}|%</div>
   <div class="row" id="section1">
      <div id="userId" class="columns four">
         <label for="" id="userIdLabel">
            §user_id§
            <span class="helpQuestionMark" title="Enter the User Id for the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_id(DODText)/w(Window)}|%
      </div>
      <div id="userPassword" class="columns four">
         <label for="" id="userPasswordLabel">
            §user_psw§
            <span class="helpQuestionMark" title="Enter the password for the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_psw(TextChoice)/w(Window)}{edit_user_information(EditUserInformation)/hidden_user_psw(TextChoice)/w(Window)}{edit_user_information(EditUserInformation)/nonEditable_user_password(DODText)/w(Window)}|%
      </div>
      <div id="userName" class="columns four">
         <label for="" id="userNameLabel">
            §user_name§
            <span class="helpQuestionMark" title="Enter the name of the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_name(TextChoice)/w(Window)}|%
      </div>
   </div>
   <div class="row" id="section2">
      <div id="userEmail" class="columns four">
         <label for="" id="userEmailLabel">
            §user_email§
            <span class="helpQuestionMark" title="Enter the email address of the rese">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_email(TextChoice)/w(Window)}{edit_user_information(EditUserInformation)/nonEditable_user_email(DODText)/w(Window)}|%
      </div>
      <div id="userPhone" class="columns four">
         <label for="" id="userPhoneLabel">
            §user_phone§
            <span class="helpQuestionMark" title="Enter the contact no. of the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_phone(TextChoice)/w(Window)}{edit_user_information(EditUserInformation)/nonEditable_user_phone(DODText)/w(Window)}|%
      </div>
      <div id="userRole" class="columns four">
         <label for="" id="userRoleLabel">
            §role§
            <span class="helpQuestionMark" title="Assign new role">?</span>
         </label>
         %|{roles(ElementChoiceOption)/group(CompleteGroup)/w(Window)}|%
      </div>
   </div>
   <div class="row" id="section3">
      <div id="passwordExpire" class="columns four">
         <label for="" id="userPasswordExpireLabel">
            §password_expires§
            <span class="helpQuestionMark" title="select the password expiry for the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/password_expires(TextMessage)/w(Window)}|%
      </div>
      <div id="userCreated" class="columns four">
         <label for="" id="userCreatedLabel">
            §user_created§
            <span class="helpQuestionMark" title="select the created date ">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_creation_time(TextMessage)/w(Window)}|%
      </div>
      <div id="connectionProfile" class="columns four">%|{connection_profiles(ElementChoiceOption)/group(CompleteGroup)/w(Window)}|%</div>
   </div>
   <div class="row" id="section4">
      <div id="userDailyLimit" class="columns four">
         <label for="" id="userDailyLimitLabel">
            §user_daily_limit§
            <span class="helpQuestionMark" title="Enter user daily limit value">?</span>
         </label>
         %|{user_daily_limit(PriceChoice)/group(CompleteGroup)/w(Window)}|%
      </div>
      <div class="columns four">
         <label>§user_daily_limit_enable_flag§</label>
         <div>%|{user_daily_limit_enable_flag(BooleanChoice)/group(CompleteGroup)/w(Window)}|%</div>
      </div>

      <div id="wrongPinCounter" class="columns four">
         <label for="" id="wrongPinCounter">
            §wrong_pin_attempts§
         </label>
          %|{edit_user_information(EditUserInformation)/wrong_pin_attempts_counter(TextChoice)/w(Window)}|%
      </div>

   </div>
   <div class="row" id="doActionsResellerUserInformation">
      <div id="resellerUserButtons1">%|{do_update(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons2">%|{do_reset_password(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons3">%|{do_reset_password_ussd(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons4">%|{do_expire_password(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons5">%|{do_reset_counter(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons6">%|{do_reset_activation_code(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons7">%|{do_block_user(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons8">%|{do_unblock_user(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
   </div>
</div>','2009-11-06 12:09:00','?(RefillAdmin)','2009-11-06 12:09:00','2009-11-06 12:09:00','2009-11-06 12:09:00');

REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTManageReseller)/edit_domain_users(EditDomainUsers)/edit_user_information(EditUserInformation)/user_info(CompleteGroup)/w(Window)/appearance(StringResource)','<div class="row" id="editUserInformationSection">
   <div class="row" id="passwordChangeInitiated">%|{password_change_initiated(AtomicMessage)/w(Window)}|%</div>
   <div class="row" id="passwordChangeInitiated">%|{activation_code_sent(AtomicMessage)/w(Window)}|%</div>
   <div class="row" id="blockUserMsg">%|{user_blocked(AtomicMessage)/w(Window)}|%</div>
   <div class="row" id="section1">
      <div id="userId" class="columns four">
         <label for="" id="userIdLabel">
            §user_id§
            <span class="helpQuestionMark" title="Enter the User Id for the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_id(DODText)/w(Window)}|%
      </div>
      <div id="userPassword" class="columns four">
         <label for="" id="userPasswordLabel">
            §user_psw§
            <span class="helpQuestionMark" title="Enter the password for the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_psw(TextChoice)/w(Window)}{edit_user_information(EditUserInformation)/hidden_user_psw(TextChoice)/w(Window)}{edit_user_information(EditUserInformation)/nonEditable_user_password(DODText)/w(Window)}|%
      </div>
      <div id="userName" class="columns four">
         <label for="" id="userNameLabel">
            §user_name§
            <span class="helpQuestionMark" title="Enter the name of the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_name(TextChoice)/w(Window)}|%
      </div>
   </div>
   <div class="row" id="section2">
      <div id="userEmail" class="columns four">
         <label for="" id="userEmailLabel">
            §user_email§
            <span class="helpQuestionMark" title="Enter the email address of the rese">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_email(TextChoice)/w(Window)}{edit_user_information(EditUserInformation)/nonEditable_user_email(DODText)/w(Window)}|%
      </div>
      <div id="userPhone" class="columns four">
         <label for="" id="userPhoneLabel">
            §user_phone§
            <span class="helpQuestionMark" title="Enter the contact no. of the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_phone(TextChoice)/w(Window)}{edit_user_information(EditUserInformation)/nonEditable_user_phone(DODText)/w(Window)}|%
      </div>
      <div id="userRole" class="columns four">
         <label for="" id="userRoleLabel">
            §role§
            <span class="helpQuestionMark" title="Assign new role">?</span>
         </label>
         %|{roles(ElementChoiceOption)/group(CompleteGroup)/w(Window)}|%
      </div>
   </div>
   <div class="row" id="section3">
      <div id="passwordExpire" class="columns four">
         <label for="" id="userPasswordExpireLabel">
            §password_expires§
            <span class="helpQuestionMark" title="select the password expiry for the reseller">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/password_expires(TextMessage)/w(Window)}|%
      </div>
      <div id="userCreated" class="columns four">
         <label for="" id="userCreatedLabel">
            §user_created§
            <span class="helpQuestionMark" title="select the created date ">?</span>
         </label>
         %|{edit_user_information(EditUserInformation)/user_creation_time(TextMessage)/w(Window)}|%
      </div>
      <div id="connectionProfile" class="columns four">%|{connection_profiles(ElementChoiceOption)/group(CompleteGroup)/w(Window)}|%</div>
   </div>
   <div class="row" id="section4">
      <div id="userDailyLimit" class="columns four">
         <label for="" id="userDailyLimitLabel">
            §user_daily_limit§
            <span class="helpQuestionMark" title="Enter user daily limit value">?</span>
         </label>
         %|{user_daily_limit(PriceChoice)/group(CompleteGroup)/w(Window)}|%
      </div>
      <div class="columns four">
         <label>§user_daily_limit_enable_flag§</label>
         <div>%|{user_daily_limit_enable_flag(BooleanChoice)/group(CompleteGroup)/w(Window)}|%</div>
      </div>

      <div id="wrongPinCounter" class="columns four">
         <label for="" id="wrongPinCounter">
            §wrong_pin_attempts§
         </label>
          %|{edit_user_information(EditUserInformation)/wrong_pin_attempts_counter(TextChoice)/w(Window)}|%
      </div>

   </div>
   <div class="row" id="doActionsResellerUserInformation">
      <div id="resellerUserButtons1">%|{do_update(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons2">%|{do_reset_password(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons3">%|{do_reset_password_ussd(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons4">%|{do_expire_password(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons5">%|{do_reset_counter(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons6">%|{do_reset_activation_code(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons7">%|{do_block_user(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
      <div id="resellerUserButtons8">%|{do_unblock_user(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
   </div>
</div>','2009-11-06 12:09:00','?(RefillAdmin)','2009-11-06 12:09:00','2009-11-06 12:09:00','2009-11-06 12:09:00');

UPDATE `Refill`.`resources` SET data = CONCAT(IFNULL(data,""), '\nuser_daily_limit=User daily limit\nuser_daily_limit_enable_flag=Enable user Limit\nwrong_pin_attempts=Wrong pin attempts')  where datakey = '?(Len)/?(*)/?(EditUserInformation)/user_info(CompleteGroup)/w(Window)/langmap(StringResource)';

Update `Refill`.`resources` set data ='msg=<font color="white">User has been blocked!</font>'
where datakey = '?(Astd)/?(*)/?(EditUserInformation)/user_blocked(AtomicMessage)/w(Window)/langmap(StringResource)';
