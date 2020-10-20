/**
 * Плагин, активирует древовидный выпадающий список
 *
 * @author ReadyScript lab.
 */
(function ($) {
    $.fn.cartAmount = function (data) {
        if ($(this).data('cartAmount')) return false;
        $(this).data('cartAmount', {});

        let defaults = {
            input: '.rs-cartAmount_input',
            addButton: '.rs-to-cart',
            increaseButton: '.rs-cartAmount_inc',
            decreaseButton: '.rs-cartAmount_dec',
            classInCart: 'rs-inCart',
            productId: null,
            amountAddToCart: 1,
            amountStep: 1,
            minAmount: null,
            maxAmount: null,
            amountBreakPoint: null,
            forbidRemoveProducts: false,
            forbidChangeRequests: false
        };

        let $this = $(this);
        $this.options = $.extend({}, defaults, data);
        $this.options.multiple = $this.attr('multiple');
        $this.options.disallow_select_branches = $this.attr('disallowSelectBranches');

        document.querySelector('body').addEventListener('cart.removeProduct', (event) => {
            if (event.detail.productId == $this.options.productId) {
                $($this.options.input, $this).val(0).trigger('keyup');
            }
        });
        
        $this
            // кнопка "В корзину"
            .on('click', $this.options.addButton, function () {
                $($this.options.input, $this).val($this.options.amountAddToCart);
                $this.addClass($this.options.classInCart);
                $this.trigger('add-product');
            })
            // нажатие на "плюсик"
            .on('click', $this.options.increaseButton, function () {
                let input = $($this.options.input, $this);
                let old_value = parseFloat(input.val());
                let new_value = Math.round((old_value + $this.options.amountStep) * 1000) / 1000;
                if (new_value < $this.options.minAmount) {
                    new_value = $this.options.minAmount;
                }
                if (old_value < $this.options.amountBreakPoint && new_value > $this.options.amountBreakPoint) {
                    new_value = $this.options.amountBreakPoint;
                }
                if ($this.options.maxAmount !== null && new_value > $this.options.maxAmount) {
                    new_value = $this.options.maxAmount;
                    $this.trigger('max-limit');
                } else {
                    $this.trigger('increase-amount');
                }
                input.val(new_value).trigger('keyup');

                return false;
            })
            // нажатие на "минусик"
            .on('click', $this.options.decreaseButton, function () {
                let input = $($this.options.input, $this);
                let old_value = parseFloat(input.val());
                let new_value = Math.round((old_value - $this.options.amountStep) * 1000) / 1000;
                if (new_value < $this.options.minAmount) {
                    new_value = 0;
                }
                if (old_value > $this.options.amountBreakPoint && new_value < $this.options.amountBreakPoint) {
                    new_value = $this.options.amountBreakPoint;
                }
                if (new_value != 0 || !$this.options.forbidRemoveProducts) {
                    $this.trigger('decrease-amount');
                    input.val(new_value).trigger('keyup');
                }

                return false;
            })
            // изменение количества
            .on('keyup', $this.options.input, function(){
                let amount = $(this).val();
                if ($this.options.maxAmount !== null && amount > $this.options.maxAmount) {
                    amount = $this.options.maxAmount;
                    $this.trigger('max-limit');
                }
                if (amount == 0) {
                    if ($this.options.forbidRemoveProducts) {
                        amount = $this.options.amountAddToCart;
                        $(this).val(amount);
                    } else {
                        $this.removeClass($this.options.classInCart);
                        $this.trigger('remove-product');
                    }
                }
                let url = $this.data('url');
                let data = {
                    id: $this.options.productId,
                    amount: amount
                };
                if (!$this.options.forbidChangeRequests) {
                    $.ajax({
                        url: url,
                        data: data,
                        type: 'POST',
                        dataType: 'json',
                        success: function (response) {
                            if (response.success) {
                                $.cart('refresh');
                            }
                        }
                    });
                }
            });
    };

    $(document).ready(function () {
        $('body').on('new-content', () => {
            $('.rs-cartAmount').each(function () {
                $(this).cartAmount($(this).data('cartAmountOptions'));
            });
        });

        $('.rs-cartAmount').each(function () {
            $(this).cartAmount($(this).data('cartAmountOptions'));
        });
    });
})(jQuery);