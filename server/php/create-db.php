<?php
require '/var/www/global-files/php-prepend.php';
require 'functions.php';

$db_name = ( isset( $argv[1] ) ) ? $argv[1] : false;


if ( empty( $db_name ) ) {
	die( 'Invalid Database Name' );
}
$db_name = name_todb_name( $db_name );

// Create connection
$conn = new mysqli( REMOTE_DB_HOST, REMOTE_DB_USER, REMOTE_DB_PASS );

// Check connection
if ( $conn->connect_error ) {
	die( 'Connection failed: ' . $conn->connect_error );
}

// Create database
$sql = 'CREATE DATABASE ' . $db_name;

if ( $conn->query( $sql ) === true ) {
	echo 'Database created successfully = ' . $db_name;
	echo ' ';
} else {
	echo 'Error creating database: ' . $conn->error;
	echo ' ';
}

$conn->close();
