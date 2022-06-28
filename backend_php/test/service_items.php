<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$service_id=$_POST['service_id'];


$query = $conn->query("select * from service_items where service_id='$service_id'");
	$result = array();

		while ($rowData1 = $query->fetch_assoc()) {
			$result[] = $rowData1;
		}

	


	echo json_encode($result);
?>