
<div class="formbox" >
            
    <div class="rs-tabs" role="tabpanel">
        <ul class="tab-nav" role="tablist">
                    <li class=" active"><a data-target="#users-usergroup-tab0" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(0)}</a></li>
                    <li class=""><a data-target="#users-usergroup-tab1" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(1)}</a></li>
                    <li class=""><a data-target="#users-usergroup-tab2" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(2)}</a></li>
                    <li class=""><a data-target="#users-usergroup-tab3" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(3)}</a></li>
        
        </ul>
        <form method="POST" action="{urlmake}" enctype="multipart/form-data" class="tab-content crud-form">
            <input type="submit" value="" style="display:none"/>
                        <div class="tab-pane active" id="users-usergroup-tab0" role="tabpanel">
                                                                                                                                                                                                                                                                                                                                        
                                            <table class="otable">
                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__alias->getTitle()}&nbsp;&nbsp;{if $elem.__alias->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__alias->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__alias->getRenderTemplate() field=$elem.__alias}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__name->getTitle()}&nbsp;&nbsp;{if $elem.__name->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__name->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__name->getRenderTemplate() field=$elem.__name}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__description->getTitle()}&nbsp;&nbsp;{if $elem.__description->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__description->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__description->getRenderTemplate() field=$elem.__description}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__is_admin->getTitle()}&nbsp;&nbsp;{if $elem.__is_admin->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__is_admin->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__is_admin->getRenderTemplate() field=$elem.__is_admin}</td>
                                </tr>
                                
                                                            
                        </table>
                                                </div>
                        <div class="tab-pane" id="users-usergroup-tab1" role="tabpanel">
                                                                                                            {include file=$elem.____access__->getRenderTemplate() field=$elem.____access__}
                                                                                                
                                                </div>
                        <div class="tab-pane" id="users-usergroup-tab2" role="tabpanel">
                                                                                                                            
                                            <table class="otable">
                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__user_cost->getTitle()}&nbsp;&nbsp;{if $elem.__user_cost->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__user_cost->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__user_cost->getRenderTemplate() field=$elem.__user_cost}</td>
                                </tr>
                                
                                                            
                        </table>
                                                </div>
                        <div class="tab-pane" id="users-usergroup-tab3" role="tabpanel">
                                                                                                                            
                                            <table class="otable">
                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__basket_min_limit->getTitle()}&nbsp;&nbsp;{if $elem.__basket_min_limit->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__basket_min_limit->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__basket_min_limit->getRenderTemplate() field=$elem.__basket_min_limit}</td>
                                </tr>
                                
                                                            
                        </table>
                                                </div>
            
        </form>
    </div>
    </div>