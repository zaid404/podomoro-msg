@echo off
setlocal enabledelayedexpansion

REM Inisialisasi variabel
set tasks=
set /p task="Tuliskan tugas Anda (ketik 'selesai' untuk keluar): "
set /p priority="Tentukan prioritas tugas (1-10): "
set /p schedule="Tentukan jadwal tugas (hh:mm): "
set alarm=%schedule%

REM Loop untuk memasukkan tugas-tugas
:loop
if /i "%task%"=="selesai" goto finish
set tasks=!tasks!%task% [Prioritas: %priority%] [Jadwal: %schedule%]
set /p task="Masukkan tugas selanjutnya (ketik 'selesai' untuk keluar): "
set /p priority="Tentukan prioritas tugas (1-10): "
set /p schedule="Tentukan jadwal tugas (hh:mm): "
set alarm=%schedule%
goto loop

REM Selesai, menyimpan tugas dalam file teks
:finish
echo %tasks% > tasks.txt & echo. >> tasks.txt
echo Tugas-tugas Anda telah disimpan dalam file tasks.txt.

REM Menggunakan Teknik Pomodoro dengan pengingat setiap 25 menit
echo Teknik Pomodoro telah diterapkan. Mulai tugas Anda sekarang!
set jumlah_sesi=0
set target_sesi=4
set waktu_pomodoro=25
set waktu_istirahat=5

:start_pomodoro
set /a jumlah_sesi+=1
echo Mulai sesi Pomodoro #%jumlah_sesi%
msg * /time:5 "Mulai sesi Pomodoro #%jumlah_sesi%"

REM Hitung waktu pomodoro
:countdown_pomodoro
if %total_waktu% geq %waktu_pomodoro% goto istirahat
echo Waktu pomodoro tersisa: %waktu_pomodoro% menit
timeout /t 60 /nobreak >nul
set /a total_waktu+=1
set /a waktu_pomodoro-=1

REM Cek apakah sudah 25 menit, jika iya, tampilkan pesan peringatan
if %total_waktu% equ 25 (
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Sudah 25 menit, istirahat sejenak!','Pengingat Pomodoro')"
)

goto countdown_pomodoro

:istirahat
echo Sesi Pomodoro #%jumlah_sesi% selesai. Waktu istirahat dimulai.
msg * /time:5 "Sesi Pomodoro #%jumlah_sesi% selesai, Waktu istirahat dimulai.."
set total_waktu=0

REM Hitung waktu istirahat
:countdown_istirahat
if %total_waktu% geq %waktu_istirahat% goto next_pomodoro
echo Waktu istirahat tersisa: %waktu_istirahat% menit
timeout /t 60 /nobreak >nul
set /a total_waktu+=1
set /a waktu_istirahat-=1
goto countdown_istirahat

:next_pomodoro
if %jumlah_sesi% lss %target_sesi% goto start_pomodoro

REM Semua sesi Pomodoro selesai
echo Semua sesi Pomodoro selesai. Selamat!
msg * /time:5 "Semua sesi Pomodoro selesai Selamat!"
goto end

:end
echo Waktu untuk istirahat!
timeout /t 300 /nobreak >nul
echo Waktu untuk kembali bekerja!
timeout /t 300 /nobreak >nul
goto end
