@echo off
setlocal enabledelayedexpansion

echo Please enter your name:
set /p username=User: 
echo Please enter your department:
set /p department=Department: 
echo Please enter your Printer Name:
set /p Printer=Printer: 


:: Write user details
echo User: %username% >> D:\SystemInfo.txt
echo Department: %department% >> D:\SystemInfo.txt
echo Computer Name: %COMPUTERNAME% >> D:\SystemInfo.txt
echo Computer Name: %Printer% >> D:\SystemInfo.txt
echo. >> D:\SystemInfo.txt

:: Retrieve Serial Number
echo Serial Number: >> D:\SystemInfo.txt
wmic bios get serialnumber | findstr /v "SerialNumber" >> D:\SystemInfo.txt

:: Retrieve System Model and Vendor
echo. >> D:\SystemInfo.txt
echo System Model and Vendor: >> D:\SystemInfo.txt
wmic csproduct get name, vendor | findstr /v "Name Vendor" >> D:\SystemInfo.txt

:: Get BIOS Release Date and Format it (DD/MM/YYYY)
for /f "skip=1 delims=" %%A in ('wmic bios get ReleaseDate') do (
    set rawdate=%%A
    goto :format_date
)

:format_date
set rawdate=%rawdate:~0,8%
set year=%rawdate:~0,4%
set month=%rawdate:~4,2%
set day=%rawdate:~6,2%
echo. >> D:\SystemInfo.txt
echo Manufacturing Date: %day%/%month%/%year% >> D:\SystemInfo.txt

:: Retrieve OS Information
echo. >> D:\SystemInfo.txt
echo OS Information: >> D:\SystemInfo.txt
wmic os get Caption, Version, BuildNumber | findstr /v "Caption Version BuildNumber" >> D:\SystemInfo.txt

:: Retrieve MAC Address
echo. >> D:\SystemInfo.txt
echo MAC Address: >> D:\SystemInfo.txt
wmic nic where "NetEnabled=true" get MACAddress | findstr /v "MACAddress" >> D:\SystemInfo.txt

:: Retrieve and Sum Up Total Disk Size
set totalSize=0
for /f "skip=1 delims=" %%A in ('wmic diskdrive get Size') do (
    set size=%%A
    if not "!size!"=="" (
        set /a totalSize+=!size!
    )
)

:: Convert Bytes to GB or TB
set /a totalGB=totalSize/1073741824
if %totalGB% LSS 1024 (
    set totalSizeFormatted=%totalGB% GB
) else (
    set /a totalTB=totalGB/1024
    set totalSizeFormatted=%totalTB% TB
)

echo. >> D:\SystemInfo.txt
echo Total Disk Size: %totalSizeFormatted% >> D:\SystemInfo.txt

:: Retrieve Drive Information
echo. >> D:\SystemInfo.txt
echo Drive Information: >> D:\SystemInfo.txt
wmic logicaldisk get DeviceID, VolumeName, Size, FileSystem | findstr /v "DeviceID VolumeName Size FileSystem" >> D:\SystemInfo.txt

:: Retrieve Disk Drive Information
echo. >> D:\SystemInfo.txt
echo Disk Drive Information: >> D:\SystemInfo.txt
wmic diskdrive get Model, MediaType, Manufacturer, Size, InterfaceType | findstr /v "Model MediaType Manufacturer Size InterfaceType" >> D:\SystemInfo.txt

:: Retrieve Installed Printers and Default Printer
echo. >> D:\SystemInfo.txt
echo Installed Printers: >> D:\SystemInfo.txt
wmic printer get Name, Default | findstr /v "Name Default" >> D:\SystemInfo.txt

:: Retrieve MAC Address of network printers
echo. >> D:\SystemInfo.txt
echo Physical Printer MAC Address: >> D:\SystemInfo.txt
for /f "tokens=2 delims=:" %%a in ('arp -a ^| findstr /i "192.168."') do echo %%a >> D:\SystemInfo.txt

echo. >> D:\SystemInfo.txt
echo ----------------------------------- >> D:\SystemInfo.txt
echo. >> D:\SystemInfo.txt

echo Information saved to D:\SystemInfo.txt
pause
