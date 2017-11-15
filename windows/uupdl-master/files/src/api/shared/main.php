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

function uupApiVersion() {
    return '1.4.1';
}

function uupApiPrintBrand() {
    global $uupApiBrandPrinted;

    if(!isset($uupApiBrandPrinted)) {
        consoleLogger('UUP dump API v'.uupApiVersion());
        $uupApiBrandPrinted = 1;
    }
}

function randStr($length = 4) {
    $characters = '0123456789abcdef';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

function sendWuPostRequest($url, $postData) {
    $req = curl_init($url);

    curl_setopt($req, CURLOPT_HEADER, 0);
    curl_setopt($req, CURLOPT_POST, 1);
    curl_setopt($req, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($req, CURLOPT_POSTFIELDS, $postData);
    curl_setopt($req, CURLOPT_SSL_VERIFYPEER, 0);
    curl_setopt($req, CURLOPT_HTTPHEADER, array(
        'User-Agent: Windows-Update-Agent/10.0.10011.16384 Client-Protocol/1.70',
        'Content-Type: application/soap+xml; charset=utf-8',
    ));

    $out = curl_exec($req);
    curl_close($req);

    return $out;
}

function consoleLogger($message, $showTime = 1) {
    if(php_sapi_name() != 'cli') return
    $currTime = '';
    if($showTime) {
        $currTime = '['.date('Y-m-d H:i:s T', time()).'] ';
    }

    $msg = $currTime.$message;
    fwrite(STDERR, $msg."\n");
}

function uupDevice() {
    return 'dAA9AEUAdwBBAHcAQQBzAE4AMwBCAEEAQQBVADEAYgB5AHMAZQBtAGIAZQBEAFYAQwArADMAZgBtADcAbwBXAHkASAA3AGIAbgBnAEcAWQBtAEEAQQBHADcAVwBtAGUAWQBmAGkAdwAxAGMAdgByAEoAbwBvAGkAUQBzAFoAZABqAHEAawBQAEkARwA5AHUAVQBQAFcAMQB3ADMAQgBVAE8ALwBKAC8AdwBwAGUAcgBhAHQAZAB2AFgAQgB6AFkAbABaAHAAYgBzAHQANAB4AHkAbABHADcAQwBSADQANABBAFoARwB4AG4ARAAvAHIAYwBVAGoAdwBEAFAAVQBXAHkAMABPAEwAaABqAFAAZABWAEgAOQBVAFkATAA4AE0AVgBJAFIAbQA5ADEALwAwAGwATQBjAHUAMwBQAFMAOQB5AFoARwBFADIAZgBOAEcAWAA2AE8AbABrAFoAaABiAG0AbAB1AGsAdwBXAEsAdQBQAHcAcABGADQARQB5AFgAcgBTAHgALwBwAEsATgArAFoANgBOAEoAdQArAFYASwBqAFoANwBoADIAUgBBADIAWQBBAEEAQQBpAEUAWQBjADgAawBnAFoAYQBsAEgAWQBBAEIASwBIADEAZAAvAEoAZABEAFUAeAB5ADIAegBkAEoAMwA0AEIAbABYAGMAYwBsAFoANABJAE4ANQBuAHcAYQBLAE4AWgA3ADEAcQA4AEMAcQBVAFgAYwBQAGMAQgBjAGEAVQBXAFgAVgBGAEMASgBsAEEAegBTAGwAQQBtAHEALwBvAFQAQQBVAFcAYQBOAEgAWQBRADAAWQBNADEAVQAzAHEATAAvAFEAdQBhAEcAMgBuAE4AdQBvADYAVwBqAFEAcQBFAFgAYwBUAGMAWAA3AGMAdgAyAHEANABzADcAWgBpADkAWQB1ACsANwBYADAAeQA1AFgAeQAvAE4AbgBLAGUAeABRAHEAdwA3AG8AKwBjAGIAMwB1AGYAQQBFAEYAdABWAHAAawB3AGwAagBZAHYAZgBvADcAdQBwAFkANQBnAGEAdABlADUAWABwADkALwBoAFoAdQBYAFIANgAwAEoAMQBUAHEATQBGADYAVQBOAEIATQB6AC8ATABCAEMAUABPAEcAWABIAGkAWgBJAEUAZQBIAE8ASwBiAEIAUAB1AFAASwBZAGMAUQBUAFkAZwBIAEkARwA3AFIAegBnAGIAMAAzAGQARABrAFUANgByAHUASQA1AHQAYgBIAHoAaQBmAHoAVgBHAHAAVABGAGcANABrAEoAYgBQAHkARQBXAHcAcwBOAEMARgA4AFQATQBuAHAARABhAHcAeAAvAEUARgBUADcAeQBLAFQAQwBYAFkAbgBhADQASQBJAFAAMABtAFcAMABYADIAdABDAHEANgA1AEUASwBlAFkAcQBBAEYARQA1AEMASABmAFEAMQBvAHIAYgBBAGEASgBWAGkAaQBFAGsARQB3AEEANwBuADMAcgAxAFIAUQB1AHgARgBlAG4ARwBkAHgAdQByAFoAdwByADAAMABEADgATQBoAGwAUQAvAFcAYQBaAGwANgBvAFgAdgBkAHUATgBXAEIAZwBPAFMANgBLAGEARwBpAC8AYgBLADEAZwBWAEgAcABzAEcAcwBFAC8AQgA4AGkAbQBsAGYAcAAzAFEATQBWAGkAUABEAEgANgBhADMANQBCAGYAOABpAHkAMgAyAG4ASABQADAATgBIADkASwBEAHoAWAB5AGkAeABnAGsARQBlAGwAaABKAEcANgAyAHUAMgBjAFQAMgBmAFgAMQA0AEwAdwBSAFkATwArAGkAcgBWAGQAYwBqAEUAQgBoAGQASwA1ADQAYgBPAFcAdgBUAHcAbQBUAFMAVwBHAE8AaAB2ADIAbwBiADIAawBQAEEANgBpADEAVgBRAFUAaQA4AEQASwB1AEsANAA4AGYAWgBIADcASQBKAGEAZQBxAHMAdwBFAD0AJgBwAD0A';
}

function uupEncryptedData() {
    return 'mWAGiUaiYgHfsAeIJgLgiRDyjNbyIThm35CJYPrxVEh9HAeQmequNwXuWtOJFOlHv5yT96WmtFLTh7ubpLl9H3pO4F4eCmkNqI1rWQ+CRwCUg8s5IX/mWRN1xCN3vMIl8Smkunz7/+PJ63/or2AsuDPd+bjdU0lO4tSY94mbvqJgI5mnLuRPqHY3ad+QGXBx7ipPKTt5g+g=';
}
?>
