
<div class="formbox" >
    {if $elem._before_form_template}{include file=$elem._before_form_template}{/if}

            
    <div class="rs-tabs" role="tabpanel">
        <ul class="tab-nav" role="tablist">
                            <li class=" active"><a data-target="#gallerist-config-file-tab0" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(0)}</a></li>
                            <li class=""><a data-target="#gallerist-config-file-tab1" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(1)}</a></li>
            
        </ul>
        <form method="POST" action="{urlmake}" enctype="multipart/form-data" class="tab-content crud-form">
            <input type="submit" value="" style="display:none">
                            <div class="tab-pane active" id="gallerist-config-file-tab0" role="tabpanel">
                                                                                                                                                                                                                                                                                                                                                                                            
                                                    <table class="otable">
                                                                    
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
                                        <td class="otitle">{$elem.__version->getTitle()}&nbsp;&nbsp;{if $elem.__version->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__version->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__version->getRenderTemplate() field=$elem.__version}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__core_version->getTitle()}&nbsp;&nbsp;{if $elem.__core_version->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__core_version->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__core_version->getRenderTemplate() field=$elem.__core_version}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__author->getTitle()}&nbsp;&nbsp;{if $elem.__author->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__author->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__author->getRenderTemplate() field=$elem.__author}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__enabled->getTitle()}&nbsp;&nbsp;{if $elem.__enabled->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__enabled->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__enabled->getRenderTemplate() field=$elem.__enabled}</td>
                                        </tr>
                                    
                                
                            </table>
                                                            </div>
                            <div class="tab-pane" id="gallerist-config-file-tab1" role="tabpanel">
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                    <table class="otable">
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_material->getTitle()}&nbsp;&nbsp;{if $elem.__prop_material->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_material->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_material->getRenderTemplate() field=$elem.__prop_material}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_shape->getTitle()}&nbsp;&nbsp;{if $elem.__prop_shape->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_shape->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_shape->getRenderTemplate() field=$elem.__prop_shape}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_orientation->getTitle()}&nbsp;&nbsp;{if $elem.__prop_orientation->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_orientation->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_orientation->getRenderTemplate() field=$elem.__prop_orientation}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_style->getTitle()}&nbsp;&nbsp;{if $elem.__prop_style->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_style->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_style->getRenderTemplate() field=$elem.__prop_style}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_base->getTitle()}&nbsp;&nbsp;{if $elem.__prop_base->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_base->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_base->getRenderTemplate() field=$elem.__prop_base}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_theme->getTitle()}&nbsp;&nbsp;{if $elem.__prop_theme->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_theme->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_theme->getRenderTemplate() field=$elem.__prop_theme}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_width->getTitle()}&nbsp;&nbsp;{if $elem.__prop_width->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_width->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_width->getRenderTemplate() field=$elem.__prop_width}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_height->getTitle()}&nbsp;&nbsp;{if $elem.__prop_height->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_height->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_height->getRenderTemplate() field=$elem.__prop_height}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_in_stock->getTitle()}&nbsp;&nbsp;{if $elem.__prop_in_stock->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_in_stock->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_in_stock->getRenderTemplate() field=$elem.__prop_in_stock}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_in_baguette->getTitle()}&nbsp;&nbsp;{if $elem.__prop_in_baguette->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_in_baguette->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_in_baguette->getRenderTemplate() field=$elem.__prop_in_baguette}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_is_original->getTitle()}&nbsp;&nbsp;{if $elem.__prop_is_original->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_is_original->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_is_original->getRenderTemplate() field=$elem.__prop_is_original}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__prop_city->getTitle()}&nbsp;&nbsp;{if $elem.__prop_city->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__prop_city->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__prop_city->getRenderTemplate() field=$elem.__prop_city}</td>
                                        </tr>
                                    
                                
                            </table>
                                                            </div>
            
        </form>
    </div>
    </div>