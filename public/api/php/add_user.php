<?php
#error_reporting(0);
#ini_set('display_errors', '0');
//debug statements
//consumer
//card_id=12345678&account=consumer&account_name=Mark+Lochrie&username=marklochrie&password1=mypass1&password2=mypass1&email=marklochrie50265%40gmail.com&gender=M&postcode=LA1+4DG&ethical_pref=environmental_impact&goods_services=&statement=&service=false&manufacturer=false&retailer=false&fixed=false&normadic=false&dob=19-08-1986 

//trader
//

//include the database class
require 'config/con.php';
require 'config/const.php';
require 'config/utils.php';

if (isset($_REQUEST['card_id']))
{
	//get the data
	$card_id = $_REQUEST['card_id'];
	$account = $_REQUEST['account'];
	$account_name = $_REQUEST['account_name'];
	$password1 = "";
	
  $age_group = $_REQUEST['age_group'];
	
	$email = $_REQUEST['email'];
	$gender = $_REQUEST['gender'];
	$postcode = $_REQUEST['postcode'];
	
	//$postcode = $postcode1." ".$postcode2;
	
	
	
	//taken the movie tag out
	$movie ="";
	$ethical_pref = $_REQUEST['ethical_pref_type'];
	
	
	if (($account == 'business') || ($account == 'organisation'))
	{
		$user_type        = $account;
		$account          = 1;
		$wholesaler       = $_REQUEST['wholesaler'];
		$service          = $_REQUEST['service'];
		$manufacturer     = $_REQUEST['manufacturer'];
		$retailer         = $_REQUEST['retailer'];
		$fixed            = $_REQUEST['fixed'];
		$normadic         = $_REQUEST['normadic'];
		$goods_services   = $_REQUEST['goods_services'];
		$trader_statement = $_REQUEST['statement'];
		$business_name    = $_REQUEST['account_business_name'];
		
		$bpostcode = $_REQUEST['b_postcode'];
		
		//convert postcode data into lat/lon
		$latlon = geoencodeaddress($bpostcode);

		$barter_card = "unknown";
		$emplyment_status = "";
	}
	
	else
	{
		$user_type = $account;
		$account = 0;
		$service = 0;
		$wholesaler = 0;
		$manufacturer = 0;
		$retailer = 0;
		$fixed = 0;
		$normadic = 0;
		$goods_services = "";
		$trader_statement = "";
		$business_name = "";
		$bpostcode = "";
		$latlon = geoencodeaddress($postcode);
		$barter_card = $_REQUEST['barter_card'];
		$emplyment_status = $_REQUEST['employment_status'];
	}
	
	//$ethical_pref = $environmental.";".$social.";".$economic.";".$wellbeing;
	
	//get the consumer_rfid from the databas
	$stmt = DB::get()->prepare("SELECT user_card_id FROM tbl_users WHERE user_card_id=:card_id");
	$stmt->bindParam(':card_id', $card_id, PDO::PARAM_STR);
	$stmt->execute();
		
	//setting the fetch mode  
	$stmt->setFetchMode(PDO::FETCH_ASSOC); 
	$row = $stmt->rowCount();
	
	$pass_key = generate_random_string();
	
	//set the response for the client	
	$ajax_response = false;
		if($row == 0)
		{
			//no consumers with this card are registerd
			//add new consumer
			$statement = DB::get()->prepare("INSERT INTO tbl_users (user_name, user_card_id, user_gender, user_age_group, user_postcode, user_ethical_pref, user_email, user_type, user_character, user_employment_status, hear_about_us, business_name, business_postcode, is_trader, is_manufacturer, is_wholesaler, is_retailer, is_service, is_fixed_trader, is_non_fixed_trader, user_business_lat, user_business_lon, goods_services, statement, pass_key, user_pass) values
			(:uname, :rfid, :gender, :age_group, :postcode, :ethical_pref, :email, :type, :movie, :estatus, :hear, :bname, :bpc, :trader, :manufacturer, :wholesaler, :retailer, :service, :fixed_trader, :non_fixed_trader, :lat, :lon, :items, :trader_statement, :passkey, :upass)");
			$statement->bindParam(':uname', $account_name, PDO::PARAM_STR);
			$statement->bindParam(':rfid', $card_id, PDO::PARAM_STR);
			$statement->bindParam(':gender', $gender, PDO::PARAM_STR);
			$statement->bindParam(':age_group', $age_group, PDO::PARAM_STR);
			$statement->bindParam(':postcode', $postcode, PDO::PARAM_STR);
			$statement->bindParam(':ethical_pref', $ethical_pref, PDO::PARAM_STR);
			$statement->bindParam(':email', $email, PDO::PARAM_STR);
			$statement->bindParam(':type', $user_type, PDO::PARAM_STR);
			$statement->bindParam(':movie', $movie, PDO::PARAM_STR);
			$statement->bindParam(':estatus', $emplyment_status, PDO::PARAM_STR);
			$statement->bindParam(':hear', $barter_card, PDO::PARAM_STR);
			$statement->bindParam(':bname', $business_name, PDO::PARAM_STR);
			$statement->bindParam(':bpc', $bpostcode, PDO::PARAM_STR);
			$statement->bindParam(':trader', $account, PDO::PARAM_INT);
			$statement->bindParam(':manufacturer', $manufacturer, PDO::PARAM_INT);
			$statement->bindParam(':wholesaler', $wholesaler, PDO::PARAM_INT);
			$statement->bindParam(':retailer', $retailer, PDO::PARAM_INT);
			$statement->bindParam(':service', $service, PDO::PARAM_INT);
			$statement->bindParam(':fixed_trader', $fixed, PDO::PARAM_INT);
			$statement->bindParam(':non_fixed_trader', $normadic, PDO::PARAM_INT);
			$statement->bindParam(':lat', $latlon['latitude'], PDO::PARAM_STR);
			$statement->bindParam(':lon', $latlon['longitude'], PDO::PARAM_STR);
			$statement->bindParam(':items', $goods_services, PDO::PARAM_STR);
			$statement->bindParam(':trader_statement', $trader_statement, PDO::PARAM_STR);
			$statement->bindParam(':passkey', $pass_key, PDO::PARAM_STR);
			$statement->bindParam(':upass', $password1, PDO::PARAM_STR);
			
			//$statement->debugDumpParams();
			
			//execute the query
			if($statement->execute())
			{
        email_new_user($account_name, $email, $pass_key);

				$ajax_response = true;
				$ajax_message = "Welcome! $account_name, you have successfully been registered. We will shortly send you an email, you will need follow the instructions in order to verify your account with us.";
			}
			else
			{
				$ajax_response = false;
				$ajax_message = "There seems to be an issue with our system at the moment, please try again later or alternativly contact us on info@barterproject.org";
			}
		}
		else
		{
			$ajax_message = "Someone with that card number has already been registered, please make sure the number printed on the front of your card is correct.";
		}
}
else
{
	$ajax_response = "";
	$ajax_message = "";
}
	$data_to_send = array('response' => $ajax_response, 'message' => $ajax_message);
	echo json_encode($data_to_send);
	
	

?>
