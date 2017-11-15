<?php
$lang = isset($argv[1]) ? $argv[1] : 'en-us';

require_once 'api/listeditions.php';

$editions = uupListEditions($lang);
if(isset($editions['error'])) {
    die($editions['error']);
}

$editions = $editions['editionFancyNames'];
asort($editions);

foreach($editions as $key => $val) {
    echo $key;
    echo '|';
    echo $val;
    echo "\n";
}
?>
