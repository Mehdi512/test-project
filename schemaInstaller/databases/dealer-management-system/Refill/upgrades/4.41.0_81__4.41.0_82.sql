REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Astd)/?(*)/?(OUTManageProducts)/group(CompleteGroup)/w(Window)/appearance(StringResource)','<div class="row flowControlForProducts pageHeader">

    <div class="row">
        <div class="columns three">
            <label for="" class="input-header">§product_name§ <span class="helpQuestionMark" title="Enter product name to search"> ?</span></label>%|{products(OUTManageProducts)/search_for_product_name(TextChoice)/w(Window)}|% </div>
        <div class="columns three">
            <label for="" class="input-header">§product_SKU§ <span class="helpQuestionMark" title="Enter product SKU to search"> ?</span></label><span id="systemUserRoleField">%|{products(OUTManageProducts)/search_for_product_SKU(TextChoice)/w(Window)}|%</span></div>
        <div class="columns three">
            <label for="" class="input-header">§product_EAN§ <span class="helpQuestionMark" title="Enter product EAN code to search"> ?</span></label>%|{products(OUTManageProducts)/search_for_product_EAN(TextChoice)/w(Window)}|%</div>
        <div class="columns three">
            <label for="" class="input-header">§product_type§ <span class="helpQuestionMark" title="Select product type"> ?</span></label>%|{product_type(OUTSelectProductType)/group(CompleteGroup)/w(Window)}|%</div>
    </div>
    <div class="row" id="searchProduct"> <span id="doSearchProductsButton">%|{do_search_product(FlowControl)/group(CompleteGroup)/w(Window)}|%</span> </div>
    <div class="row flowControlButtonsSectionOne">
        <div class="doAddETopupFreeDenomination columns six"> %|{do_add_etopup_product(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
        <div class="doAddETopupFixDenominations columns six"> %|{do_add_etopup_fixed_denom_product(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
    </div>
    <div class="row flowControlButtonsSectionTwo">
        <div class="columns six doAddTransferFreeDenominations"> %|{do_add_transfer_product(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
        <div class="columns six doAddTransferFixedDenominations"> %|{do_add_transfer_fixed_denom_product(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
    </div>
    <div class="row flowControlButtonsSectionThree">
        <div class="columns six doAddEvoucherProducts"> %|{do_add_evoucher_product(FlowControl)/group(CompleteGroup)/w(Window)}|%</div>
    </div>
    %|{product(OUTManageProduct)/group(CompleteGroup)/w(Window)}|% %|{create_evoucher_products(OUTCreateEVoucherProducts)/group(CompleteGroup)/w(Window)}|%
</div>','2022-05-17 09:48:29','?(RefillAdmin)','2022-05-17 10:03:59','2022-05-17 10:07:02','2022-05-17 10:07:02');
REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(OUTManageProducts)/do_search_product(FlowControl)/?(Window)/langmap(StringResource)','msg=Search\n','2022-09-17 12:38:28','?(RefillAdmin)','2022-07-05 19:05:27','2005-07-05 19:06:26','2022-07-05 17:06:26');
REPLACE INTO `Refill`.`resources` (`datakey`, `data`, `LastUpdated`, `ResourceGroup`, `startup`, `touched`, `last_modified`) VALUES
('?(Len)/?(*)/?(OUTManageProducts)/group(CompleteGroup)/w(Window)/langmap(StringResource)','\nproduct_name=product name\nproduct_SKU=product SKU\nproduct_EAN=product EAN\nproduct_type=product type','2022-09-17 12:38:28','?(RefillAdmin)','2022-07-05 19:05:27','2005-07-05 19:06:26','2022-07-05 17:06:26');
