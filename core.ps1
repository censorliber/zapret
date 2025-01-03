# Устанавливаем кодовую страницу UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Устанавливаем синий цвет фона (не работает в PowerShell 7+)
if ($PSVersionTable.PSVersion.Major -lt 6) {
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    Clear-Host
}


<#
### 1.3. Настройки файла hosts
В файл `C:\Windows\System32\drivers\etc\hosts` пропишите следующее содержание (_рекомендуется использовать [`Notepad++`](https://github.com/notepad-plus-plus/notepad-plus-plus/releases), ссылка на оф. сайт была заблокирована_):

```
31.13.72.36 facebook.com
31.13.72.36 www.facebook.com
31.13.72.12 static.xx.fbcdn.net
31.13.72.18 fburl.com
157.240.227.174 www.instagram.com
157.240.227.174 instagram.com
31.13.72.53 static.cdninstagram.com
31.13.72.53 edge-chat.instagram.com
157.240.254.63 scontent.cdninstagram.com
157.240.205.63 scontent-hel3-1.cdninstagram.com
104.21.32.39 rutracker.org
172.67.182.196 rutracker.org
116.202.120.184 torproject.org
116.202.120.184 bridges.torproject.org
116.202.120.166 community.torproject.org
162.159.152.4 medium.com
172.67.182.196 rutracker.org
188.114.96.1 dept.one
142.250.185.238 youtube.com
142.250.186.110 www.youtube.com
130.255.77.28 ntc.party
```

Либо на какой-то из примеров ниже (_предыдущий вариант удалите_):
```
31.13.72.36 facebook.com
31.13.72.36 www.facebook.com
31.13.72.12 static.xx.fbcdn.net
31.13.72.18 fburl.com
157.240.229.174 www.instagram.com
157.240.229.174 instagram.com
31.13.72.53 static.cdninstagram.com
31.13.72.53 edge-chat.instagram.com
31.13.72.53 scontent-arn2-1.cdninstagram.com
157.240.247.63 scontent.cdninstagram.com
157.240.205.63 scontent-hel3-1.cdninstagram.com
104.21.32.39 rutracker.org
172.67.182.196 rutracker.org
116.202.120.184 torproject.org
116.202.120.184 bridges.torproject.org
116.202.120.166 community.torproject.org
162.159.152.4 medium.com
172.67.182.196 rutracker.org
188.114.96.1 dept.one
142.250.185.238 youtube.com
142.250.186.110 www.youtube.com
130.255.77.28 ntc.party
```

```
31.13.72.36 facebook.com
31.13.72.36 www.facebook.com
31.13.72.12 static.xx.fbcdn.net
31.13.72.18 fburl.com
157.240.225.174 instagram.com
157.240.225.174 www.instagram.com
157.240.225.174 i.instagram.com
31.13.72.53 edge-chat.instagram.com
31.13.72.53 scontent-arn2-1.cdninstagram.com
31.13.72.53 scontent.cdninstagram.com
31.13.72.53 static.cdninstagram.com 
157.240.205.63 scontent-hel3-1.cdninstagram.com
104.21.32.39 rutracker.org
172.67.182.196 rutracker.org
116.202.120.184 torproject.org
116.202.120.184 bridges.torproject.org
116.202.120.166 community.torproject.org
162.159.152.4 medium.com
172.67.182.196 rutracker.org
188.114.96.1 dept.one
142.250.185.238 youtube.com
142.250.186.110 www.youtube.com
130.255.77.28 ntc.party
```
#>

Write-Host "██████████████████████████████████████████████████████████████████"
Write-Host ""
Write-Host "███████      ██████      ██████     ██████       ███████    ███████"
Write-Host "    ███     ██    ██     ██    ██   ██    ██     ██           ███"
Write-Host "   ███      ████████     ██████     ██████       ███████      ███"
Write-Host "  ███       ██    ██     ██         ██   ██      ██           ███"
Write-Host " ██████     ██    ██     ██         ██    ██     ███████      ███"
Write-Host ""
Write-Host "██████████████████████████████████████████████████████████████████"
Write-Host ""

$BIN = "$PSScriptRoot\bin\"
$LISTS = "$PSScriptRoot\lists\"
$localVersion = "6.3.6"

$Host.UI.RawUI.WindowTitle = "Zapret $localVersion | https://t.me/bypassblock"

function Test-Administrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Show-Telegram {
    $regKey = "HKCU:\Software\Zapret"
    $regValue = "TelegramOpened"

    if ((Get-ItemProperty -Path $regKey -Name $regValue -ErrorAction SilentlyContinue).$regValue -eq 1) {
        Write-Host "Присоединяйтесь к нашему каналу Telegram (для обновлений) https://t.me/bypassblock"
    } else {
        Write-Host "Присоединяйтесь к нашему каналу Telegram"
        Start-Process https://t.me/bypassblock
        New-Item -Path $regKey -Force | Out-Null
        New-ItemProperty -Path $regKey -Name $regValue -Value 1 -PropertyType DWORD -Force | Out-Null
    }
}

function Check-AndDownload-WinDivert {
    $WinDivertDll = "WinDivert.dll"
    $WinDivert64Sys = "WinDivert64.sys"
    $exeName = "winws.exe"

    $WinDivertDLLURL = "https://zapret.vercel.app/WinDivert.dll"
    $WinDivert64SysURL = "https://zapret.vercel.app/WinDivert64.sys"
    $exeRawUrl = "https://github.com/bol-van/zapret-win-bundle/raw/refs/heads/master/zapret-winws/winws.exe"

    # Проверяем наличие папки bin
    if (-not (Test-Path -Path $BIN)) {
        Write-Host "Папка bin не найдена. Создаю..."
        New-Item -ItemType Directory -Path $BIN | Out-Null
    }

    $WinDivertDllPATH = Join-Path -Path $BIN -ChildPath $WinDivertDll
    if (-not (Test-Path -Path $WinDivertDllPATH)) {
        Write-Host "Драйвер $WinDivertDll не найден. Скачиваю..."
        try {
            Start-Sleep -Seconds 3
            Invoke-WebRequest -Uri $WinDivertDLLURL -OutFile $WinDivertDllPATH
            Write-Host "Драйвер $WinDivertDll успешно скачан."
        } catch {
            Write-Error "Ошибка при скачивании драйвера: $_"
            return
        }
    } else {
    }

    $WinDivert64SysPATH = Join-Path -Path $BIN -ChildPath $WinDivert64Sys
    if (-not (Test-Path -Path $WinDivert64SysPATH)) {
        Write-Host "Драйвер $WinDivert64Sys не найден. Скачиваю..."
        try {
            Start-Sleep -Seconds 3
            Invoke-WebRequest -Uri $WinDivert64SysURL -OutFile $WinDivert64SysPATH
            Write-Host "Драйвер $WinDivert64Sys успешно скачан."
        } catch {
            Write-Error "Ошибка при скачивании драйвера: $_"
            return
        }
    } else {
    }

    $exePath = Join-Path -Path $BIN -ChildPath $exeName
    if (-not (Test-Path -Path $exePath)) {
        Write-Host "Исполняемый файл $exeName не найден. Скачиваю..."
        try {
            Start-Sleep -Seconds 3
            Invoke-WebRequest -Uri $exeRawUrl -OutFile $exePath
            Write-Host "Исполняемый файл $exeName успешно скачан."
        } catch {
            Write-Error "Ошибка при скачивании исполняемого файла: $_"
            return # Прерываем выполнение функции в случае ошибки
        }
    } else {
    }
}

if (!(Test-Administrator)) {
    Write-Host "Requesting administrator rights..."
    Start-Process powershell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"" -Verb RunAs
    exit
}

Show-Telegram
Check-AndDownload-WinDivert

function Invoke-ZapretStrategy {
    param(
        [string]$StrategyName,
        [string]$Arguments
    )

    Start-Sleep -Seconds 1
    $global:STRATEGY_STARTED = $true

    # Добавление проверки существования файла winws.exe
    if (-Not (Test-Path -Path "$BIN\winws.exe")) {
        Write-Error "Файл winws.exe не найден по пути: $BIN\winws.exe"
        return
    }

    # Попытка запуска процесса
    try {
        $process = Start-Process -FilePath "$BIN\winws.exe" -ArgumentList $Arguments -WindowStyle Minimized -PassThru -WorkingDirectory $PSScriptRoot
        # Проверка успешности запуска
        if ($process -eq $null) {
            Write-Error "Не удалось запустить winws.exe с аргументами: $Arguments"
            return
        }

        # Сохранение PID запущенного процесса
        #$process.Id | Out-File -FilePath "$PSScriptRoot\zapret_pid.txt" -Encoding UTF8
        Write-Host "Стратегия '$StrategyName' успешно загружена! PID: $($process.Id)"
    }
    catch {
        Write-Error "Ошибка при запуске winws.exe: $_"
    }
}

function Stop-Zapret {
    $zapretProcess = Get-Process winws -ErrorAction SilentlyContinue
    if ($zapretProcess) {
        Stop-Process -Force -Name winws
        Stop-Service -Name "Zapret" -Force -ErrorAction SilentlyContinue
        sc.exe delete "Zapret" > $null 2>&1
    } else {
        Write-Host "Попытка запуска стратегии..."
    }

    $goodbyeDpiProcess = Get-Process goodbyedpi -ErrorAction SilentlyContinue
    if ($goodbyeDpiProcess) {
        Write-Host "ГУДБАЙДИПИАЙ НЕ РАБОТАЕТ С ZAPRET!!!"
        Stop-Process -Force -Name winws
        Stop-Service -Name "GoodbyeDPI" -Force -ErrorAction SilentlyContinue
        sc.exe delete "GoodbyeDPI" > $null 2>&1
        Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\GoodbyeDPI" -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Start-Sleep -Seconds 1
    try {
        Stop-Service -Name "WinDivert" -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Служба WinDivert была успешно остановлена."
    }

    try {
        sc.exe delete "WinDivert" > $null 2>&1
    } catch {
        Write-Host "Служба WinDivert была успешно удалена."
    }

    try {
        Stop-Service -Name "WinDivert14" -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Host "Служба WinDivert была успешно остановлена."
    }

    try {
        sc.exe delete "WinDivert14" > $null 2>&1
    } catch {
        Write-Host "Служба WinDivert была успешно удалена."
    }

    Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\WinDivert" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\WinDivert14" -Recurse -Force -ErrorAction SilentlyContinue
}

function Restart-Discord {
    $discordProcesses = Get-Process discord -ErrorAction SilentlyContinue
    if ($discordProcesses) {
        foreach ($process in $discordProcesses) {
            Write-Host "Killing process with PID: $($process.Id)"
            Stop-Process -Force -Id $process.Id
        }
    } else {
        Write-Host "No Discord processes found."
    }

    Write-Host "Starting Discord..."
    Start-Process -FilePath "$env:AppData\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk"
}

function Set-GoogleDNS {
    $PrimaryDNS = "8.8.8.8"
    $SecondaryDNS = "8.8.4.4"

    Write-Host "Изменение DNS для активных интерфейсов..."

    # Получаем список активных сетевых интерфейсов
    try {
        $interfaces = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} -ErrorAction Stop
    } catch {
        Write-Error "Ошибка при получении списка сетевых интерфейсов: $_"
        return
    }

    # Проверяем, найдены ли активные интерфейсы
    if ($interfaces.Count -eq 0) {
        Write-Warning "Не найдено активных сетевых интерфейсов."
        return
    }

    # Устанавливаем DNS-серверы для каждого интерфейса
    foreach ($interface in $interfaces) {
        try {
            Write-Host "Установка DNS для интерфейса $($interface.InterfaceAlias)..."
            Set-DnsClientServerAddress -InterfaceAlias $interface.InterfaceAlias -ServerAddresses ($primaryDNS, $secondaryDNS) -ErrorAction Stop
            Write-Host "DNS для интерфейса $($interface.InterfaceAlias) успешно установлен."
        } catch {
            Write-Error "Ошибка при установке DNS для интерфейса $($interface.InterfaceAlias): $_"
        }
    }

    # Очищаем кэш DNS
    Write-Host "Очистка кэша DNS..."
    ipconfig /flushdns | Out-Null
    Write-Host "Кэш DNS успешно очищен."
}

function Set-ZapretDNS {
    $PrimaryDNS = "185.222.222.222"
    $SecondaryDNS = "45.11.45.11"

    Write-Host "Изменение DNS для активных интерфейсов..."

    # Получаем список активных сетевых интерфейсов
    try {
        $interfaces = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} -ErrorAction Stop
    } catch {
        Write-Error "Ошибка при получении списка сетевых интерфейсов: $_"
        return
    }

    # Проверяем, найдены ли активные интерфейсы
    if ($interfaces.Count -eq 0) {
        Write-Warning "Не найдено активных сетевых интерфейсов."
        return
    }

    # Устанавливаем DNS-серверы для каждого интерфейса
    foreach ($interface in $interfaces) {
        try {
            Write-Host "Установка DNS для интерфейса $($interface.InterfaceAlias)..."
            Set-DnsClientServerAddress -InterfaceAlias $interface.InterfaceAlias -ServerAddresses ($primaryDNS, $secondaryDNS) -ErrorAction Stop
            Write-Host "DNS для интерфейса $($interface.InterfaceAlias) успешно установлен."
        } catch {
            Write-Error "Ошибка при установке DNS для интерфейса $($interface.InterfaceAlias): $_"
        }
    }

    # Очищаем кэш DNS
    Write-Host "Очистка кэша DNS..."
    ipconfig /flushdns | Out-Null
    Write-Host "Кэш DNS успешно очищен."
}

function Reset-DNS {
    Write-Host "Сброс DNS для активных интерфейсов на значения по умолчанию..."

    try {
        $interfaces = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} -ErrorAction Stop
    } catch {
        Write-Error "Ошибка при получении списка сетевых интерфейсов: $_"
        return
    }

    if ($interfaces.Count -eq 0) {
        Write-Warning "Не найдено активных сетевых интерфейсов."
        return
    }

    foreach ($interface in $interfaces) {
        try {
            Write-Host "Сброс DNS для интерфейса $($interface.InterfaceAlias)..."
            Set-DnsClientServerAddress -InterfaceAlias $interface.InterfaceAlias -ResetServerAddresses -ErrorAction Stop
            Write-Host "DNS для интерфейса $($interface.InterfaceAlias) успешно сброшен."
        } catch {
            Write-Error "Ошибка при сбросе DNS для интерфейса $($interface.InterfaceAlias): $_"
        }
    }

    # Очищаем кэш DNS
    Write-Host "Очистка кэша DNS..."
    ipconfig /flushdns | Out-Null
    Write-Host "Кэш DNS успешно очищен."
}

