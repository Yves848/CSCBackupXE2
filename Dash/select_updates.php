<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 26/02/2017
 * Time: 09:58
 */

require_once('backup_db.php');

if (isset($_GET["func"])) {
    $param = $_GET["func"];
} else {
    $param = "";
}

if ($param == "header")
{
    headers($db);
}

if ($param == "detail")
{
    if (isset($_GET["id"])) {
        $id = $_GET["id"];
        detail($db,$id);
    } else {
        $param = "";
    }

}

function headers($db)
{
    $sql = "select * from Sessions";
    $arrayval = array();
    $result = $db->query($sql);


    foreach ($result as $row) {
        $arow = array(
            'id' => $row['id'],
            'apb' => $row['apb'],
            'date' => $row['date'],
            'updversion' => $row['updversion'],
            'cscversion_before' => $row['cscversion_before'],
            'cscversion_after' => $row['cscversion_after'],
            'result' => $row['result']
        );
        array_push($arrayval, $arow);
    }
    echo json_encode($arrayval);
}

function detail($db,$id)
{
    $sql = "select * from logs where session_id=".$id;
    $arrayval = array();
    $result = $db->query($sql);

    foreach ($result as $row) {
        //echo "\n".$row['id'];
        $arow = array(
            'id' => $row['id'],
            'session_id' => $row['session_id'],
            'date' => $row['date'],
            'description' => $row['description']
        );
        array_push($arrayval, $arow);
    }
    echo json_encode($arrayval);
}