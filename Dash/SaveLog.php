<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 24/02/2017
 * Time: 10:33
 */
header("Content-Type: application/json; charset=UTF-8");
require_once ('sendmail.php');

$filename = 'Db/BackupLogs.db';
$db = new PDO('sqlite:'.$filename);
$db->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);

if(!$db){
    echo $db->lastErrorMsg();
} else {
    //echo "Opened database successfully\n";
}

if (isset($_GET["func"])) {
    $param = $_GET["func"];
} else {
    $param = "";
}

$input = file_get_contents('php://input');
$jsondata = json_decode($input,true);



$subject = "CSCXE Backup (".$jsondata['APB'].")";
$message = "Pharmacy :\t\t". $jsondata['APB']. "\n";
$message .= "Greenock Version :\t\t".$jsondata['GO_VERSION']."p".$jsondata['GO_PATCH']."\n \n";
$message .= "CSC Version :\t\t".$jsondata['CSC_VERSION']."\n \n";
$message .= "Start :\t\t".$jsondata['DT_START']." \tStop :\t\t".$jsondata['DT_STOP']."\n\n";
$message .= "Result :\t\t".$jsondata['result']."\n\n Log :\n";


$sql = "insert into Backup_heads (APB, GO_Version, GO_Patch, CSC_Version, DT_Start, DT_Stop, result) VALUES (\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", \"%s\", %d)";
$query = sprintf($sql,$jsondata['apb'],$jsondata['version'],$jsondata['patch'],$jsondata['cscversion'],$jsondata['datestart'],$jsondata['datestop'],$jsondata['result']);

$result = $db->query($query);


if ($result) {
    $lastid = $db->lastInsertId();
    $sql = "insert into Backup_Details (Backup_Id, DT,Type_Ligne, Description) VALUES (%d, \"%s\", \"%s\", \"%s\")";
    $logs[] = $jsondata['entries'];

    $loglength = count($logs[0]);

    for($x = 0; $x < $loglength; $x++) {
        $query = sprintf($sql,$lastid,$logs[0][$x]['tag'],"0",$logs[0][$x]['name']);
        //$message .= $logs[0][$x]['Timestamp']."\t".$logs[0][$x]['Type_Ligne']."  ".$logs[0][$x]['Description']."\n";
        $result = $db->query($query);
    }

    $logs[] = $jsondata['Errors'];
    
        $loglength = count($logs[0]);
    
        for($x = 0; $x < $loglength; $x++) {
            $query = sprintf($sql,$lastid,$logs[0][$x]['tag'],"1",$logs[0][$x]['message']);
            //$message .= $logs[0][$x]['Timestamp']."\t".$logs[0][$x]['Type_Ligne']."  ".$logs[0][$x]['Description']."\n";
            $result = $db->query($query);
        }
}

sendmail($subject,$message);

if ($param == "test") {
    echo "\n";
    //var_dump($jsondata);

    $logs = $jsondata['Log'];
    foreach ($logs as $obj) {

        echo "\n" . $obj['Timestamp']. "  " . $obj['Description'];
    }
    echo "\n";
}

$response = [
    'received' => $jsondata['APB']
];

echo json_encode($response);
?>
