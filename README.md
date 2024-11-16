<h1 align="center"><img src="https://i.imgur.com/uABXHHI.png" width="30px"></img> <a href="https://github.com/bol-van/zapret">Zapret</a> (Запрет: обход блокировки Дискорда и Ютуба) </h1>

1. Скачать по ссылке https://github.com/censorliber/zapret/archive/refs/heads/main.zip
2. **Обязательно разархивировать проект из ZIP файла! _(и создать папку)_**
3. Запустить первую стратегию, файл под именем **`start1.cmd`**
4. Если это не помогло (_или у вас не МГТС_), то попробуйте загрузить любой из **`start.cmd`** файлов. При этом обязательно **закрывайте предыдущее окно**, только после чего открываете следующую стратегию. Можете перезагрузить страницу/браузер и подождите хотя бы 4-6 секунд.

## 1. Перед тем как использовать
### 1.1. Chromium браузеры
Все конфиги представленные ниже работают Chromium подобных браузерах (Chrome, Vivaldi и т.д.). Поэтому рекомендуем переключиться на них. **Никакие флаги переключать там не нужно, всё оставляем по умолчанию!**
<br>
К сожалению в некоторых случаях Яндекс браузер может блокировать работу программы, поэтому рекомендуем воздержаться от его использования.

Не используйте Cent Browser и иные подобные браузеры со встроенными блокировщиками (Thromium, Ungoogled Chromium, Iridum, Brave, Opera GX и т.д.). Они безусловно полезны, но могут отключать некоторые функции, такие как WebRTC, которая важна для работы Discord. Поэтому для необходимых ресурсов используйте чистые браузеры. 

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

### 1.3. Настройки файла hosts
> [!WARNING]  
> ПРОВЕРЬТЕ ЧТОБЫ по адресу `about://settings/security` DNS DOH В БРАУЗЕРЕ БЫЛ **ВЫКЛЮЧЕН**! В ДАННЫЙ МОМЕНТ ЭТОЙ НАСТРОЙКИ **НЕ** ТРЕБУЕТСЯ!

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
```

Либо на (_предыдущий вариант удалите_):
```
31.13.72.36 facebook.com
31.13.72.36 www.facebook.com
31.13.72.12 static.xx.fbcdn.net
31.13.72.18 fburl.com
157.240.229.174 www.instagram.com
157.240.229.174 instagram.com
31.13.72.53 static.cdninstagram.com
31.13.72.53 edge-chat.instagram.com
157.240.247.63 scontent.cdninstagram.com
157.240.205.63 scontent-hel3-1.cdninstagram.com
104.21.32.39 rutracker.org
172.67.182.196 rutracker.org
116.202.120.184 torproject.org
116.202.120.184 bridges.torproject.org
116.202.120.166 community.torproject.org
```

### 1.4 Сборки Windows
Участились случаи попытки заблокировать обходы блокировок от систем Windows встроенные в ноутбуки, которые поставляются из под коробки самим производителем. В таком случае нужно заменить систему на свою чистую (_не сборку!_).

Если у Вас ну никак не работает Zapret - поставьте чистую Windows, например [LTSC](https://windows64.net/398-windows-10-x64-ltsc-21h2-s-aktivatorom-na-russkom.html). 

## 2. Частые ошибки
Ошибка ниже говорит о том что Вы не разархивировали zip архив через встроенные средства Windows или 7zip.

![image](https://github.com/user-attachments/assets/09a9c77e-c45b-408a-99b4-21899643cf7a)

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

----------------

### По всем вопросам обращаться в группу https://t.me/youtubenotwork или https://discord.gg/JGVgTefCjM
### Другие полезные сервисы и VPN https://github.com/awesome-windows11/CensorNet
> [!CAUTION]  
> При любых ошибках просьба **ВСЕГДА** оставляйте скриншот и изображение ошибки, не описывайте их на словах, так Вам нельзя будет помочь, так как не понятно что за проблема.
> <br>
> Также следует писать Вашего **провайдера и город**, чтобы можно было составить список рабочих конфигураций для различных провайдеров, который будет не публичный.

> [!WARNING]  
> Если не работает Discord, указывается используете ли вы **приложение** или веб браузер. Если используется **веб браузер** (_что рекомендуется_), то указывайте бренд и имя версии.

> [!TIP]  
> Если совсем отчаетесь то можете написать в [ЛС **БЕСПЛАТНЫЙ** запрос на удалённую настройку](https://t.me/youtubenotwork/4764) через AnyDesk. В любой момент подключение можно завершить и удалить программу.

> [!TIP]  
> Автор KDS. Его оригинальный [архив сборок](https://ntc.party/t/ytdisbystro-%D0%B0%D1%80%D1%85%D0%B8%D0%B2-%D0%B2%D1%81%D0%B5%D1%85-%D0%B2%D0%B5%D1%80%D1%81%D0%B8%D0%B9/12582)

<div align='center'><a href='https://www.websitecounterfree.com'><img src='https://www.websitecounterfree.com/c.php?d=9&id=60326&s=1' border='0' alt='Free Website Counter'></a><br / ><small></small></div>
