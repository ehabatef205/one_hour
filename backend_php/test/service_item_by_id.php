<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$service_item_id=$_POST['service_item_id'];


$query = $conn->query("select * from service_items where service_item_id='$service_item_id'");
	$result = array();

		while ($rowData1 = $query->fetch_assoc()) {
			$result[] = $rowData1;
		}

	


	echo json_encode($result);
?>