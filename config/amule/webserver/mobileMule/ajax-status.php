<?php
	$status = amule_get_stats();
	echo "{";
	foreach ($status as $key => $value) 
	{
		echo '"'.$key.'": "'.$value.'",';
	}
	echo '"forclose": "null"';
	echo "}";
?>