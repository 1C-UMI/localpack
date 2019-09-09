Здесь находится локальная версия UMI.CMS для ознакомления (под Windows), или **LocalPack**. Для того, чтобы обновить локальную версию UMI.CMS, нужно:

* Установить программу [nsis](http://nsis.sourceforge.net/Main_Page). Официально поддерживается только версия под Windows, но для линукса тоже есть сборки. Например, на Ubuntu 16.04 программа устанавливается так: `sudo apt-get install nsis`. Путь установки: `/usr/share/nsis`.
* [Установить](http://nsis.sourceforge.net/How_can_I_install_a_plugin) плагин TextReplace (файл `Textreplace.zip`). Для установки нужно распаковать архив и скопировать файлы:  `Include/TextReplace.nsh` в `<путь до nsis>/Include` и `Plugins/textreplace.dll` в `<путь до nsis>/Plugins`.
* Выполнить команду `makensis umicms_localpack.nsi`. Результат работы: установочный файл `umicms_localpack.exe`.
* Положить файл в zip-архив и залить его на [страницу для скачивания](https://www.umi-cms.ru/downloads/local/).
