## Chromium браузеры
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

### Firefox браузеры
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

## Сборки Windows
Участились случаи попытки заблокировать обходы блокировок от систем Windows встроенные в ноутбуки, которые поставляются из под коробки самим производителем. В таком случае нужно заменить систему на свою чистую (_не сборку!_).

Если у Вас ну никак не работает Zapret - поставьте чистую Windows, например [LTSC](https://windows64.net/398-windows-10-x64-ltsc-21h2-s-aktivatorom-na-russkom.html). 
