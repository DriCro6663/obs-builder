<#
  作成者: DriCro6663, 作成日: 2023/05/04, 更新日: 2023/05/14
  
  StreamFX 0.11.1: 2022/02/27: https://github.com/Xaymar/obs-StreamFX/releases/tag/0.11.1
  OBS Studio 27.2.4: 2022/03/20: https://github.com/obsproject/obs-studio/releases/tag/27.2.4
  Cmake v3.23.0: 2022/03/20: https://github.com/Kitware/CMake/releases/tag/v3.23.0
  
  $env:7z = "C:\Program Files\7-Zip"
  $env:GIT = "C:\Program Files\Git\bin"
  $env:CMAKE = "C:\Program Files\CMake\bin"
  $env:MSBUILD = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin"
  
  /* StreamFx */
  https://github.com/Xaymar/obs-StreamFX/wiki/Building
  https://note.com/allegromoltov/n/ndc861c461cfb
  https://note.com/ymmnote/n/n8a91de6e0436
  
  /* Move transition */
  for obs 27 use move transition 2.6.1 or lower
  https://github.com/exeldro/obs-move-transition/issues/132
#>

# ======================================================================================================================================

# /*初期設定*/
# 文字コードを "UTF-8" に変更
chcp 65001

# https://github.com/Xaymar/obs-StreamFX/releases/tag/0.11.1
$sfx_ver = "0.11.1"
# https://github.com/obsproject/obs-studio/releases/tag/27.2.4
$obs_ver = "27.2.4"

# 現在のディレクトリ取得
$current_dir = Get-Location

# ======================================================================================================================================

# /* OBS Studio */
# カレントディレクトリのリセット
Set-Location -Path $current_dir
. ./ps1/obs.ps1
Build-OBS $current_dir $obs_ver
Copy-OBS $current_dir

# ======================================================================================================================================

# /* StreamFx */
# カレントディレクトリのリセット
Set-Location -Path $current_dir
. ./ps1/streamfx.ps1
Build-StreamFX $current_dir $sfx_ver
Copy-StreamFX $current_dir

# ======================================================================================================================================

# /* Copy-Plugin */
# カレントディレクトリのリセット
Set-Location -Path $current_dir
. ./ps1/copy_plugin.ps1

# ======================================================================================================================================

# /* Scene Collection Manager 0.0.8 */
$plugin_name = "scene-collection-manager"
$plugins_url = "https://obsproject.com/forum/resources/scene-collection-manager.1434/version/4407/download?file=86113"
Copy-Plugin $current_dir $plugin_name $plugins_url

# ======================================================================================================================================

# /* Move transition */
$plugin_name = "move-transition"
if ($obs_ver.Substring(0, 2) -le 27) {
  # for obs 27 use move transition 2.6.1
  $plugins_url = "https://obsproject.com/forum/resources/move-transition.913/version/4297/download?file=84807"
  Copy-Plugin $current_dir $plugin_name $plugins_url
} else {
  # Move transition 2.9.1
  $plugins_url = "https://obsproject.com/forum/resources/move-transition.913/version/4904/download?file=94076"
  Copy-Plugin $current_dir $plugin_name $plugins_url
}


# ======================================================================================================================================

# /* OBS websocket */
if ($obs_ver.Substring(0, 2) -le 27) {
  # - OBS websocket 4.9.1 を導入 -
  $plugin_name = "obs-websocket-compat"
  $plugins_url = "https://github.com/obsproject/obs-websocket/releases/download/5.0.1/obs-websocket-4.9.1-compat-Windows.zip"
  Copy-Plugin $current_dir $plugin_name $plugins_url
  
  # - OBS websocket 5.0.1 を導入 -
  $plugin_name = "obs-websocket"
  $plugins_url = "https://github.com/obsproject/obs-websocket/releases/download/5.0.1/obs-websocket-5.0.1-Windows.zip"
  Copy-Plugin $current_dir $plugin_name $plugins_url
  # $plugin_name/bin/64bit/imageformats/* -> "obs-studio/bin/64bit/imageformats"
  $builded_dir = Join-Path $current_dir "builded/obs-studio"
  $plugins_imageformats_dir = Join-Path $builded_dir "bin/64bit/imageformats"
  $imageformats_path = Join-Path $current_dir "$plugin_name/bin/64bit/imageformats/*"
  Copy-Item -Path $imageformats_path -Recurse -Destination $plugins_imageformats_dir
}

# ======================================================================================================================================

# /* 後片付け */
# カレントディレクトリのリセット
Set-Location -Path $current_dir
# bat, ps1 ファイルと builded フォルダ以外を削除
Remove-Item "obs-*","move-transition","scene-collection-manager","*.zip" `
  -Exclude "build.bat","obs-build.ps1","builded","ps1" -Recurse -Force