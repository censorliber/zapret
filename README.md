### Zapret (Запрет: обход блокировки Discord'а и Youtube'а)
1. Скачать по ссылке https://github.com/censorliber/zapret/archive/refs/heads/main.zip
2. Запустить **`MGTS_ver1.cmd`**
3. Если это не помогло (_или у вас не МГТС_), то попробуйте загрузить любой из **`preset_russia.cmd`**

## Перед тем как использовать
### 1. Chromium браузеры
Все конфиги представленные ниже работают только на Chromium подобных браузерах (Chrome, Opera, Vivaldi и т.д.). Поэтому рекомендуем переключиться на них.
<br>
К сожалению в некоторых случаях Яндекс браузер может блокировать работу программы, поэтому рекомендуем воздержаться от его использования.
<br>
Не используйте Cent Browser и иные подобные браузеры со встроенными блокировщиками (Thromium, Ungoogled Chromium, Iridum, Brave и т.д.). Они безусловно полезны, но могут отключать некоторые функции, такие как WebRTC, которая важна для работы Discord. Поэтому для необходимых ресурсов используйте чистые браузеры. 

### 2. Настройки браузера
1. Для правильной настройки Zapret поставьте на DEFAULT (а не выключите!) протокол QUIC по адресу:
```css
about://flags/#enable-quic
```

2. В настройках браузера также включите сторонний DNS (DOH). Так как Ваш провайдер может блокировать запросы DNS:
```css
about://settings/security
```

![image](https://github.com/user-attachments/assets/93c0f374-3ccd-41ab-837c-59588b293aca)

И впишите в строку "Безопасный провайдер DNS":
```css
https://dns.comss.one/dns-query
```
Иногда данный DNS сервер не разблокирует заблокированные ресурсы. В таком случае попробуйте сменить DOH от компаний Google DNS, Cloudflare DNS или Next DNS (_перезагружайте страницу после каждой смены DNS!_).

Также другие DNS сервисы: 
```css
https://common.dot.dns.yandex.net/dns-query
```
```css
https://dns.comss.one/dns-query
```
```css
https://dns.adguard-dns.com/dns-query
```
```css
https://dns.cloudflare.com/dns-query
```
```css
https://doh.opendns.com/dns-query
```
> [!IMPORTANT]  
> **После каждой смены DNS серверов обязательно перезапускайте браузер!**

## Частые ошибки
Ошибка ниже говорит о том что Вы не разархивировали zip архив через встроенные средства Windows или 7zip.

![image](https://github.com/user-attachments/assets/09a9c77e-c45b-408a-99b4-21899643cf7a)

## Обход блокировок аватарок в Instagram
К сожалению сервис и сайт `scontent-hel3-1.cdninstagram.com` использует только один IP адрес, и обойти его блокировку посредствам DNS не предоставляется возможным. Поэтому для обхода блокировок именно Instagram аватарок, следует обратиться к VPN.

![image](https://github.com/user-attachments/assets/57eaf8ff-eb76-4e16-8626-714c53de23bb)

## О вирусах
Вирусов в программе нет. Данное творение создано с открытым исходным кодом, и Вы можете собрать его самостоятельно. В данном случае на программу ругаются неизвестные китайские вирусы, а также 360 Total Security, который является китайским и не заслуживает доверия. Все американские антивирусы молчат.

Вот [пример](https://www.virustotal.com/gui/file/a188ff24aec863479408cee54b337a2fce25b9372ba5573595f7a54b784c65f8/detection) незараженного dll файла, который всего лишь изменяет код некоторых файлов для запуска пиратской игры. Данный dll хорошо известен и достаточно популярный на запада, однако антивирусы сходят с ума когда его видят.

![image](https://github.com/user-attachments/assets/040a0fd7-be98-4db3-9b7b-c5bc971f14a7)

**Win64/Trojan.Generic.HgEATiwA** — китайские антивирусы часто нумируют так неизвестные им программы, которые как-то вшиваются в трафик. Доказательства этому приведены [здесь](https://www.reddit.com/r/GenP/comments/14ul7nd/is_trojan_win64_downloader_sa_a_false_positive/), [здесь](https://www.reddit.com/r/BlueStacks/comments/xjc4z1/trojangenerichbadk_is_malware/) и [здесь](https://www.reddit.com/r/antivirus/comments/15kqey4/trojangenerichetyo_false_pozitive_please_help).

> [!CAUTION]  
> **Неизвестные источники могут маскировать Zapret под вирусы!**
> <br>
> Есть способ защититься от этого - всегда сверяйте хэш файла **`WinDivert.dll`** и **`winws.exe`**. Если хэш суммы одинаковые, это значит что файлы никак не были изменены автором и были загружены из оригинального источника.

[Оригинальные](https://www.virustotal.com/gui/file/0453fce6906402181dbff7e09b32181eb1c08bb002be89849e8992b832f43b89/detection) хэщи программы **`winws.exe`**
- MD5 `444fe359ca183016b93d8bfe398d5103`
- SHA-1 `61716de8152bd3a59378a6cd11f6b07988a549d5`
- SHA-256 `0453fce6906402181dbff7e09b32181eb1c08bb002be89849e8992b832f43b89`

----------------

### По всем вопросам обращаться в группу https://t.me/youtubenotwork
### Другие полезные сервисы и VPN https://github.com/awesome-windows11/CensorNet
> [!CAUTION]  
> При любых ошибках просьба **ВСЕГДА** оставляйте скриншот и изображение ошибки, не описывайте их на словах, так Вам нельзя будет помочь, так как не понятно что за проблема.
> <br>
> Также следует писать Вашего **провайдера и город**, чтобы можно было составить список рабочих конфигураций для различных провайдеров, который будет не публичный.

> [!WARNING]  
> Если не работает Discord, указывается используете ли вы **приложение** или веб браузер. Если используется **веб браузер** (_что рекомендуется_), то указывайте бренд и имя версии.

> [!TIP]  
> Если совсем отчаетесь то можете написать в [ЛС **БЕСПЛАТНЫЙ** запрос на удалённую настройку](https://t.me/youtubenotwork/4764) через AnyDesk. В любой момент подключение можно завершить и удалить программу.

<div align='center'><a href='https://www.websitecounterfree.com'><img src='https://www.websitecounterfree.com/c.php?d=9&id=60326&s=1' border='0' alt='Free Website Counter'></a><br / ><small></small></div>
