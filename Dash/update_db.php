<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 26/02/2017
 * Time: 09:56
 */

//$db = new MyDB();
$filename = 'Db/BackupLogs.db';
$dbUpd = new PDO('sqlite:'.$filename);
$dbUpd->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);

if(!$dbUpd){
    echo $dbUpd->lastErrorMsg();
} else {
    //echo "Opened database successfully\n";
}