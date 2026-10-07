-- lua/lsp/gopls.lua

return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  
  -- プロジェクトのルートを判定するマーカー
  root_markers = { "go.work", "go.mod", ".git" },

  settings = {
    gopls = {
      -- 1. より厳格なフォーマッター (gofumpt) を使用する
      -- 標準の gofmt よりも厳しく、Goコミュニティで推奨されている綺麗なコードに整形します
      gofumpt = true,

      -- 2. 静的解析（Linter）の強化
      -- 標準の解析に加えて、強力な 'staticcheck' を有効にします
      staticcheck = true,
      analyses = {
        unusedparams = true, -- 使われていない引数を警告
        shadow = true,       -- 変数のシャドウイング（同名変数の上書き）を警告
        nilness = true,      -- nilポインタ参照の危険性を警告
        unusedwrite = true,  -- 書き込んだのに読まれていない変数を警告
      },

      -- 3. 補完時のスニペット展開（先ほどの callSnippet と似た機能）
      -- 関数を補完した際に、引数のプレースホルダーを自動で展開します
      usePlaceholders = true,

      -- 4. インレイヒント（コード上に薄く表示される情報）の設定
      -- これを有効にすると、Rustのように変数や戻り値の型が画面上でパッと見でわかるようになります
      hints = {
        assignVariableTypes = true,    -- 変数代入時の型
        compositeLiteralFields = true, -- 構造体初期化時のフィールド名
        compositeLiteralTypes = true,  -- 構造体初期化時の型
        constantValues = true,         -- 定数の値
        functionTypeParameters = true, -- 関数の型パラメータ
        parameterNames = true,         -- 関数呼び出し時の引数名
        rangeVariableTypes = true,     -- for range ループ時の変数の型
      },
    },
  },
}
