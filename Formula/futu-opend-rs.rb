class FutuOpendRs < Formula
  desc "Rust implementation of FutuOpenD trading gateway (TCP/REST/gRPC/WS/MCP)"
  homepage "https://futuapi.com/"
  version "1.5.0"
  license :cannot_represent # Proprietary Free Software

  # v1.4.8 因为 GitHub Actions 配额耗尽，只手工打了 macos-arm64 + linux-x86_64 两个
  # 平台 tarball。macos-x86_64 和 linux-aarch64 的 URL 会 404（sha256 保留旧占位值），
  # CI 恢复后下一版同步补齐。大多数用户都在 Apple Silicon Mac 或 x86_64 Linux 上。
  on_macos do
    if Hardware::CPU.arm?
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-macos-arm64.tar.gz"
      sha256 "e645b22f9273db34df1025f913fb75196ea32672ed9c97e13846d2d0b7a92249"
    else
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-macos-x86_64.tar.gz"
      sha256 "e241cada6d84b095525daece3a32f03789b6f1224b077ef1cfdd00d6640f2df0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-linux-aarch64.tar.gz"
      sha256 "56ca494f4027cbcc89f3482ee03218cb41e5a2726a27f01f82b8dee3406d6c26"
    else
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-linux-x86_64.tar.gz"
      sha256 "7e1411e0f1ee0c8f28339b67abe789fbdbf84b0b1b0293edded625ad22ff8ef9"
    end
  end

  def install
    bin.install "futu-opend"
    bin.install "futu-mcp"
    bin.install "futucli"

    # 示例配置和文档
    doc.install "README.md" if File.exist?("README.md")
    doc.install "LICENSE" if File.exist?("LICENSE")
    pkgshare.install "examples" if File.directory?("examples")
  end

  def caveats
    <<~EOS
      三个二进制已安装到 PATH：
        futu-opend   网关（TCP/REST/gRPC/WebSocket）
        futu-mcp     MCP server（供 Claude / Cursor 等 LLM 调用）
        futucli      命令行客户端 + 交互式 REPL

      快速启动：
        futu-opend --login-account 你的富途账号 --login-pwd 你的密码

      示例配置文件：
        #{opt_pkgshare}/examples/

      完整文档：https://futuapi.com/
    EOS
  end

  test do
    assert_match "futu-opend", shell_output("#{bin}/futu-opend --help")
    assert_match "futu-mcp", shell_output("#{bin}/futu-mcp --help")
    assert_match "futucli", shell_output("#{bin}/futucli --help")
  end
end
