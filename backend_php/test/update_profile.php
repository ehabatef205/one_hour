<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$id=$_POST["id"];
$first_name=$_POST["first_name"];
$middle_name=$_POST["middle_name"];
$last_name=$_POST["last_name"];
$phone=$_POST["phone"];
$gender=$_POST["gender"];
$image=$_POST["image"];

$conn->query("UPDATE users SET first_name='".$first_name."', middle_name='".$middle_name."', last_name='".$last_name."',
phone='".$phone."', gender='".$gender."', image='".$image."' WHERE id='".$id."'");

?>