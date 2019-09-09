<?php

	include_once 'common.php';

	stopService($apacheService);
	stopService($mysqlService);
	unMountDrive($drive);
