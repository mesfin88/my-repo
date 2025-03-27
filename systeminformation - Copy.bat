@echo off
setlocal enabledelayedexpansion

echo Please enter your name:
set /p username=User: 
echo Please enter your department:
set /p department=Department: 
echo Please enter your Printer Name:
set /p Printer=Printer: 


:: Write user details
echo User: %username% >> I:\SystemInfo.txt
echo Department: %department% >> I:\SystemInfo.txt
echo Computer Name: %COMPUTERNAME% >> I:\SystemInfo.txt
echo Computer Name: %Printer% >> I:\SystemInfo.txt
echo. >> I:\SystemInfo.txt

:: Retrieve Serial Number
echo Serial Number: >> I:\SystemInfo.txt
wmic bios get serialnumber | findstr /v "SerialNumber" >> I:\SystemInfo.txt

:: Retrieve System Model and Vendor
echo. >> I:\SystemInfo.txt
echo System Model and Vendor: >> I:\SystemInfo.txt
wmic csproduct get name, vendor | findstr /v "Name Vendor" >> I:\SystemInfo.txt

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
echo. >> I:\SystemInfo.txt
echo Manufacturing Date: %day%/%month%/%year% >> I:\SystemInfo.txt

:: Retrieve OS Information
echo. >> I:\SystemInfo.txt
echo OS Information: >> I:\SystemInfo.txt
wmic os get Caption, Version, BuildNumber | findstr /v "Caption Version BuildNumber" >> I:\SystemInfo.txt

:: Retrieve MAC Address
echo. >> I:\SystemInfo.txt
echo MAC Address: >> I:\SystemInfo.txt
wmic nic where "NetEnabled=true" get MACAddress | findstr /v "MACAddress" >> I:\SystemInfo.txt

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

echo. >> I:\SystemInfo.txt
echo Total Disk Size: %totalSizeFormatted% >> I:\SystemInfo.txt

:: Retrieve Drive Information
echo. >> I:\SystemInfo.txt
echo Drive Information: >> I:\SystemInfo.txt
wmic logicaldisk get DeviceID, VolumeName, Size, FileSystem | findstr /v "DeviceID VolumeName Size FileSystem" >> I:\SystemInfo.txt

:: Retrieve Disk Drive Information
echo. >> I:\SystemInfo.txt
echo Disk Drive Information: >> I:\SystemInfo.txt
wmic diskdrive get Model, MediaType, Manufacturer, Size, InterfaceType | findstr /v "Model MediaType Manufacturer Size InterfaceType" >> I:\SystemInfo.txt

:: Retrieve Installed Printers and Default Printer
echo. >> I:\SystemInfo.txt
echo Installed Printers: >> I:\SystemInfo.txt
wmic printer get Name, Default | findstr /v "Name Default" >> I:\SystemInfo.txt

:: Retrieve MAC Address of network printers
echo. >> I:\SystemInfo.txt
echo Physical Printer MAC Address: >> I:\SystemInfo.txt
for /f "tokens=2 delims=:" %%a in ('arp -a ^| findstr /i "192.168."') do echo %%a >> I:\SystemInfo.txt

echo. >> I:\SystemInfo.txt
echo ----------------------------------- >> I:\SystemInfo.txt
echo. >> I:\SystemInfo.txt

echo Information saved to I:\SystemInfo.txt
pause
