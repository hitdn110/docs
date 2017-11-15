<?php
/*
Copyright 2017 UUP dump API authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

require_once dirname(__FILE__).'/shared/main.php';
require_once dirname(__FILE__).'/shared/requests.php';
require_once dirname(__FILE__).'/listid.php';

function uupFetchUpd($arch = 'amd64', $ring = 'WIF', $flight = 'Active', $build = '16251', $minor = '0') {
    uupApiPrintBrand();

    $arch = strtolower($arch);
    $ring = strtoupper($ring);
    $flight = ucwords(strtolower($flight));
    if($flight == 'Current') $flight = 'Active';

    if(!($arch == 'amd64' || $arch == 'x86' || $arch == 'arm64')) {
        return array('error' => 'UNKNOWN_ARCH');
    }

    if(!($ring == 'WIF' || $ring == 'WIS' || $ring == 'RP' || $ring == 'RETAIL')) {
        return array('error' => 'UNKNOWN_RING');
    }

    if(!($flight == 'Skip' || $flight == 'Active')) {
        return array('error' => 'UNKNOWN_FLIGHT');
    }

    if($flight == 'Skip' && $ring != 'WIF') {
        return array('error' => 'UNKNOWN_COMBINATION');
    }

    if($build < 15063 || $build > 65536) {
        return array('error' => 'ILLEGAL_BUILD');
    }

    if($minor < 0 || $minor > 65536) {
        return array('error' => 'ILLEGAL_MINOR');
    }

    if($flight == 'Active' && $ring == 'RP') $flight = 'Current';

    $build = '10.0.'.$build.'.'.$minor;

    consoleLogger('Fetching information from the server...');
    $postData = composeFetchUpdRequest(uupDevice(), uupEncryptedData(), $arch, $flight, $ring, $build);
    $out = sendWuPostRequest('https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx', $postData);

    $out = html_entity_decode($out);
    consoleLogger('Information was successfully fetched.');

    consoleLogger('Checking build information...');
    preg_match_all('/<UpdateInfo>.*?<\/UpdateInfo>/', $out, $updateInfos);
    $updateInfo = preg_grep('/<Action>Install<\/Action>/', $updateInfos[0]);
    sort($updateInfo);

    if(empty($updateInfo[0])) {
        consoleLogger('An error has occurred');
        return array('error' => 'NO_UPDATE_FOUND');
    }

    $updateNumId = preg_replace('/<UpdateInfo><ID>|<\/ID>.*/i', '', $updateInfo[0]);

    $updates = preg_replace('/<Update>/', "\n<Update>", $out);
    preg_match_all('/<Update>.*<\/Update>/', $updates, $updates);

    $updateMeta = preg_grep('/<ID>'.$updateNumId.'<\/ID>/', $updates[0]);
    sort($updateMeta);

    $updateFiles = preg_grep('/<Files>.*<\/Files>/', $updateMeta);
    sort($updateFiles);

    preg_match('/<Files>.*<\/Files>/', $updateFiles[0], $fileList);
    if(empty($fileList[0])) {
        consoleLogger('An error has occurred');
        return array('error' => 'EMPTY_FILELIST');
    }

    preg_match('/Version\=".*?"/', $updateInfo[0], $foundBuild);
    $foundBuild = preg_replace('/Version="10\.0\.|"/', '', $foundBuild[0]);

    $updateTitle = preg_grep('/<Title>.*<\/Title>/', $updateMeta);
    sort($updateTitle);

    preg_match('/<Title>.*?<\/Title>/i', $updateTitle[0], $updateTitle);
    $updateTitle = preg_replace('/<Title>|<\/Title>/i', '', $updateTitle);
    sort($updateTitle);

    if(isset($updateTitle[0])) {
        $updateTitle = $updateTitle[0];
    } else {
        $updateTitle = 'Windows 10 build '.$foundBuild;
    }

    $updateTitle = preg_replace('/ for .{3,5}-based systems/i', '', $updateTitle);

    if(preg_match('/Feature update/i', $updateTitle)) {
        $updateTitle = $updateTitle.' ('.$foundBuild.')';
    }

    preg_match('/UpdateID=".*?"/', $updateInfo[0], $updateId);
    preg_match('/RevisionNumber=".*?"/', $updateInfo[0], $updateRev);

    $updateId = preg_replace('/UpdateID="|"$/', '', $updateId[0]);
    $updateRev = preg_replace('/RevisionNumber="|"$/', '', $updateRev[0]);

    consoleLogger('Successfully checked build information.');
    consoleLogger('BUILD: '.$updateTitle.' '.$arch);

    $updateString = $updateId;
    if($updateRev != 1) {
        $updateString = $updateId.'_rev.'.$updateRev;
    }

    $fileWrite = 'NO_SAVE';
    if(!file_exists('fileinfo/'.$updateString.'.json')) {
        consoleLogger('WARNING: This build is NOT in the database. It will be saved now.');
        consoleLogger('Parsing information to write...');
        if(!file_exists('fileinfo')) mkdir('fileinfo');

        $fileList = preg_replace('/<Files>|<\/Files>/', '', $fileList[0]);
        preg_match_all('/<File .*?>/', $fileList, $fileList);

        $shaArray = array();

        foreach($fileList[0] as $val) {
            preg_match('/Digest=".*?"/', $val, $sha1);
            $sha1 = preg_replace('/Digest="|"$/', '', $sha1[0]);
            $sha1 = bin2hex(base64_decode($sha1));

            preg_match('/FileName=".*?"/', $val, $name);
            $name = preg_replace('/FileName="|"$/', '', $name[0]);

            preg_match('/Size=".*?"/', $val, $size);
            $size = preg_replace('/Size="|"$/', '', $size[0]);

            $temp = array(
                'name' => $name,
                'size' => $size,
            );

            $shaArray = array_merge($shaArray, array($sha1 => $temp));
        }

        unset($temp, $sha1, $name, $size);

        ksort($shaArray);

        $temp = array();
        $temp['title'] = $updateTitle;
        $temp['ring'] = $ring;
        $temp['flight'] = $flight;
        $temp['arch'] = $arch;
        $temp['build'] = $foundBuild;
        $temp['checkBuild'] = $build;

        if(preg_match('/Cumulative Update/', $updateTitle)) {
            $temp['containsCU'] = 1;
        }

        $temp['files'] = $shaArray;

        consoleLogger('Successfully parsed the information.');
        consoleLogger('Writing new build information to the disk...');

        $success = file_put_contents('fileinfo/'.$updateString.'.json', json_encode($temp)."\n");
        if($success) {
            consoleLogger('Successfully written build information to the disk.');
            $fileWrite = 'INFO_WRITTEN';
        } else {
            consoleLogger('An error has occured while writing the information to the disk.');
        }
    } else {
        consoleLogger('This build already exists in the database.');
    }

    $ids = uupListIds();
    if(!isset($ids['error'])) {
        $ids = $ids['builds'];
        $buildName = $foundBuild.' '.$updateTitle.' '.$arch;

        foreach($ids as $val) {
            $testName = $val['build'].' '.$val['title'].' '.$val['arch'];
            if($buildName == $testName && $val['uuid'] != $updateString) {
                unlink(realpath('fileinfo/'.$val['uuid'].'.json'));
                consoleLogger('Removed superseded update: '.$val['uuid']);
            }
        }
    }

    return array(
        'apiVersion' => uupApiVersion(),
        'updateId' => $updateString,
        'updateTitle' => $updateTitle,
        'foundBuild' => $foundBuild,
        'arch' => $arch,
        'fileWrite' => $fileWrite,
    );
}
?>
