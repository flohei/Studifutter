
<?php

$apiid = $_GET['id'];
$nocache = 0;
if($_GET['nocache'] == true){
	$nocache = 1;
}

$notes = 'Beilagen sind nicht im Preis enthalten; X = kein Schweinefleisch; V = Vegetarisch; R = Rindfleisch; 1 mit Farbstoff; 4 mit Konservierungsstoff; 7 mit Antioxidationsmittel; 8 mit Geschmacksverstärker; 9 geschwefelt; 10 geschwärzt; 11 gewachst; 12 mit Phosphat; 5 mit Süßungsmittel';

$locations[] = array(
'id' => '1', 
'url' => 'http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-eichstaett.shtml', 
'city' => 'Eichstätt', 
'closed' => '0', 
'latitude' => '48.888649',
'longitude' => '11.190262',
'name' => 'Eichstätt',
'notes' => $notes,
'street' => 'Universitätsallee 2',
'zipCode' => '85072',
);
$locations[] = array(
'id' => '2', 
'url' => 'http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-eichstaett.shtml', 
'city' => 'Ingolstadt', 
'closed' => '0', 
'latitude' => '48.768438',
'longitude' => '11.43136',
'name' => 'Ingolstadt',
'notes' => $notes,
'street' => 'Esplanade 10',
'zipCode' => '85049',
);
$locations[] = array(
'id' => '3', 
'url' => 'http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-eichstaett.shtml', 
'city' => 'Ansbach', 
'closed' => '0', 
'latitude' => '49.306322',
'longitude' => '10.569792',
'name' => 'Ansbach',
'notes' => $notes,
'street' => 'Residenzstr. 8',
'zipCode' => '91522',
);
$locations[] = array(
'id' => '4', 
'url' => 'http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-eichstaett.shtml', 
'city' => 'Erlangen', 
'closed' => '0', 
'latitude' => '49.594773',
'longitude' => '11.009846',
'name' => 'Mensa Langemarckplatz Erlangen',
'notes' => $notes,
'street' => 'Langemarckplatz 4',
'zipCode' => '91054',
);
$locations[] = array(
'id' => '5', 
'url' => 'http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-eichstaett.shtml', 
'city' => 'Erlangen', 
'closed' => '0', 
'latitude' => '49.576995',
'longitude' => '11.029758',
'name' => 'Südmensa Erlangen',
'notes' => $notes,
'street' => 'Erwin-Rommel-Str. 60',
'zipCode' => '91058',
);
$locations[] = array(
'id' => '6', 
'url' => 'http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-eichstaett.shtml', 
'city' => 'Nürnberg', 
'closed' => '0', 
'latitude' => '49.455544',
'longitude' => '11.084003',
'name' => 'Mensa Insel Schütt Nürnberg',
'notes' => $notes,
'street' => 'Andreij-Sacharow-Platz 1',
'zipCode' => '90403',
);
$locations[] = array(
'id' => '7', 
'url' => 'http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-eichstaett.shtml', 
'city' => 'Nürnberg', 
'closed' => '0', 
'latitude' => '49.440562',
'longitude' => '11.112843',
'name' => 'Mensa Regensburger Straße Nürnberg',
'notes' => $notes,
'street' => 'Regensburger Straße 160',
'zipCode' => '90478',
);
$locations[] = array(
'id' => '8', 
'url' => 'http://www.studentenwerk.uni-erlangen.de/verpflegung/de/sp-eichstaett.shtml', 
'city' => 'Nürnberg', 
'closed' => '0', 
'latitude' => '49.454707',
'longitude' => '11.094432',
'name' => 'Mensateria',
'notes' => $notes,
'street' => 'Wollentorstr. 4',
'zipCode' => '90409',
);

if(empty($apiid)){
	$data = array();
	$data['status'] = 200;
	$data['data'] = $locations;
	print json_encode($data);
	return;
}

