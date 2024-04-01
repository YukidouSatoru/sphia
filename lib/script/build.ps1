Write-Host "Installing flutter_distributor"
dart pub global activate flutter_distributor
$env:PATH += ";C:\Users\user\AppData\Roaming\Pub\Cache\bin"

Write-Host "Updating sphiaLastCommitHash"
$commitHash = git rev-parse HEAD
$aboutPageDart = "lib\view\page\about.dart"
$content = Get-Content $aboutPageDart
$content = $content -replace ("const sphiaLastCommitHash = 'SELF_BUILD';", "const sphiaLastCommitHash = '$commitHash';")
Set-Content $aboutPageDart -Value $content


Write-Host "Building Sphia"
flutter pub get
dart run build_runner build
flutter config --enable-windows-desktop
flutter_distributor release --name prod --jobs release-windows-exe
$exe = Get-Item -Path dist\*\sphia-windows.exe
Move-Item -Path $exe.FullName -Destination dist\sphia-windows-amd64.exe
