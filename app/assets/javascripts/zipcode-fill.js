$(document).ready(function () {

  var ZipcodeFill = function (zipcodeInput) {
    var thiz = this;

    $(zipcodeInput).blur(function () {
      var cep = $(this).val().replace(/\D/g, '')

      if (cep != '') {
        var validacep = /^[0-9]{8}$/

        if (validacep.test(cep)) {
          $('#user_district').val('...');
          $('#user_address').val('...');
          $('#user_city').val('...');
          $('#user_state').val('...');

          $.getJSON("https://viacep.com.br/ws/"+ cep +"/json/", function(dados) {

             if (!("erro" in dados)) {
                 //Atualiza os campos com os valores da consulta.
                 $("#user_address").val(dados.logradouro);
                 $("#user_district").val(dados.bairro);
                 $("#user_city").val(dados.localidade);
                 $("#user_state").val(dados.uf);
                 $("#user_address_ibge").val(dados.ibge);
             } //end if.
             else {
                 //CEP pesquisado não foi encontrado.
                 thiz.clearFields();
                 alert("CEP não encontrado.");
             }
         });
        } else {
          thiz.clearFields();
          alert("CEP não encontrado.");
        }
      } else {
        thiz.clearFields();
      }
    })
  }


  ZipcodeFill.prototype.clearFields = function () {
    $('#user_district').val('');
    $('#user_address').val('');
    $('#user_city').val('');
    $('#user_state').val('');
    $('#user_address_ibge').val('');
  }

  $("[data-zipcode-input]").each(function() {
    new ZipcodeFill(this);
  })

});
