import-module appx -UseWindowsPowerShell
$progarr = "microsoft.mixedreality.portal","microsoft.windows.narratorquickstart","microsoft.windows.cloudexperiencehost","microsoft.windows.peopleexperiencehost","microsoft.windowsalarms","microsoft.xbox.tcui","microsoft.xboxapp","microsoft.xboxgamecallableUI","microsoft.xboxgameoverlay","microsoft.xboxgamingoverlay","microsoft.xboxidentityprovider","microsoft.xboxspeechtotextoverlay","microsoft.yourphone","microsoft.zunevideo","microsoft.add.brokerplugin","microsoft.microsoftedge";
#This is a list of appx programs that come with windows that detract and bloat the experience. This list is not all encompasing. Edit as needed.
get-appxpackage | Select-Object name | Sort-Object name
#This will list all the appxpackages (Windows Store Apps) installed on the PC. Use this to add/remove things from the list as needed.

foreach($string in $progarr) {write-host "get-appxpackage *$string* | remove-appxpackage"}
#This is the line that actually removes all the selected programs.
#Not every program is removable, some will throw errors. Don't freak out. 
#To actually remove each program, remove "Write-Host" and the '"' from the body of the method.
#If you see a progress bar when a line is run, that program was removed. 
