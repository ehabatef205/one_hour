<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$user_type=$_POST["user_type"];
$service_id=$_POST["service_id"];


$query = $conn->query("SELECT * FROM users WHERE service_id = '$service_id' AND user_type = '$user_type' AND is_accept = 0");
	$result = array();

		while ($rowData1 = $query->fetch_assoc()) {
			$result[] = $rowData1;
		}

	


	echo json_encode($result);
?>