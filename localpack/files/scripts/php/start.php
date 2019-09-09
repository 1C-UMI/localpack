<?php

	include_once 'common.php';

	startService($apacheService);
	startService($mysqlService);
	mountDrive($drive, $rootPath);
