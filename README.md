# [GitHubAPI]-GitHubAPIを使用したサンプルアプリケーション
このアプリでは、GitHubのリポジトリをリポジトリ名で検索することができます。

入力された検索ワードはローカルDBに保存されるため、次回から同じワードを入力する手間が省かれます。

検索結果からは、リポジトリの詳細情報やREADMEを確認することが可能です。
## 1.このアプリケーションについて
## 2. 使用しているライブラリ
・RxSwift

・RxCocoa

・Kingfisher
## 3. 使用している技術
### ・RxSwift

MVC構成を使用すると、ViewControllerが肥大化してしまうため、MVVM構成を採用しました。
ViewはUIの表示に関わり、ViewModelはViewとModelの橋渡しの役割を担い、Modelはビジネスロジックや動的な処理を担当することを意識しました。

### ・AutoLayout

Storyboardを使用すると、複雑なレイアウトの場合修正が難しくなるため、コードでの実装を心がけました。

### ・UICollectionViewDiffableDataSource

UICollectionViewを使用して、TableViewのような行の削除を行うために使用しました。

### ・UIView.animate

動きのないアプリは変化が分かりづらいと感じたので、積極的にアニメーションを追加しました。

### ・UserDefaults

検索ワードをローカルに保存するために使用しました。
UserDefaultsの利用箇所が多くなると、Keyの変更時に修正が難しいと考えました。そのため、SearchHistoryManagerクラスを作成し、処理を一元管理するようにしました。

### ・KVO

UserDefaultsの値の変更を監視するためにKVOを使用しました。
値が変更された際、その変更後の値をUIにバインドして、UICollectionViewに反映させるように実装しました。

### ・GitHub REST API

リポジトリの一覧を取得するために使用しました。
ステータスコードに応じたエラー処理を実装しました。

### ・URLSession

APIの通信には、URLSessionを利用しました。
Alamofireライブラリ、URLSessionと経験はありますが、純正の動きを忘れたくなかったので、URLSessionを選択しました。

### ・Decodable
JSONDecoderを使用して、デコードしました。

### ・WKWebView

READMEの内容を表示するために使用しました。
GitHubAPIで取得したREADMEのURLをWKWebViewでロードしています。

### ・無限スクロール

UICollectionViewのscrollViewDidScrollメソッドを利用して、スクロール位置を監視しています。スクロールが下部まで到達した場合、APIを呼び出すように実装しました。
scrollViewDidScrollは頻繁に呼び出されるため、APIの呼び出し状態を管理し、重複してAPIを呼ぶことがないよう注意しました。

### ・Kingfisher

画像の取得時には、キャッシュを活用して通信処理の頻度を低減させました。
Kingfisherを選択したのは、その実績と使い勝手の良さによるものです。
## 4. テストコードについて
### ・UserDefaults

UserDefaultsの保存・削除処理が正しく行われることをテストしました。
テスト時には、suiteNameを使用して、テスト専用のUserDefaultsインスタンスを生成しました。
テスト終了後は、このインスタンスを削除することで、不要なデータが残らないように注意しました。

### ・API処理

スタブとモックを利用し、テスト時に期待する結果を返すように実装しました。
DI（Dependency Injection）を活用して、コードの依存関係を減少させるように心掛けました。
## 5. 今後学びたいこと
### ・テスト処理

コードへの信頼性と、実装スピードが早くなるようなテストコードを書いていきたいです。
機能実装時からテストを考えられたらもっと良くなる気がします。
ユニットテストをベースとしてUIテストも実装していけるようになりたいです。

### ・API処理

GitHubAPIだけでなく、他のAPIにも触れてみたいです。
処理結果をUIに反映するだけでなく、そこから発展していけるようにしたいです。

### ・アーキテクチャ

MVVMだけでなく、MVPやVIPERについても調べていきたいです。

### ・プロパティ名、クラス名、メソッド名

名前は初めて見る人にとって命なので、もっと慎重に考えたいです。
