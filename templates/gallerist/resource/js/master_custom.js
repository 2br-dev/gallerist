const image = document.getElementById('image');
var cropper;

$(() => {
    $('body').on("click", "#setCity", (e) => {
        e.preventDefault();
        var modalInstance = M.Modal.getInstance(document.querySelector('#city-selector'));
        modalInstance.close();
        var city = $('#cities').val();
        var region = $('#regions').val();
        $('#selected-city-input').val(city);
        $('#selected-region-input').val(region);
        $('#region').text(region);
        $('#city').text(city);
        $('#prompt').addClass('hidden');
        $('#selected-city').removeClass('hidden');
    });
    if(image){
        cropper = new Cropper(image, {
            aspectRatio: 'Free',
            zoomOnWheel: false
        });
        $('#image-degree').on('input', function(e){
            var degree = $(this).val();
            cropper.rotateTo(degree);
        });
        $('#image-scale').on('input', function(e){
            var scale = $(this).val();
            cropper.scale(scale);
        });
        $('#save-edited').on('click', function (e) {
            e.preventDefault();
            // console.log(cropper.getCroppedCanvas().toDataURL());
            $.ajax({
                url: $(this).data('url'),
                data: {
                    src: image.getAttribute('src'),
                    file: cropper.getCroppedCanvas().toDataURL()
                },
                type: 'POST',
                dataType: 'JSON',
                success: function(res){
                    if(res.success){
                        M.toast({html: 'Изображение сохранено'});
                        setTimeout(function(){
                            location.reload();
                        }, 500);
                    }
                },
                error: function(err){
                    console.error(err);
                }
            });
        });
        $('#reset-edited').on('click', function(e){
            e.preventDefault();
            cropper.scale(1);
            cropper.rotateTo(0);
        })
        $('#rotate-left').on('click', function(e){
            e.preventDefault();
            cropper.rotate(-1);
        });
        $('#rotate-right').on('click', function(e){
            e.preventDefault();
            cropper.rotate(1);
        });
    }
    $('body').on('click', '#send-purchase-request', sendPurchaseRequest);
    $('.phone-mask').inputmask("+7(999)9999-99-99");
    $('.email-mask').inputmask("email");
    $('body').on('click', '#personal-message-button', function(e){
        e.preventDefault();
        let form = $('#personal-message-form');
        let fd = new FormData(form[0]);
        $.ajax({
            url: form.data('url'),
            data: fd,
            type: 'POST',
            processData: false,
            contentType: false,
            dataType: 'JSON',
            success: function(res){
                if(res.success){
                    $.magnificPopup.close();
                    M.toast({html: 'Сообщение отправлено'})
                }else{
                    M.toast({html: 'Напишите сообщение'})
                }
            },
            error: function(err){
                M.toast({html: 'Произошла ошибка. Попробуйет еще раз'});
                console.error(err);
            }
        });
    });
});

function sendPurchaseRequest(e){
    if(e !== 'udefined'){
        e.preventDefault();
    }
    var form = $(this).closest('form');
    var fd = new FormData(form[0]);
    var instance =  M.Modal.getInstance(document.querySelector('#request'));
    $.ajax({
        url: $(this).data('url'),
        type: 'POST',
        data: fd,
        processData: false,
        contentType: false,
        dataType: 'JSON',
        success: function(res) {
            if(res.success){
                instance.close();
                M.toast({html: 'Заявка на покупку картины отправлена'});
            }else{
                M.toast({html: 'Не указан контакт для обратной связи', classes: 'toast-error'});
            }
        },
        error: function(err) {
            console.error(err);
        }
    });
}



