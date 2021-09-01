
<div class="formbox" >
            
    <div class="rs-tabs" role="tabpanel">
        <ul class="tab-nav" role="tablist">
                    <li class=" active"><a data-target="#gallerist-picture-tab0" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(0)}</a></li>
                    <li class=""><a data-target="#gallerist-picture-tab1" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(1)}</a></li>
                    <li class=""><a data-target="#gallerist-picture-tab6" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(6)}</a></li>
                    <li class=""><a data-target="#gallerist-picture-tab7" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(7)}</a></li>
        
        </ul>
        <form method="POST" action="{urlmake}" enctype="multipart/form-data" class="tab-content crud-form">
            <input type="submit" value="" style="display:none"/>
                        <div class="tab-pane active" id="gallerist-picture-tab0" role="tabpanel">
                                                                                                                                    {include file=$elem.__id->getRenderTemplate() field=$elem.__id}
                                                                                                                                                                                                                                                                                                                                                                                                        {include file=$elem.___tmpid->getRenderTemplate() field=$elem.___tmpid}
                                            
                                            <table class="otable">
                                                                                                                                                        
                                <tr>
                                    <td class="otitle">{$elem.__title->getTitle()}&nbsp;&nbsp;{if $elem.__title->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__title->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__title->getRenderTemplate() field=$elem.__title}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__description->getTitle()}&nbsp;&nbsp;{if $elem.__description->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__description->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__description->getRenderTemplate() field=$elem.__description}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__excost->getTitle()}&nbsp;&nbsp;{if $elem.__excost->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__excost->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__excost->getRenderTemplate() field=$elem.__excost}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__public->getTitle()}&nbsp;&nbsp;{if $elem.__public->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__public->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__public->getRenderTemplate() field=$elem.__public}</td>
                                </tr>
                                
                                                                                                                        
                        </table>
                                                </div>
                        <div class="tab-pane" id="gallerist-picture-tab1" role="tabpanel">
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                            <table class="otable">
                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__height->getTitle()}&nbsp;&nbsp;{if $elem.__height->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__height->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__height->getRenderTemplate() field=$elem.__height}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__width->getTitle()}&nbsp;&nbsp;{if $elem.__width->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__width->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__width->getRenderTemplate() field=$elem.__width}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__shape->getTitle()}&nbsp;&nbsp;{if $elem.__shape->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__shape->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__shape->getRenderTemplate() field=$elem.__shape}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__orientation->getTitle()}&nbsp;&nbsp;{if $elem.__orientation->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__orientation->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__orientation->getRenderTemplate() field=$elem.__orientation}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__style->getTitle()}&nbsp;&nbsp;{if $elem.__style->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__style->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__style->getRenderTemplate() field=$elem.__style}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__material->getTitle()}&nbsp;&nbsp;{if $elem.__material->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__material->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__material->getRenderTemplate() field=$elem.__material}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__base->getTitle()}&nbsp;&nbsp;{if $elem.__base->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__base->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__base->getRenderTemplate() field=$elem.__base}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__theme->getTitle()}&nbsp;&nbsp;{if $elem.__theme->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__theme->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__theme->getRenderTemplate() field=$elem.__theme}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__is_original->getTitle()}&nbsp;&nbsp;{if $elem.__is_original->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__is_original->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__is_original->getRenderTemplate() field=$elem.__is_original}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__in_baguette->getTitle()}&nbsp;&nbsp;{if $elem.__in_baguette->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__in_baguette->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__in_baguette->getRenderTemplate() field=$elem.__in_baguette}</td>
                                </tr>
                                
                                                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__in_stock->getTitle()}&nbsp;&nbsp;{if $elem.__in_stock->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__in_stock->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__in_stock->getRenderTemplate() field=$elem.__in_stock}</td>
                                </tr>
                                
                                                            
                        </table>
                                                </div>
                        <div class="tab-pane" id="gallerist-picture-tab6" role="tabpanel">
                                                                                                            {include file=$elem.___photo_->getRenderTemplate() field=$elem.___photo_}
                                                                                                
                                                </div>
                        <div class="tab-pane" id="gallerist-picture-tab7" role="tabpanel">
                                                                                                                            
                                            <table class="otable">
                                                                                            
                                <tr>
                                    <td class="otitle">{$elem.__has_image->getTitle()}&nbsp;&nbsp;{if $elem.__has_image->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__has_image->getHint()|escape}">?</a>{/if}
                                    </td>
                                    <td>{include file=$elem.__has_image->getRenderTemplate() field=$elem.__has_image}</td>
                                </tr>
                                
                                                            
                        </table>
                                                </div>
            
        </form>
    </div>
    </div>