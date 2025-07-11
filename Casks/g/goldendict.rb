cask "goldendict" do
  version "1.5.0-RC2"
  sha256 "bc04acbd5db51d50b8b6262d69117304df96776472b7a1df7ad42dafafe573ff"

  url "https://downloads.sourceforge.net/goldendict/GoldenDict-#{version}-372-gc3ff15f(Qt_5121).dmg",
      verified: "downloads.sourceforge.net/goldendict/"
  name "GoldenDict"
  desc "Feature-rich dictionary lookup program"
  homepage "http://goldendict.org/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :sierra"

  app "GoldenDict.app"
  binary "#{appdir}/GoldenDict.app/Contents/MacOS/GoldenDict"

  zap trash: [
    "~/.goldendict",
    "~/Library/Preferences/org.goldendict.plist",
    "~/Library/Saved Application State/org.goldendict.savedState",
  ]
end
