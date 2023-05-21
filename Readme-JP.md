# OBS Builder

[OBS]:https://github.com/obsproject/obs-studio/releases
[OBS_27.2.4]:https://github.com/obsproject/obs-studio/releases/tag/27.2.4

[StreamFX]:https://github.com/Xaymar/obs-StreamFX/releases
[StreamFX_0.11.1]:https://github.com/Xaymar/obs-StreamFX/releases/tag/0.11.1

[Move_transition]:https://obsproject.com/forum/resources/move-transition.913/
[Move_transition_2.6.1]:https://obsproject.com/forum/resources/move-transition.913/version/4297/download?file=84807

[Scene_Collection_Manager]:https://obsproject.com/forum/resources/scene-collection-manager.1434/

[OBS_websocket_4.9.1]:https://github.com/obsproject/obs-websocket/releases/tag/4.9.1-compat
[OBS_websocket_5.0.1]:https://github.com/obsproject/obs-websocket/releases/tag/5.0.1

[Visual_Studio_2019]:https://my.visualstudio.com/Downloads?q=visual%20studio%202019&wt.mc_id=o~msft~vscom~older-downloads
[Visual_Studio_2022]:https://visualstudio.microsoft.com/ja/thank-you-downloading-visual-studio/?sku=Community&channel=Release&version=VS2022&source=VSLandingPage&cid=2030&passive=false

[Cmake]:https://github.com/Kitware/CMake/releases
[Cmake_v3.23.0]:https://github.com/Kitware/CMake/releases/tag/v3.23.0

