<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$id=$_POST["id"];
$is_accept=$_POST["is_accept"];

$conn->query("UPDATE users SET is_accept=0, id_helper=NULL WHERE id='".$id."'");

?>