function Edit-Hosts {
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"

    $newHostsContent = @(
        "0.0.0.0 www.aomeitech.com",
        "185.15.211.203 bt.t-ru.org",
        "185.15.211.203 bt2.t-ru.org",
        "185.15.211.203 bt3.t-ru.org",
        "185.15.211.203 bt4.t-ru.org",
        "3.66.189.153 mail.proton.me",
        "3.73.85.131 mail.proton.me",
        "31.13.72.36 facebook.com",
        "31.13.72.36 www.facebook.com",
        "31.13.72.12 static.xx.fbcdn.net",
        "31.13.72.12 external-hel3-1.xx.fbcdn.net",
        "157.240.225.174 www.instagram.com",
        "157.240.225.174 instagram.com",
        "157.240.247.63 scontent.cdninstagram.com",
        "157.240.247.63 scontent-hel3-1.cdninstagram.com"
    )

    $newHostsContent -join "`n" | Set-Content -Path $hostsPath -Encoding UTF8
    Write-Host "Файл hosts успешно обновлён."
}

function Check-YouTube {
    try {
        $response = Invoke-WebRequest -Uri "https://jnn-pa.googleapis.com" -Method GET
        Write-Output "Запрос успешен: $($response.StatusCode)"
    } catch {
        if ($_.Exception.Response.StatusCode -eq 403) {
            Write-Output "Ошибка 403: ВЫ НЕ СМОЖЕТЕ СМОТРЕТЬ ЮТУБ с помощью сайта youtube.com ЧЕРЕЗ ZAPRET! Вам следует запустить Zapret, а после скачать Freetube по ссылке freetubeapp.io и смотреть видео там. Или скачайте для своего браузера скрипт Tampermonkey по ссылке: https://zapret.now.sh/script.user.js"
            $choice = Read-Host "Узнать подробнее? (введите цифру 1 если да / введите цифру 0 если нужно выйти)"
            if ($choice -eq "1") {
                Write-Host "Пройдите по ссылке, выполните установки и перезайдите в Zapret"
                Start-Sleep -Seconds 5
                Start-Process https://github.com/censorliber/youtube_unblock
            } elseif ($choice -eq "0") {
                Write-Host "Вы отменили установку скрипта, YouTube скорее всего не будет разблокирован"
            }
        } else {
            Write-Output $($_.Exception.Message)
            Write-Output "Если Вы видите ошибки 404, то Вы успешно сможете разблокировать YouTube через Zapret! Ничего дополнительно скачивать не требуется."
        }
    }
}

