# /* StreamFx */

function Build-StreamFX {
  param (
    [String]$current_dir,
    [String]$sfx_ver
  )
  
  # カレントディレクトリのリセット
  Set-Location -Path $current_dir
  
  # StreamFx のクローン: サブモジュール付き
  $sfx_url = "https://github.com/Xaymar/obs-StreamFX.git"
  if ([string]::IsNullOrEmpty($sfx_ver)){
    git clone $sfx_url --recursive
  } else {
    git clone $sfx_url -b $sfx_ver --recursive
  }
  
  # "obs-StreamFX" ディレクトリに移動
  $sfx_dir = Join-Path $current_dir "obs-StreamFX"
  Set-Location -Path $sfx_dir
  
  # "builds" フォルダの作成
  $builds_dir = Join-Path $current_dir "obs-StreamFX/builds"
  New-Item $builds_dir -ItemType Directory
  
  # cmake で StreamFX をビルド
  $libobs_dir = Join-Path $current_dir "obs-studio/build64/libobs"
  $w32_pthreads_dir = Join-Path $current_dir "obs-studio/build64/deps/w32-pthreads"
  $obs_frontend_api_dir = Join-Path $current_dir "obs-studio/build64/UI/obs-frontend-api"
  $ffmpeg_dir = Join-Path $current_dir "obs-studio/build64/plugins/obs-ffmpeg"
  cmake -G "Visual Studio 16 2019" -A x64 -S . -B $builds_dir `
    -D libobs_DIR=$libobs_dir -D w32-pthreads_DIR=$w32_pthreads_dir -D obs-frontend-api_DIR=$obs_frontend_api_dir `
    -D FFmpeg_DIR=$ffmpeg_dir -D DOWNLOAD_QT=ON
  
  # MSBuild で StreamFX.sln をビルド
  $sln_path = Join-Path $builds_dir "StreamFX.sln"
  MSBuild $sln_path -property:Configuration=RelWithDebInfo
}

function Copy-StreamFX {
  param (
    [String]$current_dir
  )
  # - OBS Studio に StreamFX を導入 -
  # StreamFX.dll & StreamFX.pdb -> "obs-studio/obs-plugins/64bit"
  $builded_dir = Join-Path $current_dir "builded/obs-studio"
  $plugins_dir = Join-Path $builded_dir "obs-plugins/64bit"
  $dll_path = Join-Path $builds_dir "RelWithDebInfo/StreamFX.dll"
  Copy-Item -Path $dll_path -Destination $plugins_dir
  $pdb_path = Join-Path $builds_dir "RelWithDebInfo/StreamFX.pdb"
  Copy-Item -Path $pdb_path -Destination $plugins_dir
  # effects, examples, locale, thanks.json -> "obs-studio/data/obs-plugins/StreamFX"
  $plugins_data_dir = Join-Path $builded_dir "data/obs-plugins"
  $plugins_data_streamfx_dir = Join-Path $plugins_data_dir "StreamFX"
  New-Item $plugins_data_streamfx_dir -ItemType Directory
  $streamfx_data_dir = Join-Path $current_dir "obs-StreamFX/data/*"
  Copy-Item -Path $streamfx_data_dir -Recurse -Destination $plugins_data_streamfx_dir
}