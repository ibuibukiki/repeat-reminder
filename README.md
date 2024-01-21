# repeat-reminder
繰り返しリマインドしてくれるアプリ
***

### 機能
締切当日に焦らないように、締切の一か月前から一週間ごとにリマインドするなど、    
前もって繰り返し通知してくれるアプリ
* タスクの追加
* 過去に追加したタスクの編集・削除
* 削除したタスクの復元・キャッシュの削除

### 画面
* 登録済みのタスクのリストを表示する画面
* タスクの追加・編集ができる画面
* 設定画面 (削除済みタスクの復元やキャッシュの消去を実行)
<img width="150" src="https://github.com/ibuibukiki/repeat-reminder/assets/63579269/0fa4d3de-f7ba-404f-b2be-0d6a81f26735">
<img width="150" src="https://github.com/ibuibukiki/repeat-reminder/assets/63579269/e6107a13-0946-4cc6-b5f7-f61f0f0104da">
<img width="150" src="https://github.com/ibuibukiki/repeat-reminder/assets/63579269/a2bc452a-6d2a-4963-aa75-c1d7b179e8d7">
<img width="150" src="https://github.com/ibuibukiki/repeat-reminder/assets/63579269/d6a646eb-e0b0-490c-a04f-e16433d7843b">

[設計](https://www.figma.com/file/yT7NwfrnZssVU1OEmA7K3v/RepeatReminder?type=design&node-id=0%3A1&mode=design&t=fi46CjliQRW1q6Kz-1)

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
  
