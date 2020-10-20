
<div class="formbox" >
    {if $elem._before_form_template}{include file=$elem._before_form_template}{/if}

            
    <div class="rs-tabs" role="tabpanel">
        <ul class="tab-nav" role="tablist">
                            <li class=" active"><a data-target="#kaptcha-config-file-tab0" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(0)}</a></li>
                            <li class=""><a data-target="#kaptcha-config-file-tab1" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(1)}</a></li>
                            <li class=""><a data-target="#kaptcha-config-file-tab2" data-toggle="tab" role="tab">{$elem->getPropertyIterator()->getGroupName(2)}</a></li>
            
        </ul>
        <form method="POST" action="{urlmake}" enctype="multipart/form-data" class="tab-content crud-form">
            <input type="submit" value="" style="display:none">
                            <div class="tab-pane active" id="kaptcha-config-file-tab0" role="tabpanel">
                                                                                                                                                                                                                                                                                                                                                                                            
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
                            <div class="tab-pane" id="kaptcha-config-file-tab1" role="tabpanel">
                                                                                                                                                                                                                                                                                    
                                                    <table class="otable">
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__rs_captcha_allowed_symbols->getTitle()}&nbsp;&nbsp;{if $elem.__rs_captcha_allowed_symbols->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__rs_captcha_allowed_symbols->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__rs_captcha_allowed_symbols->getRenderTemplate() field=$elem.__rs_captcha_allowed_symbols}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__rs_captcha_length->getTitle()}&nbsp;&nbsp;{if $elem.__rs_captcha_length->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__rs_captcha_length->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__rs_captcha_length->getRenderTemplate() field=$elem.__rs_captcha_length}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__rs_captcha_width->getTitle()}&nbsp;&nbsp;{if $elem.__rs_captcha_width->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__rs_captcha_width->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__rs_captcha_width->getRenderTemplate() field=$elem.__rs_captcha_width}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__rs_captcha_height->getTitle()}&nbsp;&nbsp;{if $elem.__rs_captcha_height->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__rs_captcha_height->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__rs_captcha_height->getRenderTemplate() field=$elem.__rs_captcha_height}</td>
                                        </tr>
                                    
                                
                            </table>
                                                            </div>
                            <div class="tab-pane" id="kaptcha-config-file-tab2" role="tabpanel">
                                                                                                                                                                                                                                                                                    
                                                    <table class="otable">
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__recaptcha_v3_site_key->getTitle()}&nbsp;&nbsp;{if $elem.__recaptcha_v3_site_key->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__recaptcha_v3_site_key->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__recaptcha_v3_site_key->getRenderTemplate() field=$elem.__recaptcha_v3_site_key}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__recaptcha_v3_secret_key->getTitle()}&nbsp;&nbsp;{if $elem.__recaptcha_v3_secret_key->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__recaptcha_v3_secret_key->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__recaptcha_v3_secret_key->getRenderTemplate() field=$elem.__recaptcha_v3_secret_key}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__recaptcha_v3_success_score->getTitle()}&nbsp;&nbsp;{if $elem.__recaptcha_v3_success_score->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__recaptcha_v3_success_score->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__recaptcha_v3_success_score->getRenderTemplate() field=$elem.__recaptcha_v3_success_score}</td>
                                        </tr>
                                    
                                                                    
                                        <tr>
                                        <td class="otitle">{$elem.__recaptcha_v3_hide_sticker->getTitle()}&nbsp;&nbsp;{if $elem.__recaptcha_v3_hide_sticker->getHint() != ''}<a class="help-icon" data-placement="right" title="{$elem.__recaptcha_v3_hide_sticker->getHint()|escape}">?</a>{/if}
                                        </td>
                                        <td>{include file=$elem.__recaptcha_v3_hide_sticker->getRenderTemplate() field=$elem.__recaptcha_v3_hide_sticker}</td>
                                        </tr>
                                    
                                
                            </table>
                                                            </div>
            
        </form>
    </div>
    </div>