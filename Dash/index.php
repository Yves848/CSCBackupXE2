<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 24/02/2017
 * Time: 10:33
 */
header("Content-Type: application/json; charset=UTF-8");

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

$db = new MyDB();
if(!$db){
    echo $db->lastErrorMsg();
} else {
    echo "Opened database successfully\n";
}
?>
