# /* OBS Studio */
function Build-OBS {
  param (
    [String]$current_dir,
    [String]$obs_ver,
    # https://www.bookstack.cn/read/OBS-Studio-27.1-en/ef6ec75348ae47bb.md
    [String]$cef_ver = "75.1.16+g16a67c4+chromium-75.0.3770.100"
  )
  
  # カレントディレクトリのリセット
  Set-Location -Path $current_dir
  
  # OBS Studio のクローン: サブモジュール付き
  $obs_url = "https://github.com/obsproject/obs-studio.git"
  if ([string]::IsNullOrEmpty($obs_ver)){
    git clone $obs_url --recursive
  } else {
    git clone $obs_url -b $obs_ver --recursive
  }
  
  # "obs-studio" ディレクトリに移動
  Set-Location "obs-studio"
  
  # Windows ビルド向けに用意された Powershell スクリプトを実行
  if ($obs_ver.Substring(0, 2) -le 27) {
    # Windows ビルド向けに用意されたスクリプトに処理追加: この処理がないと CEF Wrapper がダウンロードされない
    $file = Resolve-Path CI/install-script-win.cmd
    $tmp = Get-Content $file
    Clear-Content $file
    $add_line = "chcp 65001"
    $add_line | Add-Content -Encoding UTF8 $file
    $add_line = "set CEF_VERSION=$cef_ver"
    $add_line | Add-Content -Encoding UTF8 $file
    $tmp | Add-Content -Encoding UTF8 $file
    
    # Windows ビルド向けに用意されたスクリプトを実行
    CI/install-qt-win.cmd
    CI/install-script-win.cmd
    
    # MSBuild で OBS Studio を出力
    MSBuild "build64/obs-studio.sln" -property:Configuration=RelWithDebInfo
  } else {
    CI/build-windows.ps1
  }
}

function Copy-OBS {
  param (
    [String]$current_dir
  )
  # カレントディレクトリに builded フォルダを作成
  $builded_dir = Join-Path $current_dir "builded/obs-studio"
  New-Item $builded_dir -ItemType Directory
  # builded フォルダに OBS Studio を コピー
  $build64_obs_dir = Join-Path $current_dir "obs-studio/build64/rundir/RelWithDebInfo/*"
  Copy-Item $build64_obs_dir -Recurse $builded_dir
}