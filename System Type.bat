systeminfo | findstr /i "System Type"


wmic os get caption^,version^,buildnumber^,osarchitecture /format:list

wmic memorychip get capacity

wmic os get buildnumber


pause