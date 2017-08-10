<?php
//@ini_set('display_errors', 'on'); 
if ($_POST) {
  $param = $_POST["param"];
} else  {
  die("Page inaccesible");
}
//print($param);
$cmd = "sudo -u root -S /home/mistert/arduino/fp/serial ".$param." 2>&1";
//print $cmd."\n";
exec($cmd, $retArr, $retVal);
print_r($retArr[1]);
?>
