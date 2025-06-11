class MultiClaude < Formula
  desc "グローバルで動作するマルチエージェント Claude Code システム"
  homepage "https://github.com/sutaminajing40/Claude-Code-Communication"
  url "https://github.com/sutaminajing40/Claude-Code-Communication/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "24a6d1e92d095e9d9f67bcc92762be40f4b3c1b3006ee8ff236c5e0f9d3e8846"
  license "MIT"

  depends_on "tmux"

  def install
    # スクリプトファイルをbinにインストール
    bin.install "multi-claude"
    bin.install "setup.sh"
    bin.install "agent-send.sh"

    # 設定ファイルをshareにインストール（Homebrew管理下）
    share.install "instructions"
    share.install "CLAUDE.md" => "CLAUDE_template.md"
  end

  def caveats
    <<~EOS
      🎉 Multi-Claude システムがインストールされました！

      初回実行時に自動的にセットアップが行われます。
      任意のディレクトリで以下を実行してください：

        multi-claude

      📋 使用方法:
        multi-claude         - システム起動
        multi-claude --exit  - システム完全終了
        multi-claude --help  - ヘルプ表示
        multi-claude --version - バージョン表示

      ⚠️  PATH設定の確認:
        ~/bin がPATHに含まれていることを確認してください。
        必要に応じて ~/.zshrc または ~/.bashrc に追加：
          export PATH="$HOME/bin:$PATH"
    EOS
  end

  test do
    # 基本的なヘルプコマンドのテスト
    system "#{bin}/multi-claude", "--help"
  end
end