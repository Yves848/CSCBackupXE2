<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 26/02/2017
 * Time: 09:58
 */

require_once ('backup_db.php');

$sql = "select * from Sessions";
$arrayval = array();
$result = $db->query($sql);

//while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
foreach ($result as $row)
{
    //echo "\n".$row['id'];
    $arow = array(
      'id'=> $row['id'],
      'date'=>  $row['date'],
      'apb' =>  $row['apb'],
      'updversion' =>  $row['updversion'],
      'cscversion_before' =>  $row['cscversion_before'],
      'cscversion_after' =>  $row['cscversion_after'],
      'result' =>  $row['result']
    );
    array_push($arrayval,$arow);
}
//var_dump($arrayval);
echo json_encode($arrayval);