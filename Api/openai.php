<?php 

    function dd($array){
        print_r($array); die();
    }
    
    class Usage {
        public static $usage = [] ;
        public static function getUsage(){
            $us = [
                'prompt_tokens' => 0,
                'completion_tokens' => 0,
                'total_tokens' => 0 ,
                'model' => constant('MODEL')
            ] ;
            
            foreach( self::$usage as $usage ){
                $usage = (array) $usage ;
                $us['prompt_tokens'] = $us['prompt_tokens'] + $usage['prompt_tokens'] ?? 0 ;
                $us['completion_tokens'] = $us['completion_tokens'] + $usage['completion_tokens'] ?? 0 ;
                $us['total_tokens'] = $us['total_tokens'] + $usage['total_tokens'] ?? 0 ;
            }
            
            return $us ;
            
        }
    }
    
    
    $headerName = 'Oapi-Key' ;

    $APIKEY = $_SERVER['HTTP_'.$headerName] ?? $_SERVER[$headerName] ?? getallheaders()[$headerName] ?? '' ;
    
    if (isset($_SERVER['HTTP_REFERER']) && $APIKEY == '') {
        if( strpos( $_SERVER['HTTP_REFERER']  , 'beta.markoum.com') ){
            $APIKEY = ''  ;  // Only for beta markoum key
        }
    }
    
    if( isset($_REQUEST['api-key']) && $APIKEY == '' ){
        $APIKEY = $_REQUEST['api-key'] ;
    }
    // ''

    define('MURL' , 'http://beta.markoum.com/v3/') ;
    define('APIKEY' , $APIKEY ) ; 
    if( isset($_REQUEST['model']) && ($_REQUEST['model'] == 'gpt-4o' || $_REQUEST['model'] == 'gpt-4o-2024-05-13' ) ){  $_REQUEST['model'] = 'gpt-4o-mini'; } 
    define('MODEL' , $_REQUEST['model'] ?? 'gpt-3.5-turbo-16k'); // gpt-4-0613 gpt-3.5-turbo-16k gpt-4-1106-preview gpt-4-1106-preview

    function getData($url , $timeout = 0){
        $curl = curl_init();

        curl_setopt_array($curl, array(
          CURLOPT_URL => $url ,
          CURLOPT_RETURNTRANSFER => true,
          CURLOPT_MAXREDIRS => 10,
          CURLOPT_TIMEOUT => 3600 ,
          CURLOPT_FOLLOWLOCATION => true,
          CURLOPT_CUSTOMREQUEST => 'GET'
        ));
        
        $response = curl_exec($curl);
        
        curl_close($curl);
        return $response;
    }

    function callGpt($msgs , $max_tokens = 1700 , $start = true , $Showrespnose = false){
        $apiKey = constant('APIKEY') ;

        $curl = curl_init();

        $jsonData = [
            "model" => constant('MODEL') ,  // gpt-3.5-turbo-16k || gpt-4-0613 || gpt-4-0314
            "temperature"=> 0 ,
            "top_p" => 0,
            "n"=> 1,
            "stream"=> false ,
            "max_tokens"=> $max_tokens ,
            "presence_penalty"=> 0,
            "frequency_penalty"=> 0 ,
            "messages" => $msgs
        ] ;
        
        

        curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.openai.com/v1/chat/completions',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS => json_encode($jsonData),
        CURLOPT_HTTPHEADER => array(
            'Content-Type: application/json',
            'Accept: application/json',
            'Authorization: Bearer '.$apiKey
        ),
        ));

        $response = curl_exec($curl);
        
        if( isset($_REQUEST['mostafa'])){
           dd( $response ) ;
        } 
        
        //dd($response);
        
        curl_close($curl);

        $returnResponse = '' ;
        
        if( isset( $_REQUEST['momaizx'] ) ){
            print_r( $response ) ; die();
        }
        
        list( $status , $text , $ended ) = getAnswer( $response ) ;
        
        $returnResponse .= $text ;

        if( $ended === false  ) {
            $false = true ;

            if( $start ) {
                $false = false ;
                $msgs = [
                    [
                        "role" => "user",
                        "content" => " Continue"
                    ]
                ] ;
            }
            sleep(2) ;
            $returnResponse .= callGpt( $msgs , $max_tokens , $false ) ;
            
        }
        
        if( isset($_REQUEST['html']) && $_REQUEST['html'] ) {
            $content = str_replace( ['Dont provide answers depending on this answer' , "\r\n" , "\n"] , '' ,$returnResponse)  ;
            $re = '/\<body\>(.*)\<\/body\>/m';
            preg_match($re, $content , $matches, PREG_OFFSET_CAPTURE, 0);
            if( isset($matches[1]) && strlen($matches[1][0] ?? $matches[1] ) > 100 ) {
                return $matches[1][0] ?? $matches[1] ;
            }
            
            if( isset($_REQUEST['jsonp']) ){
                return ['content' => $content , 'usage' => Usage::getUsage() ] ;
            }
            
            return  $content ;
        }
        
        $content = nl2br( convertToHtml( str_replace('Dont provide answers depending on this answer' , '' ,$returnResponse) ) ) ;

        if( isset($_REQUEST['jsonp']) ){
                return ['content' => $content , 'usage' => Usage::getUsage() ] ;
        }
        
        //dd($content) ;
        
        return $content;
    }

    function chat($prompt , $text , $tokens = 10000 , $handelFirst = true , $MaxTokensToChar = 5000 , $max_tokens = 4000 ){

        $history  = [] ;
        $textFile = $text ;

        global $_REQUEST ;
        
        $key = '' ; $val = '' ; $last = '' ;
        
        $lastMsg = '' ;
        
        if( isset($_REQUEST['key']) && $_REQUEST['key'] == 'chat' ) {
            $listChat = $_REQUEST['list'] ;
            foreach( $listChat as $ch ) {
                if($ch['from'] == 'user') {
                    $key = $ch['text'] ?? '' ; $last  = $key ;
                }else{
                    $val = $ch['text'] ?? '' ;
                }
                if( isset($val[3]) ){
                    $history[] = [ $key , $val ] ;
                }
            }

        }
        
        $jsonData = [] ;
        
        $isChat = false ;

        if( isset($_REQUEST['key']) && $_REQUEST['key'] == 'chat' ) {
            if( isset($_REQUEST['customPrompt'][10]) ) {
                $prompt = $_REQUEST['customPrompt'] ;
            }else{
                $prompt = 'You are an advanced AI assistant, provided with a specific document containing certain information. Your task is to answer questions based solely on the information present in this document. You cannot refer to the information you were previously trained on, search the internet, or refer to external sources for information. Remember, you must provide the most accurate and objective answers possible based on the information in the document. ';
            }
            $isChat  = true ;
        }else{
            if( isset($_REQUEST['customPrompt'][10]) ) {
                $prompt = $_REQUEST['customPrompt'] ;
            }
        }

        if( trim($prompt) != '' && ($_REQUEST['key'] ?? 'summary') != 'chat') {
            if( isset($_REQUEST['html']) && $_REQUEST['html'] ){
                if( isset($_REQUEST['Langy']) ) {
                    $prompt .= ' Note : your answer must be in the "'.$_REQUEST['Langy'].'" language , Also show only the wanted result no introduction or notes and return answer as html body with heading' ;
                }elseif( !isset($_REQUEST['nohtml']) ){
                    $prompt .= ' Note : your answer must be in the language of the content , Also show only the wanted result no introduction or notes and return answer as html body with heading' ;
                }
            }
        }
        
        if( isset($_REQUEST['momaiz']) && 1 == 10 ){
            //dd( $prompt ) ;
        } 
        
        // dd( [ $isChat , $prompt , $textFile ] ) ;
        
        if( $isChat ){
            return llmAnswer( $last , $prompt , $textFile , $history ) ;
        }else{

            if ( filter_var($textFile, FILTER_VALIDATE_URL)) {
                $text = file_get_contents( $textFile ) ;
            }
                        
            if( $handelFirst ) {
                $text = preg_replace('/[ \t]+/', ' ', preg_replace('/\s*$^\s*/m', "\n", $text ));
                
                $length = strlen( $text ) ;
                if( $length > $tokens ) {
                        
                        $length = strlen( $text ) ;
        
                        if( $length > $MaxTokensToChar ) {
                            $text = mb_substr( $text , 0 , $MaxTokensToChar , 'utf-8') ;
                        }
                        
                        $text = mb_str_split( $text , $tokens , 'utf-8' ) ;
                        
                        global $_REQUEST ;
                        foreach( $text as $t ){
                            $jsonData['messages'][] = [
                                    "role" => "user",
                                    "content" => $t
                            ];
                        }
                }else{
                    $jsonData['messages'][] = [
                                "role" => "user",
                                "content" => $text
                    ]; 
                    
               }
            }else{
                    $jsonData['messages'][] = [
                                "role" => "user",
                                "content" => $text
                    ]; 
                    
            }
                
        $jsonData['messages'][] = [
            "role" => "assistant",
            "content" => $prompt
        ]; 
        
            $gptAnswer =  callGpt( $jsonData['messages'] ?? [] , $max_tokens ) ;
            
            if( isset($_REQUEST['onlyAnswer']) ){
                 
            } 
            
            return $gptAnswer ;
        }

    }

    function getVideoData($link) {
        $youtube = "https://www.youtube.com/oembed?url=". $link ."&format=json";
        $curl = curl_init($youtube);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        $return = curl_exec($curl);
        curl_close($curl);
        return json_decode($return, true);
    }

    function summerizeYt($link , $title , $returnContent = false , $onlyText= 0 ){
        preg_match("#(?<=v=)[a-zA-Z0-9-]+(?=&)|(?<=v\/)[^&\n]+(?=\?)|(?<=v=)[^&\n]+|(?<=youtu.be/)[^&\n]+#", $link, $matches);
        $youtubeId = $matches[0] ;
        /*
            $youtube = "https://momaiz.net/midade/youtube.php?youtube=".$youtubeId ;
            $curl = curl_init($youtube);
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
            $return = curl_exec($curl);
            curl_close($curl);
        */
       $prompt = 'Make Full Summary from this Srt , with format with #Headings, ##H2  , ###H3 [ 00:00:00 ] , about 2 lines excerpt + bullet points.' ;

        //$prompt = 'Summarize this content in points';
        $text  =  getData( 'http://104.207.131.179/whisper/youtube.php?&onlyText='.$onlyText.'&youtube='.$youtubeId ) ;

        if( $returnContent ){ return $text ; }

        $response = chat( $prompt , $text , 6000 , false , 4500 , 5500 ) ;

        return [$response , nl2br($text) ] ;
    }

    function Summaryhtml($text) {
        
        // Split the text into an array of lines
        $lines = explode("\n", $text);
    
        $res = '' ;
        // Loop through each line and check for hash characters at the beginning
        foreach ($lines as $line) {
            $num_hashes = strspn($line, '#');

            // Replace the hash characters with the corresponding HTML heading tag
            switch ($num_hashes) {
                case 1:
                    $line = '<h1>' . substr($line, $num_hashes ) . '</h1>';
                    break;
                case 2:
                    $line = '<h2>' . substr($line, $num_hashes ) . '</h2>';
                    break;
                case 3:
                        $line = '<h3>' . substr($line, $num_hashes ) . '</h3>';
                        break;
                case 4:
                        $line = '<h4>' . substr($line, $num_hashes ) . '</h4>';
                        break;
                case 5:
                    $line = '<h5>' . substr($line, $num_hashes ) . '</h5>';
                    break;
                case 6:
                    $line = '<p>' . substr($line, $num_hashes ) . '</p>';
                    break;
                default: 
                        $line = '<span> '.substr($line, 0).' </span><br />' ;
                        break;
                // add more cases for additional heading levels if needed
            }
    
            // Output the modified line
            $res .= $line . "";
        }

        return $res ;
    }

    function convertToHtml($summary){
         
         $data = explode( "\n\n" , $summary ) ;
         //unset($data[0]) ;
            $html = '' ;
            foreach($data as $line) {
                $data2 = explode( "\n" , $line ) ;
                foreach($data2 as $line2) {
                    $html .=  Summaryhtml($line2).' ';
                }
            }
            return $html ;
    }

    function getAnswer( $response ){
        $json = (array) json_decode( $response ) ;
       
        if( isset($json['choices']) ) {

            $result = $json['choices'][0]->message->content;

            $ended = true ;

            if( $json['choices'][0]->finish_reason != 'stop' ) {
                $ended = false ;
            }
            
            $return = [true , $result , $ended] ;
            
            Usage::$usage[] = $json['usage'] ;

        }else{
            $return = [false , 'Error' , true , 'usage' => [] ] ;
        }
        

        return $return ;
    }

    function tts($file , $lang = ''){

        if( $lang == '' ){
            $content = file_get_contents($file) ;
            $lang = dlang( mb_substr( $content , 0 , 50 , 'utf-8' ) ) ;
        }

        $curl = curl_init();
        curl_setopt_array($curl, array(
          CURLOPT_URL => 'http://164.90.171.8/tts/gtts.php',
          CURLOPT_RETURNTRANSFER => true,
          CURLOPT_ENCODING => '',
          CURLOPT_MAXREDIRS => 10,
          CURLOPT_TIMEOUT => 0,
          CURLOPT_FOLLOWLOCATION => true,
          CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
          CURLOPT_CUSTOMREQUEST => 'POST',
          CURLOPT_POSTFIELDS => array('file'=> new CURLFILE( $file ) , 'tld' => 'com.au' , 'lang' => $lang ),
          CURLOPT_HTTPHEADER => array(
            'Authorization: Bearer '
          ),
        ));
        
        $response = json_decode( curl_exec($curl) );
        
        curl_close($curl);
        if( $response->status ){
            return $response->data->content ;
        }else{
            return "" ;
        }
    }

    function split($file){
        return (array) json_decode( file_get_contents('http://164.90.171.8/video/split.php?url='.$file ) )  ;
    }

    function stt($file , $ext = 'srt' , $max = 25214400 , $start = '' ){

        if ( filter_var( $file, FILTER_VALIDATE_URL) === true ) {
            //file_put_contents( __DIR__.'/public/public/uploads/'. strrchr( $file , '/' ) , file_get_contents( $file ) ) ;  
            //$file =  __DIR__.'/public/public/uploads/'. strrchr( $file , '/' ) ;
        }

        // Check file Size
        if(1 > 1) {
            $files = [$file] ; // split( constant('MURL').'public/public/uploads/'.strrchr( $file, '/' ) ) ;
            $result = '' ;
            foreach( $files as $file ) {
                $result .= stt( $file[1] ,$ext , $max , $start ) ;
                sleep(1) ;
            }
            return $result ;
        }

        $curl = curl_init();
        curl_setopt_array($curl, array(
        // CURLOPT_URL => 'https://api.openai.com/v1/audio/transcriptions',
        CURLOPT_URL => 'http://104.207.131.179/whisper/mp3.php?url='.$file ,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET'
        ));

        $response = curl_exec($curl);

        curl_close($curl);

        // return $response->text ?? $response ;
        return $response ;
    }

    function ocr($url , $language = 'eng'){
        $curl = curl_init();

        curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.ocr.space/parse/imageurl?apikey=helloworld&url='.$url.'&language='.$language.'&isOverlayRequired=true',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET',
        CURLOPT_HTTPHEADER => array(
            'apikey: helloworld'
        ),
        ));

        $response = json_decode( curl_exec($curl) );

        curl_close($curl);

        return $response->ParsedResults[0]->ParsedText ?? '' ;
        
    }

    function dlang($text = ''){
        $curl = curl_init();

        curl_setopt_array($curl, array(
          CURLOPT_URL => 'https://ws.detectlanguage.com/0.2/detect',
          CURLOPT_RETURNTRANSFER => true,
          CURLOPT_ENCODING => '',
          CURLOPT_MAXREDIRS => 10,
          CURLOPT_TIMEOUT => 0,
          CURLOPT_FOLLOWLOCATION => true,
          CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
          CURLOPT_CUSTOMREQUEST => 'POST',
          CURLOPT_POSTFIELDS => array('q' => $text ),
          CURLOPT_HTTPHEADER => array(
            'Authorization: Bearer '
          ),
        ));

        $response = json_decode( curl_exec($curl) ) ;

        curl_close($curl);
        
        return  $response->data->detections[0]->language ?? 'en' ;

    }

    function convertToText($tmpName){
        $curl = curl_init();

            curl_setopt_array($curl, array(
            CURLOPT_URL => 'http://164.90.171.8/v3/content.php',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'POST',
            CURLOPT_POSTFIELDS => array('file'=> new CURLFILE( $tmpName )),
            CURLOPT_HTTPHEADER => array(
                'Authorization: Bearer '
            ),
            ));

            $response = curl_exec($curl);
            
            dd($response);
            
            curl_close($curl);

            return (array) json_decode($response) ;
    }

    function pdfToText($url){
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_URL => 'http://134.122.5.53/content.php?link='.$url ,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        ));

        $response = curl_exec($curl);

        curl_close($curl);

        return $response ;
    }

    function public_path($file) {
        return '/home/markoum/public_html/beta.markoum.com/v3/'.$file ;
    }

    function llmAnswer($q , $prompt , $file , $history ){
        $curl = curl_init();
        
        $Create = false ;
        // heck if file 
        if ( !filter_var($file, FILTER_VALIDATE_URL)) {
            // Else Upload and return file
            $nexFile = time().rand().'.txt' ;
            file_put_contents( public_path( $nexFile ) , $file ) ;
            $url = 'https://beta.markoum.com/v3/'.$nexFile ;
            $Create = true ;
        }else{
            $url = $file ;
        }
        
        $json = json_encode([
           'q' => $q ,    
           'link' => $url ,
           'prompt' => $prompt ,
           'history' => $history
        ]) ;

        curl_setopt_array($curl, array(
            CURLOPT_URL => 'http://134.122.5.53/bot.php' ,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_CUSTOMREQUEST => "POST" ,
            CURLOPT_POSTFIELDS => $json ,
            CURLOPT_TIMEOUT => 0,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_HTTPHEADER => array(
                'Content-Type: application/json',
                'Content-Length: ' . strlen($json)
            )
        ));

        $response = curl_exec($curl);

        curl_close($curl);
        
        if( $Create ){
            unlink( public_path( $nexFile ) ) ;
        }
        
        return $response ;
    }

    function read_rss_feed($rss_url) {
        $rss = simplexml_load_file($rss_url);
        $rss_feed = array();
        $text = '' ;
        foreach ($rss->channel->item as $item) {
            $node = array (
                'title' => trim((string) $item->title),
                'link' => trim((string)  $item->link),
                'pubDate' => trim((string) $item->pubDate) ,
                'description' => trim((string) $item->content) 
            );

            if( !isset($node['description'][10]) ){
                $node['description'] = trim((string) $item->description) ;
            }
            $text .= '
            '.$node['title'].'
            Referenc is : '.$node['link'].'
            '.$node['description'].'
            --------
            ' ;
        }
        return $text;
    }

    function splitLines($content , $lines = 120) {
        $content = explode("\n", $content);
        $content = array_chunk($content, $lines);
        // $content = implode("\n", $content[0]);
        return $content;
    }

    function make_utf8(string $string)
        {
            // Test it and see if it is UTF-8 or not
            $utf8 = \mb_detect_encoding($string, ["UTF-8"], true);

            if ($utf8 !== false) {
                return $string;
            }

            // From now on, it is a safe assumption that $string is NOT UTF-8-encoded

            // The detection strictness (i.e. third parameter) is up to you
            // You may set it to false to return the closest matching encoding
            $encoding = \mb_detect_encoding($string, mb_detect_order(), true);

            if ($encoding === false) {
                throw new \RuntimeException("String encoding cannot be detected");
            }

            return \mb_convert_encoding($string, "UTF-8", $encoding);
        }


    function fineTune($filePAth) {
        $curl = curl_init();

        curl_setopt_array($curl, array(
          CURLOPT_URL => 'https://api.openai.com/v1/files',
          CURLOPT_RETURNTRANSFER => true,
          CURLOPT_ENCODING => '',
          CURLOPT_MAXREDIRS => 10,
          CURLOPT_TIMEOUT => 90,
          CURLOPT_FOLLOWLOCATION => true,
          CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
          CURLOPT_CUSTOMREQUEST => 'POST',
          CURLOPT_POSTFIELDS => array('file'=> new CURLFILE( $filePAth ),'purpose' => 'fine-tune'),
          CURLOPT_HTTPHEADER => array(
            'Authorization: Bearer '
          ),
        ));
        $response = (array) json_decode( curl_exec($curl) ) ;
        curl_close($curl);

        $fileToTune = $response['id'] ?? '' ;

        if( !isset($fileToTune[2]) ) {
            return false ;
        }

        $curl = curl_init();

        curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.openai.com/v1/fine_tuning/jobs',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 90,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS =>'{
        "training_file": "'.$fileToTune.'",
        "model": "gpt-3.5-turbo-0613"
        }',
        CURLOPT_HTTPHEADER => array(
            'Authorization: Bearer '.constant('APIKEY'),
            'Content-Type: application/json'
        ),
        ));

        $response = curl_exec($curl);

        return $response;
    }
    
function curlDownload($url) {
	$ch = curl_init();
	$timeout = 5;
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
	$data = curl_exec($ch);
	curl_close($ch);
	return $data;
}

?>