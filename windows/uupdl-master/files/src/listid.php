<?php
require_once 'api/listid.php';
require_once 'shared/main.php';

consoleLogger(brand('listid'));
$ids = uupListIds();
if(isset($ids['error'])) {
    die($ids['error']);
}

foreach($ids['builds'] as $val) {
    echo $val['build'];
    echo '|';
    echo $val['arch'];
    echo '|';
    echo $val['uuid'];
    echo '|';
    echo $val['title'];
    echo "\n";
}
?>
