<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$id=$_POST["id"];

$conn->query("UPDATE users SET service_id=NULL, service_item_id=NULL, city_id =NULL, address=NULL, comment=NULL, is_accept=NULL, id_helper=NULL WHERE id='".$id."'");

?>