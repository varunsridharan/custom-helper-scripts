<?php
require '/var/www/global-files/php-prepend.php';
require 'functions.php';
$db_name = ( isset( $argv[1] ) ) ? $argv[1] : false;
echo name_todb_name( $db_name );