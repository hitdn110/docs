<?php
require_once 'api/listlangs.php';

$langs = uupListLangs();
$langs = $langs['langFancyNames'];
asort($langs);

foreach($langs as $key => $val) {
    echo $key;
    echo '|';
    echo $val;
    echo "\n";
}
?>
