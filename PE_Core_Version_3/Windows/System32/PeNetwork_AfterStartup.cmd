Title=[PeNetwork After Startup]
Color 1F
@Echo off

:: Broadcast %ComputerName% Environnement variable
BroadcastEnvChange.exe /broadcast SendMessageTimeout

Netsh WLan add profile filename="X:\Program Files\PENetwork_x64\WifiProfiles\SSIDProfile.xml" user=all
Netsh WLan set profileparameter name=SSIDProfile connectionmode=auto
Exit
