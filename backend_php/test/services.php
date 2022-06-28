<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}


$query = $conn->query("select * from services");
	$result = array();

		while ($rowData1 = $query->fetch_assoc()) {
			$result[] = $rowData1;
		}

	echo json_encode($result);
?>