if($nocache != 0 && file_exists("cache".$_SERVER['PHP_SELF'].$apiid.".html") && time()-filemtime("cache".$_SERVER['PHP_SELF'].$apiid.".html")<24*3600) {
  echo file_get_contents("cache".$_SERVER['PHP_SELF'].$apiid.".html");
  exit();
}

$html = file_get_contents($locations[$apiid-1]['url']);

function getTextBetweenTags($tag, $html, $strict=0)
{
    $dom = new domDocument;
   
   
    $dom->loadHTML($html);
   	$dom->preserveWhiteSpace = false;
    $content = $dom->getElementsByTagname($tag);
        $out = array();
    foreach ($content as $item)
    {
        $out[] = $item->nodeValue;
    }
    return $out;
}

$content = getTextBetweenTags('tr', $html);
$result = array();

foreach( $content as $item ){
    $result[] =  $item;
}

foreach($result as $id => $resultItem){
	if(strpos($resultItem,"Essen 1") == false && strpos($resultItem,"Essen 2") == false && strpos($resultItem,"Essen 3") == false  ){
	 unset($result[$id]);
	} 
}

foreach($result as $id => $resultItem){
	$result[$id] = explode("\n", $resultItem);
}


$result = array_values($result);

/* Leerzeichen entfernen */

for ($i = 0; $i < sizeof($result); $i++) {
	for ($ii = 0; $ii < sizeof($result[$i]); $ii++) {
		$result[$i][$ii] = trim($result[$i][$ii]);
	}
}

/* Newline-Bugfix */

for ($i = 0; $i < sizeof($result); $i++) {	
	if (sizeof($result[$i]) > 6) {	
		// Preise herausfiltern			
		$pattern = '#(?:[1-9])?[0-9],[0-9]{2} .*#';				
		if(preg_match_all($pattern,$result[$i][3]) > 0){
			print 'Preis! <br>';
			// WEITERE ÜBERPRÜFUNG
		}
		else {
			$result[$i][2] = trim($result[$i][2]).' '.trim($result[$i][3]);
			unset($result[$i][3]);
			$result[$i] = array_values($result[$i]);
		}		
		//print_r($result[$i]);		
	}	
}

/* Zahlen Zusatz herausfiltern */

for ($i = 0; $i < sizeof($result); $i++) {				
	preg_match_all(
		'#(((?:[0-9])?[0-9](?: *)?)*)$#s',		
	    $result[$i][2],
	    $extraNumberT
	 );	 		
	 $extraNumber[$i] = $extraNumberT[1][0];	    
}

/* extraNumber anpassen, Kommatrennung */

for ($i = 0; $i < count($extraNumber); $i++) {		
	if(strlen($extraNumber[$i])!=false){
		$extraNumber[$i] = str_replace(' ', ', ', $extraNumber[$i]);			
	}	
}

// Zahlen Zusatz entfernen
for ($i = 0; $i < count($result); $i++) {		
	for ($ii = 0; $ii < 10; $ii++) {
		for ($iii = 0; $iii < 10; $iii++) {
			if(substr($result[$i][2], -1, 1) == strval($iii)){
				$result[$i][2] = chop(substr($result[$i][2],0,-1));				
			}		
		}		
	}

}

// X,V,R Zusatz	herausfiltern

for ($i = 0; $i < count($result); $i++) {			
	preg_match_all(
		'#(X(?:..)?|V(?:..)?|R(?:..)?)$#s',	 
	    $result[$i][2],
	    $extraCharT
	);		
	$extraChar[$i] = $extraCharT[1][0];
}

// Char Zusatz (X,V,R) entfernen

for ($i = 0; $i < count($result); $i++) {			
	$result[$i][2] = chop($result[$i][2]);	
	if(substr($result[$i][2], -1, 1) == 'V' || substr($result[$i][2], -1, 1) == 'X' || substr($result[$i][2], -1, 1) == 'R'){
		$result[$i][2] = chop(substr($result[$i][2],0,-1));		
	}		
}

// Array Machine :D

