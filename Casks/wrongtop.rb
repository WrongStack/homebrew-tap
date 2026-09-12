cask "wrongtop" do
  version "2.0.1"

  sha256 arm:   "e053f13113859804f005965aab052913033d5931c2dfafc8d4e93eb8db0d72cd",
         intel: "8024886099e97100f0a5b3630e904034ac6044795b8a4d72e997cfc04731bac6"

  # macOS-only content: without this stanza brew readall (4.x) evaluates
  # the cask for Linux and rejects it over a nil Linux sha256. Floor
  # matches the Go 1.26 darwin toolchain (macOS 12+); symbol form is the
  # non-deprecated DSL (">= :monterey" string comparison is deprecated).
  depends_on macos: :monterey

  on_arm do
    url "https://github.com/wrongstack/wrongtop/releases/download/v#{version}/wrongtop_darwin_aarch64.tar.gz"
  end
  on_intel do
    url "https://github.com/wrongstack/wrongtop/releases/download/v#{version}/wrongtop_darwin_x86_64.tar.gz"
  end

  name "WrongTop"
  desc "Cross-platform terminal system monitor"
  homepage "https://github.com/wrongstack/wrongtop"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  binary "wrongtop"

  # Release binaries are unsigned and un-notarized; without dropping the
  # quarantine attribute macOS Gatekeeper blocks every launch. Mirrors the
  # goreleaser homebrew_casks hook in wrongtop's .goreleaser.yaml.
  postflight do
    if OS.mac?
      system_command "/usr/bin/xattr",
                     args: ["-dr", "com.apple.quarantine", "#{staged_path}/wrongtop"]
    end
  end
end
