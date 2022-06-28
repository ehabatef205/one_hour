<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$user_type=$_POST["user_type"];
$city_id=$_POST["city_id"];
$service_id=$_POST["service_id"];
$service_item_id=$_POST["service_item_id"];


$query = $conn->query("SELECT * FROM users WHERE city_id='$city_id' AND service_id = '$service_id' AND service_item_id = '$service_item_id' AND user_type = '$user_type' AND is_accept = 0");
	$result = array();

		while ($rowData1 = $query->fetch_assoc()) {
			$result[] = $rowData1;
		}

	


	echo json_encode($result);
?>