<?php
require 'config/con.php';
require 'config/const.php';
require 'config/utils.php';
?>
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="images/fav.png">
    <title>PEAR Trading - Registration</title>

    <link href="config/css/bootstrap.min.css" rel="stylesheet">
    <link href="config/css/bootstrap-glyphicons.css" rel="stylesheet">
    <link href="config/style.css" rel="stylesheet">
    <link href="css/main.css" rel="stylesheet">

    <script src="http://code.jquery.com/jquery.js"></script>
    <script src="config/js/bootstrap.min.js"></script>
    <script src="config/js/jqBootstrapValidation.js"></script>
    <script src="js/index.js"></script>

  </head>
  <body>

    <div id="header">
      <?php require_once('./config/header.php');?>
    </div>

   <div class="container">

      <h2>Please register your Pear Card Here</h2>
      <p>
        Welcome to Pear Card!  Pear Trading Ltd is a local initiative designed
        to collect local trading data in order to inform both citizens and
        businesses as to where there money goes and how it flows. The aim is to
        provide general feedback to the community so we can work together to
        keep as much of our money in the local economy as possible.
      </p>
      <p>
        To achieve this we have created a card, which we invite you to register.
      </p>
      <p>
        To help us with this we need some details from you. We don't require
        your life-story (you have probably already given that to other social
        media platforms) Just some minimum basic generic information for the
        system along with your name and card number so we can create an account
        for you.
      </p>
      <p>
        We promise we will not share your personally identifiable data with any
        third parties. As a business member people obviously need to know how
        to identify you so they can use your services. Beyond that we will
        leave it to both citizens and businesses how much they reveal about
        themselves as the social and interactive aspects of the Pear Trading
        platform grows.
      </p>
      <p>
        Michael Hallam
      </p>
      <p>
        System coordinator
      </p>

      <iframe
        width="560"
        height="315"
        src="//www.youtube.com/embed/1uQxQyAZEAk"
        frameborder="0"
        allowfullscreen>
      </iframe>

      <div class="row">

        <div class="col-12 col-sm-8 col-lg-8">
          <form class="form-horizontal"  id="add_user_form" name="add_user_form" action="php/add_user.php" method="post">
            <fieldset>
            
            <legend>Account Details</legend>
  
            <!-- Card ID Input -->
            <div class="form-group control-group">
              <label class="control-label col-lg-2" for="card_id">
                Card ID:
              </label>
              <div class="col-lg-10">
                <label for="card_id">
                  Please enter the ID shown on your Pear card
                  <a class="hover_span">
                    help
                    <div class="hover_content">
                      <p>You need to type in the card ID on your card. e.g. PEAR01</p>
                    </div>
                  </a>
                  <input
                    id="card_id"
                    name="card_id"
                    style="text-transform:uppercase"
                    type="text"
                    placeholder="PEAR01"
                    class="form-control"
                    required
                    data-validation-ajax-ajax="php/check_rfid.php"
                    maxlength="20"
                  >
                </label>
                <p class="help-block"><!-- Empty for errors --></p>
              </div>
            </div>
            <!-- /Card ID Input -->

            <!-- Account Type Selection -->
            <div class="form-group control-group">
              <label class="control-label col-lg-2" for="account">Account Type:</label>
              <div class="col-lg-10">
                  <input
                    class="account_type"
                    type="radio"
                    name="account"
                    value="customer"
                    checked> 
                  <span class="account_type_label">Customer</span>
                  <br>
                  <input
                    class="account_type"
                    type="radio"
                    name="account"
                    value="business">
                  <span class="account_type_label">Business</span>
                  <br>
                <input
                  class="account_type"
                  type="radio"
                  name="account"
                  value="organisation">
                <span class="account_type_label">Organisation (Not For Profit)</span>
              </div>
            </div>
            <!-- /Account Type Selection -->
            
            <!-- Name Input -->
            <div class="form-group control-group">
              <label class="control-label col-lg-2" for="name">Your Name:</label>
              <div class="col-lg-10 controls">
                <label for="account_name">
                  <h5 id="account_name">Please enter your full name</h5>
                  <input
                    id="account_name"
                    name="account_name"
                    type="text"
                    placeholder="Full Name"
                    class="form-control"
                    required
                  >
                </label>
                <p class="help-block"></p>
              </div>
            </div>
            <!-- /Name Input --> 
           
            <!-- Email Input -->
            <div class="form-group control-group">
              <label class="control-label col-lg-2" for="email">Email Address:</label>
              <div class="col-lg-4 controls">
                <input
                  id="email"
                  name="email"
                  type="email"
                  placeholder="email address"
                  class="form-control"
                  required>
                <p>(We will only use this to verify your account)</p>
                <p class="help-block"></p>
              </div>
            </div>
            <!-- /Email Input -->
            

            <!-- Postcode Input -->
            <div class="form-group control-group">
              <label class="control-label col-lg-2" for="postcode">Postcode:</label>
              <div class="col-lg-4 controls">
                <input
                  id="postcode"
                  name="postcode"
                  type="text"
                  placeholder="LA1 4XX"
                  class="form-control"
                  maxlength="8"
                  required 
                  data-validation-regex-regex="[A-Za-z][A-Za-z][0-9R][0-9A-Za-z ][ ]?[0-9][A-Za-z][A-Za-z]"
                  data-validation-regex-message="Please enter a valid UK postcode"
                  size="8"
                  style="text-transform:uppercase"
                >
                <p class="help-block"></p>
              </div>
            </div>
            <!-- /Postcode Input -->

            <!-- Age Group Input -->
            <div class="form-group control-group">
              <label class="control-label col-lg-2" for="age_group">Age Group:</label>
              <div class="col-lg-4 controls">
                <select id="age_group" name="age_group" class="form-control">
                  <option>Under 20</option>
                  <option>20-29</option>
                  <option>30-39</option>
                  <option>40-49</option>
                  <option>50-59</option>
                  <option>60-69</option>
                  <option>70+</option>
                </select>
              </div>
            </div>
            <!-- /Age Group Input -->
	
            <!-- Gender Input -->
            <div class="form-group control-group">
              <label class="control-label col-lg-2" for="gender">Gender:</label>
              <div class="col-lg-4 controls">
                <select id="gender" name="gender" class="form-control">
                  <option value="F">Female</option>
                  <option value="M">Male</option>
                  <option value="T">Transgender</option>
                  <option value="0">Rather not say</option>
                </select>
              </div>
            </div>

            <!-- Customer Details Set -->
            <div id="customer_details">

              <!-- Customer Employment Status -->
              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="employment_status">
                  Employment Status:
                </label>
                <div class="col-lg-4 controls">
                  <select id="employment_status" name="employment_status" class="form-control">
                    <option value="self_employed">Self Employed</option>
                    <option value="employed">Employed</option>
                    <option value="student">Student</option>
                    <option value="unpaid carer">Unpaid Carer</option>
                    <option value="looking for work">Looking for work</option>
                    <option value="other">Other</option>
                    <option value="unknown">Rather not say</option>
                  </select>
                </div>
              </div>
              <!-- /Customer Employment Status -->

              <!-- From Where Input -->
              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="barter_card"> </label>
                <div class="col-lg-10 controls">
                  <label  for="barter_card">Where did you pick up your Pear Card?
                    <input placeholder='Business name' type='text' id="barter_card" name="barter_card" class="form-control">
                  </label>
                </div>
              </div>
              <!-- /From Where Input -->

            </div>
            <!-- /Customer Details Set -->

            <!-- Business Details Set -->
            <div id="trader_details">

              <!-- Business Name Input -->
              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="name">Business Name:</label>
                <div class="col-lg-10 controls">
                  <label for="account_business_name">
                    <input id="account_business_name" name="account_business_name" type="text" placeholder="" class="form-control"  >
                  </label>
                  <p class="help-block"></p>
                </div>
              </div>
              <!-- /Business Name Input -->


              <!-- Business Postcode Input -->
              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="postcode">Business Postcode: <br /></label>
                <div class="col-lg-10 controls">
                  <label for="b_postcode">
                    <input
                      id="b_postcode"
                      name="b_postcode"
                      type="text"
                      placeholder="LA1 4ZZ"
                      class="form-control"
                      maxlength="8"
                      required 
                      data-validation-regex-regex="[A-Za-z][A-Za-z][0-9R][0-9A-Za-z ][ ]?[0-9][A-Za-z][A-Za-z]"
                      data-validation-regex-message="Please enter a valid UK postcode"  size="8" style="text-transform:uppercase">
                  </label>
                  <p class="help-block"></p>
                </div>
              </div>
              <!-- /Business Postcode Input -->

              <!-- Multiple Checkboxes -->
              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="trader_type">Type of Business:</label>
                <div class="col-lg-10 controls">
                  Select the options that best describe your business
                  <label class="checkbox" for="manufacturer">
                    <img src="images/manufacturer_icon_on.png" width="50px" style="float:left; margin: 0 20px 0 0;"/>
                    <br /><input type="checkbox" name="trader_type[]" id="manufacturer" value="manufacturer" minchecked="1" data-validation-minchecked-message="You must select at least one type of business.">
                    Manufacturing<br />
                  </label><br />
                  <label class="checkbox" for="wholesaler">
                    <img src="images/wholesaler_icon_on.png" width="50px" style="float:left; margin: 0 20px 0 0;"/>
                    <br /><input type="checkbox" name="trader_type[]" id="wholesaler" value="wholesaler">
                    Wholesaling<br />
                  </label><br />
                  <label class="checkbox" for="retailer">
                    <img src="images/retail_icon_on.png" width="50px" style="float:left; margin: 0 20px 0 0;"/>
                    <br /><input type="checkbox" name="trader_type[]" id="retailer" value="retailer">
                    Retailing<br />
                  </label><br />
                  <label class="checkbox" for="service">
                    <img src="images/service_icon_on.png" width="50px" style="float:left; margin: 0 20px 0 0;"/>
                    <br /><input type="checkbox" name="trader_type[]" id="service" value="service" >
                    Service<br />
                  </label>
                  <p class="help-block"></p>
                </div>
              </div>

              <!-- Multiple Checkboxes -->
              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="transaction_types">Style of Business:</label>
                <div class="col-lg-10 controls">
                  Select the options that best describes how you perform transactions
                  <label class="checkbox" for="fixed">
                    <img src="images/fixed_icon_on.png" width="50px" style="float:left; margin: 0 20px 0 0;"/>
                    <br /><input type="checkbox" name="transaction_types[]" id="fixed"  value="fixed" minchecked="1" data-validation-minchecked-message="You must select at least one stlye of trading.">
                    In a fixed location<br />(business premises, market stall etc)
                  </label><br />
                  <label class="checkbox" for="normadic" style="margin:10px 0 0 0;">
                    <img src="images/location_icon_on.png" width="50px" style="clear:both; float:left; margin: 0 20px 0 0;"/>
                    <br /><input type="checkbox" name="transaction_types[]"  id="normadic" value="normadic">
                    In varying locations<br />(at customers premises) 
                  </label>
                  <p class="help-block"></p>
                </div>
              </div>

              <!-- Textarea -->
              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="goods_services">What do you do? <br/> <a class="hover_span">why?
                  <div class="hover_content"><p>Tell your customers what you do. It will make it easier for them to search for you.</p></div></a>
                </label>
                <div class="col-lg-10 controls">           
                  <label  for="goods_services">
                    Itemise the goods and services you offer
                    <textarea id="goods_services" name="goods_services" placeholder="Marketing Design, Business Consultation" style="resize:none" class="form-control"></textarea>
                    <p>separate each item by a comma(,) remember make this as easy to search as possible  </p>
                  </label>
                </div>
              </div>

              <!-- Textarea -->
              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="statement">Statement: <br />
                  <a class="hover_span">
                    why?
                    <div class="hover_content">
                      <p>
                        You can write anything you would like here. <br />
                        See it as an area to write a personal message. <br />
                        Why should the customers support your business etc..
                      </p>
                    </div>
                  </a>
                </label>
                <div class="col-lg-10">        
                  <label  for="statement" >
                    Let your consumers know a little more about you / your business 

                    <textarea id="statement" name="statement" style="resize:none"  class="form-control" ></textarea>

                  </label>
                </div>
              </div>

            </div>

            <!-- Multiple Radios -->
            <div class="form-group control-group">
              <label class="control-label col-lg-2" for="ethical_pref">
                Community support preference:
                <br />
                <a class="hover_span">
                  what is it for?
                  <div class="hover_content">
                    <p>
                      We will ultimately be using this preference to support local initiatives in these sectors.
                    </p>
                  </div>
                </a>
              </label>
              <div>Please chose the one that you are most keen on supporting</div>
                <div class="col-lg-10">
                  <label class="radio" for="ethical_pref-0">
                    <input type="radio" name="ethical_pref_type" id="ethical_pref-0" value="capacity" checked="checked">
                    Individual capacity building and learning
                  </label>
                  <label class="radio" for="ethical_pref-1">
                    <input type="radio" name="ethical_pref_type" id="ethical_pref-1" value="community">
                    Community support and community building
                  </label>
                  <label class="radio" for="ethical_pref-2">
                    <input type="radio" name="ethical_pref_type" id="ethical_pref-2" value="environmental">
                    Environmental stewardship
                  </label>
                  <label class="radio" for="ethical_pref-3">
                    <input type="radio" name="ethical_pref_type" id="ethical_pref-3" value="wellbeing">
                    Economic well-being
                  </label>
                  <p class="help-block"></p>
                  <a href="http://www.smallgreenconsultancy.co.uk/the-four-bottom-lines-overview.html" target="_blank">more info</a>
                </div>
              </div>

              <div class="form-group control-group">
                <label class="control-label col-lg-2" for="terms-and-conditions">Legal</label>
                <div class="col-lg-10 controls">
                  <label for="terms-and-conditions">
                    <input type="checkbox"  name="terms-and-conditions" required data-validation-required-message="You must agree to the terms and conditions">
                    I agree to the <a href="http://www.peartrade.org/terms-and-conditions.html" target="_blank">terms and conditions</a>
                  </label>
                  <p class="help-block"></p>
                </div>
              </div>
              <div class="controls controls-row">
                <button type="submit" class="btn btn-success  btn-lg btn-block">Register</button>
                <div id='register_result' style='margin-top:20px;'></div>
              </div>
            </fieldset>
          </form>
          <br />
          <iframe width="560" height="315" src="https://www.youtube.com/embed/2ZzlNMUmadM" frameborder="0" allowfullscreen></iframe>
        </div>
          <div class="col-6 col-sm-4 col-lg-4">
            <?php require_once('./config/am_i_local.php');?>
            <?php require_once('./config/needacard_sidebar.php');?>
          </div>
        </div> <!-- /row -->
      </div> <!-- /container -->
    </body>
  </html>
