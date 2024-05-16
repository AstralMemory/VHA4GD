# VRoid Hub API 4 Godot
GodotAssetLibraryは<a href=https://godotengine.org/asset-library/asset/2974>こちら</a>
 当プロジェクトファイルは<br>
 GodotEngineでVRoidHubAPIを使うためのプラグインが入ったものです！<br>
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

またモデルを呼び出したいところで VRoidHub.load_model(scene_name) を記載すれば指定したシーンにモデルが追加されます。(scene_nameの引数にシーン名を入力してください。※ファイルの名前ではありません　デフォルトでは VRoidHub となっています。)
<hr>
現時点でできることは以上です。

最後に当プラグインは個人で開発を行っております。今後のサービス継続や向上の為ぜひとも<a href=https://www.buymeacoffee.com/astralmemory10>寄付</a>のほどよろしくお願いいたします。

<hr>
# English<br>
GodotAssetLibrary is <a href=https://godotengine.org/asset-library/asset/2974>here</a>
 This project file is<br>
  This includes a plugin for using VRoidHubAPI with GodotEngine! <br>
  <hr>
  <h2>How to use</h2><br>
  First, when you activate the plugin, a tab called [VHA4GD] will be added next to [2D], [3D], [script], and [assetlib] at the top center of the screen. <br>
  That tab is the settings screen for this plugin. <br>
  By entering the client ID (application ID) and client secret (secret) on the setting screen and pressing the button labeled set<br>
  You can save your settings.
 
  Then he writes VRoidHub.start() in the scene where he wants to call VRoidHub. <br>
  example : 
  ![Screenshot 2024-05-15 002049](https://github.com/AstralMemory/VHA4GD/assets/124105935/026a4840-b875-4f89-879e-6d053c9373d2)<br>
The location of the selected text. <br>
In the sample, VRoidHub is called when the VHButton (VRoidHubStart) is pressed. <br>
Once called, it will proceed in the order of OAuth and ModelList unless you press the close button on the top right. <br>

Also, when he wants to call a model, he can write VRoidHub.load_model(scene_name) and the model will be added to the specified scene. (Please enter the scene name in the scene_name argument. *This is not the file name. The default is VRoidHub.)
<hr>
That's all we can do for now.

Lastly, this plugin is being developed by an individual. Please make a <a href=https://www.buymeacoffee.com/astralmemory10>donation</a> to help us continue and improve our services in the future.<br>
by GoogleTranslate




 
