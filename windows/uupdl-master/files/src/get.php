<?php
$updateId = isset($argv[1]) ? $argv[1] : 'c2a1d787-647b-486d-b264-f90f3782cdc6';
$usePack = isset($argv[2]) ? $argv[2] : 0;
$desiredEdition = isset($argv[3]) ? $argv[3] : 0;
$simple = isset($argv[4]) ? $argv[4] : 0;

require_once 'api/get.php';
require_once 'shared/main.php';

consoleLogger(brand('get'));
$files = uupGetFiles($updateId, $usePack, $desiredEdition);
if(isset($files['error'])) {
    die($files['error']);
}

$files = $files['files'];
$filesKeys = array_keys($files);

function sortBySize($a, $b) {
    global $files;

    if ($files[$a]['size'] == $files[$b]['size']) {
        return 0;
    }

    return ($files[$a]['size'] < $files[$b]['size']) ? -1 : 1;
}
usort($filesKeys, 'sortBySize');

if($simple == 1) {
    foreach($filesKeys as $val) {
        echo $val."|".$files[$val]['sha1']."|".$files[$val]['url']."\n";
    }
    die();
}

foreach($filesKeys as $val) {
    echo $files[$val]['url']."\n";
    echo '  out='.$val."\n";
    echo '  checksum=sha-1='.$files[$val]['sha1']."\n\n";
}
?>
