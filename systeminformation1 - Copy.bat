@echo off
setlocal enabledelayedexpansion

::echo Please enter your name:
set username="elfnesh yaya" 
:: echo Please enter your department:
set department="chilote Tsehaf melikit" 
::echo Please enter your Printer Name:
set Printer="No": 


:: Write user details
echo User: %username% >> G:\SystemInfo.txt
echo Department: %department% >> G:\SystemInfo.txt
echo Computer Name: %COMPUTERNAME% >> G:\SystemInfo.txt
echo Computer Name: %Printer% >> G:\SystemInfo.txt
echo. >> G:\SystemInfo.txt

:: Retrieve Serial Number
echo Serial Number: >> G:\SystemInfo.txt
wmic bios get serialnumber | findstr /v "SerialNumber" >> G:\SystemInfo.txt

:: Retrieve System Model and Vendor
echo. >> G:\SystemInfo.txt
echo System Model and Vendor: >> G:\SystemInfo.txt
wmic csproduct get name, vendor | findstr /v "Name Vendor" >> G:\SystemInfo.txt

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
echo. >> G:\SystemInfo.txt
echo Manufacturing Date: %day%/%month%/%year% >> G:\SystemInfo.txt

:: Retrieve OS Information
echo. >> G:\SystemInfo.txt
echo OS Information: >> G:\SystemInfo.txt
wmic os get Caption, Version, BuildNumber | findstr /v "Caption Version BuildNumber" >> G:\SystemInfo.txt

:: Retrieve MAC Address
echo. >> G:\SystemInfo.txt
echo MAC Address: >> G:\SystemInfo.txt
wmic nic where "NetEnabled=true" get MACAddress | findstr /v "MACAddress" >> G:\SystemInfo.txt

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

echo. >> G:\SystemInfo.txt
echo Total Disk Size: %totalSizeFormatted% >> G:\SystemInfo.txt

:: Retrieve Drive Information
echo. >> G:\SystemInfo.txt
echo Drive Information: >> G:\SystemInfo.txt
wmic logicaldisk get DeviceID, VolumeName, Size, FileSystem | findstr /v "DeviceID VolumeName Size FileSystem" >> G:\SystemInfo.txt

:: Retrieve Disk Drive Information
echo. >> G:\SystemInfo.txt
echo Disk Drive Information: >> G:\SystemInfo.txt
wmic diskdrive get Model, MediaType, Manufacturer, Size, InterfaceType | findstr /v "Model MediaType Manufacturer Size InterfaceType" >> G:\SystemInfo.txt

:: Retrieve Installed Printers and Default Printer
echo. >> G:\SystemInfo.txt
echo Installed Printers: >> G:\SystemInfo.txt
wmic printer get Name, Default | findstr /v "Name Default" >> G:\SystemInfo.txt

:: Retrieve MAC Address of network printers
echo. >> G:\SystemInfo.txt
echo Physical Printer MAC Address: >> G:\SystemInfo.txt
for /f "tokens=2 delims=:" %%a in ('arp -a ^| findstr /i "192.168."') do echo %%a >> G:\SystemInfo.txt

echo. >> G:\SystemInfo.txt
echo ----------------------------------- >> G:\SystemInfo.txt
echo. >> G:\SystemInfo.txt

echo Information saved to G:\SystemInfo.txt
pause
