import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import subprocess
import os

import ctypes, sys

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

if not is_admin():
    # Перезапуск программы с правами администратора
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
    sys.exit()
    
# Списки хостов для YouTube
youtube_hosts = [
    "youtube.com",
    "www.youtube.com",
    "m.youtube.com",
    "youtubei.googleapis.com",
    "youtube.googleapis.com",
    "www.youtube-nocookie.com",
    "youtube-nocookie.com",
]

# Списки хостов для Discord
discord_hosts = [
    "discord.com",
    "discordapp.com",
    "discordapp.net",
    "discord.media",
    "discord.gg",
    "media.discordapp.net",
]

# Список хостов для other
other_hosts = [
    "google.com",
    "www.google.com",
]

strategies_and_filters = {
    "Strategy 1": {
        "youtube (udp:443)": [
            "--filter-udp=443",
            f"--hostlist-data={','.join(youtube_hosts)}", # Передаем список хостов
            "--dpi-desync=fake",
            "--dpi-desync-repeats=2",
            "--dpi-desync-cutoff=n2",
            "--dpi-desync-fake-quic=./bin/quic_test_00.bin",
            "--new"
        ],
        "youtube (tcp:443) split": [
            "--filter-tcp=443",
            f"--hostlist-data={','.join(youtube_hosts)}",
            "--dpi-desync=split",
            "--dpi-desync-split-pos=1",
            "--dpi-desync-fooling=badseq",
            "--dpi-desync-repeats=10",
            "--dpi-desync-cutoff=d2",
            "--dpi-desync-ttl=4",
            "--new"
        ],
        "youtube (tcp:443) fake,split2": [
            "--filter-tcp=443",
            f"--hostlist-data={','.join(youtube_hosts)}",
            "--dpi-desync=fake,split2",
            "--dpi-desync-split-seqovl=2",
            "--dpi-desync-split-pos=3",
            "--dpi-desync-fake-tls=./bin/tls_clienthello_www_google_com.bin",
            "--dpi-desync-ttl=3",
            "--new"
        ],
        "discord (udp:443)": [
            "--filter-udp=443",
            f"--hostlist-data={','.join(discord_hosts)}",
            "--dpi-desync=fake",
            "--dpi-desync-udplen-increment=10",
            "--dpi-desync-repeats=7",
            "--dpi-desync-udplen-pattern=0xDEADBEEF",
            "--dpi-desync-fake-quic=./bin/quic_test_00.bin",
            "--dpi-desync-cutoff=n2",
            "--new"
        ],
        "discord (udp:50000-59000)": [
            "--filter-udp=50000-59000",
            "--dpi-desync=fake,split2",
            "--dpi-desync-any-protocol",
            "--dpi-desync-cutoff=d2",
            "--dpi-desync-fake-quic=./bin/quic_test_00.bin",
            "--new"
        ],
        "discord (tcp:443)": [
            "--filter-tcp=443",
            f"--hostlist-data={','.join(discord_hosts)}",
            "--dpi-desync=split",
            "--dpi-desync-split-pos=1",
            "--dpi-desync-fooling=badseq",
            "--dpi-desync-repeats=10",
            "--dpi-desync-ttl=4",
            "--new"
        ],
        "other (tcp:443)": [
            "--filter-tcp=443",
            f"--hostlist-data={','.join(other_hosts)}",
            "--dpi-desync=fake,split2",
            "--dpi-desync-split-seqovl=1",
            "--dpi-desync-split-tls=sniext",
            "--dpi-desync-fake-tls=./bin/tls_clienthello_2.bin",
            "--dpi-desync-ttl=2",
            "--new"
        ]
    },
    "Strategy 2": {
        "youtube (udp:443)": [
            "--filter-udp=443",
            f"--hostlist-data={','.join(youtube_hosts)}",
            "--dpi-desync=fake",
            "--dpi-desync-repeats=2",
            "--dpi-desync-cutoff=n2",
            "--dpi-desync-fake-quic=./bin/quic_test_00.bin",
            "--new"
        ],
        "youtube (tcp:443) split": [
            "--filter-tcp=443",
            f"--hostlist-data={','.join(youtube_hosts)}",
            "--dpi-desync=split",
            "--dpi-desync-split-pos=1",
            "--dpi-desync-fooling=badseq",
            "--dpi-desync-repeats=10",
            "--dpi-desync-cutoff=d2",
            "--dpi-desync-ttl=4",
            "--new"
        ],
        "youtube (tcp:443) fake,split2": [
            "--filter-tcp=443",
            f"--hostlist-data={','.join(youtube_hosts)}",
            "--dpi-desync=fake,split2",
            "--dpi-desync-split-seqovl=2",
            "--dpi-desync-split-pos=3",
            "--dpi-desync-fake-tls=./bin/tls_clienthello_www_google_com.bin",
            "--dpi-desync-ttl=3",
            "--new"
        ],
        "discord (tcp:80)": [
            "--filter-tcp=80",
            f"--hostlist-data={','.join(discord_hosts)}",
            "--dpi-desync=fake,split2",
            "--dpi-desync-autottl=2",
            "--dpi-desync-fooling=md5sig",
            "--new"
        ],
        "discord (udp:443)": [
            "--filter-udp=443",
            f"--hostlist-data={','.join(discord_hosts)}",
            "--dpi-desync=fake",
            "--dpi-desync-repeats=6",
            "--dpi-desync-fake-quic=./bin/quic_1.bin",
            "--new"
        ],
        "discord (udp:50000-59000)": [
            "--filter-udp=50000-59000",
            "--dpi-desync=fake",
            "--dpi-desync-any-protocol",
            "--dpi-desync-cutoff=d3",
            "--dpi-desync-repeats=6",
            "--new"
        ],
        "discord (tcp:443)": [
            "--filter-tcp=443",
            f"--hostlist-data={','.join(discord_hosts)}",
            "--dpi-desync=split2",
            "--dpi-desync-split-seqovl=652",
            "--dpi-desync-split-pos=2",
            "--dpi-desync-split-seqovl-pattern=./bin/tls_clienthello_2.bin",
            "--new"
        ],
        "other (tcp:443)": [
            "--filter-tcp=443",
            f"--hostlist-data={','.join(other_hosts)}",
            "--dpi-desync=fake,split2",
            "--dpi-desync-split-seqovl=1",
            "--dpi-desync-split-tls=sniext",
            "--dpi-desync-fake-tls=./bin/tls_clienthello_2.bin",
            "--dpi-desync-ttl=2",
            "--new"
        ]
    }
}
class App:
    def __init__(self, master):
        self.master = master
        master.title("winws.exe Launcher")

        # Выбор стратегии
        self.strategy_label = tk.Label(master, text="Выберите стратегию:")
        self.strategy_label.grid(row=0, column=0, sticky="w", padx=10, pady=10)

        self.strategy_var = tk.StringVar(master)
        self.strategy_var.set(list(strategies_and_filters.keys())[0])  # Устанавливаем первую стратегию по умолчанию
        self.strategy_dropdown = ttk.Combobox(master, textvariable=self.strategy_var, values=list(strategies_and_filters.keys()))
        self.strategy_dropdown.grid(row=0, column=1, padx=10, pady=10)
        self.strategy_dropdown.bind("<<ComboboxSelected>>", self.update_filter_list)

        # Выбор фильтров
        self.filter_label = tk.Label(master, text="Выберите фильтры:")
        self.filter_label.grid(row=1, column=0, sticky="nw", padx=10, pady=10)

        self.filter_listbox = tk.Listbox(master, selectmode="multiple", exportselection=0)
        self.filter_listbox.grid(row=1, column=1, padx=10, pady=10)
        self.update_filter_list()  # Изначально заполняем список фильтров для первой стратегии

        # Выбор пути до winws.exe
        self.winws_label = tk.Label(master, text="Путь до winws.exe:")
        self.winws_label.grid(row=2, column=0, sticky="w", padx=10, pady=10)

        self.winws_path_var = tk.StringVar()
        self.winws_path_entry = tk.Entry(master, textvariable=self.winws_path_var, width=40, state="readonly")
        self.winws_path_entry.grid(row=2, column=1, padx=10, pady=10)

        self.winws_browse_button = tk.Button(master, text="Обзор", command=self.browse_winws)
        self.winws_browse_button.grid(row=2, column=2, padx=5, pady=10)

        # Кнопка запуска
        self.run_button = tk.Button(master, text="Запустить", command=self.run_winws)
        self.run_button.grid(row=3, column=1, pady=20)

    def update_filter_list(self, event=None):
        selected_strategy = self.strategy_var.get()
        filters = list(strategies_and_filters[selected_strategy].keys())
        self.filter_listbox.delete(0, tk.END)
        for filter_name in filters:
            self.filter_listbox.insert(tk.END, filter_name)

    def browse_winws(self):
        filename = filedialog.askopenfilename(
            initialdir=".",
            title="Выберите winws.exe",
            filetypes=(("Executable files", "*.exe"), ("all files", "*.*"))
        )
        if filename:
            self.winws_path_var.set(filename)
    def run_winws(self):
        winws_path = self.winws_path_var.get()
        if not winws_path:
            messagebox.showerror("Ошибка", "Не выбран файл winws.exe!")
            return

        if not os.path.exists(winws_path):
            messagebox.showerror("Ошибка", f"Файл не найден: {winws_path}")
            return

        selected_strategy = self.strategy_var.get()
        selected_filters_indices = self.filter_listbox.curselection()
        selected_filters = [self.filter_listbox.get(i) for i in selected_filters_indices]

        if not selected_filters:
            messagebox.showerror("Ошибка", "Не выбраны фильтры!")
            return

        command = [winws_path]
        command.extend(["--wf-tcp=80,443", "--wf-udp=443,50000-59000"])

        for filter_name in selected_filters:
            command.extend(strategies_and_filters[selected_strategy][filter_name])

        # Формируем команду для запуска в cmd.exe с паузой
        cmd_command = ["cmd", "/k", f"{winws_path} {' '.join(command[1:])} && pause"]
        print(f"Running command: {' '.join(cmd_command)}")

        try:
            # Запускаем cmd_command
            process = subprocess.Popen(cmd_command, creationflags=subprocess.CREATE_NEW_CONSOLE, cwd=os.path.dirname(winws_path))
            messagebox.showinfo("Успех", "winws.exe запущен с выбранными фильтрами.")
        except Exception as e:
            messagebox.showerror("Ошибка", f"Не удалось запустить winws.exe:\n{e}")

root = tk.Tk()
app = App(root)
root.mainloop()