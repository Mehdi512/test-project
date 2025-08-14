--
-- $Id$
--

alter table `reseller_types` 
	drop column `payment_option_key`, 
	drop column `invoicing_type`, 
	drop column `use_etopup_product`, 
	drop column `resellersite_reportgroup`, 
	drop column `resellersite_inforeport_key`, 
	drop column `resellersite_helpreport_key`;
   
