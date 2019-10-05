# Docker + Flask のボイラープレート

## Usage(使い方)
#### 1. このテンプレートrepoから自分のリポジトリを作成
![img](https://i.imgur.com/AlA5ZcQ.png)

#### 2. `.env.sample`を参考に`.env`ファイルを`.env.sample`と同じ場所に作成

#### 3. Dockerを使ってビルド => アップ
__Dockerが入ってないと動きません__  

```bash
$ make build_up
```

これでサーバーがたちます
`http://localhost:8000`
にアクセスすればみれます  

#### 4. 普段`manage.py xxxx`のように使うDjangoのコマンドは
```bash
$ make manage
Input command (below manage.py): ここにうつ
```


## 基礎フォルダ構造の解説
```text
.
├── Dockerfile              // アプリケーション自体のDockerfile
├── Makefile                // `make XXX`みたいなコマンドでいろんなコマンドを簡略化するためのファいうr
├── README.md               // まず読みましょうというもの
├── docker-compose.yml      
├── guniconf.py             // gunicornの設定
├── manage.py     
├── .docker                 // アプリケーション以外のdockerで立ち上げるものたち
│   ├── db
│   │   ├── initializers/01_createdb.sql    // サーバー立ち上げた時にこの内容によってデフォルトのROLEとDBができる         
│   │   └── data/           // 実際のデータベースのデータが同期される
│   ├── nginx
│   │   ├── app.conf        // Nginxの設定         
│   │   └── Dockerfile
│   └── redis               // 非同期ジョブ実行の際に使われる揮発性DB
├── project                 // プロジェクトのソースコードが入るフォルダ *1
│   ├── __init__.py
│   ├── celery.py           // celeryの設定
│   ├── settings.py         // アプリケーションの設定
│   ├── urls.py            
│   └── wsgi.py             // ウェブサーバー立ち上げるためのもの 
├── templates               // テンプレートがはいる
└── tmp                     // プログラムによって一時的に生成されるファイルなどを格納する用のフォルダ
    └── sockets             // ソケットファイルがはいる

```
`*1` => 独自のプロジェクト名・アプリ名に変えてもいいが、ソースコード内のパッケージ名も変える必要がある