for ($i = 0; $i < count($result); $i++) {
	$result[$i][5] = $extraNumber[$i];
	$result[$i][6] = $extraChar[$i];
}

ob_start();
$data = array();
$studiFutter = array();
$data['status'] = 200;
$y = 0;
for ($i = 1; $i <= count($result); $i=$i+3) {
	$studiFutter[$y]['date'] = substr($result[$i][0], 3);
	/*$studiFutter[substr($result[$i][0], 3)][$result[($i-1)][1]]['title'] = $result[($i-1)][2];
	$studiFutter[substr($result[$i][0], 3)][$result[($i-1)][1]]['price1'] = $result[($i-1)][3];
	$studiFutter[substr($result[$i][0], 3)][$result[($i-1)][1]]['price2'] = $result[($i-1)][4];
	$studiFutter[substr($result[$i][0], 3)][$result[($i-1)][1]]['extraNumber'] = $result[($i-1)][5];
	$studiFutter[substr($result[$i][0], 3)][$result[($i-1)][1]]['extraChar'] = $result[($i-1)][6];
	$studiFutter[substr($result[$i][0], 3)][$result[$i][1]]['title'] = $result[$i][2];
	$studiFutter[substr($result[$i][0], 3)][$result[$i][1]]['price1'] = $result[$i][3];
	$studiFutter[substr($result[$i][0], 3)][$result[$i][1]]['price2'] = $result[$i][4];
	$studiFutter[substr($result[$i][0], 3)][$result[$i][1]]['extraNumber'] = $result[$i][5];
	$studiFutter[substr($result[$i][0], 3)][$result[$i][1]]['extraChar'] = $result[$i][6];
	$studiFutter[substr($result[$i][0], 3)][$result[($i+1)][1]]['title'] = $result[($i+1)][2];
	$studiFutter[substr($result[$i][0], 3)][$result[($i+1)][1]]['price1'] = $result[($i+1)][3];
	$studiFutter[substr($result[$i][0], 3)][$result[($i+1)][1]]['price2'] = $result[($i+1)][4];
	$studiFutter[substr($result[$i][0], 3)][$result[($i+1)][1]]['extraNumber'] = $result[($i+1)][5];
	$studiFutter[substr($result[$i][0], 3)][$result[($i+1)][1]]['extraChar'] = $result[($i+1)][6];
	*/
	
	$studiFutter[$y]['meals'][0]['title'] = $result[($i-1)][2];
	$studiFutter[$y]['meals'][0]['price1'] = $result[($i-1)][3];
	$studiFutter[$y]['meals'][0]['price2'] = $result[($i-1)][4];
	$studiFutter[$y]['meals'][0]['extraNumber'] = $result[($i-1)][5];
	$studiFutter[$y]['meals'][0]['extraChar'] = $result[($i-1)][6];
	
	$studiFutter[$y]['meals'][1]['title'] = $result[($i)][2];
	$studiFutter[$y]['meals'][1]['price1'] = $result[($i)][3];
	$studiFutter[$y]['meals'][1]['price2'] = $result[($i)][4];
	$studiFutter[$y]['meals'][1]['extraNumber'] = $result[($i)][5];
	$studiFutter[$y]['meals'][1]['extraChar'] = $result[($i)][6];
	
	$studiFutter[$y]['meals'][2]['title'] = $result[($i+1)][2];
	$studiFutter[$y]['meals'][2]['price1'] = $result[($i+1)][3];
	$studiFutter[$y]['meals'][2]['price2'] = $result[($i+1)][4];
	$studiFutter[$y]['meals'][2]['extraNumber'] = $result[($i+1)][5];
	$studiFutter[$y]['meals'][2]['extraChar'] = $result[($i+1)][6];
	$y++;
}

$data['data'] = $studiFutter;
print json_encode($data);
//print_r($data);

$content = ob_get_clean();
$fh = fopen("cache".$_SERVER['PHP_SELF'].$apiid.".html","w");
fputs($fh, $content);
fclose($fh);
echo $content;

?>



 

