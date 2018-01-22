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
    if (isset($_GET["apb"])) {
        $apb = trim($_GET["apb"]);
        //detail($db,$apb);
    } else {
        $apb = "";
    }
    headers($db,$apb);
}

if ($param == "pharmas")
{

    getpharmas($db);
}

if ($param == "detail")
{
    if (isset($_GET["id"])) {
        $id = $_GET["id"];
        detail($db,$id);
    } else {
        $id = "";
    }

}

function getpharmas($db)
{

    $sqlcount = "select count(*) from Backup_heads where APB=";
    $sqlversion = "select cscversion_after from Sessions where apb=\"%s\" order by id desc limit 1";
    $sql = "select * from Pharma";
    $arrayval = array();
    $result = $db->query($sql);
    foreach ($result as $row) {
       $r = $db->query($sqlcount.$row['apb'])->fetchColumn();
       $query = sprintf($sqlversion,$row['apb']);
       $r2 = $db->query($query)->fetchColumn();
       if ($r2)
       {
           $version = $r2;
       }
       else
       {
           $version = 'none';
       }
        $arow = array(
            'id' => $row['id'],
            'apb' => $row['apb'],
            'nom' => $row['Nom'],
            'count' => $r,
            'version' => $version
        );
        array_push($arrayval, $arow);
    }
    echo json_encode($arrayval);
}

function countbackups($db,$apb)
{
    $sql = "select * from Backup_heads";
}

function headers($db,$apb)
{
    if ($apb != "")
    {
        $sql = "select * from Backup_heads where APB=".$apb;
    }
    else
    {
        $sql = "select * from Backup_heads";
    }

    $arrayval = array();
    $result = $db->query($sql);


    foreach ($result as $row) {
        $arow = array(
            'Id' => $row['Id'],
            'APB' => $row['APB'],
            'GO_Version' => $row['GO_Version'],
            'GO_Patch' => $row['GO_Patch'],
            'CSC_Version' => $row['CSC_Version'],
            'DT_Start' => $row['DT_Start'],
            'DT_Stop' => $row['DT_Stop'],
            'result' => $row['result']
        );
        array_push($arrayval, $arow);
    }
    echo json_encode($arrayval);
}

function detail($db,$id)
{
    $sql = "select * from Backup_Details where Backup_Id=".$id;
    $arrayval = array();
    $result = $db->query($sql);

    foreach ($result as $row) {
        //echo "\n".$row['id'];
        $arow = array(
            'Id' => $row['Id'],
            'Backup_Id' => $row['Backup_Id'],
            'DT' => $row['DT'],
            'Type_Ligne' => $row['Type_Ligne'],
            'Description' => $row['Description']
        );
        array_push($arrayval, $arow);
    }
    echo json_encode($arrayval);
}