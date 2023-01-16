Add-type -assembly System.Windows.Forms


<#
The four lines below, if run, will download and install WinGet (The Windows Package Manager Plugin for Terminal and Powershell) on a sandbox/windows installation.
To install WinGet, run inside an elevated Microsoft Terminal/PowerShell (Run As Administrator), else you will be prompted to elevate upon running the program.

Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile .\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

winget source uninstall msstore

By default, WinGet attempts to use the Microsoft Store as a source, which requires a microsoft account to be logged in and tracked. Personally not a fan, so I just use the winget source list which needs no log-in.
#>

<# Below are my recommended settings for winget, both for appearences and functionality.
{
    "$schema": "https://aka.ms/winget-settings.schema.json",

    // For documentation on these settings, see: https://aka.ms/winget-settings
    // "source": {
    //    "autoUpdateIntervalInMinutes": 5
    // },
	"visual": {
        "progressBar": "rainbow"
    },
	"installBehavior": {
        "disableInstallNotes": true
    },
	"installBehavior": {
        "preferences": {
            "scope": "machine"
        }
    },
	"installBehavior": {
        "preferences": {
            "architectures": ["x64"]
        }
    },
	"telemetry": {
        "disable": true
    }
}
#>


$UserArrold = @("microsoft.mixedreality.portal","microsoft.windows.narratorquickstart","microsoft.windows.cloudexperiencehost","microsoft.windows.peopleexperiencehost","microsoft.windowsalarms","microsoft.xbox.tcui","microsoft.xboxapp","microsoft.xboxgamecallableUI","microsoft.xboxgameoverlay","microsoft.xboxgamingoverlay","microsoft.xboxidentityprovider","microsoft.xboxspeechtotextoverlay","microsoft.yourphone","microsoft.zunevideo","microsoft.add.brokerplugin","microsoft.microsoftedge";)
#Array for the user to fill with every AppXPackage they want to try and remove.
#The array is pre-populated with some common annoyances I personally just nuke off of windows installations. 
$UserArr = New-Object -typename 'System.Collections.ArrayList'

import-module appx -UseWindowsPowerShell
#Ensures that the terminal has appxpackage access and will respond consistently. Powershell 7 doesn't have native appxsupport, for some reason, but powershell 2/3/5 and command prompt do.

$TempStorage = get-appxpackage | select-object name | sort-object name 
#Grabs all of the Windows Store packages on a system, by the Name value, and sorts them alphabetically. 
#The Name value is a string value associated with the custom object which stores the values of the AppXPackages
#By storing them in an object like this it makes it easier to handle the data later on in the program.
$progArr = New-Object -typename 'System.Collections.ArrayList'
#This is an array to store the strings of Name value data from the AppXPackage collection above.
foreach($string in $TempStorage) {$progarr += $string.Name}
#Stores the AppXPackage Name values into the $progarr array object.
$ThirdPartyArr = New-Object -typename 'System.Collections.ArrayList'
#Array to store all the AppXPackages who's Name indicates that they are developed outside of and/or with no association with Microsoft.
#Examples include AMD GPU Drivers, Realtek audio drivers, and Windows Store applications such as EarTrumpet. 
#Technically this is a way to install/uninstall applications from the windows store, but be cautious about it. Lots of malware and scams on there that are easy to install while looking for a trusted program, and they're harder to spot over terminal.
$MicrosoftArr = New-Object -typename 'System.Collections.ArrayList'
#Array to store all the AppXPackages who's Name begins with "Microsoft."
#These are packages/programs published and developed by Microsoft that are not integral core components to windows and can thus be deleted with caution but seldom catastrophy.
$WindowsArr = New-Object -typename 'System.Collections.ArrayList'
#Array to store all the AppXPackages who's Name begins with "Windows."
#These are packages/programs published and developed by Microsoft that are integral core components to windows. Extreme caution should be taken with editing or deleting these, as they can cause windows to corrupt itself.
#Most of these packages/programs are not a part of the Windows Kernal, but they do cover some very integral features and are not always named to display their purpose.
$MicrosoftWindowsArr = New-Object -typename 'System.Collections.ArrayList'
#Array to store all the AppXPackages who's Name begins with "Microsoft.Windows."
#These are packages/programs published and developed by Microsoft that are integral core components to windows. Extreme caution should be taken with editing or deleting these, as they can cause windows to corrupt itself.
#While almost none of these packages/programs are a part of the Windows Kernal, they do cover very core user features such as the Narrator, CapturePicker (Snip Tool?), Parental Controls, or Calling the Shell. Extreme Caution needed.
#$Int = 0 #DEBUG TOOL

