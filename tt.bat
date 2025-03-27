@echo off
echo OS Information: >> f:\systeminfo.txt
echo =================== >> f:\systeminfo.txt

for /f "tokens=1,* delims=" %%a in ('wmic os get caption^,version^,buildnumber^,osarchitecture /format:list') do (
    echo %%a >> E:\systeminfo.txt
)
