<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$id=$_POST['id'];


$query = $conn->query("select * from users where id='$id'");
	$result = array();

		while ($rowData1 = $query->fetch_assoc()) {
			$result[] = $rowData1;
		}

	


	echo json_encode($result);
?>