module LanguagesHelper
  def language_options
    [["Portuguese (Brazil)", "pt-BR"],
     ["English (United States)", "en-US"],
     ["Afrikaans (Namibia)", "af-NA"],
     ["Afrikaans (South Africa)", "af-ZA"],
     ["Afrikaans", "af"],
     ["Akan (Ghana)", "ak-GH"],
     ["Akan", "ak"],
     ["Albanian (Albania)", "sq-AL"],
     ["Albanian", "sq"],
     ["Amharic (Ethiopia)", "am-ET"],
     ["Amharic", "am"],
     ["Arabic (Algeria)", "ar-DZ"],
     ["Arabic (Bahrain)", "ar-BH"],
     ["Arabic (Egypt)", "ar-EG"],
     ["Arabic (Iraq)", "ar-IQ"],
     ["Arabic (Jordan)", "ar-JO"],
     ["Arabic (Kuwait)", "ar-KW"],
     ["Arabic (Lebanon)", "ar-LB"],
     ["Arabic (Libya)", "ar-LY"],
     ["Arabic (Morocco)", "ar-MA"],
     ["Arabic (Oman)", "ar-OM"],
     ["Arabic (Qatar)", "ar-QA"],
     ["Arabic (Saudi Arabia)", "ar-SA"],
     ["Arabic (Sudan)", "ar-SD"],
     ["Arabic (Syria)", "ar-SY"],
     ["Arabic (Tunisia)", "ar-TN"],
     ["Arabic (United Arab Emirates)", "ar-AE"],
     ["Arabic (Yemen)", "ar-YE"],
     ["Arabic", "ar"],
     ["Armenian (Armenia)", "hy-AM"],
     ["Armenian", "hy"],
     ["Assamese (India)", "as-IN"],
     ["Assamese", "as"],
     ["Asu (Tanzania)", "asa-TZ"],
     ["Asu", "asa"],
     ["Azerbaijani (Cyrillic)", "az-Cyrl"],
     ["Azerbaijani (Cyrillic, Azerbaijan)", "az-Cyrl-AZ"],
     ["Azerbaijani (Latin)", "az-Latn"],
     ["Azerbaijani (Latin, Azerbaijan)", "az-Latn-AZ"],
     ["Azerbaijani", "az"],
     ["Bambara (Mali)", "bm-ML"],
     ["Bambara", "bm"],
     ["Basque (Spain)", "eu-ES"],
     ["Basque", "eu"],
     ["Belarusian (Belarus)", "be-BY"],
     ["Belarusian", "be"],
     ["Bemba (Zambia)", "bem-ZM"],
     ["Bemba", "bem"],
     ["Bena (Tanzania)", "bez-TZ"],
     ["Bena", "bez"],
     ["Bengali (Bangladesh)", "bn-BD"],
     ["Bengali (India)", "bn-IN"],
     ["Bengali", "bn"],
     ["Bosnian (Bosnia and Herzegovina)", "bs-BA"],
     ["Bosnian", "bs"],
     ["Bulgarian (Bulgaria)", "bg-BG"],
     ["Bulgarian", "bg"],
     ["Burmese (Myanmar [Burma])", "my-MM"],
     ["Burmese", "my"],
     ["Cantonese (Traditional, Hong Kong SAR China)", "yue-Hant-HK"],
     ["Catalan (Spain)", "ca-ES"],
     ["Catalan", "ca"],
     ["Central Morocco Tamazight (Latin)", "tzm-Latn"],
     ["Central Morocco Tamazight (Latin, Morocco)", "tzm-Latn-MA"],
     ["Central Morocco Tamazight", "tzm"],
     ["Cherokee (United States)", "chr-US"],
     ["Cherokee", "chr"],
     ["Chiga (Uganda)", "cgg-UG"],
     ["Chiga", "cgg"],
     ["Chinese (Simplified Han)", "zh-Hans"],
     ["Chinese (Simplified Han, China)", "zh-Hans-CN"],
     ["Chinese (Simplified Han, Hong Kong SAR China)", "zh-Hans-HK"],
     ["Chinese (Simplified Han, Macau SAR China)", "zh-Hans-MO"],
     ["Chinese (Simplified Han, Singapore)", "zh-Hans-SG"],
     ["Chinese (Traditional Han)", "zh-Hant"],
     ["Chinese (Traditional Han, Hong Kong SAR China)", "zh-Hant-HK"],
     ["Chinese (Traditional Han, Macau SAR China)", "zh-Hant-MO"],
     ["Chinese (Traditional Han, Taiwan)", "zh-Hant-TW"],
     ["Chinese", "zh"],
     ["Cornish (United Kingdom)", "kw-GB"],
     ["Cornish", "kw"],
     ["Croatian (Croatia)", "hr-HR"],
     ["Croatian", "hr"],
     ["Czech (Czech Republic)", "cs-CZ"],
     ["Czech", "cs"],
     ["Danish (Denmark)", "da-DK"],
     ["Danish", "da"],
     ["Dutch (Belgium)", "nl-BE"],
     ["Dutch (Netherlands)", "nl-NL"],
     ["Dutch", "nl"],
     ["Embu (Kenya)", "ebu-KE"],
     ["Embu", "ebu"],
     ["English (American Samoa)", "en-AS"],
     ["English (Australia)", "en-AU"],
     ["English (Belgium)", "en-BE"],
     ["English (Belize)", "en-BZ"],
     ["English (Botswana)", "en-BW"],
     ["English (Canada)", "en-CA"],
     ["English (Guam)", "en-GU"],
     ["English (Hong Kong SAR China)", "en-HK"],
     ["English (India)", "en-IN"],
     ["English (Ireland)", "en-IE"],
     ["English (Israel)", "en-IL"],
     ["English (Jamaica)", "en-JM"],
     ["English (Malta)", "en-MT"],
     ["English (Marshall Islands)", "en-MH"],
     ["English (Mauritius)", "en-MU"],
     ["English (Namibia)", "en-NA"],
     ["English (New Zealand)", "en-NZ"],
     ["English (Northern Mariana Islands)", "en-MP"],
     ["English (Pakistan)", "en-PK"],
     ["English (Philippines)", "en-PH"],
     ["English (Singapore)", "en-SG"],
     ["English (South Africa)", "en-ZA"],
     ["English (Trinidad and Tobago)", "en-TT"],
     ["English (U.S. Minor Outlying Islands)", "en-UM"],
     ["English (U.S. Virgin Islands)", "en-VI"],
     ["English (United Kingdom)", "en-GB"],
     ["English (Zimbabwe)", "en-ZW"],
     ["English", "en"],
     ["Esperanto", "eo"],
     ["Estonian (Estonia)", "et-EE"],
     ["Estonian", "et"],
     ["Ewe (Ghana)", "ee-GH"],
     ["Ewe (Togo)", "ee-TG"],
     ["Ewe", "ee"],
     ["Faroese (Faroe Islands)", "fo-FO"],
     ["Faroese", "fo"],
     ["Filipino (Philippines)", "fil-PH"],
     ["Filipino", "fil"],
     ["Finnish (Finland)", "fi-FI"],
     ["Finnish", "fi"],
     ["French (Belgium)", "fr-BE"],
     ["French (Benin)", "fr-BJ"],
     ["French (Burkina Faso)", "fr-BF"],
     ["French (Burundi)", "fr-BI"],
     ["French (Cameroon)", "fr-CM"],
     ["French (Canada)", "fr-CA"],
     ["French (Central African Republic)", "fr-CF"],
     ["French (Chad)", "fr-TD"],
     ["French (Comoros)", "fr-KM"],
     ["French (Congo - Brazzaville)", "fr-CG"],
     ["French (Congo - Kinshasa)", "fr-CD"],
     ["French (Côte d’Ivoire)", "fr-CI"],
     ["French (Djibouti)", "fr-DJ"],
     ["French (Equatorial Guinea)", "fr-GQ"],
     ["French (France)", "fr-FR"],
     ["French (Gabon)", "fr-GA"],
     ["French (Guadeloupe)", "fr-GP"],
     ["French (Guinea)", "fr-GN"],
     ["French (Luxembourg)", "fr-LU"],
     ["French (Madagascar)", "fr-MG"],
     ["French (Mali)", "fr-ML"],
     ["French (Martinique)", "fr-MQ"],
     ["French (Monaco)", "fr-MC"],
     ["French (Niger)", "fr-NE"],
     ["French (Rwanda)", "fr-RW"],
     ["French (Réunion)", "fr-RE"],
     ["French (Saint Barthélemy)", "fr-BL"],
     ["French (Saint Martin)", "fr-MF"],
     ["French (Senegal)", "fr-SN"],
     ["French (Switzerland)", "fr-CH"],
     ["French (Togo)", "fr-TG"],
     ["French", "fr"],
     ["Fulah (Senegal)", "ff-SN"],
     ["Fulah", "ff"],
     ["Galician (Spain)", "gl-ES"],
     ["Galician", "gl"],
     ["Ganda (Uganda)", "lg-UG"],
     ["Ganda", "lg"],
     ["Georgian (Georgia)", "ka-GE"],
     ["Georgian", "ka"],
     ["German (Austria)", "de-AT"],
     ["German (Belgium)", "de-BE"],
     ["German (Germany)", "de-DE"],
     ["German (Liechtenstein)", "de-LI"],
     ["German (Luxembourg)", "de-LU"],
     ["German (Switzerland)", "de-CH"],
     ["German", "de"],
     ["Greek (Cyprus)", "el-CY"],
     ["Greek (Greece)", "el-GR"],
     ["Greek", "el"],
     ["Gujarati (India)", "gu-IN"],
     ["Gujarati", "gu"],
     ["Gusii (Kenya)", "guz-KE"],
     ["Gusii", "guz"],
     ["Hausa (Latin)", "ha-Latn"],
     ["Hausa (Latin, Ghana)", "ha-Latn-GH"],
     ["Hausa (Latin, Niger)", "ha-Latn-NE"],
     ["Hausa (Latin, Nigeria)", "ha-Latn-NG"],
     ["Hausa", "ha"],
     ["Hawaiian (United States)", "haw-US"],
     ["Hawaiian", "haw"],
     ["Hebrew (Israel)", "he-IL"],
     ["Hebrew", "he"],
     ["Hindi (India)", "hi-IN"],
     ["Hindi", "hi"],
     ["Hungarian (Hungary)", "hu-HU"],
     ["Hungarian", "hu"],
     ["Icelandic (Iceland)", "is-IS"],
     ["Icelandic", "is"],
     ["Igbo (Nigeria)", "ig-NG"],
     ["Igbo", "ig"],
     ["Indonesian (Indonesia)", "id-ID"],
     ["Indonesian", "id"],
     ["Irish (Ireland)", "ga-IE"],
     ["Irish", "ga"],
     ["Italian (Italy)", "it-IT"],
     ["Italian (Switzerland)", "it-CH"],
     ["Italian", "it"],
     ["Japanese (Japan)", "ja-JP"],
     ["Japanese", "ja"],
     ["Kabuverdianu (Cape Verde)", "kea-CV"],
     ["Kabuverdianu", "kea"],
     ["Kabyle (Algeria)", "kab-DZ"],
     ["Kabyle", "kab"],
     ["Kalaallisut (Greenland)", "kl-GL"],
     ["Kalaallisut", "kl"],
     ["Kalenjin (Kenya)", "kln-KE"],
     ["Kalenjin", "kln"],
     ["Kamba (Kenya)", "kam-KE"],
     ["Kamba", "kam"],
     ["Kannada (India)", "kn-IN"],
     ["Kannada", "kn"],
     ["Kazakh (Cyrillic)", "kk-Cyrl"],
     ["Kazakh (Cyrillic, Kazakhstan)", "kk-Cyrl-KZ"],
     ["Kazakh", "kk"],
     ["Khmer (Cambodia)", "km-KH"],
     ["Khmer", "km"],
     ["Kikuyu (Kenya)", "ki-KE"],
     ["Kikuyu", "ki"],
     ["Kinyarwanda (Rwanda)", "rw-RW"],
     ["Kinyarwanda", "rw"],
     ["Konkani (India)", "kok-IN"],
     ["Konkani", "kok"],
     ["Korean (South Korea)", "ko-KR"],
     ["Korean", "ko"],
     ["Koyra Chiini (Mali)", "khq-ML"],
     ["Koyra Chiini", "khq"],
     ["Koyraboro Senni (Mali)", "ses-ML"],
     ["Koyraboro Senni", "ses"],
     ["Langi (Tanzania)", "lag-TZ"],
     ["Langi", "lag"],
     ["Latvian (Latvia)", "lv-LV"],
     ["Latvian", "lv"],
     ["Lithuanian (Lithuania)", "lt-LT"],
     ["Lithuanian", "lt"],
     ["Luo (Kenya)", "luo-KE"],
     ["Luo", "luo"],
     ["Luyia (Kenya)", "luy-KE"],
     ["Luyia", "luy"],
     ["Macedonian (Macedonia)", "mk-MK"],
     ["Macedonian", "mk"],
     ["Machame (Tanzania)", "jmc-TZ"],
     ["Machame", "jmc"],
     ["Makonde (Tanzania)", "kde-TZ"],
     ["Makonde", "kde"],
     ["Malagasy (Madagascar)", "mg-MG"],
     ["Malagasy", "mg"],
     ["Malay (Brunei)", "ms-BN"],
     ["Malay (Malaysia)", "ms-MY"],
     ["Malay", "ms"],
     ["Malayalam (India)", "ml-IN"],
     ["Malayalam", "ml"],
     ["Maltese (Malta)", "mt-MT"],
     ["Maltese", "mt"],
     ["Manx (United Kingdom)", "gv-GB"],
     ["Manx", "gv"],
     ["Marathi (India)", "mr-IN"],
     ["Marathi", "mr"],
     ["Masai (Kenya)", "mas-KE"],
     ["Masai (Tanzania)", "mas-TZ"],
     ["Masai", "mas"],
     ["Meru (Kenya)", "mer-KE"],
     ["Meru", "mer"],
     ["Morisyen (Mauritius)", "mfe-MU"],
     ["Morisyen", "mfe"],
     ["Nama (Namibia)", "naq-NA"],
     ["Nama", "naq"],
     ["Nepali (India)", "ne-IN"],
     ["Nepali (Nepal)", "ne-NP"],
     ["Nepali", "ne"],
     ["North Ndebele (Zimbabwe)", "nd-ZW"],
     ["North Ndebele", "nd"],
     ["Norwegian Bokmål (Norway)", "nb-NO"],
     ["Norwegian Bokmål", "nb"],
     ["Norwegian Nynorsk (Norway)", "nn-NO"],
     ["Norwegian Nynorsk", "nn"],
     ["Nyankole (Uganda)", "nyn-UG"],
     ["Nyankole", "nyn"],
     ["Oriya (India)", "or-IN"],
     ["Oriya", "or"],
     ["Oromo (Ethiopia)", "om-ET"],
     ["Oromo (Kenya)", "om-KE"],
     ["Oromo", "om"],
     ["Pashto (Afghanistan)", "ps-AF"],
     ["Pashto", "ps"],
     ["Persian (Afghanistan)", "fa-AF"],
     ["Persian (Iran)", "fa-IR"],
     ["Persian", "fa"],
     ["Polish (Poland)", "pl-PL"],
     ["Polish", "pl"],
     ["Portuguese (Guinea-Bissau)", "pt-GW"],
     ["Portuguese (Mozambique)", "pt-MZ"],
     ["Portuguese (Portugal)", "pt-PT"],
     ["Portuguese", "pt"],
     ["Punjabi (Arabic)", "pa-Arab"],
     ["Punjabi (Arabic, Pakistan)", "pa-Arab-PK"],
     ["Punjabi (Gurmukhi)", "pa-Guru"],
     ["Punjabi (Gurmukhi, India)", "pa-Guru-IN"],
     ["Punjabi", "pa"],
     ["Romanian (Moldova)", "ro-MD"],
     ["Romanian (Romania)", "ro-RO"],
     ["Romanian", "ro"],
     ["Romansh (Switzerland)", "rm-CH"],
     ["Romansh", "rm"],
     ["Rombo (Tanzania)", "rof-TZ"],
     ["Rombo", "rof"],
     ["Russian (Moldova)", "ru-MD"],
     ["Russian (Russia)", "ru-RU"],
     ["Russian (Ukraine)", "ru-UA"],
     ["Russian", "ru"],
     ["Rwa (Tanzania)", "rwk-TZ"],
     ["Rwa", "rwk"],
     ["Samburu (Kenya)", "saq-KE"],
     ["Samburu", "saq"],
     ["Sango (Central African Republic)", "sg-CF"],
     ["Sango", "sg"],
     ["Sena (Mozambique)", "seh-MZ"],
     ["Sena", "seh"],
     ["Serbian (Cyrillic)", "sr-Cyrl"],
     ["Serbian (Cyrillic, Bosnia and Herzegovina)", "sr-Cyrl-BA"],
     ["Serbian (Cyrillic, Montenegro)", "sr-Cyrl-ME"],
     ["Serbian (Cyrillic, Serbia)", "sr-Cyrl-RS"],
     ["Serbian (Latin)", "sr-Latn"],
     ["Serbian (Latin, Bosnia and Herzegovina)", "sr-Latn-BA"],
     ["Serbian (Latin, Montenegro)", "sr-Latn-ME"],
     ["Serbian (Latin, Serbia)", "sr-Latn-RS"],
     ["Serbian", "sr"],
     ["Shona (Zimbabwe)", "sn-ZW"],
     ["Shona", "sn"],
     ["Sichuan Yi (China)", "ii-CN"],
     ["Sichuan Yi", "ii"],
     ["Sinhala (Sri Lanka)", "si-LK"],
     ["Sinhala", "si"],
     ["Slovak (Slovakia)", "sk-SK"],
     ["Slovak", "sk"],
     ["Slovenian (Slovenia)", "sl-SI"],
     ["Slovenian", "sl"],
     ["Soga (Uganda)", "xog-UG"],
     ["Soga", "xog"],
     ["Somali (Djibouti)", "so-DJ"],
     ["Somali (Ethiopia)", "so-ET"],
     ["Somali (Kenya)", "so-KE"],
     ["Somali (Somalia)", "so-SO"],
     ["Somali", "so"],
     ["Spanish (Argentina)", "es-AR"],
     ["Spanish (Bolivia)", "es-BO"],
     ["Spanish (Chile)", "es-CL"],
     ["Spanish (Colombia)", "es-CO"],
     ["Spanish (Costa Rica)", "es-CR"],
     ["Spanish (Dominican Republic)", "es-DO"],
     ["Spanish (Ecuador)", "es-EC"],
     ["Spanish (El Salvador)", "es-SV"],
     ["Spanish (Equatorial Guinea)", "es-GQ"],
     ["Spanish (Guatemala)", "es-GT"],
     ["Spanish (Honduras)", "es-HN"],
     ["Spanish (Latin America)", "es-419"],
     ["Spanish (Mexico)", "es-MX"],
     ["Spanish (Nicaragua)", "es-NI"],
     ["Spanish (Panama)", "es-PA"],
     ["Spanish (Paraguay)", "es-PY"],
     ["Spanish (Peru)", "es-PE"],
     ["Spanish (Puerto Rico)", "es-PR"],
     ["Spanish (Spain)", "es-ES"],
     ["Spanish (United States)", "es-US"],
     ["Spanish (Uruguay)", "es-UY"],
     ["Spanish (Venezuela)", "es-VE"],
     ["Spanish", "es"],
     ["Swahili (Kenya)", "sw-KE"],
     ["Swahili (Tanzania)", "sw-TZ"],
     ["Swahili", "sw"],
     ["Swedish (Finland)", "sv-FI"],
     ["Swedish (Sweden)", "sv-SE"],
     ["Swedish", "sv"],
     ["Swiss German (Switzerland)", "gsw-CH"],
     ["Swiss German", "gsw"],
     ["Tachelhit (Latin)", "shi-Latn"],
     ["Tachelhit (Latin, Morocco)", "shi-Latn-MA"],
     ["Tachelhit (Tifinagh)", "shi-Tfng"],
     ["Tachelhit (Tifinagh, Morocco)", "shi-Tfng-MA"],
     ["Tachelhit", "shi"],
     ["Taita (Kenya)", "dav-KE"],
     ["Taita", "dav"],
     ["Tamil (India)", "ta-IN"],
     ["Tamil (Sri Lanka)", "ta-LK"],
     ["Tamil", "ta"],
     ["Telugu (India)", "te-IN"],
     ["Telugu", "te"],
     ["Teso (Kenya)", "teo-KE"],
     ["Teso (Uganda)", "teo-UG"],
     ["Teso", "teo"],
     ["Thai (Thailand)", "th-TH"],
     ["Thai", "th"],
     ["Tibetan (China)", "bo-CN"],
     ["Tibetan (India)", "bo-IN"],
     ["Tibetan", "bo"],
     ["Tigrinya (Eritrea)", "ti-ER"],
     ["Tigrinya (Ethiopia)", "ti-ET"],
     ["Tigrinya", "ti"],
     ["Tonga (Tonga)", "to-TO"],
     ["Tonga", "to"],
     ["Turkish (Turkey)", "tr-TR"],
     ["Turkish", "tr"],
     ["Ukrainian (Ukraine)", "uk-UA"],
     ["Ukrainian", "uk"],
     ["Urdu (India)", "ur-IN"],
     ["Urdu (Pakistan)", "ur-PK"],
     ["Urdu", "ur"],
     ["Uzbek (Arabic)", "uz-Arab"],
     ["Uzbek (Arabic, Afghanistan)", "uz-Arab-AF"],
     ["Uzbek (Cyrillic)", "uz-Cyrl"],
     ["Uzbek (Cyrillic, Uzbekistan)", "uz-Cyrl-UZ"],
     ["Uzbek (Latin)", "uz-Latn"],
     ["Uzbek (Latin, Uzbekistan)", "uz-Latn-UZ"],
     ["Uzbek", "uz"],
     ["Vietnamese (Vietnam)", "vi-VN"],
     ["Vietnamese", "vi"],
     ["Vunjo (Tanzania)", "vun-TZ"],
     ["Vunjo", "vun"],
     ["Welsh (United Kingdom)", "cy-GB"],
     ["Welsh", "cy"],
     ["Yoruba (Nigeria)", "yo-NG"],
     ["Yoruba", "yo"],
     ["Zulu (South Africa)", "zu-ZA"],
     ["Zulu", "zu"]]
  end
end
