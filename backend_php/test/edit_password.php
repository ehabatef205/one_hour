<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$id=$_POST["id"];
$password=$_POST["password"];

$conn->query("UPDATE users SET password='".$password."' WHERE id='".$id."'");

?>