Function sortPackage
{
    $TempStorage = get-appxpackage | select-object name | sort-object name 

    $thirdpartyArr.Clear()
    $microsoftarr.Clear()
    $windowsArr.Clear()
    $microsoftWindowsArr.Clear()

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
                        $microsoftWindowsArr.add($string); #write-output "Microsoft.windows Added"
                    }
                    else
                    {
                        $microsoftarr.add($string); #Write-output "Microsoft Added"
                    }
                }
                else 
                {
                    $microsoftarr.add($string); #Write-output "Microsoft Added"
                }
            }
            elseif($string.substring(0,8) -eq "Windows.")
            {
                $windowsArr.add($string); #write-output "Windows Added"
            }
            elseif($string.substring(0,17) -eq "MicrosoftWindows.")
            {
                $microsoftwindowsarr.add($string); #write-output "MicrosoftWindows Added"
            }
            else 
            {
                $thirdpartyArr.add($string); #write-output "Third Party Added"
            }; 
        }
        else 
        {
            $thirdpartyArr.add($string); #write-output "Third Party Added"
        }; 
        $int++
    }
}


#ForEach Loop that sorts all the Names into their associated category 
#Once the Name values are sorted, the user can be given a new list of these AppXPackages grouped together by their likely source and how cautious they should be when fiddling with it.

$font = New-Object System.Drawing.Font("Lucida Console",11,[System.Drawing.FontStyle]::Regular)

$form = new-object System.Windows.Forms.Form
$form.text = "Windows Bloatware Removal Tool V 0.8"
$form.width = 1700
$form.height = 800
$form.autosize = $true
$form.startposition = "CenterScreen"

$button1 = new-object System.Windows.Forms.Button
$button1.location = new-object system.drawing.size(10, 10)
$button1.size = new-object system.drawing.size(180,40)
$button1.text = "Check Windows AppXPackages"
$button1.font = New-Object System.Drawing.Font("Lucida Console", 16, [System.Drawing.FontStyle]::Regular)
$button1.autosize = $true

$button1_Click = 
{
    $label1.text = "Compiling your list."

    $checkedlistbox.Items.Clear()
    $CheckedListBox.Items.Add("Select All") > $null
    $checkedlistbox2.Items.Clear()
    $CheckedListBox2.Items.Add("Select All") > $null
    $checkedlistbox3.Items.Clear()
    $CheckedListBox3.Items.Add("Select All") > $null
    $checkedlistbox4.Items.Clear()
    $CheckedListBox4.Items.Add("Select All") > $null

    sortPackage

    $checkedListBox.Items.addrange($thirdpartyArr)
    $checkedlistbox2.Items.addrange($microsoftarr)
    $checkedlistbox3.Items.addrange($windowsArr)
    $checkedlistbox4.Items.AddRange($MicrosoftWindowsArr)

    $label1.text = "Compilation complete."
}
$button1.add_click($button1_Click)
$form.Controls.add($button1)

$label1 = new-object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(10,60)
$label1.text = "List is empty"
$label1.autosize = $true
$label1.font = $font
$form.controls.add($label1)

$label_X = 10
$label_Y = 110

$label2 = new-object System.Windows.Forms.Label
$label2.Location = new-object System.drawing.point($label_X, $label_Y)
$label2.text = "Third Party Packages"
$label2.autosize = $true
$label2.font = $font
$form.Controls.add($label2)

