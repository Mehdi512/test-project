UPDATE `resources`
SET `data` = '%|{reseller_choice(ElementChoiceList)/group(CompleteGroup)/w(Window)}|%\n%|{messages(OUMessageGroup)/group(CompleteGroup)/w(Window)}|%'
WHERE `datakey`='?(Astd)/?(*)/?(OUTManageSubResellers)/group(CompleteGroup)/w(Window)/appearance(StringResource)' AND `ResourceGroup`='?(RefillAdmin)';