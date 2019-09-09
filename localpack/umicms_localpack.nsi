;Include
!define MUI_ABORTWARNING
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "TextReplace.nsh"

;General
OutFile "umicms_localpack.exe"
InstallDir "C:\UMI.CMS_Localpack"

!define WELCOME_TITLE "��������� UMI.CMS Localhost Pack"
!define PROGRAM_NAME "UMI.CMS Localhost Pack"
!define START_SHORTCUT "��������� UMI.CMS Localpack.lnk"
!define STOP_SHORTCUT "���������� UMI.CMS Localpack.lnk"
!define APACHE_SERVICE "Apache_LocalPack"
!define MYSQL_SERVICE "Mysql_LocalPack"
!define MUI_WELCOMEPAGE_TEXT "��� ������������ ������ ��������� LocalPack. ��� ���������� ������ LocalPack �� ����� ���������� ������ ���� ���������� ���������������� ����� Microsoft Visual C++ 2010. ������ ����������� ����� ������ ����� �������� ������������� �� ���������� ��������� LocalPack. ��� ������������� ������� � �������� LocalPack ��������� �� ����� �� ���� 80 ������ �����������, �������� Skype (��� ������� �������� ������ ������� � <�����������> -> <���������> -> <�������������> -> <����������> � ����� ����� '��� �������������� �������� ���������� ������� ������������ ����� 80 � 443)'"

;Version Information

  VIProductVersion "1.0.0.0"
  VIAddVersionKey  /LANG=1049 "ProductName" "${PROGRAM_NAME}"
  VIAddVersionKey /LANG=1049 "CompanyName" "��� �������"
  VIAddVersionKey /LANG=1049 "LegalCopyright" "Copyright � 2016, �������"
  VIAddVersionKey /LANG=1049 "FileDescription" "${PROGRAM_NAME}"
  VIAddVersionKey /LANG=1049 "FileVersion" "1.0.0.0"
  VIAddVersionKey /LANG=1049 "ProductVersion" "1.0.0.0"
  VIAddVersionKey /LANG=1049 "Language" "Russian"

Caption "${WELCOME_TITLE}"
Name "${PROGRAM_NAME}"
BrandingText "${PROGRAM_NAME}"
SetCompressor /SOLID "lzma"

!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\umi\README(UMI.CMS).txt"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "�������� ���������"
!define MUI_FINISHPAGE_RUN "$INSTDIR\scripts\bat\start.bat"
!define MUI_FINISHPAGE_RUN_TEXT "��������� ${PROGRAM_NAME}"
!define MUI_FINISHPAGE_TEXT "��������� ${PROGRAM_NAME} ���������."
!define MUI_FINISHPAGE_TITLE "��������� ${PROGRAM_NAME} ��������� �������."

!define MUI_ICON "files\umi\icons\umicms.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "files\umi\icons\logo_big.bmp"
!define MUI_WELCOMEPAGE_TITLE '${WELCOME_TITLE}'
;!define MUI_FINISHPAGE_NOAUTOCLOSE

Var SM_DIR ;Start menu folder

;Pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "files\umi\license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU 0 $SM_DIR
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;Languages
!insertmacro MUI_LANGUAGE "Russian"

;Sections
Section "����� �������" general
	SetOutPath '$INSTDIR'
	SectionIn RO
	
	; ${If} ${FileExists} "$INSTDIR"
		; ${If} ${Cmd} 'MessageBox MB_YESNO "���������� $INSTDIR ��� ����������. �� ������������� ������ ����������?" IDNO'
			
		; ${EndIf}
    ; ${EndIf}
	
	File /nonfatal /a /r "files\"
	CopyFiles /SILENT $INSTDIR\components\php\libssh2.dll $WINDIR\System32
	CopyFiles /SILENT $INSTDIR\components\php\libssh2.dll $WINDIR\SysWOW64
	CopyFiles /SILENT $INSTDIR\components\php\libeay32.dll $WINDIR\System32
	CopyFiles /SILENT $INSTDIR\components\php\libeay32.dll $WINDIR\SysWOW64
	CopyFiles /SILENT $INSTDIR\components\php\ssleay32.dll $WINDIR\System32
	CopyFiles /SILENT $INSTDIR\components\php\ssleay32.dll $WINDIR\SysWOW64
	CopyFiles /SILENT $INSTDIR\components\php\ext\php_curl.dll $WINDIR\System32
	CopyFiles /SILENT $INSTDIR\components\php\ext\php_curl.dll $WINDIR\SysWOW64

	writeUninstaller "$INSTDIR\uninstall.exe"

	;�������� ���� �� ���������� ��������� � ������
	${textreplace::ReplaceInFile} "$INSTDIR\components\apache\conf\httpd.conf" "$INSTDIR\components\apache\conf\httpd.conf" "<install_path>" "$INSTDIR" "" $0
	${textreplace::ReplaceInFile} "$INSTDIR\components\php\php.ini" "$INSTDIR\components\php\php.ini" "<install_path>" "$INSTDIR" "" $0
	${textreplace::ReplaceInFile} "$INSTDIR\scripts\php\common.php" "$INSTDIR\scripts\php\common.php" "<install_path>" "$INSTDIR" "" $0
	${textreplace::ReplaceInFile} "$INSTDIR\scripts\bat\start.bat" "$INSTDIR\scripts\bat\start.bat" "<install_path>" "$INSTDIR" "" $0
	${textreplace::ReplaceInFile} "$INSTDIR\scripts\bat\stop.bat" "$INSTDIR\scripts\bat\stop.bat" "<install_path>" "$INSTDIR" "" $0

	${textreplace::ReplaceInFile} "$INSTDIR\scripts\php\common.php" "$INSTDIR\scripts\php\common.php" "<apache_service>" "${APACHE_SERVICE}" "" $0
	${textreplace::ReplaceInFile} "$INSTDIR\scripts\php\common.php" "$INSTDIR\scripts\php\common.php" "<mysql_service>" "${MYSQL_SERVICE}" "" $0

	ExecWait '"$INSTDIR\components\apache\bin\httpd.exe" -k install -n "${APACHE_SERVICE}"'
	ExecWait '"$INSTDIR\components\mysql\bin\mysqld.exe" --install "${MYSQL_SERVICE}" --defaults-file="$INSTDIR\components\mysql\my.ini"'

	CreateShortcut "$INSTDIR\scripts\php\php.lnk" "$INSTDIR\components\php\php.exe" "" "" 0
	ExecWait '"$INSTDIR\components\php\php.exe" -f "$INSTDIR\scripts\php\makeLinkAdmin.php"'

	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}" "DisplayName" "${PROGRAM_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}" "DisplayIcon" "$\"$INSTDIR\umi\icons\umicms.ico$\""
	ExecWait '"$INSTDIR\required_apps\vcredist_x86.exe"'
