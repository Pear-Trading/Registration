<?php

  $pass = "banana";

  echo $pass . "<br>";

  $hashed_pass = password_hash("banana", PASSWORD_BCRYPT);

  echo $hashed_pass . "<br>";

  $verified = password_verify($pass, $hashed_pass);

  echo $verified . "<br>";

  $denied = password_verify("poop", $hashed_pass);

  echo $denied . "<br>";

?>
