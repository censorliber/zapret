# Устанавливаем кодовую страницу UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Устанавливаем синий цвет фона (не работает в PowerShell 7+)
if ($PSVersionTable.PSVersion.Major -lt 6) {
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    Clear-Host
}

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
$localVersion = "6.3.1"

function Test-Administrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Test-Administrator)) {
    Write-Host "Requesting administrator rights..."
    Start-Process powershell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"" -Verb RunAs
    exit
}
Write-Host "Запуск прошёл успешно..."

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
        $process = Start-Process -FilePath "$BIN\winws.exe" `
                                 -ArgumentList $Arguments `
                                 -WindowStyle Minimized `
                                 -PassThru `
                                 -WorkingDirectory $PSScriptRoot
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
        Write-Host "Перезапуск Запрета..."
        Stop-Process -Force -Name winws
        Stop-Service -Name "Zapret" -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Попытка запуска стратегии..."
    }

    $goodbyeDpiProcess = Get-Process goodbyedpi -ErrorAction SilentlyContinue
    if ($goodbyeDpiProcess) {
        Write-Host "ГУДБАЙДИПИАЙ НЕ РАБОТАЕТ С ZAPRET!!!"
        Stop-Process -Force -Name winws
        Stop-Service -Name "GoodbyeDPI" -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\GoodbyeDPI" -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Start-Sleep -Seconds 1
    Stop-Service -Name "WinDivert" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "WinDivert14" -Force -ErrorAction SilentlyContinue
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
    $primaryDNS = "8.8.8.8"
    $secondaryDNS = "8.8.4.4"

    Write-Host "Изменение DNS для интерфейсов..."

    $interfaces = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}

    foreach ($interface in $interfaces) {
        Set-DnsClientServerAddress -InterfaceAlias $interface.InterfaceAlias -ServerAddresses ($primaryDNS, $secondaryDNS)
    }

    ipconfig /flushdns
    Write-Host "Все интерфейсы успешно обновлены."
}

function Set-ZapretDNS {
    $primaryDNS = "185.222.222.222"
    $secondaryDNS = "45.11.45.11"

    Write-Host "Изменение DNS для интерфейсов..."

    $interfaces = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
    
    foreach ($interface in $interfaces) {
        Set-DnsClientServerAddress -InterfaceAlias $interface.InterfaceAlias -ServerAddresses ($primaryDNS, $secondaryDNS)
    }

    ipconfig /flushdns
    Write-Host "Все интерфейсы успешно обновлены."
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
        "157.240.229.174 www.instagram.com",
        "157.240.229.174 instagram.com",
        "157.240.247.63 scontent.cdninstagram.com"
    )

    $newHostsContent -join "`n" | Set-Content -Path $hostsPath -Encoding UTF8
    Write-Host "Файл hosts успешно обновлён."
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

