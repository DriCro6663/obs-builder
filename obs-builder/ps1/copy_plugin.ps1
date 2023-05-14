function Copy-Plugin {
  param (
    [String]$current_dir,
    [String]$plugin_name,
    [String]$plugin_url
  )
  # カレントディレクトリのリセット
  Set-Location -Path $current_dir
  
  # プラグインのダウンロード＆解凍
  $save_path = Join-Path $current_dir "$plugin_name.zip"
  Invoke-WebRequest $plugin_url -OutFile $save_path
  Start-Process 7z -ArgumentList "x $plugin_name.zip -o$plugin_name" -NoNewWindow -Wait
  
  # .dll & .pdb -> "obs-studio/obs-plugins/64bit"
  $builded_dir = Join-Path $current_dir "builded/obs-studio"
  $plugins_dir = Join-Path $builded_dir "obs-plugins/64bit"
  $plugin_path = Join-Path $current_dir "$plugin_name/obs-plugins/64bit/*"
  Copy-Item -Path $plugin_path -Recurse -Destination $plugins_dir
  # data -> "obs-studio/data/obs-plugins/$plugin_name"
  $plugins_data_dir = Join-Path $builded_dir "data/obs-plugins"
  $data_path = Join-Path $current_dir "$plugin_name/data/obs-plugins/$plugin_name"
  Copy-Item -Path $data_path -Recurse -Destination $plugins_data_dir
}
