Запустите данную команду из консоли (_`win + r`, потом `cmd.exe`_), где следует указать необходимый `cmd` файл (_в данном случае `C:\Zapret-main\start1.cmd`)_:

```cmd
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Zapret /t REG_SZ /d "C:\Zapret-main\start1.cmd" /f
```

> [!NOTE]  
> Это будет каждый раз открывать окно консоли, но его можно перенести на другой рабочий стол через комбинацию `win + tab`
