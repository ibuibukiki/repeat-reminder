# repeat-reminder
繰り返しリマインドしてくれるアプリ

***

### 機能
* タスクの追加
* 過去に追加したタスクの編集・削除
* 削除したタスクの復元・キャッシュの削除

### 画面
* 登録済みのタスクのリストを表示する画面
* タスクの追加・編集ができる画面
* 設定画面 (削除済みタスクの復元やキャッシュの消去を実行)
* [デザイン](https://www.figma.com/file/yT7NwfrnZssVU1OEmA7K3v/RepeatReminder?type=design&node-id=0%3A1&mode=design&t=fi46CjliQRW1q6Kz-1)

***

### フォルダ構成
クリーンアーキテクチャとMVVMを併用
* RepeatReminder
  * Domain : データモデルを管理
    * Entities 
    * Usecases
    * Models
  * Presentation : 画面の情報を管理
    * ViewModels
    * Views
  * Infrastructure : 外部リソースの情報を管理
  
