## О вирусах в Zapret
> [!CAUTION]
> ### Вирусная копия Zapret!
> Телеграм канал `peekbot` начал распространять [вирусы](https://github.com/Flowseal/zapret-discord-youtube/issues/794) под предлогом Zapret. Будьте внимательны! Также у них имеется вредоносный сайт `https://gitrok.com`!
>
> В папке висит вирусный **cygwin.exe** который весит свыше 13 МБ. Такие [большие файлы](https://www.virustotal.com/gui/file/5591f24e96ed8d2877ac056955f5aaeb45fab792f1b35d635ae4a961c7000e26/detection) никогда не находились в оригинальном Zapret.

Вирусов в программе нет. Почему это так:
- Проект с открытым исходным кодом
- Вы можете собрать его самостоятельно из исходных файлов
- В проекте нет ни одного неизвестного exe файла, все они собираются напрямую из репозитория bol-van

В данном случае на программу ругаются неизвестные китайские вирусы, а также 360 Total Security, который является китайским и не заслуживает доверия, из-за того что она меняет системные настройки, в частности hosts. Однако все американские антивирусы молчат.


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

## [Что такое Zapret](https://github.com/censorliber/zapret/blob/main/docs/zapret.md)

## [Настройка браузеров](https://github.com/censorliber/zapret/blob/main/docs/browser.md)

## [Частые вопросы и ошибки](https://github.com/censorliber/zapret/blob/main/docs/faq.md)
