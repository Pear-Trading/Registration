<h2>Need a PEAR card?</h2>
<h3>join the community</h3>
<h4>Visit any of these businesses:</h4>
<div class="sidebar_business_list">
<?php
  $data = get_bartercard_businesses();

  foreach ($data as $item) {
    if ( ! empty( $item['b_contact_number'] ) ) {
        $contact = $item['b_contact_person']
                 . " ("
                 . $item['b_contact_number']
                 . ")";
    } else {
        $contact = "";
    }
?>
  <div class="sidebar_business_list_item">
    <h4><? echo $item['b_name'] ?></h4>
    <a href=' <? echo $item['b_url'] ?>' target='_blank'><? echo $item['b_url'] ?></a>
    <p><? echo $contact ?></p>
  </div>
<?
  }
?>
</div>
<div class="clearfix"></div>
<h4>Contact us</h4>
<ul>
  <li>
    <a href="mailto:hello@barterproject.org">mike@smallgreenconsultancy.co.uk</a>
  </li>
  <li>
    <a href="http://www.peartrade.org/">http://www.peartrade.org/</a>
  </li>
</ul>
