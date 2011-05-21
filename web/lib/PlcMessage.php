<?php

class PlcMessage
{
   protected
      $station,
      $timestamp,
      $items = array();

   
   public function __construct($data)
   {
      $data = $this->parseData($data);

      $this->station = $data['station'];
      $this->timestamp = $data['timestamp'];
      $this->items = $data['items'];
   }


   public function getStation()
   {
      return $this->station;
   }


   public function getTimestamp()
   {
      return $this->timestamp;
   }


   public function getItems()
   {
      return $this->items;
   }


   public function getItem($key)
   {
      return (isset($this->items[$key])) ? $this->items[$key] : null;
   }


   protected function parseData($data)
   {
      $tokens = explode(',', $data);

      // station and timestamp
      $station = $tokens[0];
      $timestamp = $tokens[1];

      // fetch items
      $tokens = array_slice($tokens, 2);
      $total = count($tokens);
      $items = array();
      for($i = 0; $i < $total; $i = $i + 2)
      {
         $items[$tokens[$i]] = trim($tokens[$i + 1]);
      }

      return array(
         'station' => $station,
         'timestamp' => $timestamp,
         'items' => $items
      );
   }
}