REPLACE INTO Refill.`id_scenarios` (`ScenarioKey`, `ScenarioName`, `ScenarioDescription`, `ScenarioGroup`, `last_modified`, `domain_key`) VALUES
(313,'Advanced contract management','Advanced contract management','Admin/Advanced Contract',NOW(),3);

REPLACE INTO Refill.`id_scenario_objects` (`ObjectKey`, `ScenarioKey`, `ObjectPath`, `AutoActivate`, `ErrorMark`, `Comment`) VALUES
(521,313,'/site(Site)/default-shared(AdminApp)/admin_ERS(OUTAdminERSSystem)/main_menu(StaticMenu)/admin(StaticMenu)/manage_advanced_contracts(FlowControl)',0,0,'New scenario object for ERS 4.0');
