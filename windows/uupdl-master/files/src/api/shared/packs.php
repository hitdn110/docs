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

$packs = array(
    // Base pack
    0 => array(
        'editionNeutral' => array(
            'Microsoft-Windows-Foundation-Package',
            'Microsoft-Windows-Client-Features-Package',
            'Microsoft-Windows-Client-Features-WOW64-Package',
            'Microsoft-Windows-Client-Features-arm64arm-Package',
            'Microsoft-Windows-WowPack-CoreARM-arm64arm-Package',
            'Microsoft-Windows-ContactSupport-Package',
            'Microsoft-Windows-RegulatedPackages-Package',
            'Microsoft-Windows-RegulatedPackages-WOW64-Package',
            'Microsoft-Windows-RegulatedPackages-arm64arm-Package',
            'Microsoft-Windows-Holographic-Desktop-Merged-Package',
            'Microsoft-Windows-Holographic-Desktop-Merged-WOW64-Package',
            'Microsoft-Windows-Holographic-Desktop-Analog-Package',
            'Microsoft-Windows-QuickAssist-Package',
            'Microsoft-Windows-InternetExplorer-Optional-Package',
            'Microsoft-Windows-MediaPlayer-Package',
            'Microsoft-Windows-Hello-Face-Resource-A-Package',
            'Microsoft-Windows-Hello-Face-Resource-B-Package',
            'Microsoft-OneCore-ApplicationModel-Sync-Desktop-FOD-Package',
            'Windows10\.0-KB',
        ),
        'CLOUD' => array(
            'Microsoft-Windows-EditionPack-Professional-Package',
            'Microsoft-Windows-EditionPack-Professional-WOW64-Package',
            'Microsoft-Windows-EditionPack-Professional-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-Cloud-Package',
            'Microsoft-Windows-EditionSpecific-Cloud-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-Cloud-arm64arm-Package',
            'Microsoft\.ModernApps\.Client\.All',
            'Microsoft\.ModernApps\.Client\.cloud',
        ),
        'CORE' => array(
            'Microsoft-Windows-EditionPack-Core-Package',
            'Microsoft-Windows-EditionPack-Core-WOW64-Package',
            'Microsoft-Windows-EditionPack-Core-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-Core-Package',
            'Microsoft-Windows-EditionSpecific-Core-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-Core-arm64arm-Package',
            'Microsoft\.ModernApps\.Client\.All',
            'Microsoft\.ModernApps\.Client\.core',
        ),
        'EDUCATION' => array(
            'Microsoft-Windows-EditionPack-Enterprise-Package',
            'Microsoft-Windows-EditionPack-Enterprise-WOW64-Package',
            'Microsoft-Windows-EditionPack-Enterprise-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-Education-Package',
            'Microsoft-Windows-EditionSpecific-Education-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-Education-arm64arm-Package',
            'Microsoft\.ModernApps\.Client\.All',
            'Microsoft\.ModernApps\.Client\.education',
        ),
        'ENTERPRISE' => array(
            'Microsoft-Windows-EditionPack-Enterprise-Package',
            'Microsoft-Windows-EditionPack-Enterprise-WOW64-Package',
            'Microsoft-Windows-EditionPack-Enterprise-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-Enterprise-Package',
            'Microsoft-Windows-EditionSpecific-Enterprise-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-Enterprise-arm64arm-Package',
            'Microsoft\.ModernApps\.Client\.All',
            'Microsoft\.ModernApps\.Client\.enterprise',
        ),
        'PROFESSIONAL' => array(
            'Microsoft-Windows-EditionPack-Professional-Package',
            'Microsoft-Windows-EditionPack-Professional-WOW64-Package',
            'Microsoft-Windows-EditionPack-Professional-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-Professional-Package',
            'Microsoft-Windows-EditionSpecific-Professional-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-Professional-arm64arm-Package',
            'Microsoft\.ModernApps\.Client\.All',
            'Microsoft\.ModernApps\.Client\.professional',
        ),
    ),

    // European "N" Editions
    1 => array(
        'CLOUDN' => array(
            'Microsoft-Windows-EditionPack-Professional-Package',
            'Microsoft-Windows-EditionPack-Professional-WOW64-Package',
            'Microsoft-Windows-EditionPack-Professional-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-CloudN-Package',
            'Microsoft-Windows-EditionSpecific-CloudN-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-CloudN-arm64arm-Package',
            'Microsoft\.ModernApps\.ClientN\.All',
        ),
        'COREN' => array(
            'Microsoft-Windows-EditionPack-Core-Package',
            'Microsoft-Windows-EditionPack-Core-WOW64-Package',
            'Microsoft-Windows-EditionPack-Core-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-CoreN-Package',
            'Microsoft-Windows-EditionSpecific-CoreN-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-CoreN-arm64arm-Package',
            'Microsoft\.ModernApps\.ClientN\.All',
        ),
        'EDUCATIONN' => array(
            'Microsoft-Windows-EditionPack-Enterprise-Package',
            'Microsoft-Windows-EditionPack-Enterprise-WOW64-Package',
            'Microsoft-Windows-EditionPack-Enterprise-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-EducationN-Package',
            'Microsoft-Windows-EditionSpecific-EducationN-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-EducationN-arm64arm-Package',
            'Microsoft\.ModernApps\.ClientN\.All',
        ),
        'ENTERPRISEN' => array(
            'Microsoft-Windows-EditionPack-Enterprise-Package',
            'Microsoft-Windows-EditionPack-Enterprise-WOW64-Package',
            'Microsoft-Windows-EditionPack-Enterprise-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-EnterpriseN-Package',
            'Microsoft-Windows-EditionSpecific-EnterpriseN-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-EnterpriseN-arm64arm-Package',
            'Microsoft\.ModernApps\.ClientN\.All',
        ),
        'PROFESSIONALN' => array(
            'Microsoft-Windows-EditionPack-Professional-Package',
            'Microsoft-Windows-EditionPack-Professional-WOW64-Package',
            'Microsoft-Windows-EditionPack-Professional-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-ProfessionalN-Package',
            'Microsoft-Windows-EditionSpecific-ProfessionalN-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-ProfessionalN-arm64arm-Package',
            'Microsoft\.ModernApps\.ClientN\.All',
        ),
    ),

    // CoreSingleLanguage
    2 => array(
        'CORESINGLELANGUAGE' => array(
            'Microsoft-Windows-EditionPack-Core-Package',
            'Microsoft-Windows-EditionPack-Core-WOW64-Package',
            'Microsoft-Windows-EditionPack-Core-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-CoreSingleLanguage-Package',
            'Microsoft-Windows-EditionSpecific-CoreSingleLanguage-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-CoreSingleLanguage-arm64arm-Package',
            'Microsoft\.ModernApps\.Client\.All',
            'Microsoft\.ModernApps\.Client\.coresinglelanguage',
        ),
    ),

    // China specific editions
    3 => array(
        'CORECOUNTRYSPECIFIC' => array(
            'Microsoft-Windows-EditionPack-Core-Package',
            'Microsoft-Windows-EditionPack-Core-WOW64-Package',
            'Microsoft-Windows-EditionPack-Core-arm64arm-Package',
            'Microsoft-Windows-EditionSpecific-CoreCountrySpecific-Package',
            'Microsoft-Windows-EditionSpecific-CoreCountrySpecific-WOW64-Package',
            'Microsoft-Windows-EditionSpecific-CoreCountrySpecific-arm64arm-Package',
            'Microsoft\.ModernApps\.Client\.All',
        ),
    ),

    // Additional packages for some languages
    4 => array(
        'editionNeutral' => array(
            'Microsoft-Windows-LanguageFeatures-Basic-en-us-Package',
            'Microsoft-Windows-LanguageFeatures-OCR-en-us-Package',
        ),
    ),

    // Additional packages for ar-sa language
    5 => array(
        'editionNeutral' => array(
            'Microsoft-Windows-LanguageFeatures-TextToSpeech-ar-eg-Package',
        ),
    ),

    // Additional packages for fr-ca language
    6 => array(
        'editionNeutral' => array(
            'Microsoft-Windows-LanguageFeatures-Basic-fr-fr-Package',
            'Microsoft-Windows-LanguageFeatures-Handwriting-fr-fr-Package',
        ),
    ),

    // Additional packages for zh-tw language
    7 => array(
        'editionNeutral' => array(
            'Microsoft-Windows-LanguageFeatures-Speech-zh-hk-Package',
            'Microsoft-Windows-LanguageFeatures-TextToSpeech-zh-hk-Package',
        ),
    ),
);