$label3 = new-object System.Windows.Forms.Label
$label3.Location = new-object System.drawing.point((410 + $label_X), $label_Y)
$label3.text = "Microsoft Packages"
$label3.autosize = $true
$label3.font = $font
$form.Controls.add($label3)

$label4 = new-object System.Windows.Forms.Label
$label4.Location = new-object System.drawing.point((820 + $label_X), $label_Y)
$label4.text = "Windows Packages"
$label4.autosize = $true
$label4.font = $font
$form.Controls.add($label4)

$label5 = new-object System.Windows.Forms.Label
$label5.Location = new-object System.drawing.point((1230 + $label_X), $label_Y)
$label5.text = "Microsoft Windows Packages"
$label5.autosize = $true
$label5.font = $font
$form.Controls.add($label5)

$check_click = 
{
If($this.selecteditem -eq 'Select All')
    {
        If ($This.GetItemCheckState(0) -ne 'Checked')
        {
            For($i=1;$i -lt $CheckedListBox.Items.Count; $i++)
            {
                $CheckedListBox.SetItemChecked($i,$true)
            }            
        }
        Else
        {
            For($i=1;$i -lt $CheckedListBox.Items.Count; $i++)
            {
                $CheckedListBox.SetItemChecked($i,$False)
            } 
        }
    }
}
$checkedListBox = new-object System.Windows.Forms.CheckedListBox  
$checkedlistbox.location = new-object system.drawing.size(10,140)
$checkedlistbox.size = new-object system.drawing.size(400, 250) 
$checkedlistbox.font = $font
$checkedlistbox.checkonclick = $true #So we only have to click once to check a box, rather than click to focus and then click to check
$CheckedListBox.Items.Add("Select All") > $null
$checkedlistbox.clearselected()

$CheckedListBox.Add_click($check_click)
$form.Controls.add($checkedlistbox)

$CheckListBox_X = $checkedlistbox.Location.X 
$CheckListBox_Y = $checkedlistbox.Location.Y

$check_click2 = 
{
If($this.selecteditem -eq 'Select All')
    {
        If ($This.GetItemCheckState(0) -ne 'Checked')
        {
            For($i=1;$i -lt $CheckedListBox2.Items.Count; $i++)
            {
                $CheckedListBox2.SetItemChecked($i,$true)
            }            
        }
        Else
        {
            For($i=1;$i -lt $CheckedListBox2.Items.Count; $i++)
            {
                $CheckedListBox2.SetItemChecked($i,$False)
            } 
        }
    }
}
$checkedListBox2 = new-object System.Windows.Forms.CheckedListBox  
$checkedlistbox2.location = new-object system.drawing.size((410 + $checklistbox_x), $checklistbox_y)
$checkedlistbox2.size = new-object system.drawing.size(400, 250) 
$checkedlistbox2.font = $font
$checkedlistbox2.checkonclick = $true #So we only have to click once to check a box, rather than click to focus and then click to check
$CheckedListBox2.Items.Add("Select All") > $null
$checkedlistbox2.clearselected()

$CheckedListBox2.Add_click($check_click2)
$form.Controls.add($checkedlistbox2)

$check_click3 = 
{
If($this.selecteditem -eq 'Select All')
    {
        If ($This.GetItemCheckState(0) -ne 'Checked')
        {
            For($i=1;$i -lt $CheckedListBox3.Items.Count; $i++)
            {
                $CheckedListBox3.SetItemChecked($i,$true)
            }            
        }
        Else
        {
            For($i=1;$i -lt $CheckedListBox3.Items.Count; $i++)
            {
                $CheckedListBox3.SetItemChecked($i,$False)
            } 
        }
    }
}
$checkedListBox3 = new-object System.Windows.Forms.CheckedListBox  
$checkedlistbox3.location = new-object system.drawing.size((820 + $checklistbox_x), $checklistbox_y)
$checkedlistbox3.size = new-object system.drawing.size(400, 250) 
$checkedlistbox3.font = $font
$checkedlistbox3.checkonclick = $true #So we only have to click once to check a box, rather than click to focus and then click to check
$CheckedListBox3.Items.Add("Select All") > $null
$checkedlistbox3.clearselected()

