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

function uupListEditions($lang = 'en-us') {
    require dirname(__FILE__).'/shared/packs.php';

    if($lang) {
        $lang = strtolower($lang);
        if(!isset($packsForLangs[$lang])) {
            return array('error' => 'UNSUPPORTED_LANG');
        }
    }

    $editionList = array();
    $editionListFancy = array();
    foreach($packsForLangs[$lang] as $val) {
        foreach(array_keys($packs[$val]) as $edition) {
            if($edition == 'editionNeutral') continue;

            if(isset($fancyEditionNames[$edition])) {
                $fancyName = $fancyEditionNames[$edition];
            } else {
                $fancyName = $edition;
            }

            $temp = array($edition => $fancyName);
            $editionList = array_merge($editionList, array($edition));
            $editionListFancy = array_merge($editionListFancy, $temp);
        }
    }

    return array(
        'apiVersion' => uupApiVersion(),
        'editionList' => $editionList,
        'editionFancyNames' => $editionListFancy,
    );
}
?>
