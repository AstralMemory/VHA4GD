# VRoid Hub API 4 Godot
 当プロジェクトファイルは<br>
 GodotEngineでVRoidHubAPIを使うためのプラグインが入ったものです！<br>
 現時点ではエディター上のみで機能させることができます。<br>
 今後のエクスポート後のゲームでもモデルを読み込めるように開発を進める予定です。<br>
 <hr>
 <h2>使い方</h2><br>
 まずプラグインを有効化すると画面中央上[2D][3D][script][assetlib]の横に[VHA4GD]というタブが追加されます。<br>
 そのタブが本プラグインの設定画面になっています。<br>
 その設定画面へクライアントID(アプリケーションID)とクライアントシークレット(シークレット)を入力し set と書かれたボタンを押すことで<br>
 設定を保存することができます。
 
 次に、VRoidHubを呼び出したいシーンに VRoidHub.start() を記載します。<br>
 例 : 
 ![スクリーンショット 2024-05-15 002049](https://github.com/AstralMemory/VHA4GD/assets/124105935/026a4840-b875-4f89-879e-6d053c9373d2)<br>
選択されているテキストの場所です。<br>
サンプルではVHButton(VRoidHubStart)を押すとVRoidHubが呼び出されるようになっています。<br>
一度呼び出せば、右上の閉じるボタンを押さない限りOAuth,ModelListと順番に進むようになっています。<br>
<hr>
現時点でできることは以上です。

最後に当プラグインは個人で開発を行っております。今後のサービス継続や向上の為ぜひとも<a href=https://www.buymeacoffee.com/astralmemory10>寄付</a>のほどよろしくお願いいたします。





 