function Check-YouTube {
    try {
        $response = Invoke-WebRequest -Uri "https://jnn-pa.googleapis.com" -Method GET
        Write-Output "Запрос успешен: $($response.StatusCode)"
    } catch {
        if ($_.Exception.Response.StatusCode -eq 403) {
            Write-Output "Ошибка 403: ВЫ НЕ СМОЖЕТЕ СМОТРЕТЬ ЮТУБ ЧЕРЕЗ ZAPRET! Вам следует скачать Freetube по ссылке freetubeapp.io и/или смотреть ссылки через embed, вот пример: https://www.youtube.com/embed/0e3GPea1Tyg"
        } else {
            Write-Output $($_.Exception.Message)
            Write-Output "Если Вы видите ошибки 404, то Вы успешно сможете разблокировать YouTube через Zapret!"
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
            Write-Host "Доступно обновление! Текущая версия: $localVersion, Новая версия: $latestVersion"
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

Show-Telegram

if (Check-Update) {
    # Предлагаем пользователю скачать обновление
    $choice = Read-Host "Скачать обновление? (введите цифру 1 если Вы согласны обновить программу / введите цифру 0 если против)"
    if ($choice -eq "1") {
        # Здесь код для скачивания и установки обновления
        Write-Host "Скачивание обновления..."
        Start-Sleep -Seconds 2
        Write-Host "Пожалуйста удалите старую папку после того как Вы скачаете новую папку (запускайте уже новую версию!)"
        Start-Sleep -Seconds 5
        Start-Process https://github.com/censorliber/zapret_binary/raw/refs/heads/main/zapret$latestVersion.exe
        Exit 0
    } elseif ($choice -eq "0") {
        Write-Host "ОБНОВЛЕНИЕ ОТМЕНЕНО! В БУДУЩЕМ ВЫ ДОЛЖНЫ СКАЧАТЬ НОВУЮ ВЕРСИЮ"
    } else {
        Exit 0
    }
}

Write-Host "ВНИМАНИЕ: Вы должны распаковать ZIP архив перед использованием!"
Write-Host ""
Write-Host "-----------------------"
Write-Host "ВЫБЕРИТЕ СТРАТЕГИЮ:"
Write-Host "0. Остановить Zapret"
Write-Host ""
Write-Host "1. Запустить стратегию Discord v1 (предпочтительно Ростелеком)"
Write-Host "2. Запустить стратегию Discord v2 (предпочтительно Ростелеком)"
Write-Host "3. Запустить стратегию Discord v3 (предпочтительно Уфанет)"
Write-Host "4. Запустить стратегию Discord v4 (УльтиМейт фикс, разблокирует любые сайты, предпочтительно Билайн и Ростелеком)"
Write-Host ""
Write-Host "5. Запустить стратегию split с sniext (предпочтительно ДомРу)"
Write-Host "6. Запустить стратегию split с badseq (предпочтительно ДомРу)"
Write-Host ""
Write-Host "7. Запустить стратегию Rostelecom and Megafon (предпочтительно Ростелеком и Мегафон)"
Write-Host "8. Запустить стратегию Rostelecom v2 (предпочтительно Ростелеком)"
Write-Host ""
Write-Host "9. Запустить стратегию Другое v1"
Write-Host "10. Запустить стратегию Другое v2"
Write-Host ""
Write-Host "11. Запустить стратегию v1 (предпочтительно МГТС)"
Write-Host "12. Запустить стратегию v2 (предпочтительно МГТС или ЯлтаТВ)"
Write-Host "13. Запустить стратегию v3 (предпочтительно МГТС)"
Write-Host "14. Запустить стратегию v4 (предпочтительно МГТС)"
Write-Host ""
Write-Host "20. Запустить стратегию v5 (устаревшая, иногда ютуб разблокируется на Ростелекоме)"
Write-Host "21. Запустить стратегию v6 (устаревшая)"
Write-Host ""
Write-Host "30. Запустить ультимейт конфиг ZL (разблокирует любые сайты)"
Write-Host "31. Запустить ультимейт конфиг v2 (разблокирует любые сайты)"
Write-Host ""
Write-Host ""
Write-Host "91 Проверить работу YouTube глобально! (если никакие стратегии не помогают)"
Write-Host "92. Сменить DNS на Google DNS (помогает если Вы этого ещё не сделали)"
Write-Host "93. Сменить DNS на DNS от Запрета"
Write-Host "94. Отредактировать файл hosts (помогает разблокировать Instagram, Facebook, Twitter и т.д.)"
Write-Host ""
Write-Host ""

do {
    $userInput = Read-Host "Введите цифру"

    switch ($userInput) {
        "0" {
            Stop-Zapret
            Write-Host "ЗАПРЕТ ОСТАНОВЛЕН!"
        }
        "1" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Discord v1 Rostelecom" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new --filter-udp=50000-59000 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
            Restart-Discord
        }
        "2" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Discord v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
            Restart-Discord
        }
        "3" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Discord v3" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-50100 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
            Restart-Discord
        }
        "4" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Ultimate Fix ALT Beeline-Rostelekom" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_vk_com.bin"" --new --filter-udp=50000-65535 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-ttl=1 --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
            Restart-Discord
        }
        "5" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "DomRu v1" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=1 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_3.bin"" --dpi-desync-ttl=5 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
        }
        "6" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "DomRu v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl=2 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_3.bin"" --dpi-desync-ttl=5 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
        }
        "7" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Rostelecom & Megafon" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl=2 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new"
        }
        "8" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Rostelecom v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-autottl=2 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new"
        }
        "9" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Other v1" -Arguments "--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=1 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=4 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new"
        }
        "10" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Other v2" -Arguments "--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=4 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-cutoff=n5 --dpi-desync-repeats=10 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_www_google_com.bin"""
        }
        "11" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "MGTS v1" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl"
        }
        "12" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "MGTS v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new --filter-udp=50000-65535 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"""
        }
        "13" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "MGTS v3" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2--dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new --filter-udp=50000-65535 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"""
        }
        "14" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "MGTS v4" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new --filter-udp=50000-59000 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
        }
        "20" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Strategy 2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
        }
        "21" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Strategy 3" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-50100 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
        }
        "30" {
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Ultimate Config ZL" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50099 --filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --dpi-desync-repeats=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtubeGV.txt"" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=3 --new --filter-tcp=80 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=1 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=5 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_2.bin"" --dpi-desync-repeats=8 --dpi-desync-cutoff=n2 --new --filter-udp=50000-50099 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_1.bin"""
        }
        "31" {
            $YTDB_YTPot = "--dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld+1"
            $YTDB_WinSZ = "--hostlist=""$LISTS\youtubeGV.txt"" --dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1"
            $YTDB_DIS1 = "--ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_3.bin"" --dpi-desync-autottl"
            $YTDB_DIS2 = "--hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,udplen --dpi-desync-udplen-increment=5 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_2.bin"" --dpi-desync-repeats=7 --dpi-desync-cutoff=n2"
            $YTDB_DIS3 = "--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n3"
            Stop-Zapret
            Invoke-ZapretStrategy -StrategyName "Ultimate Config v2" -Arguments "$YTDB_prog_log --wf-tcp=80,443 --wf-udp=443,50000-50090 --filter-tcp=443 --ipset=""$LISTS\russia-youtube-rtmps.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_4.bin"" --dpi-desync-autottl --new --filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake,udplen --dpi-desync-udplen-increment=2 --dpi-desync-fake-quic=""$BIN\quic_3.bin"" --dpi-desync-cutoff=n3 --dpi-desync-repeats=2 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" $YTDB_YTPot --new --filter-tcp=80 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --dpi-desync-autottl --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1 --dpi-desync-fooling=md5sig,badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_4.bin"" --dpi-desync-autottl --new --filter-tcp=443 $YTDB_DIS1 --new --filter-udp=443 $YTDB_DIS2 --new --filter-udp=50000-50090 $YTDB_DIS3 --new --filter-tcp=443 $YTDB_WinSZ"
        }
        "91" {
            Check-YouTube
        }
        "92" {
            Set-GoogleDNS
        }
        "93" {
            Set-ZapretDNS
        }
        "94" {
            Edit-Hosts
        }
        default {
            Write-Host "Вы не выбрали правильную цифру!"
        }
    }
} while ($true)