$packsForLangs = array(
    'ar-sa' => array(0, 2, 4, 5),
    'bg-bg' => array(0, 1, 4),
    'cs-cz' => array(0, 1),
    'da-dk' => array(0, 1, 4),
    'de-de' => array(0, 1),
    'el-gr' => array(0, 1, 4),
    'en-gb' => array(0, 1, 2),
    'en-us' => array(0, 1, 2),
    'es-es' => array(0, 1, 2),
    'es-mx' => array(0, 2),
    'et-ee' => array(0, 1),
    'fi-fi' => array(0, 1),
    'fr-ca' => array(0, 4, 6),
    'fr-fr' => array(0, 1, 2),
    'he-il' => array(0, 4),
    'hr-hr' => array(0, 1),
    'hu-hu' => array(0, 1),
    'it-it' => array(0, 1),
    'ja-jp' => array(0),
    'ko-kr' => array(0, 1),
    'lt-lt' => array(0, 1),
    'lv-lv' => array(0, 1),
    'nb-no' => array(0, 1),
    'nl-nl' => array(0, 1),
    'pl-pl' => array(0, 1),
    'pt-br' => array(0, 2),
    'pt-pt' => array(0, 1, 2),
    'ro-ro' => array(0, 1),
    'ru-ru' => array(0, 2, 4),
    'sk-sk' => array(0, 1),
    'sl-si' => array(0, 1),
    'sv-se' => array(0, 1),
    'th-th' => array(0, 2, 4),
    'tr-tr' => array(0, 2),
    'uk-ua' => array(0, 2, 4),
    'zh-cn' => array(0, 2, 3),
    'zh-tw' => array(0, 7),
);

