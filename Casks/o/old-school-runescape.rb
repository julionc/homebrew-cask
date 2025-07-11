cask "old-school-runescape" do
  version "1.2"
  sha256 :no_check

  url "https://www.runescape.com/downloads/OldSchool.dmg"
  name "Old School RuneScape"
  desc "Game client for Old School RuneScape"
  homepage "https://oldschool.runescape.com/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-12-25", because: :discontinued

  app "Old School RuneScape.app"

  zap trash: [
    "~/jagex_cl_oldschool_LIVE.dat",
    "~/jagexcache/oldschool",
    "~/random.dat",
  ]

  caveats do
    requires_rosetta
  end
end
