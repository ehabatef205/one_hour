<?php

$id = $_POST["id"];
$image = $_FILES['image']['name'];

  $imagePath = "uploads/helper/".$image;

  move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);
 
?>