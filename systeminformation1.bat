@echo off
setlocal enabledelayedexpansion

echo Please enter your name:
set /p username=User: 
:: echo Please enter your department:
set department="chilote Tsehaf" 
echo Please enter your Printer Name:
set /p Printer=Printer: 


:: Write user details
echo User: %username% >> F:\SystemInfo.txt
echo Department: %department% >> F:\SystemInfo.txt
echo Computer Name: %COMPUTERNAME% >> F:\SystemInfo.txt
echo Computer Name: %Printer% >> F:\SystemInfo.txt
echo. >> F:\SystemInfo.txt

:: Retrieve Serial Number
echo Serial Number: >> F:\SystemInfo.txt
wmic bios get serialnumber | findstr /v "SerialNumber" >> F:\SystemInfo.txt

:: Retrieve System Model and Vendor
echo. >> F:\SystemInfo.txt
echo System Model and Vendor: >> F:\SystemInfo.txt
wmic csproduct get name, vendor | findstr /v "Name Vendor" >> F:\SystemInfo.txt

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
echo. >> F:\SystemInfo.txt
echo Manufacturing Date: %day%/%month%/%year% >> F:\SystemInfo.txt

:: Retrieve OS Information
echo. >> F:\SystemInfo.txt
echo OS Information: >> F:\SystemInfo.txt
wmic os get Caption, Version, BuildNumber | findstr /v "Caption Version BuildNumber" >> F:\SystemInfo.txt

:: Retrieve MAC Address
echo. >> F:\SystemInfo.txt
echo MAC Address: >> F:\SystemInfo.txt
wmic nic where "NetEnabled=true" get MACAddress | findstr /v "MACAddress" >> F:\SystemInfo.txt

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

echo. >> F:\SystemInfo.txt
echo Total Disk Size: %totalSizeFormatted% >> F:\SystemInfo.txt

:: Retrieve Drive Information
echo. >> F:\SystemInfo.txt
echo Drive Information: >> F:\SystemInfo.txt
wmic logicaldisk get DeviceID, VolumeName, Size, FileSystem | findstr /v "DeviceID VolumeName Size FileSystem" >> F:\SystemInfo.txt

:: Retrieve Disk Drive Information
echo. >> F:\SystemInfo.txt
echo Disk Drive Information: >> F:\SystemInfo.txt
wmic diskdrive get Model, MediaType, Manufacturer, Size, InterfaceType | findstr /v "Model MediaType Manufacturer Size InterfaceType" >> F:\SystemInfo.txt

:: Retrieve Installed Printers and Default Printer
echo. >> F:\SystemInfo.txt
echo Installed Printers: >> F:\SystemInfo.txt
wmic printer get Name, Default | findstr /v "Name Default" >> F:\SystemInfo.txt

:: Retrieve MAC Address of network printers
echo. >> F:\SystemInfo.txt
echo Physical Printer MAC Address: >> F:\SystemInfo.txt
for /f "tokens=2 delims=:" %%a in ('arp -a ^| findstr /i "192.168."') do echo %%a >> F:\SystemInfo.txt

echo. >> F:\SystemInfo.txt
echo ----------------------------------- >> F:\SystemInfo.txt
echo. >> F:\SystemInfo.txt

echo Information saved to F:\SystemInfo.txt
pause
