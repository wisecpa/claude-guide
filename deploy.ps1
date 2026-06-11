# 배포 스크립트 — src\index.html을 암호화해 index.html로 만들고 GitHub에 업로드
$ErrorActionPreference = "Stop"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir
if (-not (Test-Path ".sitepass")) {
    Write-Host "비밀번호 파일(.sitepass)이 없습니다. 암호설정.bat을 먼저 실행하세요." -ForegroundColor Yellow
    pause; exit 1
}
$ss = Get-Content ".sitepass" | ConvertTo-SecureString
$env:STATICRYPT_PASSWORD = [Net.NetworkCredential]::new('', $ss).Password

Write-Host "[1/3] 페이지 암호화 중..." -ForegroundColor Cyan
npx -y staticrypt src/index.html -d . --short --remember 30 --template-title "Claude 활용 가이드" --template-instructions "세무회계 현지 내부 페이지입니다. 공용 비밀번호를 입력하세요." --template-button "열기" --template-placeholder "비밀번호" --template-remember "이 기기에서 30일간 기억" --template-color-primary "#1d3357"
$enc = $LASTEXITCODE
$env:STATICRYPT_PASSWORD = $null
if ($enc -ne 0) { Write-Host "암호화 실패 — 인터넷 연결을 확인하세요." -ForegroundColor Red; pause; exit 1 }

Write-Host "[2/3] GitHub 업로드 중..." -ForegroundColor Cyan
$ErrorActionPreference = "Continue"
git add -A
git commit -m "사이트 내용 업데이트"
git push origin main
if ($LASTEXITCODE -ne 0) { Write-Host "업로드 실패 — 네트워크 또는 인증을 확인하세요." -ForegroundColor Red; pause; exit 1 }

Write-Host "[3/3] 완료! 1~2분 후 반영됩니다: https://wisecpa.github.io/claude-guide/" -ForegroundColor Green
pause
