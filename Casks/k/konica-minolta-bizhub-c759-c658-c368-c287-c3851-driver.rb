cask "konica-minolta-bizhub-c759-c658-c368-c287-c3851-driver" do
  on_catalina :or_older do
    version "11.6.0,08e8308b1e134d6bb6837e3b046b126b,122431"
    sha256 "8baec3e834f41d4156b3da9ff598171af4182290d7af1183f07df7476158a4b7"

    livecheck do
      skip "Legacy version"
    end

    pkg "C759_C658_C368_C287_C3851_Series_v#{version}_Letter/C759_C658_C368_C287_C3851.pkg"
  end
  on_big_sur :or_newer do
    version "11.9.0A,eb6d403e0fae336969cf627b3e38a647,139511"
    sha256 "1e21d40a62e37222b350299f95496898e7934fef71421a4990f7e78f0bf91fe2"

    livecheck do
      url "https://dl.konicaminolta.eu/en?tx_kmdownloadcenter_dlajaxservice[action]=getDocuments&tx_kmdownloadcenter_dlajaxservice[controller]=AjaxService&tx_kmdownloadcenter_dlajaxservice[productId]=102314&tx_kmdownloadcenter_dlajaxservice[system]=KonicaMinolta&cHash=dd72618a38434b6cb3edfc20595d58c5&type=1527583889"
      strategy :json do |json|
        json.map do |item|
          next if item["TypeOfApplicationId_textS"] != "1"
          next unless item["OperatingSystemsNames_textM"]&.any? { |os| os =~ /macOS/i }

          version = item["Version_textS"]
          document_id = item["AnacondaId_textS"]
          next if version.blank? || document_id.blank?

          files = item["DownloadFiles_textS"]&.split("\n")&.map { |file| file.split("|") }
          dmg_file = files.find { |file| file.first.end_with?(".dmg") } if files
          next if dmg_file.blank?

          "#{version},#{Digest::MD5.hexdigest(dmg_file[2])},#{document_id}"
        end
      end
    end

    pkg "C759_C658_C368_C287_C3851_#{version.major}.pkg"
  end

  url "https://dl.konicaminolta.eu/en?tx_kmdownloadproxy_downloadproxy[fileId]=#{version.csv.second}&tx_kmdownloadproxy_downloadproxy[documentId]=#{version.csv.third}&tx_kmdownloadproxy_downloadproxy[system]=KonicaMinolta&tx_kmdownloadproxy_downloadproxy[language]=EN&type=1558521685"
  name "Konica Minolta Bizhub C759/C658/C368/C287/C3851 Series Printer"
  desc "Drivers for Konica Monolta Bizhub printers"
  homepage "https://www.konicaminolta.eu/eu-en/support/download-centre"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  uninstall_preflight do
    set_ownership "/Library/Printers/KONICAMINOLTA/Preferences"
  end

  uninstall pkgutil: "jp.konicaminolta.print.package.C759"

  zap trash: [
        "/Library/Printers/KONICAMINOLTA/Preferences/jp.konicaminolta.printers.C759",
        "/Library/Printers/KONICAMINOLTA/Preferences/jp.konicaminolta.printers.C759.plist",
      ],
      rmdir: "/Library/Printers/KONICAMINOLTA"
end
