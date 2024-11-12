<?php 
    $_REQUEST['model'] = 'gpt-4o' ;
    $_REQUEST['api-key'] = '' ; // define api key here for hackthon : Quran Mentor
    
    require('openai.php') ;
    // Create chatgpt search in books with embeding and ask question ?
    // List of tags that should be used in the analysis ... examples of tags ... not needed we got it from gpt 
    
    $tags = [
        "happy", "sad" , "sadness" , "excited", "nervous", "afraid", "angry", "surprised", "joyful", "content", "proud",
        "hopeful", "disappointed", "guilty", "ashamed", "regretful", "longing", "lovestruck", "grateful",
        "whimsical", "playful", "curious", "thoughtful", "wise", "dreamy", "serene", "calm", "peaceful",
        "relaxed", "restless", "anxious", "stressed", "tense", "confused", "forgetful", "dizzy", "drunk",
        "sober", "awake", "tired", "sleepy", "exhausted", "refreshed", "invigorated", "sluggish", "sick",
        "nauseous", "hungry", "thirsty", "full", "stuffed", "satisfied", "disgusted", "bored", "frustrated",
        "helpless", "powerless", "hopeful", "optimistic", "pessimistic", "defeated", "triumphant", "victorious",
        "confident", "insecure", "jealous", "envious", "bitter", "sweet", "salty", "sour", "spicy", "savory",
        "crunchy", "creamy", "chewy", "smooth", "soft", "hard", "warm", "cold", "frozen", "hot", "lukewarm",
        "shiny", "dull", "glossy", "matte", "rough", "smooth", "silky", "hairy", "furry", "feathery",
        "scaly", "wrinkled", "smooth", "wet", "dry", "sticky", "slippery", "greasy", "oily", "dusty",
        "muddy", "sandy", "grainy", "gritty", "crumbly", "flaky", "powdery", "chunky", "gooey", "runny",
        "drippy", "droopy", "perky", "peppy", "bubbly", "fizzy", "sparkling", "flat", "stale", "musty",
        "moldy", "rotten", "rancid", "putrid", "fresh", "clean", "pure", "fragrant", "stinky", "reeky",
        "pungent", "spicy", "sweet", "sour", "salty", "umami", "metallic", "chemical", "plastic", "rubbery",
        "leathery", "woody", "paper", "cardboard", "clay", "glass", "metal", "stone", "water", "ice",
        "steam", "smoke", "fire", "electricity", "magnetism", "gravity", "wind", "rain", "snow", "thunder",
        "lightning", "fog", "mist", "haze", "dust", "smog", "light", "dark", "color", "shape", "size",
        "space", "time", "speed", "velocity", "acceleration", "force", "energy", "power", "momentum",
        "inertia", "weight", "mass", "density", "volume", "length", "width", "height", "distance",
        "area", "perimeter", "circumference", "angle", "degree", "radian", "minute", "second", "hour",
        "day", "week", "month", "year", "decade", "century", "millennium", "era", "epoch", "season",
        "solstice", "equinox", "holiday", "festival", "celebration", "anniversary", "birthday", "graduation",
        "retirement", "funeral", "memorial", "wedding", "engagement", "announcement", "proposal", "pregnancy",
        "birth", "infancy", "childhood", "adolescence", "youth", "adulthood", "middle age", "seniority",
        "longevity", "immortality", "eternity", "infinity", "zero", "one", "two", "three", "four", "five",
        "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
        "sixteen", "seventeen", "eighteen", "nineteen", "twenty", "thirty", "forty", "fifty", "sixty",
        "seventy", "eighty", "ninety", "hundred", "thousand", "million", "billion", "trillion", "quadrillion",
        "quintillion", "sextillion", "septillion", "octillion", "nonillion", "decillion" , "trust" , "truth"
    ];

    // Example of Ayat with tags should come from database 
    $ayat = [
        
         [
            'aya' => 'وَأَنزَلْنَا إِلَيْكَ الْكِتَابَ بِالْحَقِّ مُصَدِّقًا لِّمَا بَيْنَ يَدَيْهِ مِنَ الْكِتَابِ وَمُهَيْمِنًا عَلَيْهِ' ,
            'translation' => 'English - Sahih International
            5:48 And We have revealed to you, [O Muhammad], the Book in truth, confirming that which preceded it of the Scripture and as a criterion over it. So judge between them by what Allah has revealed and do not follow their inclinations away from what has come to you of the truth.' ,
            'mp3' => 'https://beta.markoum.com/v3/sura/5/english_rwwad/0SjcZPyviTlWOXxHCs0G/048.mp3',
            'sura' => [
                'name' => 'المائدة',
                'number' => 5 ,
                'info' => 'سورة  مدنية '    
            ] , 
            'aya_id' => 48 ,
            'translation_mp3' => 'https://beta.markoum.com/v3/sura/5/english_rwwad/0SjcZPyviTlWOXxHCs0G/048.mp3' ,
            'tags' => ['truth' , 'admiration']
        ],
        
        [
            'aya' => 'وَتَمَّتْ كَلِمَتُ رَبِّكَ صِدْقًا وَعَدْلًا ۚ لَّا مُبَدِّلَ لِكَلِمَاتِهِ ۚ وَهُوَ السَّمِيعُ الْعَلِيمُ' ,
            'translation' => 'And the word of your Lord has been fulfilled in truth and in justice. None can alter His words, and He is the Hearing, the Knowing."
            Peaceful:' ,
            'mp3' => 'https://beta.markoum.com/v3/sura/6/english_rwwad/0SjcZPyviTlWOXxHCs0G/115.mp3',
            'sura' => [
                'name' => 'الأنعام - Surah Al-An\'am (6:115)' ,
                'number' => 6 ,
                'info' => 'سورة  مدنية '    
            ] , 
            'aya_id' => 115 ,
            'translation_mp3' => 'https://beta.markoum.com/v3/sura/6/english_rwwad/0SjcZPyviTlWOXxHCs0G/115.mp3' ,
            'tags' => ['truth' , 'admiration' ]
        ],


        [
            'aya' => 'وَاللَّهُ يَدْعُو إِلَى دَارِ السَّلَامِ وَيَهْدِي مَن يَشَاءُ إِلَى صِرَاطٍ مُّسْتَقِيمٍ' ,
            'translation' => 'And the word of your Lord has been fulfilled in truth and in justice. None can alter His words, and He is the Hearing, the Knowing."
            Peaceful:' ,
            'mp3' => 'https://beta.markoum.com/v3/sura/10/english_rwwad/0SjcZPyviTlWOXxHCs0G/025.mp3',
            'sura' => [
                'name' => 'يونس - Surah Yunus (10:25)' ,
                'number' => 10 ,
                'info' => 'سورة  مدنية '    
            ] , 
            'aya_id' => 25 ,
            'translation_mp3' => 'https://beta.markoum.com/v3/sura/10/english_rwwad/0SjcZPyviTlWOXxHCs0G/025.mp3' ,
            'tags' => [ 'peaceful' ]
        ],

        [
            'aya' => 'ثُمَّ أَنزَلَ اللَّهُ سَكِينَتَهُ عَلَى رَسُولِهِ وَعَلَى الْمُؤْمِنِينَ وَأَنزَلَ جُنُودًا لَّمْ تَرَوْهَا وَعَذَّبَ الَّذِينَ كَفَرُوا ۚ وَذَٰلِكَ جَزَاءُ الْكَافِرِينَ' ,
            'translation' => 'Then Allah sent down His tranquility upon His Messenger and upon the believers and sent down soldiers [angels] whom you did not see and punished those who disbelieved. And that is the recompense of the disbelievers' ,
            'mp3' => 'https://beta.markoum.com/v3/sura/9/english_rwwad/0SjcZPyviTlWOXxHCs0G/026.mp3',
            'sura' => [
                'name' => ' التوبة - Surah At-Tawbah (9:26):' ,
                'number' => 9 ,
                'info' => 'سورة  مدنية '    
            ] , 
            'aya_id' => 26 ,
            'translation_mp3' => 'https://beta.markoum.com/v3/sura/9/english_rwwad/0SjcZPyviTlWOXxHCs0G/026.mp3' ,
            'tags' => [ 'calm' , 'admiration' , 'sadness' ]
        ],
        
        [
            'aya' => ' فَتَعَالَى اللَّهُ الْمَلِكُ الْحَقُّ ۖ وَلَا تَعْجَلْ بِالْقُرْآنِ مِن قَبْلِ أَن يُقْضَىٰ إِلَيْكَ وَحْيُهُ ۖ وَقُل رَّبِّ زِدْنِي عِلْمًا ' ,
            'translation' => 'So high [above all] is Allah, the Sovereign, the Truth. And, [O Muhammad], do not hasten with [recitation of] the Quran before its revelation is completed to you, and say, \'My Lord, increase me in knowledge' ,
            'mp3' => 'https://beta.markoum.com/v3/sura/20/english_rwwad/0SjcZPyviTlWOXxHCs0G/114.mp3',
            'sura' => [
                'name' => ' طه - Taha (20:114):' ,
                'number' => 20 ,
                'info' => 'سورة  مدنية '    
            ] , 
            'aya_id' => 114 ,
            'translation_mp3' => 'https://beta.markoum.com/v3/sura/20/english_rwwad/0SjcZPyviTlWOXxHCs0G/114.mp3' ,
            'tags' => [ 'curious' ]
        ],
        
        [
            'aya' => ' أَمْ حَسِبْتُمْ أَن تَدْخُلُوا الْجَنَّةَ وَلَمَّا يَأْتِكُم مَّثَلُ الَّذِينَ خَلَوْا مِن قَبْلِكُم ۖ مَّسَّتْهُمُ الْبَأْسَاءُ وَالضَّرَّاءُ وَزُلْزِلُوا حَتَّىٰ يَقُولَ الرَّسُولُ وَالَّذِينَ آمَنُوا مَعَهُ مَتَىٰ نَصْرُ اللَّهِ ۗ أَلَا إِنَّ نَصْرَ اللَّهِ قَرِيبٌ﴾ ' ,
            'translation' => 'Do you think that you will enter Paradise without being tested like those before you who were tested? They were afflicted with poverty and adversity and were shaken[109] until the messenger[110] and the believers with him said, “When will the help of Allah come?” Indeed, the victory of Allah is near' ,
            'mp3' => 'https://nekhtem.com/kariem/ayat/ayatsound/AbdAlRashed/002214.mp3',
            'sura' => [
                'name' => ' البقرة / Albaqra (2:214)' ,
                'number' => 2 ,
                'info' => 'سورة  مدنية '    
            ] , 
            'aya_id' => 214 ,
            'translation_mp3' => 'https://beta.markoum.com/v3/sura/2/english_rwwad/0SjcZPyviTlWOXxHCs0G/214.mp3' ,
            'tags' => [ 'afraid' , 'tired' , 'hopeful' , 'thoughtful' , 'curious' , 'curiosity' , 'interest' , 'sadness' ]
        ]

    ];

    $question = $_REQUEST['q'] ?? 'is the islam has fire and paradise ? , why ? , is it hurt ?' ;

    //$prompt = 'You are feeling reader , you can read the feeling in user words then you can generate tags per percents in json format , tags should be in this list :'.implode(' , ' , $tags) ;

    $prompt = 'You are feeling reader , you can read the feeling in user words then you can generate tags per percents in json format , tags should be in small case' ;


    $msgs = [
        'messages' => [
            [
                "role" => "system",
                "content" => $prompt
            ]  ,
            [
                "role" => "assistant",
                "content" => 'Depending on user text , extract feeling from text as json with percent '
            ]  ,
            [
                "role" => "user",
                "content" => 'User text is "'.$question.'"'
            ]
        ]
    ] ;


    $_REQUEST['html'] = 1 ;

    $answer     = callGpt( $msgs['messages'] ,  4000 , true , true ) ;
    
    $answer     = str_replace(['```json' , '```'] , '' , $answer ) ;

    $answerJson = json_decode( $answer , true ) ;

    $res     = $answerJson ;

    $AyatOk = [] ;
    $TagsSort = [] ;
    if( is_array($res) && count($res) > 0 && isset($question[5]) ){
        foreach( $res as $k => $v ){
            if( $v > 5 ){
                $TagsSort[$k] = $v ;
            }
        }
        arsort($TagsSort) ;
        foreach( $ayat as $k => $v ){
            $Tags = $v['tags'] ;
            $Tags = array_intersect($Tags , array_keys($TagsSort)) ;
            if( count($Tags) > 0 ){
                
                // Get Aya Prompt for information            
                    // $aya =  $v['aya'] ; 
                    // $prompt = ' Could you analyze the following Quranic verses: [insert verses or references here]? I\'m looking for keywords that highlight the emotional and spiritual themes within these verses. Please consider both the immediate context and the broader theological significance. I\'m interested in emotions such as hope, patience, and resilience. I'd like the keywords in both Arabic and English, as I plan to use them for a personal reflection project on spiritual resilience. It's important that the analysis respects the depth and sensitivity of the Quranic text ' ;
                    //$prompt = ' You can analyze Quranic verses: User is looking for keywords that highlight the emotional and spiritual themes within these verses. Please consider both the immediate context and the broader theological significance. User is interested in emotions such as hope, patience, and resilience. You would like the keywords in both Arabic and English, as I plan to use them for a personal reflection project on spiritual resilience. It\'s important that the analysis respects the depth and sensitivity of the Quranic text ' ;
                    // $msgs = [
                    //    'messages' => [
                    //        [
                    //            "role" => "system",
                    //            "content" => $prompt
                    //       ]  ,
                    //        [
                    //            "role" => "assistant",
                    //            "content" => 'Depending on user text , analyze Quranic verses , and highlight emotional and spiritual themes within these verses '
                    //        ]  ,
                    //        [
                    //            "role" => "user",
                    //            "content" => 'User text is "'.$aya.'"'
                    //        ]
                    //    ]
                    //] ;
                    //$_REQUEST['html'] = 1 ;
                    // If we need to get the result of aya from GPT-4o model
                    //$answer     = callGpt( $msgs['messages'] ,  4000 , true , true ) ;
                    //$answerJson = json_decode( $answer , true ) ;
                    //print_r( $answer ) ; die();
                    //$resx     = $answerJson['choices'][0]['message']['content'] ?? '';
                    //$v['gpt_result'] = nl2br($answer) ;
                    $AyatOk[] = $v ;
            }
        }

    }else{
        var_dump( [ $answer , $res ] ) ; die();
    }

    $resultAll = [
        'q' => $question ,
        'tags' => $res ,
        'ayat' => $AyatOk
    ];

    header('Content-type: Application/json');
    echo json_encode($resultAll) ;
?>