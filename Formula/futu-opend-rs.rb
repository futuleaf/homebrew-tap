class FutuOpendRs < Formula
  desc "Rust implementation of FutuOpenD trading gateway (TCP/REST/gRPC/WS/MCP)"
  homepage "https://futuapi.com/"
  version "1.4.22"
  license :cannot_represent # Proprietary Free Software

  # v1.4.8 因为 GitHub Actions 配额耗尽，只手工打了 macos-arm64 + linux-x86_64 两个
  # 平台 tarball。macos-x86_64 和 linux-aarch64 的 URL 会 404（sha256 保留旧占位值），
  # CI 恢复后下一版同步补齐。大多数用户都在 Apple Silicon Mac 或 x86_64 Linux 上。
  on_macos do
    if Hardware::CPU.arm?
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-macos-arm64.tar.gz"
      sha256 "e8be77ecae570ec7ee6ef0e750f94dbf90c9e88637698ac0a9e948df321a9c3c"
    else
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-macos-x86_64.tar.gz"
      sha256 "01a2f879b80e9a3d024ca905b266d52e7e2c48eabe61443ed2d95b737811a4fa"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-linux-aarch64.tar.gz"
      sha256 "00261de5d057c618051e2425162cb4baa4011d5729b8f2df860c65db11dc4565"
    else
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-linux-x86_64.tar.gz"
      sha256 "4777c92cbf260ac94ab54d3631f4ce078a02d2cc2ad573a7afd33c6b388aca48"
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
