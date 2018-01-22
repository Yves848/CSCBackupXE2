<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 18/05/2017
 * Time: 13:56
 */

function sendmail($subject, $message)
{
    $headers = 'From: CSCBackupXE@corilus.be' . "\n";
    $headers .= 'Reply-To: yves.godart@corilus.be' . "\n";
    $headers .= 'Content-Type: text/plain; charset="iso-8859-1"' . "\n";
    $headers .= 'Content-Transfer-Encoding: 8bit';
    mail('yves.godart@corilus.be', $subject,
        $message, $headers);

}

function sendmail2($to,$subject, $message)
{
    $headers = 'From: CSCBackupXE@corilus.be' . "\n";
    $headers .= 'Reply-To: yves.godart@corilus.be' . "\n";
    $headers .= 'Content-Type: text/plain; charset="iso-8859-1"' . "\n";
    $headers .= 'Content-Transfer-Encoding: 8bit';
    mail($to, $subject,
        $message, $headers);

}
?>
