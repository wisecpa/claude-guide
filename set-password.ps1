# 사이트 공용 비밀번호 설정 — DPAPI로 이 PC/계정에만 암호화 저장됩니다 (채팅·파일에 평문 저장 안 함)
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host ""
Write-Host "=== Claude 활용 가이드 — 사이트 비밀번호 설정 ===" -ForegroundColor Cyan
Write-Host "직원들이 사이트 접속 시 입력할 공용 비밀번호를 정해주세요. (4자 이상)"
Write-Host ""
while ($true) {
    $p1 = Read-Host "사이트 비밀번호 입력" -AsSecureString
    $p2 = Read-Host "비밀번호 다시 입력(확인)" -AsSecureString
    $a = [Net.NetworkCredential]::new('', $p1).Password
    $b = [Net.NetworkCredential]::new('', $p2).Password
    if ($a.Length -ge 4 -and ($a -ceq $b)) { break }
    Write-Host "비밀번호가 4자 미만이거나 서로 다릅니다. 다시 입력해주세요." -ForegroundColor Yellow
}
$p1 | ConvertFrom-SecureString | Set-Content (Join-Path $dir ".sitepass")
Write-Host ""
Write-Host "저장 완료! 이 창은 닫아도 됩니다." -ForegroundColor Green
Start-Sleep -Seconds 3