function Check-Update {
    # URL файла с актуальной версией
    $versionUrl = "https://zapret.vercel.app/version.txt"

    try {
        # Загружаем актуальную версию с сервера
        $global:latestVersion = (Invoke-WebRequest -Uri $versionUrl).Content.Trim()

        # Сравниваем версии
        if ([version]$localVersion -lt [version]$latestVersion) {
            $Title2 = "Доступно новое обновление! Текущая версия: $localVersion, Новая версия: $latestVersion"
            $Host.UI.RawUI.WindowTitle = $Title2
            return $true  # Возвращаем $true, если есть обновление
        } else {
            Write-Host "У вас установлена последняя версия ($localVersion)."
            return $false # Возвращаем $false, если обновлений нет
        }
    } catch {
        Write-Host "Ошибка при проверке обновлений: $_"
        return $false # Возвращаем $false, если обновлений нет
    }
}

if (Check-Update) {
    # Предлагаем пользователю скачать обновление
    Write-Host "Доступно новое обновление! Текущая версия: $localVersion, Новая версия: $latestVersion"
    $choice = Read-Host "Вы можете скачать его прямо сейчас (введите цифру 1 если Вы согласны обновить программу / введите цифру 0 если против)"
    if ($choice -eq "1") {
        # Здесь код для скачивания и установки обновления
        Start-Process -FilePath "powershell.exe" -ArgumentList "-File `"$BIN\check_update.ps1`""
        Exit 0
    } elseif ($choice -eq "0") {
        Write-Host "ОБНОВЛЕНИЕ ОТМЕНЕНО! В БУДУЩЕМ ВЫ ДОЛЖНЫ СКАЧАТЬ НОВУЮ ВЕРСИЮ"
    } else {
        Exit 0
    }
}

Write-Host "-----------------------"
Write-Host "ВЫБЕРИТЕ СТРАТЕГИЮ:"
Write-Host "0. Остановить Zapret"
Write-Host ""
Write-Host "1. Запустить стратегию Discord TCP 80 (предпочтительно Ростелеком)"
Write-Host "2. Запустить стратегию Discord fake (предпочтительно Ростелеком)"
Write-Host "3. Запустить стратегию Discord fake и split (предпочтительно Уфанет)"
Write-Host "4. Запустить стратегию Discord fake и split2 (УльтиМейт фикс, предпочтительно Билайн и Ростелеком)"
Write-Host ""
Write-Host "5. Запустить стратегию split с sniext (предпочтительно ДомРу)"
Write-Host "6. Запустить стратегию split с badseq (предпочтительно ДомРу)"
Write-Host ""
Write-Host "7. Запустить стратегию split с badseq (предпочтительно Ростелеком и Мегафон)"
Write-Host "8. Запустить стратегию fake и split2, второй bin файл (предпочтительно Ростелеком)"
Write-Host ""
Write-Host "9. Запустить стратегию YouTube fake QUIC, bin файл google, больше размер пакетов, также YouTube fake"
Write-Host "10. Запустить стратегию YouTube fake QUIC, bin файл google, больше размер пакетов, также YouTube fake и split 2"
Write-Host ""
Write-Host "11. Запустить стратегию split с badseq (предпочтительно МГТС)"
Write-Host "12. Запустить стратегию split с badseq, дополнительно cutoff (предпочтительно МГТС или ЯлтаТВ)"
Write-Host "13. Запустить стратегию fake и split2, bin файл google (предпочтительно МГТС)"
Write-Host "14. Запустить стратегию fake и split2 bin файл quic_test_00 (предпочтительно МГТС)"
Write-Host ""
Write-Host "30. Запустить стратегию ультимейт конфиг ZL (разблокирует любые сайты)"
Write-Host "31. Запустить стратегию ультимейт конфиг v2 (разблокирует любые сайты)"
Write-Host ""
Write-Host ""
Write-Host "40 Проверить работу YouTube глобально! (если никакие стратегии не помогают)"
Write-Host ""
Write-Host "50. Очистить DNS (установить дефолтные) (помогает если после смены DNS сломался интернет)"
Write-Host "51. Сменить DNS на Google DNS (помогает если Вы этого ещё не сделали)"
Write-Host "52. Сменить DNS на SB DNS"
Write-Host ""
Write-Host "60. Отредактировать файл hosts (помогает разблокировать Instagram, Facebook, Twitter и т.д.)"
Write-Host ""
Write-Host ""

$YT1 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new"
$YT5 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-autottl=2 --new"
$YT2 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --new"
$YT4 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl=2 --new"
$YT8 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=3 --new"
$YT7 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new"
$YT3 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=1 --new"
$YT6 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=4 --new"
$YT9 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=3 --new"

$YGV1 = "--filter-tcp=443 --hostlist=""$LISTS\youtubeGV.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new"
$YGV2 = "--filter-tcp=443 --hostlist=""$LISTS\youtubeGV.txt"" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new"
$YGV3 = "--filter-tcp=443 --hostlist=""$LISTS\youtubeGV.txt"" --dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1 --new"

$YRTMP1 = "--filter-tcp=443 --ipset=""$LISTS\russia-youtube-rtmps.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_4.bin"" --dpi-desync-autottl --new"

$DISTCP1 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new"
$DISTCP2 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new"
$DISTCP3 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new"
$DISTCP4 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-ttl=1 --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fake-tls=""$BIN\tls_clienthello_sberbank_ru.bin"" --new"
$DISTCP5 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_3.bin"" --dpi-desync-ttl=5 --new"
$DISTCP6 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new"
$DISTCP7 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=4 --new"
$DISTCP8 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new"
$DISTCP9 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl --new"
$DISTCP10 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=3 --new"
$DISTCP11 = "--filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl --new"
$DISTCP12 = "--filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld+1 --new"
$DISTCP80 = "--filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"


$UDP1 = "--filter-udp=50000-59000 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new"
#$UDP6 = "--filter-udp=50000-65535 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new"
$UDP2 = "--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
$UDP3 = "--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$UDP4 = "--filter-udp=50000-59000 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$UDP5 = "--filter-udp=50000-59000 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-cutoff=n5 --dpi-desync-repeats=10 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$UDP7 = "--filter-udp=50000-50090 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n3 --new"

$YQ1 = "--filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new"
$YQ2 = "--filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$YQ3 = "--filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --new"
$YQ4 = "--filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$YQ5 = "--filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$YQ6 = "--filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --dpi-desync-repeats=4 --new"
$YQ7 = "--filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake,udplen --dpi-desync-udplen-increment=2 --dpi-desync-fake-quic=""$BIN\quic_3.bin"" --dpi-desync-cutoff=n3 --dpi-desync-repeats=2 --new"

$DISUDP1 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new"
$DISUDP2 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --new"
$DISUDP3 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$DISUDP4 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_vk_com.bin"" --new"
$DISUDP5 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$DISUDP6 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$DISUDP7 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$DISUDP8 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_2.bin"" --dpi-desync-repeats=8 --dpi-desync-cutoff=n2 --new"
$DISUDP9 = "--filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,udplen --dpi-desync-udplen-increment=5 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_2.bin"" --dpi-desync-repeats=7 --dpi-desync-cutoff=n2 --new"

$DISIP1 = "--filter-udp=50000-50100 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
$DISIP2 = "--filter-udp=50000-65535 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
$DISIP3 = "--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
$DISIP4 = "--filter-udp=50000-50099 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" -- new"
$DISIP5 = "--filter-tcp=443 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_3.bin"" --dpi-desync-autottl --new"

$faceinsta = "--filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_4.bin"" -- new"

$other1 = "--filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
$other2 = "--filter-tcp=80 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --dpi-desync-autottl --new"
$other3 = "--filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=1 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=5 --new"
$other4 = "--filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1 --dpi-desync-fooling=md5sig,badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_4.bin"" --dpi-desync-autottl --new"

do {
    $userInput = Read-Host "Введите цифру"

    switch ($userInput) {
        "0" {
            Stop-Zapret
            Write-Host "ЗАПРЕТ ОСТАНОВЛЕН!"
        }
        "1" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Discord TCP 80" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 $YQ1 $YGV1 $YT1 $DISTCP80 $DISUDP2 $UDP2 $DISTCP2 $other1 $faceinsta"
            Restart-Discord
        }
        "2" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Discord fake" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 $YQ1 $YGV1 $YT1 $DISUDP1 $UDP1 $DISTCP1 $other1 $faceinsta"
            Restart-Discord
        }
        "3" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Discord fake и split" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50100 $DISUDP3 $DISIP1 $DISTCP80 $DISTCP3 $YQ1 $YGV1 $YT2 $other1 $faceinsta"
            Restart-Discord
        }
        "4" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Ultimate Fix ALT Beeline-Rostelekom" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 $DISUDP4 $DISIP2 $DISTCP80 $DISTCP4 $YQ1 $YGV1 $YT2 $other1 $faceinsta"
            Restart-Discord
        }
        "5" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "split с sniext" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 $YQ2 $YGV1 $YT3 $DISTCP5 $DISUDP5 $DISIP3 $other1 $faceinsta"
        }
        "6" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "split с badseq" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 $YQ2 $YGV1 $YT4 $DISTCP5 $DISUDP5 $DISIP3 $other1 $faceinsta"
        }
        "7" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Rostelecom & Megafon" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 $YQ2 $YGV1 $YT4 $DISUDP3 $UDP3 $DISTCP6 $other1 $faceinsta"
        }
        "8" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Rostelecom v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 $YQ3 $YGV1 $YT5 $DISUDP3 $UDP3 $DISTCP6 $other1 $faceinsta"
        }
        "9" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Other v1" -Arguments "--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 $YQ4 $YGV1 $YT3 $DISTCP7 $DISUDP6 $UDP4 $other1 $faceinsta"
        }
        "10" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Other v2" -Arguments "--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 $YQ4 $YGV2 $YT6 $DISUDP7 $UDP5 $DISTCP8 $other1 $faceinsta"
        }
        "11" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "MGTS v1" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 $YQ2 $YGV2 $YT7 $DISUDP5 $DISIP3 $DISTCP9 $other1 $faceinsta"
        }
        "12" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "MGTS v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 $YT8 $YGV1 $DISTCP10 $YQ5 $DISUDP1 $UDP1 $other1 $faceinsta"
        }
        "13" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "MGTS v3" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 $YT1 $YGV2 $DISTCP10 $YQ5 $DISUDP1 $UDP1 $other1 $faceinsta"
        }
        "14" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "MGTS v4" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 $YQ1 $YGV3 $YT1 $DISUDP1 $UDP1 $DISTCP1 $other1 $faceinsta"
        }
        "30" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Ultimate Config ZL" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50099 $YQ6 $YGV2 $YT9 $DISTCP11 $DISUDP8 $DISIP4 $other3 $faceinsta"
        }
        "31" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Ultimate Config v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50090 $YRTMP1 $YQ7 $DISIP5 $DISTCP12 $DISUDP9 $UDP7 $YGV3 $other2 $other4 $faceinsta"
        }
        "40" {
            Check-YouTube
        }
        "50" {
            Reset-DNS
        }
        "51" {
            Set-GoogleDNS
        }
        "52" {
            Set-ZapretDNS
        }
        "60" {
            Edit-Hosts
        }
        default {
            Write-Host "Вы не выбрали правильную цифру!"
        }
    }
} while ($true)