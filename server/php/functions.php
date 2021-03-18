<?php

/**
 * Fixes Key.
 *
 * @param $key
 *
 * @return string|string[]|null
 */
function sanitize_key( $key ) {
	return preg_replace( '/[^a-z0-9_\-]/', '', strtolower( $key ) );
}

/**
 * Converts Normal Name To Database Name.
 *
 * @param $name
 *
 * @return string
 */
function name_todb_name( $name ) {
	return 'wpdemos_' . str_replace( '-', '_', sanitize_key( str_replace( '.sva.one', '', $name ) ) );
}