[OBS Scene Collection: Advanced-PET](https://github.com/DriCro6663/advanced-pet) を使用するための [OBS Studio][OBS] をビルドするバッチファイル群です。

※ 2023/05/21 現在、StreamFX では GPL ライセンス違反のため、バイナリが削除されています。<br>
　 その為、StreamFX のソースコードからビルドして OBS Studio プラグインとして使用するための処理が必要なりました。

> <details>
>   <summary>
>     <h3>
>       ⚠️ Binaries removed due to GPL license violation! ⚠️
>     </h3>
>   </summary>
> We had to remove binaries and source code due to a contributor submitting code that was not licensed under the GPLv2 "or later" license or any compatible license. While we were able to adjust the source code contained in the repository to exclude these license violations, we can't guarantee that binaries will be available again.
> </details>

## はじめに

* [StreamFX -Building from Source-](https://github.com/Xaymar/obs-StreamFX/wiki/Building)
* [OBS Studio 向けプラグイン StreamFX をソースからビルドした (Windows11) [#Vtuber/あれぐろもると]](https://note.com/allegromoltov/n/ndc861c461cfb)
* [StreamFX をビルドして使う (Windows)](https://note.com/ymmnote/n/n8a91de6e0436)

上記の記事を参考にさせて頂きました。

略儀ながら、ここに感謝の意を表します。

## 概要

[OBS Scene Collection: Advanced-PET](https://github.com/DriCro6663/advanced-pet) を使用するための [OBS Studio][OBS] をビルドするバッチファイル群です。ビルド後の OBS Studio には、以下の拡張機能：プラグインをビルド・インストールします。

* [StreamFX][StreamFX]
* [Move transition][Move_transition]
* [Scene Collection Manager][Scene_Collection_Manager]
* [OBS websocket 4.9.1][OBS_websocket_4.9.1]: for [OBS Studio 27.2.4][OBS_27.2.4]
* [OBS websocket 5.0.1][OBS_websocket_5.0.1]: for [OBS Studio 27.2.4][OBS_27.2.4]

## 使い方

1. 環境構築　←　/\* **とても重要** \*/
2. バッチファイルの実行
3. OBS Studio の実行確認

### 1. 環境構築

1. 以下のアプリケーションをインストールしてください。
    <details open>
      <summary>OBS Studio 27.2.4 & StreamFX 0.11.1 の場合</summary>
      
      * [Visual Studio 2019][Visual_Studio_2019]
      * [Cmake v3.23.0][Cmake_v3.23.0]
      * [git](https://git-scm.com/download/win)
      * [7zip](https://www.7-zip.org/a/7z2201-x64.exe)
    </details>

    <details>
      <summary>OBS Studio -Latest- & StreamFX -Latest- の場合</summary>
      
      * [Visual Studio -Latest-][Visual_Studio_2022]
      * [Cmake v3.24.0 or Higher][Cmake]
      * [git](https://git-scm.com/download/win)
      * [7zip](https://www.7-zip.org/a/7z2201-x64.exe)
    </details>

    <details>
      <summary>Visual Studio 2019, Cmake v3.23.0 が必要な理由</summary>
      
      <p>
        　StreamFX 0.11.1 を使用する際、OBS Studio 27.2.4 が推奨されています。そのため、OBS Studio 27.2.4 と StreamFX 0.11.1 を Cmake でビルドする際、当時の最新版である Cmake v3.23.0 でなければ、正常にビルドできません。
      </p>
      <p>
        　また、Cmake でビルドした際に出力される sln ファイルを MSBuild でビルドする必要があります。OBS Studio 27.2.4 を MSBuild でビルドする際、Visual Studio 2019 を要求されます。そのため、Visual Studio 2019 をインストールする必要があります。
      </p>
    </details>

2. 環境変数の設定

    以下のパスを環境変数の Path に追加してください。

    ```ps1: 環境変数の設定
    # git
    C:\Program Files\Git\bin
    # 7-zip
    C:\Program Files\7-Zip
    # Cmake
    C:\Program Files\CMake\bin
    # MSBuild: Visual Studio 2019
    C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin
    # MSBuild: Visual Studio 2022
    C:\Program Files (x86)\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin
    ```

    環境変数を設定する際、この [記事](https://www.scc-kk.co.jp/scc-books/java8_workbook/java_dev-win10.html) を参考に設定してください。

    または、以下のコードを PowerShell で実行してください。

    <details>
      <summary>PowerShell: 環境変数にパス追加</summary>
      
      ```ps1: 環境変数の設定
      # 既存の環境変数を変数に保存
      $oldSystemPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
      # git
      $oldSystemPath += ";C:\Program Files\Git\bin"
      # 7-zip
      $oldSystemPath += ";C:\Program Files\7-Zip"
      # Cmake
      $oldSystemPath += ";C:\Program Files\CMake\bin"
      # MSBuild
      $oldSystemPath += ";C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin"
      # 環境変数の更新
      [System.Environment]::SetEnvironmentVariable("Path", $oldSystemPath, "Machine")
      ```
      
      ※設定後、環境変数は直ちに認識されません。<br>
      　認識させるにはコマンドプロンプトを再起動する必要があります。
    </details>

3. 環境変数の確認

    コマンドプロンプト上で git, 7-zip, Cmake, MSBuild のパスが認識されることを確認してください。

    ```ps1: 環境変数の設定
    # git
    where git
    # 7-zip
    where 7z
    # Cmake
    where cmake
    # MSBuild
    where MSBuild
    ```

    ※設定後、環境変数は直ちに認識されません。<br>
    　認識させるにはコマンドプロンプトを再起動する必要があります。<br>
    　それでも認識されない場合は、パソコンを再起動してください。

### 2. バッチファイル実行

1. OBS Studio -Latest-, StreamFX -Latest- を使用したい場合、obs-builder/obs-build.ps1 の以下の部分を変更してください。

    ```ps1: ビルドする OBS, StreamFX のバージョン変更
    # 30 行目のコードを変更、または削除
    # $sfx_ver = "0.11.1" -> latest version tag
    $sfx_ver = "0.12.0b299"

    # 32 行目のコードを変更、または削除
    # $obs_ver = "27.2.4" -> latest version tag
    $obs_ver = "29.1.1"
    ```

2. build.bat を実行してください。パソコンの性能によりますが、5 ~ 10 分ほどで処理が終了します。

### 3. OBS Studio の実行確認

1. すでに OBS Studio をインストールして設定されている方は、既存の OBS Studio を実行して、新しいシーンコレクションを作成してください。

    ※ OBS Studio と Move transition のバージョンが合わなかった場合、開いたシーンコレクションの Move Transition 設定が初期化されるためです。

2. バッチファイル実行後、カレントディレクトリに builded フォルダが作成されます。その中にビルドされた OBS Studio があります。/obs-studio/bin/x64/obs-studio.exe を実行して以下のプラグインが適用されていることを確認してください。

    <details open>
      <summary>OBS Studio 27.2.4 & StreamFX 0.11.1 の場合</summary>
      
      * [StreamFX 0.11.1][StreamFX_0.11.1]
      * [Move transition 2.6.1][Move_transition_2.6.1]
      * [Scene Collection Manager 0.0.8][Scene_Collection_Manager]
      * [OBS websocket 4.9.1][OBS_websocket_4.9.1]
      * [OBS websocket 5.0.1][OBS_websocket_5.0.1]
    </details>
    
    <details>
      <summary>OBS Studio -Latest- & StreamFX -Latest- の場合</summary>
      
      * [StreamFX -Latest-][StreamFX]
      * [Move transition -Latest-][Move_transition]
      * [Scene Collection Manager 0.0.8][Scene_Collection_Manager]
    </details>

## 注意

* 3GB 以上のデータを展開できるドライブで実行してください。OBS Studio や StreamFX のリポジトリをクローンするため、3GB 以上の空き領域が必要です。
* OBS 28, StreamFX 0.12 以上の動作未確認<br>
  問題があった場合は、Twitter や GitHub の Issues 等で連絡してください。修正します。

## 更新情報

* 2023/05/07:<br>
  [v1.0.0](https://github.com/DriCro6663/bmovt/releases/tag/v0.0.1) を公開。

## 開発者情報 & 文責

* [Github DriCro6663](https://github.com/DriCro6663)
* [Twitter Dri_Cro_6663](https://twitter.com/Dri_Cro_6663)
* [YouTube ドリクロ -DriCro-](https://www.youtube.com/channel/UCyWgav9wdiPVjYphB7jrWCQ)
* [PieceX DriCro6663](https://www.piecex.com/users/profile/DriCro6663)
* [ドリクロの備忘録](https://dri-cro-6663.jp/)
* dri.cro.6663@gmail.com

## ライセンス

[LICENSE](.LICENSE) ファイルをご確認してください。
