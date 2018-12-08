<?php
// Authors     : Luis Fernando
//               Kevin Legarreta
//               David J. Ortiz Rivera
//               Bryan Pesquera
//               Enrique Rodriguez
//
//  File: fUploadAPI.php
//  Description: File responsible for uploading the files with a given file to a given 
//     		     path.
//
//  Created by Los Duendes Malvados.
//  Copyright © 2018 Los Duendes Malvados. All rights reserved.

include_once "config.php";
// For debugging purposes
// error_reporting(E_ALL);
// ini_set('display_errors', TRUE);
// ini_set('display_startup_errors', TRUE);
define("TEXT_FILE",      0);
define("OTHER_FILE",     1);
// Exit if no request variables were passed when called.
if(!isset($_REQUEST['fileType'])) exit();
// Extract file type from URL parameter.
$fileType = $_REQUEST["fileType"];
// Depending on what type of file it is, perform the corresponding code.
// $return = array();

switch($fileType){
	   case TEXT_FILE:
	   		if(!isset($_REQUEST['path'])) exit();
			if(!isset($_REQUEST['text'])) exit();
			if(!isset($_REQUEST['uid'])) exit();
			if(!isset($_REQUEST['pid'])) exit();

			// Get the path and the text from the URL.
			$text = $_REQUEST["text"];
			$path = $_REQUEST["path"];

			$pid = $_REQUEST["pid"];
			$uid = $_REQUEST["uid"];
			// Attempt to create a file at the given path.
			try{
				$file = fopen("$path", "w") or die ("Unable to open file!");
				fwrite($file, $text);
				fclose($file);
				$return = array("file_created"=>true);
			}
			catch(Exception $e){
				echo 'Couldn\'t create file: ',  $e->getMessage(), "\n"; 
			    $return = array("file_created"=>false);
			}

			$emails = array();

			$query = "SELECT email FROM users WHERE user_id IN (SELECT user_id FROM user_project WHERE project_id=?) AND user_id<>?";

			// // Prepare the query statement. (for sanitation)
			$statement = $connection->prepare($query);			
			// Bind the parameters with the sql query.
			$statement->bind_param('ii', $pid,$uid);
			// Execute the now sanitized query.	
			$statement->execute();						
			// Asign the fetch value to this new variable.
			$statement->bind_result($email);				

			while($statement->fetch()) {
				$emails[] = $email;

			}

			// if(count($emails) != 0)
				// for each email here
			
			$statement->close();

			break;
	    case OTHER_FILE:
	    	if(!isset($_REQUEST['path'])) exit();
	    	if(!isset($_REQUEST['uid'])) exit();
			if(!isset($_REQUEST['pid'])) exit();
			
	    	$pid = $_REQUEST["pid"];
			$uid = $_REQUEST["uid"];

			// Create the destination directory for the file from the request
			$target_dir = $_REQUEST['path'] . basename($_FILES["file"]["name"]);
			// Move the file to the destination directory.
			if(move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir)){
				$return = array("file_created"=>true);

				$emails = array();

				$query = "SELECT email FROM users WHERE user_id IN (SELECT user_id FROM user_project WHERE project_id=?) AND user_id<>?";

				// // Prepare the query statement. (for sanitation)
				$statement = $connection->prepare($query);			
				// Bind the parameters with the sql query.
				$statement->bind_param('ii', $pid,$uid);
				// Execute the now sanitized query.	
				$statement->execute();						
				// Asign the fetch value to this new variable.
				$statement->bind_result($email);				

				while($statement->fetch()) {
					$emails[] = $email;
				}
				
				// if(count($emails) != 0)
					// for each email here
				
				$statement->close();

			}
			else{
				$return = array("file_created"=>false);				
			}
			break;
	default:
			echo "Invalid parameter";
}
// Display {"file_created": true} if file created successfully.
echo json_encode($return);
?>