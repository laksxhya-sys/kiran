$url = "https://www.cgboardonline.com/cg-board-class-12.html"
Write-Host "Fetching main page..."
$response = Invoke-WebRequest -Uri $url -UseBasicParsing
$html = $response.Content

# Find all links that match biology, chemistry, or physics for 2022 and 2023
$pattern = 'href="(https://www\.cgboardonline\.com/papers/cg-board-class-12-(?:biology|chemistry|physics)-[^"]+(?:2022|2023)\.html)"'
$urlMatches = $html | Select-String -Pattern $pattern -AllMatches | ForEach-Object { $_.Matches }

$downloadedCount = 0

foreach ($match in $urlMatches) {
    $pageUrl = $match.Groups[1].Value
    Write-Host "Fetching $pageUrl..."
    try {
        $pageResponse = Invoke-WebRequest -Uri $pageUrl -UseBasicParsing
        $pageHtml = $pageResponse.Content
        
        if ($pageHtml -match 'href="([^"]+\.pdf)"') {
            $pdfRelUrl = $Matches[1]
            if ($pdfRelUrl -notmatch "^http") {
                $pdfUrl = "https://www.cgboardonline.com/papers/" + $pdfRelUrl.TrimStart('/')
            } else {
                $pdfUrl = $pdfRelUrl
            }
            
            $fileName = [System.IO.Path]::GetFileName($pdfUrl)
            
            if (-not (Test-Path -Path $fileName)) {
                Write-Host "Found PDF: $pdfUrl. Downloading to $fileName..."
                Invoke-WebRequest -Uri $pdfUrl -OutFile $fileName -UseBasicParsing
                Write-Host "Downloaded $fileName successfully."
                $downloadedCount++
            } else {
                Write-Host "File $fileName already exists. Skipping."
            }
        }
    } catch {
        Write-Host "Error processing $pageUrl : $_"
    }
}

Write-Host "Finished all. Downloaded $downloadedCount new files."
