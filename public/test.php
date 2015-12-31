<?php

  $hashed_pass = password_hash("banana", PASSWORD_BCRYPT);

  echo $hashed_pass;

?>
