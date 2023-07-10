## What is
Calendar

## DB structure
1. **usersテーブル**
    
    | Column | Type | Constraints | Description |
    | --- | --- | --- | --- |
    | id | int | PK, Auto Increment | ユーザーの一意なID |
    | sex | int | Not Null | ユーザーの性別（0: 男性、1: 女性など） |
    | name | varchar | Not Null | ユーザーの名前 |
    | email | varchar | Not Null | ユーザーのEメールアドレス |
    | password | varchar | Not Null | ユーザーのパスワード |
    | image | varchar |  | ユーザーの画像のURLまたはパス |
    | created_at | datetime |  | レコードが作成された日時 |
    | updated_at | datetime |  | レコードが最後に更新された日時 |

2. **groupsテーブル**
    
    | Column | Type | Constraints | Description |
    | --- | --- | --- | --- |
    | id | int | PK, Auto Increment | グループの一意なID |
    | name | varchar | Not Null | グループの名前 |
    | description | text |  | グループの説明 |
    | image | varchar |  | グループの画像のURL |
    | creator_id | int | FK, Not Null | グループを作成したユーザーのID |
    | created_at | datetime |  | レコードが作成された日時 |
    | updated_at | datetime |  | レコードが最後に更新された日時 |

3. **user_groupテーブル**    
    ※ user_idとgroup_idは複合ユニーク
    
    | Column | Type | Constraints | Description |
    | --- | --- | --- | --- |
    | id | int | PK, Auto Increment | ユーザーとグループの関係の一意なID |
    | user_id | int | FK users.id, Not Null | ユーザーの一意なID |
    | group_id | int | FK groups.id, Not Null | グループの一意なID |
    | created_at | datetime |  | レコードが作成された日時 |
    | updated_at | datetime |  | レコードが最後に更新された日時 |

4. **schedulesテーブル**
        
    | Column | Type | Constraints | Description |
    | --- | --- | --- | --- |
    | id | int | PK, Auto Increment | スケジュールの一意なID |
    | title | varchar | Not Null | スケジュールのタイトル |
    | description | text |  | スケジュールの説明 |
    | start_datetime | datetime | Not Null | スケジュールの開始日時 |
    | end_datetime | datetime | Not Null | スケジュールの終了日時 |
    | is_repeated | boolean | Not Null | スケジュールが定期的かどうか |
    | is_shared_to_gc | boolean | Not Null | スケジュールがGoogle Calendarに共有されたか |
    | color | int | Not Null | スケジュールを表示する色のコード |
    | user_group_id | int | FK, Not Null | スケジュールを作成したユーザグループーID |
    | created_at | datetime |  | レコードが作成された日時 |
    | updated_at | datetime |  | レコードが最後に更新された日時 |

5. **invitationsテーブル**
    
    | Column | Type | Constraints | Description |
    | --- | --- | --- | --- |
    | id | int | PK, Auto Increment| 招待の一意なID |
    | sender_id | int | FK, Not Null | 招待を送ったユーザーID |
    | receiver_id | int | FK, Not Null | 招待を受けたユーザーID |
    | group_id | int | FK, Not Null | 招待が関連するグループID |
    | created_at | datetime |  | レコードが作成された日時 |
    | updated_at | datetime |  | レコードが最後に更新された日時 |

## How to start Go http server
1. Run docker container

```
$ docker compose up -d --build
```
