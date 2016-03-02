Function Install-OSCNetPSKB
{
	$KBURLs  = 	"http://download.microsoft.com/download/5/E/A/5EA7504B-E2B3-43A1-8279-892E007D50A0/Windows6.1-KB2592525-x64.msu",`
				"http://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.1-KB2506143-x64.msu",`
				"http://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.0-KB2506146-x86.msu",`
				"http://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.0-KB2506146-x64.msu"
	$KBPaths = 	"C:\Users\$env:username\Downloads\Windows6.1-KB2592525-x64.msu",`
				"C:\Users\$env:username\Downloads\Windows6.1-KB2506143-x64.msu",`
				"C:\Users\$env:username\Downloads\Windows6.0-KB2506146-x86.msu",`
				"C:\Users\$env:username\Downloads\Windows6.0-KB2506146-x64.msu"
	#Check the OS version
	switch(GetSystemInfo)
	{
		1 	
		{ 
			InstallNetFx
			InstallKB $KBURLs[0] $KBPaths[0] "KB2592525"
			InstallKB $KBURLs[1] $KBPaths[1] "KB2506143"
		}
		2 	
		{
			InstallNetFx 
			InstallKB $KBURLs[0] $KBPaths[0] "KB2592525"   
			InstallKB $KBURLs[2] $KBPaths[2] "KB2506146"
		}
		3 
		{	
			InstallNetFx 
			InstallKB $KBURLs[0] $KBPaths[0] "KB2592525"   
			InstallKB $KBURLs[3] $KBPaths[3] "KB2506146"
		}
		0 	
		{ 
			Write-Warning "Please run this script on Windows Server 2008 sp2 or 2008 R2"
		}
	}
    
    
}
Function GetSystemInfo
{	
	#This function is to get some information about the current OS
	$SystemInfo = Get-WmiObject -Class "win32_operatingsystem" | Select-Object -Property Caption,CSDVersion,OSArchitecture
	If($SystemInfo.Caption -match "Microsoft Windows Server 2008 R2")
	{
		#If the system version is Windows Server 2008 R2, it will return 1
		Return 1
	}
	Elseif($SystemInfo.Caption -match "Microsoft Windows Server 2008")
	{
		If( $SystemInfo.CSDVersion -match "Service Pack 2")
		{	
			If($SystemInfo.OSArchitecture -match "32-bit")
			{
				#If the system version is Windows Server 2008 SP2(32-bit), it will return 2
				Return 2
			}
			Else 
			{	
				#If the system version is Windows Server 2008 SP2(64-bit), it will return 2
				Return 3
			}
		}
		Else 
		{
			#If it is other version ,it will return 0
			Return 0
		}
	}
	Else
	{
		#If it is other version ,it will return 0
		Return 0
	}
}

Function InstallNetFx
{	
	#This function is to download and install .Net framework 4.5 
	$NetFxURL = "http://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_setup.exe"
	$NetFxPath = "C:\Users\$env:username\Downloads\dotNetFx45_Full_setup.exe"
	#Verify if the .Net Framework 4.5 is installed
 	If((Get-WmiObject -Class "win32_product" | Where-Object {$_.name -match "Microsoft .NET Framework 4.5"}) -eq $null)
	{	
		#Verify if the file exists
        If(Test-Path -Path $NetFxPath)
		{	
			Write-Host "Installing Microsoft .NET Framework 4.5"
			#Install .Net Framework 4.5
			$process = (Start-Process -FilePath $NetFxPath -ArgumentList "/q /norestart" -Wait -Verb RunAs -PassThru)
		}
        Else 
        {	
			#Download .Net Framework 4.5
		    Write-Host "Downloading Microsoft .NET Framework 4.5"
		    $WebClient = New-Object System.Net.WebClient
		    $WebClient.DownloadFile($NetFxURL,$NetFxPath)
		    If(Test-Path -Path $NetFxPath)
		    {	
			    Write-Host "Installing Microsoft .NET Framework 4.5 "
				#Install .Net Framework 4.5
			    $process = (Start-Process -FilePath $NetFxPath -ArgumentList "/q /norestart" -Wait -Verb RunAs -PassThru)
		    }
		    Else
		    {
			    Write-Warning "Failed to download Microsoft .NET Framework 4.5."
		    }
        }
		#Verify if .Net Framework 4.5 is installed successfully
		If(Get-WmiObject -Class "win32_product" | Where-Object {$_.name -match "Microsoft .NET Framework 4.5"})
		{
		 	Write-Host "Install  Microsoft .NET Framework 4.5 Successfully"
		}
		Else 
		{
			Write-Host "Failed to download Microsoft .NET Framework 4.5,you can find it in $$NetFxPath and install it manually."
		}
	}
	Else
	{	
		Write-Host "Microsoft .NET Framework 4.5 has been installed."
	}
}

Function InstallKB($KBURl,$KBPath,$KBId)
{
	#This function is to download and install KB
	#Verify if the specified KB is installed 
	If((Get-HotFix | Where-Object {$_.HotFixId -eq $KBId}) -eq $null )
	{
		#Verify if the file exists
    	If(Test-Path -Path $KBPath)
        {
			#Execute the KB
		    wusa.exe $KBPath /quiet /norestart 
			#Pause PowerShell when insatlling KB
			do
			{
				Start-Sleep -Seconds 10
			}while(Get-Process | Where-Object {$_.name -eq "wusa"})
        }
        Else 
        {
			#Download KB
            Write-Host "Downloading $KBId"
		    $WebClient = New-Object System.Net.WebClient
		    $WebClient.DownloadFile($KBURl,$KBPath)
			#Verify if the file exists
            If(Test-Path -Path $KBPath)
		    {	
                Write-Host "Installing $KBId"
			    wusa.exe $KBPath /quiet /norestart 
			    do
			    {
				    Start-Sleep -Seconds 10
			    }while(Get-Process | Where-Object {$_.name -eq "wusa"})
		    }
		    Else 
		    {
			    Write-Warning "Failed to download $KBId."
		    }
			#Verify if KB is installed successfully
			If(Get-HotFix | Where-Object {$_.HotFixId -eq $KBId} )
			{
				Write-Host "Install $KBId successfully"
			}
			Else 
			{
				Write-Host "Failed to install $KBId,you can find it in $KBPath and install it manually. "
			}		
     
        }
		
	}
	Else
	{
		Write-Host "$KBId has been installed"
	}			
}

Install-OSCNetPSKB