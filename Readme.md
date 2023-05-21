# OBS Builder

## /\* [日本語の Readme.md はコチラ](./Readme-JP.md) \*/

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

Batch files to build [OBS Studio][OBS] for using [OBS Scene Collection: Advanced-PET](https://github.com/DriCro6663/advanced-pet).

* As of May 21, 2023, StreamFX has deleted the binary due to GPL license violation. <br>
Therefore, it was necessary to build from the StreamFX source code and use it as an OBS Studio plug-in.

> <details>
>   <summary>
>     <h3>
>       ⚠️ Binaries removed due to GPL license violation! ⚠️
>     </h3>
>   </summary>
> We had to remove binaries and source code due to a contributor submitting code that was not licensed under the GPLv2 "or later" license or any compatible license. While we were able to adjust the source code contained in the repository to exclude these license violations, we can't guarantee that binaries will be available again.
> </details>

## Introduction

* [StreamFX -Building from Source-](https://github.com/Xaymar/obs-StreamFX/wiki/Building)
* [OBS Studio 向けプラグイン StreamFX をソースからビルドした (Windows11) [#Vtuber/あれぐろもると]](https://note.com/allegromoltov/n/ndc861c461cfb)
* [StreamFX をビルドして使う (Windows)](https://note.com/ymmnote/n/n8a91de6e0436)

I referred to the article above.

I would like to express my gratitude here.

## Description

Batch files to build [OBS Studio][OBS] for using [OBS Scene Collection: Advanced-PET](https://github.com/DriCro6663/advanced-pet). Build and install the following extensions: plugins in OBS Studio after building.

* [StreamFX][StreamFX]
* [Move transition][Move_transition]
* [Scene Collection Manager][Scene_Collection_Manager]
* [OBS websocket 4.9.1][OBS_websocket_4.9.1]: for [OBS Studio 27.2.4][OBS_27.2.4]
* [OBS websocket 5.0.1][OBS_websocket_5.0.1]: for [OBS Studio 27.2.4][OBS_27.2.4]

## Usage

1. Build Environment ← /\* **Very important** \*/
2. Run batch file
3. Check for builded OBS Studio

### 1. Build Environment

1. Please install the following applications.
    <details open>
      <summary>For OBS Studio 27.2.4 & StreamFX 0.11.1</summary>

      * [Visual Studio 2019][Visual_Studio_2019]
      * [Cmake v3.23.0][Cmake_v3.23.0]
      * [git](https://git-scm.com/download/win)
      * [7zip](https://www.7-zip.org/a/7z2201-x64.exe)
    </details>

    <details>
      <summary>For OBS Studio -Latest- & StreamFX -Latest-</summary>

      * [Visual Studio -Latest-][Visual_Studio_2022]
      * [Cmake v3.24.0 or Higher][Cmake]
      * [git](https://git-scm.com/download/win)
      * [7zip](https://www.7-zip.org/a/7z2201-x64.exe)
    </details>

    <details>
      <summary>Why need Visual Studio 2019 & Cmake v3.23.0</summary>

      <p>
        OBS Studio 27.2.4 is recommended when using StreamFX 0.11.1. Therefore, when building OBS Studio 27.2.4 and StreamFX 0.11.1 with Cmake, Cmake v3.23.0, the latest version at the time, can be used to build successfully.
      </p>
      <p>
        Also, the sln file that is output when building with Cmake must be built with MSBuild. Visual Studio 2019 is required when building OBS Studio 27.2.4 with MSBuild. So you need to install Visual Studio 2019.
      </p>
    </details>

2. Setting environment variables

    Add the following path to the environment variable Path.

    ```ps1: Setting environment variables
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

    Please refer to this [article](https://www.scc-kk.co.jp/scc-books/java8_workbook/java_dev-win10.html) when setting environment variables.

    Alternatively, run the code below in PowerShell.

    <details>
      <summary>PowerShell: Add path to environment variables</summary>
      
      ```ps1: Setting environment variables
      # Save existing environment variables to variables
      $oldSystemPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
      # git
      $oldSystemPath += ";C:\Program Files\Git\bin"
      # 7-zip
      $oldSystemPath += ";C:\Program Files\7-Zip"
      # Cmake
      $oldSystemPath += ";C:\Program Files\CMake\bin"
      # MSBuild
      $oldSystemPath += ";C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin"
      # Update environment variables
      [System.Environment]::SetEnvironmentVariable("Path", $oldSystemPath, "Machine")
      ```

      * Environment variables are not recognized immediately after setting. <br> You need to restart the command prompt to recognize it.
    </details>

3. Check environment variables

    Make sure the git, 7-zip, Cmake, and MSBuild paths are recognized on the command prompt.

    ```ps1: Check environment variables
    # git
    where git
    # 7-zip
    where 7z
    # Cmake
    where cmake
    # MSBuild
    where MSBuild
    ```

    * Environment variables are not recognized immediately after setting. <br> You need to restart the command prompt to recognize it. <br> If it is still not recognized, please restart your computer.

### 2. Run batch file

1. If you want to use OBS Studio -Latest-, StreamFX -Latest-, please change the following part of obs-builder/obs-build.ps1.

    ```ps1: Change the version of OBS and StreamFX to build
    # Change or remove code on line 30
    # $sfx_ver = "0.11.1" -> latest version tag
    $sfx_ver = "0.12.0b299"

    # Change or remove the code on line 32
    # $obs_ver = "27.2.4" -> latest version tag
    $obs_ver = "29.1.1"
    ```

2. Run "build.bat". Depending on the performance of your computer, the process will complete in about 5 to 10 minutes.

### 3. Confirm for builded OBS Studio

1. If you have already installed and configured OBS Studio, run your existing OBS Studio and create a new Scene Collection.

    * If the versions of OBS Studio and Move transition do not match, the Move Transition settings of the opened scene collection will be initialized.

2. After executing the batch file, a built folder will be created in the current directory. You will find OBS Studio built in it. Run /obs-studio/bin/x64/obs-studio.exe and check that the following plugins are applied.

    <details open>
      <summary>For OBS Studio 27.2.4 & StreamFX 0.11.1</summary>
      
      * [StreamFX 0.11.1][StreamFX_0.11.1]
      * [Move transition 2.6.1][Move_transition_2.6.1]
      * [Scene Collection Manager 0.0.8][Scene_Collection_Manager]
      * [OBS websocket 4.9.1][OBS_websocket_4.9.1]
      * [OBS websocket 5.0.1][OBS_websocket_5.0.1]
    </details>
    
    <details>
      <summary>For OBS Studio -Latest- & StreamFX -Latest-</summary>
      
      * [StreamFX -Latest-][StreamFX]
      * [Move transition -Latest-][Move_transition]
      * [Scene Collection Manager 0.0.8][Scene_Collection_Manager]
    </details>

## Note

* Execute with a drive that can expand data of 3GB or more. 3GB or more free space is required for cloning OBS Studio and StreamFX repositories.
* Operation not confirmed for OBS 28 & StreamFX 0.12 or higher. <br> If there are any problems, please let us know via Twitter or GitHub Issues so that we can fix them.

## Updates

* 2023/05/21:<br>
   Released [v1.0.0](https://github.com/DriCro6663/obs-builder/releases/tag/v1.0.0).

## Author

* [Github DriCro6663](https://github.com/DriCro6663)
* [Twitter Dri_Cro_6663](https://twitter.com/Dri_Cro_6663)
* [YouTube ドリクロ -DriCro-](https://www.youtube.com/channel/UCyWgav9wdiPVjYphB7jrWCQ)
* [PieceX DriCro6663](https://www.piecex.com/users/profile/DriCro6663)
* dri.cro.6663@gmail.com

## License

Check [LICENSE](.LICENSE).
