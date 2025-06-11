class MultiClaude < Formula
  desc "グローバルで動作するマルチエージェント Claude Code システム"
  homepage "https://github.com/sutaminajing40/Claude-Code-Communication"
  url "https://github.com/sutaminajing40/Claude-Code-Communication/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "5e6b2ae1bad3fc3be878a1f2b73c76a280a3af87a42dff1eb4312bf45f18b0a0"
  license "MIT"
  revision 2

  depends_on "tmux"

  def install
    # スクリプトファイルをbinにインストール
    bin.install "multi-claude"
    bin.install "setup.sh"
    bin.install "agent-send.sh"

    # 設定ファイルをshareにインストール
    share.install "instructions"
    share.install "CLAUDE.md" => "CLAUDE_template.md"
  end

  def post_install
    # ~/.multi-claude ディレクトリを作成
    multi_claude_dir = "#{Dir.home}/.multi-claude"
    
    # ディレクトリ作成（既存の場合も権限修正）
    FileUtils.mkdir_p(multi_claude_dir)
    FileUtils.mkdir_p("#{multi_claude_dir}/instructions")
    
    # 必要なファイルをコピー（強制上書き）
    FileUtils.cp("#{bin}/setup.sh", multi_claude_dir, preserve: false)
    FileUtils.cp("#{bin}/agent-send.sh", multi_claude_dir, preserve: false)
    FileUtils.cp("#{share}/CLAUDE_template.md", multi_claude_dir, preserve: false)
    FileUtils.cp_r("#{share}/instructions/.", "#{multi_claude_dir}/instructions/", remove_destination: true)

    # グローバルコマンド作成
    global_script = "#{multi_claude_dir}/multi-claude-global"
    File.write(global_script, File.read("#{bin}/multi-claude"))
    system "chmod", "+x", global_script

    # ~/bin ディレクトリとシンボリックリンク作成
    bin_dir = "#{Dir.home}/bin"
    system "mkdir", "-p", bin_dir
    system "ln", "-sf", global_script, "#{bin_dir}/multi-claude"

    puts ""
    puts "🎉 Multi-Claude システム インストール完了！"
    puts "=================================="
    puts ""
    puts "⚠️  PATH設定確認:"
    path_env = ENV["PATH"]
    if !path_env.include?("#{bin_dir}:")
      puts "  #{bin_dir} がPATHに含まれていません。"
      puts "  以下を ~/.zshrc または ~/.bashrc に追加してください："
      puts "    export PATH=\"$HOME/bin:$PATH\""
      puts "  その後、ターミナルを再起動してください。"
    else
      puts "  ✅ PATH設定OK"
    end
    puts ""
    puts "📋 使用方法:"
    puts "  任意のディレクトリで以下を実行："
    puts "    multi-claude"
    puts ""
    puts "🔧 システム制御:"
    puts "  終了: multi-claude --exit で完全終了"
    puts ""
  end

  test do
    # 基本的なヘルプコマンドのテスト
    system "#{bin}/multi-claude", "--help"
  end
end