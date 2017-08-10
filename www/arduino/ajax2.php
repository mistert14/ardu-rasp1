<?php
//@ini_set('display_errors', 'on'); 
if ($_POST) {

} 
else  {
  die("Page inaccesible");
}
//print($param);
$cmd = "sudo -u root -S ~/arduino/fp/serial "."T"." 2>&1";
exec($cmd, $retArr1, $retVal);
$cmd = "sudo -u root -S ~/arduino/fp/serial "."H"." 2>&1";
exec($cmd, $retArr2, $retVal);
$cmd = "sudo -u root -S ~/arduino/fp/serial "."\#"." 2>&1";
exec($cmd, $retArr3, $retVal);

$res=array();
$res['temp']=$retArr1[0];
$res['hum']=$retArr2[0];
$res['sol']=$retArr3[0];

die(json_encode($res));

?>
