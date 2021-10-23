Function Get-Folder($initialDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    } else {
        return ""
    }
    return $folder
}
function Get-FileName {  
    [CmdletBinding()]  
    Param (   
        [Parameter(Mandatory = $false)]  
        [string]$WindowTitle = 'Open File',

        [Parameter(Mandatory = $false)]
        [string]$InitialDirectory,  

        [Parameter(Mandatory = $false)]
        [string]$Filter = "All files (*.*)|*.*",

        [switch]$AllowMultiSelect
    ) 
    Add-Type -AssemblyName System.Windows.Forms

    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title  = $WindowTitle
    $openFileDialog.Filter = $Filter
    $openFileDialog.CheckFileExists = $true
    if (![string]::IsNullOrWhiteSpace($InitialDirectory)) { $openFileDialog.InitialDirectory = $InitialDirectory }
    if ($AllowMultiSelect) { $openFileDialog.MultiSelect = $true }

    if ($openFileDialog.ShowDialog().ToString() -eq 'OK') {
        if ($AllowMultiSelect) { 
            $selected = @($openFileDialog.Filenames)
        } 
        else { 
            $selected = $openFileDialog.Filename
        }
    }
    # clean-up
    $openFileDialog.Dispose()

    return $selected
}
function Show-Menu
{
    param (
        [string]$Title = 'My Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Pour transformer des image en jpg compresse"
    Write-Host "Q: Press 'Q' to quit."
}


do
 {
     Show-Menu
     $selection = Read-Host "Faire un choix"
     switch ($selection)
     {
         '1' {
          
            
            $folderPath =  Get-Folder
            $newFolderPath= $folderPath+"\Compressed"
            rm -r  $newFolderPath; mkdir  $newFolderPath
            squoosh-cli --mozjpeg '{"quality":75,"baseline":false,"arithmetic":false,"progressive":true,"optimize_coding":true,"smoothing":0,"color_space":3,"quant_table":3,"trellis_multipass":false,"trellis_opt_zero":false,"trellis_opt_table":false,"trellis_loops":1,"auto_subsample":true,"chroma_subsample":2,"separate_chroma_quality":false,"chroma_quality":75}' -d $newFolderPath $folderPath
            start $newFolderPath
         } '2' {
            [System.Console]::Beep(196,1200);
            [System.Console]::Beep(196,300);
            [System.Console]::Beep(220,400);
            [System.Console]::Beep(196,400);
            [System.Console]::Beep(174,300);
            [System.Console]::Beep(155,1000);
            [System.Console]::Beep(146,1000);
            [System.Console]::Beep(196,1000);
            [System.Console]::Beep(196,300);
            [System.Console]::Beep(220,400);
            [System.Console]::Beep(196,400);
            [System.Console]::Beep(174,300);
            [System.Console]::Beep(155,400);
            [System.Console]::Beep(174,300);
         } '3' {
             'You chose option #3'
         }
     }
     pause
 }
 until ($selection -eq 'q')

