<?php

	$rootPath = '<install_path>';
	$apacheService = '<apache_service>';
	$mysqlService = '<mysql_service>';
	$drive = 'U';

	/**
	 * ��������� ������ Windows
	 * @param string $service ��� ������
	 */
	function startService($service) {
		exec("NET START {$service}");
	}

	/**
	 * ������������ ������ Windows
	 * @param string $service ��� ������
	 */
	function stopService($service) {
		exec("NET STOP {$service}");
	}

	/**
	 * ������� ����������� ���� Windows
	 * @param string $driveLetter ����� �����
	 * @param string $path ���� �� �������� ���������� �����
	 */
	function mountDrive($driveLetter, $path) {
		if (!isMounted($driveLetter)) {
			exec("subst {$driveLetter}: {$path}");
		}
	}

	/**
	 * ������� ����������� ���� Windows
	 * @param string $driveLetter ����� �����
	 */
	function unMountDrive($driveLetter) {
		if (isMounted($driveLetter)) {
			exec("subst {$driveLetter}: /D");
		}
	}

	/**
	 * ���������� �� ���������� ����
	 * @param string $driveLetter ����� �����
	 * @return bool
	 */
	function isMounted($driveLetter) {
		exec("IF EXIST {$driveLetter}: ECHO 1", $output);

		$firstString = array_shift($output);
		return $firstString == 1;
	}
