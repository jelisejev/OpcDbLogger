<?php

require_once(__DIR__.'/lib/PlcMessage.php');
require_once(__DIR__.'/_common.php');

// read the message
//$msg = new PlcMessage('stationNorth,12-3,speed,3km,weight,2pd');
$msg = new PlcMessage($_REQUEST['data']);

// prepare the SQL statement
$stmt = $con->prepare(
   'INSERT INTO PlcLog
      (station, item, value, timestamp)
   VALUES 
      (:station, :item, :value, :timestamp)'
);

// save the data
foreach($msg->getItems() as $item => $value)
{
   $stmt->bindParam(':station', $msg->getStation());
   $stmt->bindParam(':item', $item);
   $stmt->bindParam(':value', $value);
   $stmt->bindParam(':timestamp', $msg->getTimestamp());
   $stmt->execute();

   // if the counter exceeds the limit, send a stop message
   if($value > 3)
   {
      $url = 'http://localhost:9333/ozeki?'.http_build_query(array(
         'login' => 'admin',
         'password' => 'abc123',
         'action' => 'sendMessage',
         'messageType' => 'SMS:TEXT',
         'recepient' => urlencode('+37128374253'),
         'messageData' => 'Stop'
      ));
      $ch = curl_init($url);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
//      curl_exec($ch);
   }
}

echo 'done';