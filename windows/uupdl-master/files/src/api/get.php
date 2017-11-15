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

function uupGetFiles($updateId = 'c2a1d787-647b-486d-b264-f90f3782cdc6', $usePack = 0, $desiredEdition = 0) {
    require dirname(__FILE__).'/shared/packs.php';
    uupApiPrintBrand();

    function packsByEdition($edition, $pack, $lang, $filesKeys) {
        $filesTemp = array();

        if($edition != 'editionNeutral') {
            $temp = preg_grep('/'.$edition.'_'.$lang.'\.esd/i', $filesKeys);
            $filesTemp = array_merge($filesTemp, $temp);
        }

        foreach($pack as $val) {
            $temp = preg_grep('/'.$val.'.*\./i', $filesKeys);
            $filesTemp = array_merge($filesTemp, $temp);
        }

        return $filesTemp;
    }

    if($usePack) {
        $usePack = strtolower($usePack);
        if(!isset($packsForLangs[$usePack])) {
            return array('error' => 'UNSUPPORTED_LANG');
        }
    }

    $desiredEdition = strtoupper($desiredEdition);
    if($desiredEdition && $desiredEdition != 'UPDATEONLY') {
        if(!$usePack) {
            return array('error' => 'UNSPECIFIED_LANG');
        }

        if(!isset($editionPacks[$desiredEdition])) {
            return array('error' => 'UNSUPPORTED_EDITION');
        }

        $supported = 0;
        foreach($packsForLangs[$usePack] as $val) {
            if($editionPacks[$desiredEdition] == $val) $supported = 1;
        }

        if(!$supported) {
            return array('error' => 'UNSUPPORTED_COMBINATION');
        }
        unset($supported);
    }

    $info = @file_get_contents('fileinfo/'.$updateId.'.json');
    if(empty($info)) {
        $info = array(
            'ring' => 'WIF',
            'flight' => 'Skip',
            'checkBuild' => '10.0.16232.0',
            'files' => array(),
        );
    } else {
        $info = json_decode($info, true);
    }

    if($desiredEdition == 'UPDATEONLY') {
        if(!isset($info['containsCU']) || !$info['containsCU']) {
            return array('error' => 'NOT_CUMULATIVE_UPDATE');
        }
    }

    if(isset($info['build'])) {
        $build = $info['build'];

        if($build == 'UNKNOWN') {
            $buildNumber = 9841;
        } else {
            $buildNumber = explode('.', $build);
            $buildNumber = $buildNumber[0];
        }
    }

    $uupFix = 0;
    if(isset($info['needsFix'])) {
        if($info['needsFix'] == true) $uupFix = 1;
    }

    $rev = 1;
    if(preg_match('/_rev\./', $updateId)) {
        $rev = preg_replace('/.*_rev\./', '', $updateId);
        $updateId = preg_replace('/_rev\..*/', '', $updateId);
    }

    consoleLogger('Fetching information from the server...');
    $postData = composeFileGetRequest($updateId, uupDevice(), $info, $rev);
    $out = sendWuPostRequest('https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx/secured', $postData);
    consoleLogger('Information was successfully fetched.');

    consoleLogger('Parsing information...');
    preg_match_all('/<FileLocation>.*?<\/FileLocation>/', $out, $out);
    if(empty($out[0])) {
        consoleLogger('An error has occurred');
        return array('error' => 'EMPTY_FILELIST');
    }

    $updateArch = (isset($info['arch'])) ? $info['arch'] : 'UNKNOWN';
    $updateName = (isset($info['title'])) ? $info['title'] : 'Unknown update: '.$updateId;
    $info = $info['files'];
    $out = preg_replace('/<FileLocation>|<\/FileLocation>/', '', $out[0]);

    $files = array();
    $removeFiles = array();

    foreach($out as $val) {
        preg_match('/<FileDigest>.*<\/FileDigest>/', $val, $sha1);
        $sha1 = preg_replace('/<FileDigest>|<\/FileDigest>/', '', $sha1[0]);
        $sha1 = bin2hex(base64_decode($sha1));

        preg_match('/<Url>.*<\/Url>/', $val, $url);
        $url = preg_replace('/<Url>|<\/Url>/', '', $url[0]);
        $url = html_entity_decode($url);

        preg_match('/P1=.*?&/', $url, $expire);
        if(isset($expire[0])) $expire = preg_replace('/P1=|&$/', '', $expire[0]);

        preg_match('/files\/.{8}-.{4}-.{4}-.{4}-.{12}/', $url, $guid);
        $guid = preg_replace('/files\/|\?$/', '', $guid[0]);

        if(empty($info[$sha1]['name'])) {
            $name = $guid;
        } else {
            $name = $info[$sha1]['name'];
        }

        if(empty($info[$sha1]['name'])) {
            $size = 0;
        } else {
            $size = $info[$sha1]['size'];
        }

        if(!isset($fileSizes[$name])) $fileSizes[$name] = 0;

        $temp = array(
            'sha1' => $sha1,
            'size' => $size,
            'url' => $url,
            'uuid' => $guid,
            'expire' => intval($expire),
        );

        if(!preg_match('/\.psf$/', $name)) {
            if($size > $fileSizes[$name]) {
                $fileSizes[$name] = $size;
                $files = array_merge($files, array($name => $temp));
            }
        } else {
            if(!preg_match('/^Windows10\.0-KB/', $name)) {
                $name = preg_replace('/\.psf$/', '', $name);
                $removeFiles = array_merge($removeFiles, array($name));
            }
        }
    }

    if(!$uupFix) {
        foreach($removeFiles as $val) {
            if(preg_match('/'.$updateArch.'_.*/i', $val)) {
                if(isset($files[$val.'.cab'])) unset($files[$val.'.cab']);
            }

            if(isset($files[$val.'.esd'])) {
                if(isset($files[$val.'.cab'])) unset($files[$val.'.cab']);
            }

            if(isset($files[$val.'.ESD'])) {
                if(isset($files[$val.'.cab'])) unset($files[$val.'.cab']);
            }
        }
        unset($removeFiles);
    }

    $filesKeys = array_keys($files);

    if($uupFix) {
        $removeFiles = preg_grep('/\.esd$/i', $filesKeys);

        foreach($removeFiles as $val) {
            $temp = preg_replace('/\.esd$/i', '', $val);
            if(isset($files[$temp.'.cab'])) unset($files[$temp.'.cab']);
        }

        unset($removeFiles, $temp);
        $filesKeys = array_keys($files);
    }

    if($desiredEdition == 'UPDATEONLY') {
        $removeFiles = preg_grep('/Windows10\.0-KB.*-EXPRESS/i', $filesKeys);

        foreach($removeFiles as $val) {
            if(isset($files[$val])) unset($files[$val]);
        }

        unset($removeFiles, $temp);
        $filesKeys = array_keys($files);

        $filesKeys = preg_grep('/Windows10\.0-KB/i', $filesKeys);
    }

    if($usePack && $desiredEdition != 'UPDATEONLY') {
        $removeFiles = preg_grep('/RetailDemo-OfflineContent/i', $filesKeys);
        $removeFiles = preg_grep('/Windows10\.0-KB.*-EXPRESS/i', $filesKeys);

        foreach($removeFiles as $val) {
            if(isset($files[$val])) unset($files[$val]);
        }

        unset($removeFiles, $temp);
        $filesKeys = array_keys($files);

        $filesTemp = array();

        $temp = preg_grep('/.*'.$usePack.'-Package.*/i', $filesKeys);
        $filesTemp = array_merge($filesTemp, $temp);

        $temp = preg_grep('/.*'.$usePack.'_lp..../i', $filesKeys);
        $filesTemp = array_merge($filesTemp, $temp);

        foreach($packsForLangs[$usePack] as $num) {
            foreach($packs[$num] as $key => $val) {
                if($key == 'editionNeutral'
                || $key == $desiredEdition
                || !$desiredEdition) {
                    $temp = packsByEdition($key, $val, $usePack, $filesKeys);
                    $filesTemp = array_merge($filesTemp, $temp);
                }
            }
        }

        $filesKeys = array_unique($filesTemp);
        unset($filesTemp, $temp, $val, $num);
    }

    if(empty($filesKeys)) {
        return array('error' => 'NO_FILES');
    }

    foreach($filesKeys as $val) {
       $filesNew[$val] = $files[$val];
    }

    $files = $filesNew;
    ksort($files);

    consoleLogger('Successfully parsed the information.');

    return array(
        'apiVersion' => uupApiVersion(),
        'updateName' => $updateName,
        'arch' => $updateArch,
        'files' => $files,
    );
}
?>
