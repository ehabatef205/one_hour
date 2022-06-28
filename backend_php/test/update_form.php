<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$id=$_POST["id"];
$service_id=$_POST["service_id"];
$service_item_id=$_POST["service_item_id"];
$city_id=$_POST["city_id"];
$address=$_POST["address"];
$comment=$_POST["comment"];

$conn->query("UPDATE users SET service_id='".$service_id."', service_item_id='".$service_item_id."', city_id ='".$city_id ."', address='".$address."', comment='".$comment."' WHERE id='".$id."'");

?>