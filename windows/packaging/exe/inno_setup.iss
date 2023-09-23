[Setup]
AppId=75776274-AEA9-436F-AD4D-CF21DA3FB689
AppVersion=0.7.2+3
AppName=Sphia
AppPublisher=YukidouSatoru
AppPublisherURL=https://github.com/YukidouSatoru/sphia
AppSupportURL=https://github.com/YukidouSatoru/sphia
AppUpdatesURL=https://github.com/YukidouSatoru/sphia
DefaultDirName=Sphia
DisableProgramGroupPage=yes
OutputDir=.
OutputBaseFilename=sphia-windows
Compression=lzma
SolidCompression=yes
SetupIconFile=..\..\assets\app_icon.ico
WizardStyle=modern
PrivilegesRequired=none
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce
Name: "launchAtStartup"; Description: "{cm:AutoStartProgram,Sphia}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
[Files]
Source: "sphia-windows_exe\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\Sphia"; Filename: "{app}\sphia.exe"
Name: "{autodesktop}\Sphia"; Filename: "{app}\sphia.exe"; Tasks: desktopicon
Name: "{userstartup}\Sphia"; Filename: "{app}\sphia.exe"; WorkingDir: "{app}"; Tasks: launchAtStartup
[Run]
Filename: "{app}\sphia.exe"; Description: "{cm:LaunchProgram,Sphia}"; Flags:  nowait postinstall skipifsilent