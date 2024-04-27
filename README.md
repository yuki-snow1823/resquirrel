# Resquirrel

RubyGems that automatically create release notes for Notion DB using Open AI API.

<img width="480" src="https://github.com/yuki-snow1823/resquirrel/assets/59280290/48ab260d-242b-421d-b7ce-88ba611f0d19">


## Installation

Add this line to your application's Gemfile:

```Gemfile
gem 'fabrique'
```

And then execute:

```console
$ bundle install
```

Or install it yourself as:

```console
$ gem install resquirrel
```

## Usage（日本語）

### NotionのAPIキーの用意
1. まずは、NotionのAPIを使えるようにするためのトークンを取得します。
2. [Notionの開発者ページ](https://www.notion.so/my-integrations)にアクセスします。
3.  `New integration`をクリックして、作成したトークンをリリースノートを作成したいリポジトリのrepository secretsに登録します。`NOTION_API_KEY`という名前で登録してください。

### Notionのデータベースの用意
1. Notionにリリースノートを作成するためのFull Pageのデータベースを作成します。
2. データベースには、以下のプロパティを用意します。
    - `changes` : リリースノートのタイトル（DBを作成するとデフォルトで用意されています。）
    - `URL` : リリースノートのリンク
3. 作成したDBのURLをコピーして、https://www.notion.so/[この部分]?v=hogehoge の文字列を、リリースノートを作成したいリポジトリのrepository secretsに登録します。`NOTION_DATABASE_ID`という名前で登録してください。

### Open AI APIの用意
1. Open AI APIを使えるようにするためのAPIキーを取得します。
2. [Open AIの開発者ページ](https://platform.openai.com/account/api-keys)にアクセスします。
3. `Create API Key`をクリックして、作成したAPIキーをリリースノートを作成したいリポジトリのrepository secretsに登録します。`OPENAI_API_KEY`という名前で登録してください。
   - 制限に関しては、ModelsのRead、Model CapabilitiesのWriteが必要です。

### 実行方法
sample: 
`.github/workflows/create_release_notes.yml` のようなCIで実行するファイルを作成します。

```yml
name: create release notes

on:
  pull_request:
    types:
      - closed

jobs:
  create_release_notes:
    if: ${{ github.event.pull_request.merged }}
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: '3.3'

    - name: Install dependencies
      run: |
        bundle install

    - name: Run script
      run: ruby lib/resquirrel.rb
      env:
        GITHUB_EVENT_PATH: ${{ github.event_path }}
        OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        NOTION_API_KEY: ${{ secrets.NOTION_API_KEY }}
        NOTION_DATABASE_ID: ${{ secrets.NOTION_DATABASE_ID }}
```

```rb
resquirrel = Resquirrel.new
resquirrel.generate_release_note
```
それぞれのenvは必須です。

## Usage(English)

### Preparing Notion's API key
1. first, you will need to obtain a token to be able to use Notion's API. 2.
2. go to [Notion's developer page](https://www.notion.so/my-integrations).
3. click `New integration` and register the token you have created in the repository secrets of the repository for which you want to create release notes. The name shold be set `NOTION_API_KEY`.

### Preparing Notion's database
1. Create a Full Page database in Notion to create release notes.
2. Prepare the following properties in the database.
    - `changes` : Title of the release note (this is provided by default when you create a DB.)
    - `URL` : Link to the release note
3. Copy the URL of the created DB and register the string `https://www.notion.so/[this part]?v=hogehoge` in the repository secrets of the repository where you want to create the release notes. The name should be set to `NOTION_DATABASE_ID`.

### Preparing Open AI API
1. Obtain an API key to use the Open AI API.
2. Go to the [Open AI developer page](https://platform.openai.com/account/api-keys).
3. Click `Create API Key` and register the created API key in the repository secrets of the repository where you want to create the release notes. The name should be set to `OPENAI_API_KEY`.
   - The required permissions are Models Read and Model Capabilities Write.

### How to run
sample:
Create a file to run the script in CI, such as `.github/workflows/create_release_notes.yml`.


```yml
name: create release notes

on:
  pull_request:
    types:
      - closed

jobs:
  create_release_notes:
    if: ${{ github.event.pull_request.merged }}
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: '3.3'

    - name: Install dependencies
      run: |
        bundle install

    - name: Run script
      run: ruby lib/resquirrel.rb
      env:
        GITHUB_EVENT_PATH: ${{ github.event_path }}
        OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        NOTION_API_KEY: ${{ secrets.NOTION_API_KEY }}
        NOTION_DATABASE_ID: ${{ secrets.NOTION_DATABASE_ID }}
```

```rb
resquirrel = Resquirrel.new
resquirrel.generate_release_note
```
Each env is required.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yuki-snow1823/resquirrel This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yuki-snow1823/resquirrel/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Resquirrel project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yuki-snow1823/resquirrel/blob/main/CODE_OF_CONDUCT.md).
