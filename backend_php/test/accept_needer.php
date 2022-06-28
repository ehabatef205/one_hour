<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$id=$_POST["id"];
$is_accept=$_POST["is_accept"];
$id_helper=$_POST["id_helper"];

$conn->query("UPDATE users SET is_accept='".$is_accept."', id_helper='".$id_helper."' WHERE id='".$id."'");

?>