<?php
require '/var/www/helpers/php-prepend.php';
$db_name = ( isset( $argv[1] ) ) ? $argv[1] : false;
echo get_wpdemo_db_name( $db_name );
