# ubuntu_setup
- ubuntu_setup.sh　: CUBOID等のロボット内部へUbuntu18.04をインストール後、各種設定を反映するスクリプト

- 手順
  1. BIOS:
    - security device support -> disable
    - secure boot -> disable
    - boot mode -> uefi
  2. Ubuntu18.04.4をインストール
  3. SSHキーを生成してGithubに登録する（参考：[GitHubでssh接続する手順](https://qiita.com/shizuma/items/2b2f873a0034839e47ce)）
  4. sbgisen_wikiをcloneする
  5. ubuntu_setup.shを実行する
  6. ROSをインストールする

- 注意点
  - virtualboを使用する場合はnvidia.shは実行不可（起動しなくなる）
  - nvidiaドライバ、cudaのインストールが不要な場合、ubuntu_environments.sh内の下記をコメントアウト  
    ```# bash nvidia.sh```
  - 壁紙の変更が不要な場合、ubuntu_environments.sh内の下記をコメントアウト  
    ```# set_wallpaper.sh```
  - launcherを隠す設定にする場合はmodules/ubuntu_tools.shの下記をコメント解除  
    ```gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false```
