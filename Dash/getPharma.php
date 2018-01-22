<?php
/**
 * Created by PhpStorm.
 * User: yves.godart
 * Date: 06/04/2017
 * Time: 11:14
 */

$pharma = array();

$pharma[] = array('apb'=>'251410','nom'=>'Mont Saint Pont');
$pharma[] = array('apb'=>'274312','nom'=>'De la Cense');
$pharma[] = array('apb'=>'254301','nom'=>'Servais Incourt');
$pharma[] = array('apb'=>'578108','nom'=>'Vantomme');
$pharma[] = array('apb'=>'531905','nom'=>'Saintes');
$pharma[] = array('apb'=>'220503','nom'=>'Danckaers');
$pharma[] = array('apb'=>'442124','nom'=>'Denys');
$pharma[] = array('apb'=>'110310','nom'=>'Schijnpoort');

echo json_encode($pharma);
