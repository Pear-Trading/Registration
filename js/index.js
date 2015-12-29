$( function() {
  var set_form_customer = function() {
    $('#trader_details').hide();
    $('#customer_details').show();
    $('#account_business_name').prop("required", false);
    $('#b_postcode').prop("required", false);
  };

  var set_form_trader = function() {
    $('#trader_details').show();
    $('#customer_details').hide();
    $('#account_business_name').prop("required", true);
    $('#b_postcode').prop("required", true);
  }

  // initialise as a customer
  set_form_customer();

  $(".account_type").click( function() {
    if ($(this).attr("value") == "customer") {
      set_form_customer();
    } else {
      set_form_trader();
    }
  });

  $("input,select,textarea").not("[type=submit]").jqBootstrapValidation( {
    preventSubmit: true,
    submitError: function($form, event, errors) {
      console.log("submitError");
      alert("There seems to be an error submitting your details, please check"
          + "you have filled in all the required fields.");
    },
    submitSuccess: function ($form, event) {
      console.log("submitSuccess");
      var service;
      var manufacturer;
      var retailer;
      var type_fixed;
      var type_normadic;
      var wholesaler;

      if ($('#service').is(':checked')) {
        service = "&service=1";
      } else {
        service = "&service=0";
      }

      if ($('#manufacturer').is(':checked')) {
        manufacturer = "&manufacturer=1";
      } else {
        manufacturer = "&manufacturer=0";
      }

      if ($('#wholesaler').is(':checked')) {
        wholesaler = "&wholesaler=1";
      } else {
        wholesaler = "&wholesaler=0";
      }

      if ($('#retailer').is(':checked')) {
        retailer = "&retailer=1";
      } else {
        retailer = "&retailer=0";
      }

      if ($('#fixed').is(':checked')) {
        type_fixed = "&fixed=1";
      } else {
        type_fixed = "&fixed=0";
      }
      if ($('#normadic').is(':checked')) {
        type_normadic = "&normadic=1";
      } else {
        type_normadic = "&normadic=0";
      }

      var dob = "&age_group="+$('#age_group').val();

      var form = $('#add_user_form').find('input, textarea, select')
        .not(':checkbox')
        .serialize()
        form += service + manufacturer + wholesaler+ retailer + type_fixed + type_normadic + dob;

      console.log(form);

      $.ajax({
        type: 'POST',
        url: $form.attr('action'),
        data: form,
        success: function(data) {
          // just to confirm ajax submission
          console.log('submitted successfully!');
          var received_data = JSON.parse(data);

          document.getElementById('register_result').innerHTML = received_data.message +
          "<p><a href='<?=BASE_URL?>'>Go back to the home page.</a></p>";

          if(received_data.response == true) {
            document.getElementById('register_result').className='alert alert-success';
          } else {
            document.getElementById('register_result').className='alert alert-danger';
          }
        }
      });

      event.preventDefault();
    },
    filter: function() {
      return $(this).is(":visible");
    }
  });
});