$CheckedListBox3.Add_click($check_click3)
$form.Controls.add($checkedlistbox3)

$check_click4 = 
{
If($this.selecteditem -eq 'Select All')
    {
        If ($This.GetItemCheckState(0) -ne 'Checked')
        {
            For($i=1;$i -lt $CheckedListBox4.Items.Count; $i++)
            {
                $CheckedListBox4.SetItemChecked($i,$true)
            }            
        }
        Else
        {
            For($i=1;$i -lt $CheckedListBox4.Items.Count; $i++)
            {
                $CheckedListBox4.SetItemChecked($i,$False)
            } 
        }
    }
}
$checkedListBox4 = new-object System.Windows.Forms.CheckedListBox  
$checkedlistbox4.location = new-object system.drawing.size((1230 + $checklistbox_x),$checklistbox_y)
$checkedlistbox4.size = new-object system.drawing.size(450, 250) 
$checkedlistbox4.font = $font
$checkedlistbox4.checkonclick = $true #So we only have to click once to check a box, rather than click to focus and then click to check
$CheckedListBox4.Items.Add("Select All") > $null
$checkedlistbox4.clearselected()

$CheckedListBox4.Add_click($check_click4)
$form.Controls.add($checkedlistbox4)

$button2 = new-object System.Windows.Forms.Button
$button2.location = new-object System.drawing.size(10, 400)
$button2.text = "Update Items inside User List"
$button2.autosize = $true
$button2.font = New-Object System.Drawing.Font("Lucida Console", 16, [System.Drawing.FontStyle]::Regular)


$button2_click = 
{
    $UserArr.clear()    

    foreach($arg in $checkedListBox.CheckedItems)
    {
        $userarr.add($arg)
    }
    foreach($arg2 in $checkedListBox2.CheckedItems)
    {
        $userarr.add($arg2)
    }
    foreach($arg3 in $checkedListBox3.CheckedItems)
    {
        $userarr.add($arg3)
    }
    foreach($arg4 in $checkedListBox4.CheckedItems)
    {
        $userarr.add($arg4)
    }

    $userarr.remove("Select All")

    #write-host $UserArr
}

$button2.add_click($button2_click)
$form.Controls.add($button2)

$checkbox = new-object System.Windows.Forms.CheckBox
$checkbox.location = new-object system.drawing.size(455, 450)
$checkbox.size = new-object system.drawing.size(150, 50)
$checkbox.text = "Ready to Delete selected packages?"
$checkbox.tabindex = 4
$checkbox.font = $font
$checkbox.autosize = $true

$form.Controls.add($checkbox)

$button3 = new-object system.windows.forms.button
$button3.text = "DELETE"
$button3.location = new-object system.drawing.size(800, 550)
$button3.size = new-object system.drawing.size(150,150)
$button3.AutoSize = $true
$button3.font = New-Object System.Drawing.Font("Lucida Console", 16, [System.Drawing.FontStyle]::Bold)

$button3_click = 
{
    if($checkbox.checked -eq $true)
    {
        foreach($string in $UserArr) {get-appxpackage *$string* | remove-appxpackage}
    }
    else 
    {
        foreach($string in $UserArr) {write-host "get-appxpackage *$string* | remove-appxpackage"}
    }
}
#This is the line that actually removes all the selected programs.
#Not every program is removable, some will throw errors. Don't freak out. 
#To actually remove each program, remove "Write-Host" and the '"' from the body of the method.
#If you see a progress bar when a line is run, that program was removed. 
$button3.add_click($button3_click)
$form.controls.add($button3)

$form.topmost = $true
$form.showdialog();
