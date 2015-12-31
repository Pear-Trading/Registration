<?php

  function encrypt_password( $input, $rounds = 10) {

    $crypt_length = 22;
    $salt = "";
    $salt_chars = array_merge(
      range('A', 'Z'),
      range('a', 'z'),
      range(0, 9),
      array( '.', '/' )
    );

    for( $i = 0; $i < $crypt_length; $i++ ) {
      $salt .= $salt_chars[array_rand($salt_chars)];
    }

    echo $salt;
    echo "<br>";
    $crypt_options = sprintf('$2y$%02d$%s', $rounds, $salt);
    echo $crypt_options;
    echo "<br>";
    echo crypt($input, $crypt_options);
  }

  encrypt_password("");

?>
