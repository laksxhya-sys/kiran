$urls = @(
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-s-262203-803-a-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-s-262203-803-b-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-s-262203-803-c-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-s-262202-a-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-s-262202-b-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-s-262202-c-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-physics-s-262201-a-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-physics-s-262201-b-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-physics-s-262201-c-2026.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-i252203-803-a-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-i252203-803-b-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-i252203-803-c-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-i252202-a-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-i252202-b-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-i252202-c-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-physics-i252201-a-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-physics-i252201-b-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-physics-i252201-c-2025.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-l-242203-803-a-2024.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-l-242203-803-b-2024.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-biology-l-242203-803-c-2024.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-l-242202-a-2024.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-l-242202-b-2024.html",
    "https://www.cgboardonline.com/papers/cg-board-class-12-chemistry-l-242202-c-2024.html"
)

foreach ($url in $urls) {
    Write-Host "Fetching $url..."
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        $html = $response.Content
        
        # Look for PDF links
        if ($html -match 'href="([^"]+\.pdf)"') {
            $pdfRelUrl = $matches[1]
            if ($pdfRelUrl -notmatch "^http") {
                $pdfUrl = "https://www.cgboardonline.com/papers/" + $pdfRelUrl.TrimStart('/')
            } else {
                $pdfUrl = $pdfRelUrl
            }
            
            $fileName = [System.IO.Path]::GetFileName($pdfUrl)
            Write-Host "Found PDF: $pdfUrl. Downloading to $fileName..."
            
            Invoke-WebRequest -Uri $pdfUrl -OutFile $fileName -UseBasicParsing
            Write-Host "Downloaded $fileName successfully."
        } else {
            Write-Host "No PDF link found on $url."
        }
    } catch {
        Write-Host "Error processing $url : $_"
    }
}
Write-Host "Finished all."
