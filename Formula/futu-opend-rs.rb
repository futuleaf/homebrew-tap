class FutuOpendRs < Formula
  desc "Rust implementation of FutuOpenD trading gateway (TCP/REST/gRPC/WS/MCP)"
  homepage "https://futuapi.com/"
  version "1.6.3"
  license :cannot_represent # Proprietary Free Software

  # macOS / Linux 的 arm64 与 x86_64 包由同一 release source SHA 构建和封印。
  on_macos do
    if Hardware::CPU.arm?
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-macos-arm64.tar.gz"
      sha256 "f447c37189c8c4c5bb182b6a6f6c9636424d4c83a9704f85ff87958e00fa60f6"
    else
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-macos-x86_64.tar.gz"
      sha256 "0287d2d17248d9363db0d4a001e7baff444f545041ddaa35b6d22f131e3f4dc6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-linux-aarch64.tar.gz"
      sha256 "500c5cb21eb8954fcd7432ce7284789a03acb01f3c3f322b5473af2a400cb335"
    else
      url "https://futuapi.com/releases/rs-v#{version}/futu-opend-rs-#{version}-linux-x86_64.tar.gz"
      sha256 "e071005b581c4adc87908d4f850e3e3634df1f00801130b60d8e23a8d6b20791"
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
