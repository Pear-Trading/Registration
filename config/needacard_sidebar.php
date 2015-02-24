<?php

echo   '<h2>Need a<br />PEAR card?</h2>
<h3>join the community</h3>
<h4>Visit any of these businesses:</h4>
<div style="height:300px; overflow:auto; left:0; float:left; list-style:none; margin:10px 0 20px 0; padding 0; width:300px;">';

$data = get_bartercard_businesses();

foreach ($data as $item)
{
    //array_push($business, $item['b_name'],$item['b_url'],$item['b_type'],$item['b_contact_number'],$item['b_contact_person']);

    if ($item['b_contact_number'] != "")
    {
        $contact = $item['b_contact_person']." (".$item['b_contact_number'].")";
    }
    else
    {
        $contact = "";
    }

    echo "
        <div style='background:#fff; padding: 10px; margin:0px'>
        <h4>".$item['b_name']."</h4>
        <a href='".$item['b_url']."' target='_blank'>".$item['b_url']."</a>
        <p>".$contact."</p>
        </div>

        ";
}
echo '     </div><div class="clearfix"></div>
    <h4>Contact us</h4>
    <ul>
    <li><a href="mailto:hello@barterproject.org">mike@smallgreenconsultancy.co.uk</a></li>
    <li><a href="http://www.peartrade.org/">http://www.peartrade.org/</a></li>
    </ul>';
?>
