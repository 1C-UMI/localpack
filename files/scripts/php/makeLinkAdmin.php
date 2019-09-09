<?php

	include_once 'common.php';

	$linkPath = "$rootPath\\scripts\\php\\php.lnk";
	$linkContent = file_get_contents($linkPath);
	$linkContentAdmin = substr_replace($linkContent, chr(0x22), 21, 1);
	file_put_contents($linkPath, $linkContentAdmin);
