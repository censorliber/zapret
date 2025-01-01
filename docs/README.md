<h1 align="center"><img src="https://i.imgur.com/uABXHHI.png" width="30px"></img> <a href="https://github.com/bol-van/zapret">Zapret</a> (Запрет: обход блокировки Дискорда и Ютуба) </h1>

> [!IMPORTANT]  
> Есть вопросы? Задай их здесь: https://github.com/censorliber/zapret/issues/new

### Хочу быстро и просто. Как использовать?
1. Скачать по ссылке https://github.com/censorliber/zapret/releases/download/6.3.4/zapret6.3.4.zip
2. Запустите файл **`start.bat`**
3. Пробуйте различные стратегии (набрав необходимую цифру и после Enter) для обхода блокировок.
4. Пробуйте ЛЮБЫЕ стратегии которые существуют, но перед этим попробуйте стратегии непосредственно для **ВАШЕГО** провайдера
5. Вы также можете использовать дополнительные настройки `9X`, чтобы например разблокировать Instagram и Facebook, а также сменить DNS.
6. **НЕ ЗАКРЫВАЙТЕ ОКНО КОНСОЛИ** `windivert initialized. capture is started`, так как данная надпись означает что Zapret **успешно** **запущен**

**Не используйте приложение Discord, вместо этого подключайтесь по ссылке https://discord.com/channels/@me**!!

![image](https://github.com/user-attachments/assets/3b52ddd1-ee0c-4c58-bab1-ffa6202e172c)

## Хочу узнать подробнее
## [Что такое Zapret](https://github.com/censorliber/zapret/blob/main/docs/zapret.md)
> [!CAUTION]  
> [Касперский](https://github.com/bol-van/zapret/issues/611) и иные российские вирусы начали войну с запретами и иными средствами обхода блокировок. Чтобы использовать их спокойно рекомендуется перейти на альтернативные американские антивирусы (Defender, ESET32 и т.д.), которые не выдают ложные и обманчивые срабатывания и помогают от большего количества угроз.

> [!CAUTION]  
> [Яндекс DNS](https://t.me/bypassblock/134) перестали открывать Discord и другие заблокированные сайты. Не пользуйтесь ими. Рекомендуем сменить их на [**Google DNS**](https://developers.google.com/speed/public-dns) или [**Quad9 DNS**](https://quad9.net/service/service-addresses-and-features). Программа быстро позволяет Вам это сделать (опции `92` и `93`)

### 1.1. Chromium браузеры
Все конфиги представленные ниже работают Chromium подобных браузерах (Chrome, Vivaldi и т.д.). Поэтому рекомендуем переключиться на них. **Никакие флаги переключать там не нужно, всё оставляем по умолчанию!**

**К сожалению в некоторых случаях Яндекс браузер может блокировать работу программы и определять её как вирус (новые версии программы ещё не внесены в базы и они игнорируются). <br> Поэтому рекомендуем воздержаться от его использования.**

![image](https://github.com/user-attachments/assets/03367961-c045-4d62-a1a3-a54814381843)

Не используйте Cent Browser и иные подобные браузеры со встроенными блокировщиками (Thorium (_Thromium_), Ungoogled Chromium, Iridum, Brave, Opera GX и т.д.). Они безусловно полезны, но могут отключать некоторые функции, такие как WebRTC, которая важна для работы Discord. Поэтому для необходимых ресурсов используйте чистые браузеры. 

Включите кастомное DNS

```
https://dns.comss.one/dns-query
```

в браузерах по адресу:

```
chrome://settings/security
```

### 1.2. Firefox браузеры
Firefox 132 [включает](https://ntc.party/t/%D0%B2%D0%B0%D0%B6%D0%BD%D0%BE-firefox-132-%D0%B2%D0%BA%D0%BB%D1%8E%D1%87%D0%B0%D0%B5%D1%82-kyber-%D0%BF%D0%BE-%D1%83%D0%BC%D0%BE%D0%BB%D1%87%D0%B0%D0%BD%D0%B8%D1%8E/12652) kyber по-умолчанию. Зайдите по адресу `about:config` и отключите (_поставьте **`false`**_):
```
network.http.http3.enable_kyber
```

А также 
```
security.tls.enable_kybe
```

Затем включите опции (_поставьте **`true`**_):
```
network.dns.disableIPv6
```

```
network.http.http3.enable
```

```
network.http.http3.retry_different_ip_family
```

Включите кастомное DNS

```
https://dns.comss.one/dns-query
```

в браузерах по адресу:

```
about:preferences#privacy
```

### 1.3 Сборки Windows
Участились случаи попытки заблокировать обходы блокировок от систем Windows встроенные в ноутбуки, которые поставляются из под коробки самим производителем. В таком случае нужно заменить систему на свою чистую (_не сборку!_).

Если у Вас ну никак не работает Zapret - поставьте чистую Windows, например [LTSC](https://windows64.net/398-windows-10-x64-ltsc-21h2-s-aktivatorom-na-russkom.html). 

## [Частые вопросы и ошибки](https://github.com/censorliber/zapret/blob/main/docs/faq.md)
### По всем вопросам обращаться в группу https://t.me/youtubenotwork или https://discord.gg/kkcBDG2uws
### Другие полезные сервисы и VPN https://github.com/awesome-windows11/CensorNet
> [!CAUTION]  
> При любых ошибках просьба **ВСЕГДА** оставляйте скриншот и изображение ошибки.
> 
> Не описывайте их на словах (ничего не работает, не запускается и т.д.), **так Вам нельзя будет помочь**, так как не понятно что за проблема.
>
> 
> Также следует писать Вашего **провайдера и город**, чтобы можно было составить список рабочих конфигураций для различных провайдеров, который будет не публичный.

> [!WARNING]  
> Если не работает Discord, указывается используете ли вы **приложение** или веб браузер. Если используется **веб браузер** (_что рекомендуется_), то указывайте бренд и имя версии.

> [!TIP]  
> Если совсем отчаетесь то можете написать в [ЛС **БЕСПЛАТНЫЙ** запрос на удалённую настройку](https://t.me/youtubenotwork/4764) через AnyDesk. В любой момент подключение можно завершить и удалить программу.

> [!TIP]  
> Автор KDS. Его оригинальный [архив сборок](https://ntc.party/t/ytdisbystro-%D0%B0%D1%80%D1%85%D0%B8%D0%B2-%D0%B2%D1%81%D0%B5%D1%85-%D0%B2%D0%B5%D1%80%D1%81%D0%B8%D0%B9/12582)

## 4. Автозапуск
Запустите данную команду из консоли (_`win + r`, потом `cmd.exe`_), где следует указать необходимый `cmd` файл (_в данном случае `C:\Zapret-main\start1.cmd`)_:

```cmd
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Zapret /t REG_SZ /d "C:\Zapret-main\start1.cmd" /f
```

> [!NOTE]  
> Это будет каждый раз открывать окно консоли, но его можно перенести на другой рабочий стол через комбинацию `win + tab`

## [О вирусах](https://github.com/censorliber/zapret/blob/main/docs/virus.md)

<div align='center'><a href=''><img src='https://www.websitecounterfree.com/c.php?d=9&id=60326&s=1' border='0' alt='Free Website Counter'></a><br / ><small></small></div>
