<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$needer_id=$_POST['needer_id'];
$helper_id=$_POST['helper_id'];
$service_id=$_POST['service_id'];
$service_item_id=$_POST['service_item_id'];
$city_id=$_POST['city_id'];

$sql="INSERT INTO history(needer_id, helper_id, service_id, service_item_id, city_id)
	VALUES('".$needer_id."','".$helper_id."','".$service_id."','".$service_item_id."','".$city_id."')"; 

$result=mysqli_query($conn, $sql); 

$conn->query("UPDATE users SET is_accept=0, id_helper=NULL, service_id=NULL, service_item_id=NULL, city_id=NULL, comment=NULL, address=NULL WHERE id='".$needer_id."'");
    
        echo json_encode("Done");

?>