<?php
$arch = isset($argv[1]) ? $argv[1] : 'amd64';
$ring = isset($argv[2]) ? $argv[2] : 'WIF';
$flight = isset($argv[3]) ? $argv[3] : 'Active';
$build = isset($argv[4]) ? intval($argv[4]) : 16251;
$minor = isset($argv[5]) ? intval($argv[5]) : 0;

require_once 'api/fetchupd.php';
require_once 'shared/main.php';

consoleLogger(brand('fetchupd'));
$fetchedUpdate = uupFetchUpd($arch, $ring, $flight, $build, $minor);
if(isset($fetchedUpdate['error'])) {
    die($fetchedUpdate['error']);
}

echo $fetchedUpdate['foundBuild'];
echo '|';
echo $fetchedUpdate['arch'];
echo '|';
echo $fetchedUpdate['updateId'];
echo '|';
echo $fetchedUpdate['updateTitle'];
echo '|';
echo $fetchedUpdate['fileWrite'];
echo "\n";
?>
