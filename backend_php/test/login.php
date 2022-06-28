<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$email=$_POST['email'];
$password=$_POST['password'];


$query = $conn->query("select * from users where email='$email' And password='$password'");
$count = mysqli_num_rows($query);
if($count == 1){
        $result = array();

    while ($rowData = $query->fetch_assoc()) {
        $result[] = $rowData;
    }

    $query1 = $conn->query("select * from users where email='$email' And password='$password'");
	$result1 = array();

		while ($rowData1 = $query1->fetch_assoc()) {
			$result1[] = $rowData1;
		}

	


	echo json_encode($result1);
}else{
    echo json_encode("There is an error in the login data");
}
?>