SectionEnd

Section /o "������ �� ������� �����" desktop_shortcuts
	CreateShortcut "$DESKTOP\${START_SHORTCUT}" "$INSTDIR\scripts\bat\start.bat" "" "$INSTDIR\umi\icons\start.ico" 0
	CreateShortcut "$DESKTOP\${STOP_SHORTCUT}" "$INSTDIR\scripts\bat\stop.bat" "" "$INSTDIR\umi\icons\stop.ico" 0
SectionEnd

Section -StartMenu
	;This macro sets $SMDir and skips to MUI_STARTMENU_WRITE_END if the "Don't create shortcuts" checkbox is checked...
	!insertmacro MUI_STARTMENU_WRITE_BEGIN 0
		CreateDirectory "$SMPROGRAMS\$SM_DIR"
		CreateShortcut "$SMPROGRAMS\$SM_DIR\${START_SHORTCUT}" "$INSTDIR\scripts\bat\start.bat" "" "$INSTDIR\umi\icons\start.ico" 0
		CreateShortcut "$SMPROGRAMS\$SM_DIR\${STOP_SHORTCUT}" "$INSTDIR\scripts\bat\stop.bat" "" "$INSTDIR\umi\icons\stop.ico" 0
		CreateShortcut "$SMPROGRAMS\$SM_DIR\��������" "$INSTDIR\license.txt" "" "$INSTDIR\umi\icons\umicms.ico" 0
		CreateShortcut "$SMPROGRAMS\$SM_DIR\�������� UMI.CMS Localpack" "$INSTDIR\uninstall.exe" "" "$INSTDIR\umi\icons\umicms.ico" 0
		WriteINIStr "$SMPROGRAMS\$SM_DIR\���� UMI.CMS.url" "InternetShortcut" "URL" "http://www.umi-cms.ru/"
		WriteINIStr "$SMPROGRAMS\$SM_DIR\������ ������.url" "InternetShortcut" "URL" "http://www.umi-cms.ru/support/"
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "uninstall"
	ExecWait '"$INSTDIR\scripts\bat\stop.bat"'
	ExecWait '"$INSTDIR\components\apache\bin\httpd.exe" -k uninstall -n "${APACHE_SERVICE}"'
	ExecWait '"$INSTDIR\components\mysql\bin\mysqld.exe" --remove "${MYSQL_SERVICE}"'

	# Remove Start Menu launcher
	Delete "$SMPROGRAMS\$SM_DIR\${START_SHORTCUT}"
	Delete "$SMPROGRAMS\$SM_DIR\${STOP_SHORTCUT}"
	Delete "$SMPROGRAMS\$SM_DIR\��������"
	Delete "$SMPROGRAMS\$SM_DIR\�������� UMI.CMS Localpack"
	Delete "$SMPROGRAMS\$SM_DIR\���� UMI.CMS.url"
	Delete "$SMPROGRAMS\$SM_DIR\������ ������.url"
	
	RmDir "$SMPROGRAMS\$SM_DIR"
	
	Delete "$DESKTOP\${START_SHORTCUT}"
	Delete "$DESKTOP\${STOP_SHORTCUT}"
	
	Delete /REBOOTOK "$INSTDIR\license.txt"
	Delete /REBOOTOK "$INSTDIR\README(UMI.CMS).txt"

	RMDir /r /REBOOTOK "$INSTDIR\components"
	RMDir /r /REBOOTOK "$INSTDIR\localhost"
	RMDir /r /REBOOTOK "$INSTDIR\scripts"
	RMDir /r /REBOOTOK "$INSTDIR\umi"
	RMDir /r /REBOOTOK "$INSTDIR\required_apps"

	Delete $INSTDIR\uninstall.exe
	RmDir /REBOOTOK $INSTDIR
	
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}"
SectionEnd


;Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${general} "�������� ����� ������� (web-������, ����������� UMI.CMS � ��.)"
	!insertmacro MUI_DESCRIPTION_TEXT ${desktop_shortcuts} "������ �� ������� �����"
!insertmacro MUI_FUNCTION_DESCRIPTION_END


