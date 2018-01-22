<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 26/02/2017
 * Time: 09:56
 */

/*
class MyDB extends SQLite3
{
    function __construct()
    {
        $this->open('Db/UpgLogs.db');
    }

    function __destruct()
    {
        // TODO: Implement __destruct() method.
        $this->close();
    }
}
*/

//$db = new MyDB();
$filename = 'Db/UpgLogs.db';
$db = new PDO('sqlite:'.$filename);
$db->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);

if(!$db){
    echo $db->lastErrorMsg();
} else {
    //echo "Opened database successfully\n";
}