@echo off
rem 文字コードを "UTF-8" に変更
chcp 65001
set ps1_path=%CD%\obs-build.ps1
rem Powershell の実行ポリシーを変更: https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.3#remotesigned
@powershell -NoProfile -ExecutionPolicy RemoteSigned -File %ps1_path%
exit