<?php

$id = $_POST["id"];
$image = $_FILES['image']['name'];

  $imagePath = "uploads/needer/".$image;

  move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);
 
?>