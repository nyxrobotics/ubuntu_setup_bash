# ubuntu_setup
- ubuntu_setup.sh　: CUBOID等のロボット内部へUbuntu16.04をインストール後、各種設定を反映するスクリプト

- 手順
  1. BIOS:
    - security device support -> disable
    - secure boot -> disable
    - boot mode -> uefi
  2. Ubuntu16.04.6をインストール
  3. SSHキーを生成してGithubに登録する
  4. sbgisen_wikiをcloneする
  5. ubuntu_environments.shを実行する
  6. ROSをインストールする

- 注意点
  - nvidiaドライバ、cudaのインストールが不要な場合、ubuntu_environments.sh内のnvidiaの行をコメントアウトしてください  
    ```bash nvidia.sh```