$editionPacks = array(
    'CLOUD' => 0,
    'CLOUDN' => 1,
    'CORE' => 0,
    'CORECOUNTRYSPECIFIC' => 3,
    'COREN' => 1,
    'CORESINGLELANGUAGE' => 2,
    'EDUCATION' => 0,
    'EDUCATIONN' => 1,
    'ENTERPRISE' => 0,
    'ENTERPRISEN' => 1,
    'PROFESSIONAL' => 0,
    'PROFESSIONALN' => 1,
);

$fancyEditionNames = array(
    'CLOUD' => 'Windows 10 S',
    'CLOUDN' => 'Windows 10 S N',
    'CORE' => 'Windows 10 Home',
    'CORECOUNTRYSPECIFIC' => 'Windows 10 Home China',
    'COREN' => 'Windows 10 Home N',
    'CORESINGLELANGUAGE' => 'Windows 10 Home Single Language',
    'EDUCATION' => 'Windows 10 Education',
    'EDUCATIONN' => 'Windows 10 Education N',
    'ENTERPRISE' => 'Windows 10 Enterprise',
    'ENTERPRISEN' => 'Windows 10 Enterprise N',
    'PROFESSIONAL' => 'Windows 10 Pro',
    'PROFESSIONALN' => 'Windows 10 Pro N',
);

$fancyLangNames = array(
    'ar-sa' => 'Arabic (Saudi Arabia)',
    'bg-bg' => 'Bulgarian',
    'cs-cz' => 'Czech',
    'da-dk' => 'Danish',
    'de-de' => 'German',
    'el-gr' => 'Greek',
    'en-gb' => 'English (United Kingdom)',
    'en-us' => 'English (United States)',
    'es-es' => 'Spanish (Spain)',
    'es-mx' => 'Spanish (Mexico)',
    'et-ee' => 'Estonian',
    'fi-fi' => 'Finnish',
    'fr-ca' => 'French (Canada)',
    'fr-fr' => 'French (France)',
    'he-il' => 'Hebrew',
    'hr-hr' => 'Croatian',
    'hu-hu' => 'Hungarian',
    'it-it' => 'Italian',
    'ja-jp' => 'Japanese',
    'ko-kr' => 'Korean',
    'lt-lt' => 'Lithuanian',
    'lv-lv' => 'Latvian',
    'nb-no' => 'Norwegian (Bokmal)',
    'nl-nl' => 'Dutch',
    'pl-pl' => 'Polish',
    'pt-br' => 'Portuguese (Brazil)',
    'pt-pt' => 'Portuguese (Portugal)',
    'ro-ro' => 'Romanian',
    'ru-ru' => 'Russian',
    'sk-sk' => 'Slovak',
    'sl-si' => 'Slovenian',
    'sv-se' => 'Swedish',
    'th-th' => 'Thai',
    'tr-tr' => 'Turkish',
    'uk-ua' => 'Ukrainian',
    'zh-cn' => 'Chinese (Simplified)',
    'zh-tw' => 'Chinese (Traditional)',
);
?>
