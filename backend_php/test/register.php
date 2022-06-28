<?php

// Create connection
$conn = mysqli_connect("localhost", "root", "", "apptest");

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

$first_name=$_POST['first_name'];
$middle_name=$_POST['middle_name'];
$last_name=$_POST['last_name'];
$ssn=$_POST['ssn'];
$phone=$_POST['phone'];
$email=$_POST['email'];
$password=$_POST['password'];
$gender=$_POST['gender'];
$image=$_POST['image'];
$point1=$_POST['point1'];
$user_type=$_POST['user_type'];
$is_accept=$_POST['is_accept'];


$query = $conn->query("select * from users where email='$email' ORDER BY id DESC");
	if(mysqli_num_rows($query) > 0){
        while($ruu=mysqli_fetch_array($query)){	
            echo json_encode("The email used is already registered");
        }
    } else {
        $sql="INSERT INTO users(first_name, middle_name, last_name, ssn, phone, email, password, gender, image, point1, user_type, is_accept)
			VALUES('".$first_name."','".$middle_name."','".$last_name."','".$ssn."','".$phone."','".$email."','".$password."','".$gender."','".$image."','".$point1."','".$user_type."','".$is_accept."')"; 
        $result=mysqli_query($conn, $sql); 

        $query1 = $conn->query("select * from users where email='$email'");
        $result1 = array();
    
            while ($rowData1 = $query1->fetch_assoc()) {
                $result1[] = $rowData1;
            }
    
        
    
    
        echo json_encode($result1);
    }
?>