<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 03/03/2017
 * Time: 15:28
 */

require_once ('backup_db.php');
//$db = new PDO('sqlite:Db.UpdLogs.db');

$sql = "select * from logs";

if (isset($_GET["id"])) {
    $session_id = $_GET["id"];
    $sql .= " where session_id = ".$session_id;
} else {
    $session_id = "";
}


$arrayval = array();
$result = $db->query($sql);

foreach ($result as $row)
{
    //echo "\n".$row['id'];
    $arow = array(
        'id'=> $row['id'],
        'session_id'=> $row['session_id'],
        'date'=>  $row['date'],
        'description' =>  $row['description']
    );
    array_push($arrayval,$arow);
}
//var_dump($arrayval);
echo json_encode($arrayval);