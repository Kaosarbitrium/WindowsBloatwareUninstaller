import-module appx -UseWindowsPowerShell
#Ensures that the terminal has appxpackage access and will respond consistently. Powershell 7 doesn't have native appxsupport, for some reason, but powershell 2/3/5 and command prompt do.

$temp = get-appxpackage | select-object name | sort-object name 
#Grabs all of the Windows Store packages on a system, by the Name value, and sorts them alphabetically. 
#The Name value is a string value associated with the custom object which stores the values of the AppXPackages
#By storing them in an object like this it makes it easier to handle the data later on in the program.
$progArr = @()
#This is an array to store the strings of Name value data from the AppXPackage collection above.
foreach($string in $temp) {$progarr += $string.Name}
#Stores the AppXPackage Name values into the $progarr array object.
$ThirdPartyArr = @()
#Array to store all the AppXPackages who's Name indicates that they are developed outside of and/or with no association with Microsoft.
#Examples include AMD GPU Drivers, Realtek audio drivers, and Windows Store applications such as EarTrumpet. 
#Technically this is a way to install/uninstall applications from the windows store, but be cautious about it. Lots of malware and scams on there that are easy to install while looking for a trusted program, and they're harder to spot over terminal.
$MicrosoftArr = @()
#Array to store all the AppXPackages who's Name begins with "Microsoft."
#These are packages/programs published and developed by Microsoft that are not integral core components to windows and can thus be deleted with caution but seldom catastrophy.
$WindowsArr = @()
#Array to store all the AppXPackages who's Name begins with "Windows."
#These are packages/programs published and developed by Microsoft that are integral core components to windows. Extreme caution should be taken with editing or deleting these, as they can cause windows to corrupt itself.
#Most of these packages/programs are not a part of the Windows Kernal, but they do cover some very integral features and are not always named to display their purpose.
$MicrosoftWindowsArr = @()
#Array to store all the AppXPackages who's Name begins with "Microsoft.Windows."
#These are packages/programs published and developed by Microsoft that are integral core components to windows. Extreme caution should be taken with editing or deleting these, as they can cause windows to corrupt itself.
#While almost none of these packages/programs are a part of the Windows Kernal, they do cover very core user features such as the Narrator, CapturePicker (Snip Tool?), Parental Controls, or Calling the Shell. Extreme Caution needed.
#$Int = 0 #DEBUG TOOL
foreach($string in $progarr)
{
    #"Index number: $int  $string ";
    if($string.length -gt 10) 
    {
        if($string.substring(0,10) -eq "Microsoft.") 
        {
            if($string.length -gt 18) 
            {
               if($string.substring(0,18) -eq "Microsoft.Windows.")
                {
                    $microsoftWindowsArr += $string; #write-output "Microsoft.windows Added"
                }
                else
                {
                    $microsoftarr += $string; #Write-output "Microsoft Added"
                }
            }
            else 
            {
                $microsoftarr += $string; #Write-output "Microsoft Added"
            }
        }
        elseif($string.substring(0,8) -eq "Windows.")
        {
            $windowsArr += $string; #write-output "Windows Added"
        }
        elseif($string.substring(0,17) -eq "MicrosoftWindows.")
        {
            $microsoftwindowsarr += $string; #write-output "MicrosoftWindows Added"
        }
        else 
        {
            $thirdpartyArr += $string; #write-output "Third Party Added"
        }; 
    }
    else 
    {
        $thirdpartyArr += $string; #write-output "Third Party Added"
    }; 
    $int++
}
#ForEach Loop that sorts all the Names into their associated category 
#Once the Name values are sorted, the user can be given a new list of these AppXPackages grouped together by their likely source and how cautious they should be when fiddling with it.

$UserArr = @("microsoft.mixedreality.portal","microsoft.windows.narratorquickstart","microsoft.windows.cloudexperiencehost","microsoft.windows.peopleexperiencehost","microsoft.windowsalarms","microsoft.xbox.tcui","microsoft.xboxapp","microsoft.xboxgamecallableUI","microsoft.xboxgameoverlay","microsoft.xboxgamingoverlay","microsoft.xboxidentityprovider","microsoft.xboxspeechtotextoverlay","microsoft.yourphone","microsoft.zunevideo","microsoft.add.brokerplugin","microsoft.microsoftedge";)
#Array for the user to fill with every AppXPackage they want to try and remove.
#The array is pre-populated with some common annoyances I personally just nuke off of windows installations. 


foreach($string in $UserArr) {write-host "get-appxpackage *$string* | remove-appxpackage"}
#A foreach loop to remove an array of AppXPackages. The user can fill the UserArr with every AppXPackage they want to be rid of, uncomment this line, and run to clean up their system.
#This is the line that actually removes all the selected programs.
#Not every program is removable, some will throw errors. Don't freak out. 
#To actually remove each program, remove "Write-Host" and the '"' from the body of the method.
#If you see a progress bar when a line is run, that program was removed. 
