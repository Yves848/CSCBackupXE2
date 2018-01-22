<?php

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

function prettyPrint( $json )
{
    $result = '';
    $level = 0;
    $in_quotes = false;
    $in_escape = false;
    $ends_line_level = NULL;
    $json_length = strlen( $json );

    for( $i = 0; $i < $json_length; $i++ ) {
        $char = $json[$i];
        $new_line_level = NULL;
        $post = "";
        if( $ends_line_level !== NULL ) {
            $new_line_level = $ends_line_level;
            $ends_line_level = NULL;
        }
        if ( $in_escape ) {
            $in_escape = false;
        } else if( $char === '"' ) {
            $in_quotes = !$in_quotes;
        } else if( ! $in_quotes ) {
            switch( $char ) {
                case '}': case ']':
                    $level--;
                    $ends_line_level = NULL;
                    $new_line_level = $level;
                    break;

                case '{': case '[':
                    $level++;
                case ',':
                    $ends_line_level = $level;
                    break;

                case ':':
                    $post = " ";
                    break;

                case " ": case "\t": case "\n": case "\r":
                    $char = "";
                    $ends_line_level = $new_line_level;
                    $new_line_level = NULL;
                    break;
            }
        } else if ( $char === '\\' ) {
            $in_escape = true;
        }
        if( $new_line_level !== NULL ) {
            $result .= "\n".str_repeat( "\t", $new_line_level );
        }
        $result .= $char.$post;
    }

    return $result;
}

$answer = array();

$input = file_get_contents('php://input');

$jsondata = json_decode($input,true);
//var_dump($jsondata);

//$result = $jsondata['result'];
$sql = "select id from Pharma where apb = \"%s\"";
$query = sprintf($sql,$jsondata['apb']);
$result = $db->query($query);
$rows = $result->fetchAll();
if (count($rows) == 0)
{
    $sql = "insert into Pharma (apb,Nom) VALUES (\"%s\",\"%s\")";
    $query = sprintf($sql,$jsondata['apb'],$jsondata['pharma']);
    $result = $db->query($query);
}

//$sql = "select id from Pharma where apb = \"%s\"";
//$query = sprintf($sql,$jsondata['apb']);
//$result = $db->query($query);
//$rows = $result->fetchAll();

//echo $rows[0]['id']."\n";

//$sql = "insert into Backup_Logs (Pharma_Id,Log) VALUES (%d,'%s')";
//$query = sprintf($sql,$rows[0]['id'],$input);
//echo $query."\n";
//$result = $db->query($query);

$sql = "insert into Backup_heads (APB, GO_Version, GO_Patch, CSC_Version, DT_Start, DT_Stop, result) VALUES (\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", \"%s\", %d)";
$query = sprintf($sql,$jsondata['apb'],$jsondata['version'],$jsondata['patch'],$jsondata['cscversion'],$jsondata['datestart'],$jsondata['datestop'],$jsondata['result']);
$result = $db->query($query);
//echo "result : ".$result."\n";

if ($result) {
    $lastid = $db->lastInsertId();
    $sql = "insert into Backup_Details (Backup_Id, DT,Type_Ligne, Description) VALUES (%d, \"%s\", \"%s\", \"%s\")";
    $logs[] = $jsondata['entries'];

    $loglength = count($logs[0]);

    for($x = 0; $x < $loglength; $x++) {
        $query = sprintf($sql,$lastid,$logs[0][$x]['tag'],"0",$logs[0][$x]['name']);
        //echo $query."\n";
        $result = $db->query($query);
        //echo "result : ".$result."\n";
    }

    $errors[] = $jsondata['Errors'];
    
    $loglength = count($errors[0]);

    for($x = 0; $x < $loglength; $x++) {
        $query = sprintf($sql,$lastid,$errors[0][$x]['tag'],"1",$errors[0][$x]['message']." => ".$errors[0][$x]['file']);
        //echo $query."\n";
        $result = $db->query($query);
        //echo "result : ".$result."\n";
    }
}

$subject = "Backup Result (".$jsondata['apb'].") ".$jsondata['pharma'];
$message = "";
$errors = "Errors :\n";
$entries = "Entries :\n";

$nEntries = count($jsondata['entries']);

for($i=0; $i<$nEntries; $i++)
{
    $entries .= $jsondata['entries'][$i]['tag'] ."\t";
    $entries .= $jsondata['entries'][$i]['name'];
}

$nErrors = count($jsondata['Errors']);
for($i=0; $i<$nErrors; $i++)
{
    $errors .= $jsondata['Errors'][$i]['tag'] ."\t";
    $errors .= $jsondata['Errors'][$i]['file'] . "\t"; 
    $errors .= $jsondata['Errors'][$i]['message']; 
}

$nrules = count($jsondata['rules']);
for($i = 0; $i<$nrules; $i++)
{
    $corps = $message;
    $corps .= prettyPrint($input);
    sendmail2($jsondata['rules'][$i]['to'],$subject,$corps);
}

$answer["result"] = "ok";
$answer["apb"] = $jsondata['apb'];
echo json_encode($answer);
