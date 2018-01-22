<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 24/02/2017
 * Time: 10:33
 */
header("Content-Type: application/json; charset=UTF-8");


require_once ('backup_db.php');
require_once ('sendmail.php');

if (isset($_GET["func"])) {
    $param = $_GET["func"];
} else {
    $param = "";
}

$input = file_get_contents('php://input');
$jsondata = json_decode($input,true);

//var_dump($jsondata);

$sqlPharma = "select id,apb,Nom from Pharma where apb=".$jsondata['apb'];
$r = $db->query($sqlPharma)->fetchAll();
if ($r) {
   $pharmaname = $r[0]['Nom'];
   //echo "\n".$pharmaname."\n";
}
else
{
    // La pharma n'existe pas dans la DB .....
    // La créer
    //$subject = "CSCXE First Install";
    //$sqlPharma = "insert into Pharma (apb) VALUES  (\"%s\")";
    //$query = sprintf($sqlPharma,$jsondata['apb']);
    //$result = $db->query($query);
    //$pharmaname ="";
}


$subject = "CSCXE Update";

$message = "Pharmacy : ". $jsondata['apb']." ".$pharmaname. "\n";
$message .= "UpdateVersion : ". $jsondata['updbackup']. "\n";
$message .= "CSC Version Before : ". $jsondata['cscversionbefore']. "\n";
$message .= "CSC Version After : ". $jsondata['cscversionafter']. "\n";
$message .= "Date Update : ". $jsondata['dateupdate']. "\n";

$sql = "insert into Sessions (date, apb, updversion, cscversion_before, cscversion_after, result) VALUES (\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", %d)";
$query = sprintf($sql,$jsondata['dateupdate'],$jsondata['apb'],$jsondata['updbackup'],$jsondata['cscversionbefore'],$jsondata['cscversionafter'],$jsondata['result']);

$result = $db->query($query);

$message .= "\n \n LOG : \n \n";
if ($result) {
    $lastid = $db->lastInsertId();
    $sql = "insert into logs (session_id, date, description) VALUES (%d, '%s', '%s')";
    $logs[] = $jsondata['entries'];
    
    //echo "\n";
    //var_dump($logs);
    //echo "\n";
    
    $loglength = count($logs[0]);

    for($x = 0; $x < $loglength; $x++) {
        $query = sprintf($sql,$lastid,$logs[0][$x]['tag'],$logs[0][$x]['line']);
        //echo "\n".$query."\n";
        $message .= $logs[0][$x]['tag']."\t".$logs[0][$x]['line']."\n";
        $result = $db->query($query);
    }
}

if ($param == "test") {
    echo "\n";
    var_dump($jsondata);

    $logs = $jsondata->log;
    foreach ($logs as $obj) {
        echo "\n" . $obj->time_stamp . "  " . $obj->description;
    }
    echo "\n";
}


sendmail($subject,$message);

$response = [
    'received' => $jsondata['apb']
];

echo json_encode($response);
?>
