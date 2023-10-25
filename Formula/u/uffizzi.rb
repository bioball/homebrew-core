class Uffizzi < Formula
  desc "Self-serve developer platforms in minutes, not months with k8s virtual clusters"
  homepage "https://uffizzi.com"
  url "https://github.com/UffizziCloud/uffizzi_cli/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "59896c1646c8cd9261b32154efbd063fba507382899e1377f2369fb0e58b608b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ff602edbfcfea058438671d0ee6d1294709d086c6ad69bf372ed68599b8ac63"
    sha256 cellar: :any,                 arm64_ventura:  "73f51b9d9a569ddf99bb6c904afdd190e33b985516f6bf6df5c3499500cc7a32"
    sha256 cellar: :any,                 arm64_monterey: "91da0386cad55c4567f6ad8d20f24ad0bf134afa37176dcfb03ef4e6b846da15"
    sha256 cellar: :any,                 sonoma:         "46ed19d29857e0d8394a1003c2c246d193cb56877ddd59a755e3dd1970fa6d5a"
    sha256 cellar: :any,                 ventura:        "82a7d6d9a109726465fa8f5fe34e2594c9fdcbdc916a179c44d2615aede06c4d"
    sha256 cellar: :any,                 monterey:       "7a4cb03baec906f1a50a3d2f84dc76e6ce4528bd254813aec6b2b2124af61618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1f4499c4ca3d1688b4732d37502d5dcdd3ee317d88867d4bc744d982f4db18"
  end

  depends_on "ruby@3.0"

  resource "activesupport" do
    url "https://rubygems.org/gems/activesupport-6.1.4.1.gem"
    sha256 "44b781877c2189aa15ca5451e2d310dcedfd16c01df1106f68a91b82990cfda5"
  end

  resource "awesome_print" do
    url "https://rubygems.org/gems/awesome_print-1.9.2.gem"
    sha256 "e99b32b704acff16d768b3468680793ced40bfdc4537eb07e06a4be11133786e"
  end

  resource "faker" do
    url "https://rubygems.org/gems/faker-3.2.1.gem"
    sha256 "d6b201b520213f6d985ac9f9f810154397a146ca22c1d3ff0a6504ef37c5517b"
  end

  resource "launchy" do
    url "https://rubygems.org/gems/launchy-2.5.2.gem"
    sha256 "8aa0441655aec5514008e1d04892c2de3ba57bd337afb984568da091121a241b"
  end

  resource "minitar" do
    url "https://rubygems.org/gems/minitar-0.9.gem"
    sha256 "23c0bebead35dbfe9e24088dc436c8a233d03f51d365a686b9a11dd30dc2d588"
  end

  resource "securerandom" do
    url "https://rubygems.org/gems/securerandom-0.2.2.gem"
    sha256 "5fcb3b8aa050bac5de93a5e22b69483856f70d43affeb883bce0c58d71360131"
  end

  resource "sentry-ruby" do
    url "https://rubygems.org/gems/sentry-ruby-5.12.0.gem"
    sha256 "2a8c161a9e5af6e8af251a778b5692fa3bfaf355a9cf83857eeef9f84e0e649a"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.3.0.gem"
    sha256 "1adc7f9e5b3655a68c71393fee8bd0ad088d14ee8e83a0b73726f23cbb3ca7c3"
  end

  resource "tty-prompt" do
    url "https://rubygems.org/gems/tty-prompt-0.23.1.gem"
    sha256 "fcdbce905238993f27eecfdf67597a636bc839d92192f6a0eef22b8166449ec8"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "uffizzi-cli" do
    url "https://rubygems.org/gems/uffizzi-cli-2.2.2.gem"
    sha256 "287690243c2e9bfc29c5cba33153ae89426773d9f45cb2944ca2d75b6ddba971"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document", "--install-dir", libexec
    end

    bin.install Dir["#{libexec}/bin/*"]

    bin.env_script_all_files(libexec, GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uffizzi version")
    server_url = "https://example.com"
    system bin/"uffizzi config set server #{server_url}"
    assert_match server_url, shell_output("#{bin}/uffizzi config get-value server")
  end
end
