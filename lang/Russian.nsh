!insertmacro MUI_LANGUAGE "Russian" ; 3: Change this to !insertmacro MUI_LANGUAGE "YourLanguage"

; 4: Replace ${LANG_ENGLISH} with ${LANG_YOUR_LANGUAGE} in this file


; 5: Convert English strings below to your language
; Interface
LangString welcomeTitle ${LANG_RUSSIAN} "Установка ${PRODUCT_NAME} ${PRODUCT_VERSION}"
LangString welcomeText ${LANG_RUSSIAN} "Этот мастер установит ${PRODUCT_NAME} ${PRODUCT_VERSION}.$\r$\n$\r$\nКликните Установить для начала установки."

LangString finishTitle ${LANG_RUSSIAN} "Установка завершена!"
LangString rebootQuestion ${LANG_RUSSIAN} "Вы хотите перезагрузить ПК и запустить ${PRODUCT_NAME} ${PRODUCT_VERSION}?"
LangString rebootNow ${LANG_RUSSIAN} "Перезагрузить сейчас"
LangString rebootLater ${LANG_RUSSIAN} "Перезагрузить позже"

; Messages
LangString un_confirm ${LANG_RUSSIAN} "Вы уверены, что хотите полностью удалить $(^Name) и все его компоненты?"
LangString un_success ${LANG_RUSSIAN} "$(^Name) был успешно удалён с вашего компьютера."

LangString un_delSaveFile ${LANG_RUSSIAN} "Вы хотите удалить сейв-файл?"
LangString un_deleteGrub ${LANG_RUSSIAN} "Вы хотите удалить GRUB? Если его использует другой Линукс, нажмите нет. В противном случае нажмите да. (Если сомневаетесь, нажмите ДА)"

; Errors
LangString unknownWinVer ${LANG_RUSSIAN} "Неизвестная версия Windows. Пожалуйста сообщите об этом на форум."
LangString notCompatibleWinVer ${LANG_RUSSIAN} "Ваша версия Windows не совместима с этой программой."
LangString mustBeAdmin ${LANG_RUSSIAN} "Вы должны быть администратором, чтобы использовать эту программу."

LangString errorFileNotFound_1 ${LANG_RUSSIAN} "Ошибка:" ; part 1
LangString errorFileNotFound_2 ${LANG_RUSSIAN} "не найден." ; part 2

LangString aborting ${LANG_RUSSIAN} "Установка сейчас будет остановлена."

LangString cantFindMenuLst ${LANG_RUSSIAN} "GRUB установлен на вашем компьютере, но установщик не может найти menu.lst. Пожалуйста вставьте следующее в этот файл:"

LangString errorWriteRegistry ${LANG_RUSSIAN} "Ошибка: Не удалось произвести запись в реестр."

LangString un_errorNoBootId ${LANG_RUSSIAN} "Ошибка: Не удалось найти BootID в реестре."

; Readme File
LangString readme_ln_1 ${LANG_RUSSIAN} "Для запуска Puppy Linux просто перезагрузитесь. При загрузке вы сможете выбрать Windows или Puppy Linux.$\r$\n"
LangString readme_ln_2 ${LANG_RUSSIAN} "Нажмите стрелку вниз, затем enter чтобы выбрать Puppy Linux.$\r$\n"
LangString readme_ln_3 ${LANG_RUSSIAN} "$\r$\n"
LangString readme_ln_4 ${LANG_RUSSIAN} "Чтобы удалить Puppy Linux, Просто выберите Пуск > Все программы > ${PRODUCT_NAME} ${PRODUCT_VERSION} > Uninstall.$\r$\n"
