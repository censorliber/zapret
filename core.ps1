# Устанавливаем кодовую страницу UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

#region - Цвета и оформление
# Устанавливаем синий цвет фона (не работает в PowerShell 7+)
if ($PSVersionTable.PSVersion.Major -lt 6) {
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    Clear-Host
}

# Составляем слово ZAPRET из синих квадратов
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
#endregion

#region - Переменные окружения
$BIN = "$PSScriptRoot\bin\"
$LISTS = "$PSScriptRoot\lists\"
#endregion

#region - Проверка прав администратора
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
#endregion

#region - Функции

function Invoke-ZapretStrategy {
    param(
        [string]$StrategyName,
        [string]$Arguments
    )

    Stop-Zapret

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
#endregion

#region - Telegram
Show-Telegram
#endregion

Write-Host "ВНИМАНИЕ: Вы должны распаковать ZIP архив перед использованием!"
Write-Host ""

#region - Меню
Write-Host "-----------------------"
Write-Host "ВЫБЕРИТЕ СТРАТЕГИЮ:"
Write-Host "0. Остановить Zapret"
Write-Host ""
Write-Host "1. Zapret: Discord v1 (любые провайдеры, предпочтительно Ростелеком)"
Write-Host "2. Zapret: Discord v2 (любые провайдеры,  предпочтительно Ростелеком)"
Write-Host "3. Zapret: Discord v3 (любые провайдеры, предпочтительно Уфанет)"
Write-Host "4. Zapret: Discord v4 (УльтиМейт фикс, разблокирует любые сайты, предпочтительно Билайн и Ростелеком)"
Write-Host ""
Write-Host "5. Zapret: ДомРу v1 (любые провайдеры)"
Write-Host "6. Zapret: ДомРу v2 (любые провайдеры)"
Write-Host ""
Write-Host "7. Zapret: Rostelecom and Megafon (любые провайдеры, предпочтительно Ростелеком и Мегафон)"
Write-Host "8. Zapret: Rostelecom v2 (любые провайдеры, предпочтительно Ростелеком)"
Write-Host ""
Write-Host "9. Zapret: Другое v1 (любые провайдеры)"
Write-Host "10. Zapret: Другое v2 (любые провайдеры)"
Write-Host ""
Write-Host "11. Zapret: МГТС v1"
Write-Host "12. Zapret: МГТС v2 (любые провайдеры, предпочтительно ЯлтаТВ)"
Write-Host "13. Zapret: МГТС v3 (любые провайдеры)"
Write-Host "14. Zapret: МГТС v4 (любые провайдеры)"
Write-Host ""
Write-Host "20. Strategy 2 (устаревшая, иногда ютуб разблокируется на Ростелекоме)"
Write-Host "21. Strategy 3 (устаревшая)"
Write-Host ""
Write-Host "30. Ультимейт конфиг ZL (разблокирует любые сайты, любые провайдеры)"
Write-Host "31. Ультимейт конфиг v2 (разблокирует любые сайты, любые провайдеры)"
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
            Invoke-ZapretStrategy -StrategyName "Discord v1 Rostelecom" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new --filter-udp=50000-59000 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
            Restart-Discord
        }
        "2" {
            Invoke-ZapretStrategy -StrategyName "Discord v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
            Restart-Discord
        }
        "3" {
            Invoke-ZapretStrategy -StrategyName "Discord v3" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-50100 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
            Restart-Discord
        }
        "4" {
            Invoke-ZapretStrategy -StrategyName "Ultimate Fix ALT Beeline-Rostelekom" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_vk_com.bin"" --new --filter-udp=50000-65535 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-ttl=1 --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
            Restart-Discord
        }
        "5" {
            Invoke-ZapretStrategy -StrategyName "DomRu v1" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=1 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_3.bin"" --dpi-desync-ttl=5 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
        }
        "6" {
            Invoke-ZapretStrategy -StrategyName "DomRu v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl=2 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_3.bin"" --dpi-desync-ttl=5 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new"
        }
        "7" {
            Invoke-ZapretStrategy -StrategyName "Rostelecom & Megafon" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl=2 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new"
        }
        "8" {
            Invoke-ZapretStrategy -StrategyName "Rostelecom v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-autottl=2 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new"
        }
        "9" {
            Invoke-ZapretStrategy -StrategyName "Other v1" -Arguments "--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=1 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=4 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new"
        }
        "10" {
            Invoke-ZapretStrategy -StrategyName "Other v2" -Arguments "--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=4 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-cutoff=n5 --dpi-desync-repeats=10 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_www_google_com.bin"""
        }
        "11" {
            Invoke-ZapretStrategy -StrategyName "MGTS v1" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=2 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl"
        }
        "12" {
            Invoke-ZapretStrategy -StrategyName "MGTS v2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new --filter-udp=50000-65535 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"""
        }
        "13" {
            Invoke-ZapretStrategy -StrategyName "MGTS v3" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-65535 --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=3 --new --filter-tcp=443 --hostlist=""$LISTS\faceinsta.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2--dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new --filter-udp=50000-65535 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"""
        }
        "14" {
            Invoke-ZapretStrategy -StrategyName "MGTS v4" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --dpi-desync-cutoff=n2 --new --filter-udp=50000-59000 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
        }
        "20" {
            Invoke-ZapretStrategy -StrategyName "Strategy 2" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-59000 --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --dpi-desync-ttl=3 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --new --filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=""$BIN\tls_clienthello_2.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
        }
        "21" {
            Invoke-ZapretStrategy -StrategyName "Strategy 3" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=""$BIN\quic_initial_www_google_com.bin"" --new --filter-udp=50000-50100 --ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=80 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,split --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=""$BIN\tls_clienthello_www_google_com.bin"" --new --filter-udp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=""$BIN\quic_test_00.bin"" --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=2 --new"
        }
        "30" {
            Invoke-ZapretStrategy -StrategyName "Ultimate Config ZL" -Arguments "--wf-tcp=80,443 --wf-udp=443,50000-50099 --filter-udp=443 --hostlist=""$LISTS\youtubeQ.txt"" --dpi-desync=fake --dpi-desync-fake-quic=""$BIN\quic_1.bin"" --dpi-desync-repeats=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtubeGV.txt"" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=""$LISTS\youtube.txt"" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=3 --new --filter-tcp=80 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=""$LISTS\other.txt"" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=1 --dpi-desync-fake-tls=""$BIN\tls_clienthello_2.bin"" --dpi-desync-ttl=5 --new --filter-tcp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl --new --filter-udp=443 --hostlist=""$LISTS\discord.txt"" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_2.bin"" --dpi-desync-repeats=8 --dpi-desync-cutoff=n2 --new --filter-udp=50000-50099 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=""$BIN\quic_1.bin"""
        }
        "31" {
            $YTDB_YTPot = "--dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld+1"
            $YTDB_WinSZ = "--hostlist=""$LISTS\youtubeGV.txt"" --dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1"
            $YTDB_DIS1 = "--ipset=""$LISTS\ipset-discord.txt"" --dpi-desync=syndata --dpi-desync-fake-syndata=""$BIN\tls_clienthello_3.bin"" --dpi-desync-autottl"
            $YTDB_DIS2 = "--hostlist=""$LISTS\discord.txt"" --dpi-desync=fake,udplen --dpi-desync-udplen-increment=5 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=""$BIN\quic_2.bin"" --dpi-desync-repeats=7 --dpi-desync-cutoff=n2"
            $YTDB_DIS3 = "--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n3"
            
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