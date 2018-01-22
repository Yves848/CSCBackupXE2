<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 26/02/2017
 * Time: 09:56
 */


//$db = new MyDB();
$filename = 'Db/BackupLogs.db';
$db = new PDO('sqlite:'.$filename);
$db->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);

if(!$db){
    echo $db->lastErrorMsg();
} else {
    //echo "Opened database successfully\n";
}