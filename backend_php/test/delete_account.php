<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$id=$_POST["id"];
$image=$_POST["image"];

unlink("thumbs/$image");
unlink("uploads/helper/$image");



$conn->query("DELETE FROM users WHERE id='".$id."'");

?>