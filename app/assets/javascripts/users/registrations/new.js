$(document).ready(function() {
  var isValid = function (ids) {
    var validations = []
    var $form      = $('#new_user');
    var validators = $form[0].ClientSideValidations.settings.validators;
    $.each(ids, function (i, id) {
      $input = $(id);
      validations.push($input.isValid(validators))
    })
    return validations.every(function (v) { return v == true })
  }

  STEPS = {
    isValidStep1: function() {
      fields = ['#user_sponsor_username', '#user_username', '#user_name',
                '#user_phone', '#user_email', '#user_gender', '#user_password',
                '#user_birthdate', '#user_registration_type']
      return isValid(fields)
    },
    isValidStep2: function(){
      return validateFieldsByUserRegistrationType()
    },
    isValidStep3: function() {
      fields = ['#user_zipcode', '#user_district', '#user_city', '#user_state']
      return isValid(fields)
    }
  }

  $('#rootwizard').bootstrapWizard({
    onTabShow: function(tab, navigation, index) {
      var $total = navigation.find('li').length;
      var $current = index+1;
      var $percent = ($current/$total) * 100;
      $('#rootwizard .progress-bar').css({width:$percent+'%'});

      $form = $('#new_user');
      $form.enableClientSideValidations()
    },
    onNext: function(tab, navigation, index) {
      var step = index + 1
      return isPreviousFormsValid(step)
    },
    onTabClick: function(tab, navigation, index) {
      var step = index + 2
      return isPreviousFormsValid(step);
    }
  });

  function isPreviousFormsValid(step) {
    if (step == 2)
      return STEPS.isValidStep1()
    if (step == 3)
      return STEPS.isValidStep1() && STEPS.isValidStep2()
  }

  $('.input-phone').mask('(00) 0000-00009', {clearIfNotMatch: true})
  $('.input-cpf').mask('000.000.000-00', {clearIfNotMatch: true})
  $('.input-cnpj').mask('00.000.000/0000-00', {clearIfNotMatch: true})
  $('.input-pis').mask('000.0000.000-0', {clearIfNotMatch: true})
  $('.input-zipcode').mask('00000-000', {clearIfNotMatch: true})

  const username_label_text = selectLabelByForAttribute('user_name').text()
  const admin_username_label_text = $("input[type='hidden']#admin_company_username").val()
  const legal_person_required_labels = ['user_document_cnpj', 'user_document_company_name',
                                      'user_document_ie', 'user_document_fantasy_name']

  $("select[name='user[registration_type]']").change(function (e) {
    if (isPhysicalPerson()) {
      showElements(['#pf-inputs'])
      hideElements(['#pj-inputs'])
      removeRequiredAbbrFrom(legal_person_required_labels)
      setLabelHtml('user_name', username_label_text)
    } else {
      showElements(['#pj-inputs'])
      hideElements(['#pf-inputs'])
      addRequiredAbbrTo(legal_person_required_labels)
      setLabelHtml('user_name', admin_username_label_text)
    }
  })

  $("select[name='user[registration_type]']").change();

  function isPhysicalPerson(){
    return $("select[name='user[registration_type]']").val() == 'pf'
  }

  function hideElements(elements) {
    $.each(elements, function(i, element){
      $(element).hide()
    })
  }

  function showElements(elements){
    $.each(elements, function(i, element){
      $(element).show()
    })
  }

  function validateFieldsByUserRegistrationType() {
    registration_type = $('select#user_registration_type').val()
    if (registration_type == 'pf')
      return validateInputDocumentCPF()
    else
      return validateLegalPersonFields()
  }

  function validateInputDocumentCPF(){
    cpf_input = $('input#user_document_cpf')
    message = $("input[type='hidden']#invalid_error_message").val()
    blank_message = $("input[type='hidden']#blank_error_message").val()

    cpf_format_validator = buildClientSideValidator('cpf', cpf_input, message)
    presence_validator = buildClientSideValidator('presence', cpf_input, blank_message)
    cpf_validator = mergeValidators(cpf_format_validator, presence_validator, 'user[document_cpf]')

    return cpf_input.isValid(cpf_validator)
  }

  function validateLegalPersonFields() {
    valid_cpf = validateInputDocumentCPF()
    valid_cnpj = validateInputDocumentCNPJ()
    required_fields_present = validateLegalPersonRequiredInputs()
    return valid_cpf && valid_cnpj && required_fields_present
  }

  function validateInputDocumentCNPJ() {
    cnpj_input = $('input#user_document_cnpj')
    message = $("input[type='hidden']#invalid_error_message").val()
    blank_message = $("input[type='hidden']#blank_error_message").val()

    cnpj_format_validator = buildClientSideValidator('cnpj', cnpj_input, message)
    presence_validator = buildClientSideValidator('presence', cnpj_input, blank_message)
    cnpj_validator = mergeValidators(cnpj_format_validator, presence_validator, 'user[document_cnpj]')

    return cnpj_input.isValid(cnpj_validator)
  }

  function validateLegalPersonRequiredInputs(){
    required_inputs = [$('#user_document_ie'), $('#user_document_company_name'), $('#user_document_fantasy_name')]
    message = $("input[type='hidden']#blank_error_message").val()
    validations = []
    $.each(required_inputs, function(i, input){
      presence_validator = buildClientSideValidator('presence', input, message)
      validations.push(input.isValid(presence_validator))
    })
    return isAllInputsValid(validations)
  }

  function isAllInputsValid(validations){
    validations.every(function(v) { v == true })
  }

  function buildClientSideValidator(name, element, error_message) {
    var element_name = '"' + element.attr('name') + '"'
    var message = '{"' + name + '":[{"message":"' + error_message + '"}]}'
    var validator = '{' + element_name + ':' + message  + '}'
    return JSON.parse(validator)
  }

  function mergeValidators(validator1, validator2, key){
    validators = Object.assign(validator1[key], validator2[key])
    validator = '{' + '"' + key + '":' + JSON.stringify(validators) + '}'
    return JSON.parse(validator)
  }

  function addRequiredAbbrTo(label_names){
    var required_abbr = '<abbr title="' + $('#required_text').val() + '">*</abbr>'
    $.each(label_names, function(i, label_name){
      label_element = selectLabelByForAttribute(label_name)
      label_element.prepend(required_abbr)
    })
  }

  function selectLabelByForAttribute(name){
    return $("label[for='" + name + "']")
  }

  function removeRequiredAbbrFrom(label_names){
    $.each(label_names, function(i, label_name){
      label_element = selectLabelByForAttribute(label_name)
      label_element.children('abbr').remove()
    })
  }

  function setLabelHtml(label_name, text){
    label = selectLabelByForAttribute(label_name)
    label.html(text)
  }

  $('input#user_document_cpf').focusout(function() { validateInputDocumentCPF() })
  $('input#user_document_cnpj').focusout(function() { validateInputDocumentCNPJ() })
});
