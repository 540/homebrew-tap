# Cask de Homebrew para Scribe — canal de distribución del equipo (uso interno).
#
# Esta es la PLANTILLA (fuente de verdad). No la edites con versiones a mano:
# scripts/release-cask.sh rellena 0.1.9 y e8b14c6f243b46ca837eae5e97fd984750aba17e99b39651cfb9f91265f291b9 a partir
# del .zip generado por scripts/package-app.sh y publica el resultado en el tap
# público 540/homebrew-tap (Casks/scribe.rb).
#
# El equipo instala/actualiza con:
#   brew tap 540/tap
#   brew install --cask scribe      #  actualizar:  brew upgrade --cask scribe
#
# Nota sobre la firma: hoy el .app va firmado AD-HOC (sin Developer ID), así que
# Gatekeeper lo pondría en cuarentena. El bloque `postflight` la retira tras
# instalar. Cuando la org tenga un certificado "Developer ID Application" y las
# releases se notaricen (package-app.sh --notarize), ese postflight sobra y se
# puede borrar.
cask "scribe" do
  version "0.1.9"
  sha256 "e8b14c6f243b46ca837eae5e97fd984750aba17e99b39651cfb9f91265f291b9"

  url "https://github.com/540/homebrew-tap/releases/download/v#{version}/Scribe-#{version}.zip"
  name "Scribe"
  desc "Bot-free meeting notes with on-device transcription"
  homepage "https://github.com/540/Scribe"

  livecheck do
    url "https://github.com/540/homebrew-tap"
    strategy :github_latest
  end

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Scribe.app"

  # Firma ad-hoc: retiramos la cuarentena para que Gatekeeper no bloquee el .app.
  # Innecesario en cuanto las releases estén notarizadas con Developer ID.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Scribe.app"],
                   sudo: false
  end

  uninstall quit: "com.540.scribe"

  zap trash: "~/Library/Application Support/Scribe"

  caveats <<~EOS
    Scribe necesita el CLI de Claude Code para redactar las actas (corre en local):
      https://claude.com/claude-code

    En el primer arranque pedirá permisos de Micrófono y de Grabación del audio del
    sistema, y descargará el modelo de transcripción (~1,6 GB).
  EOS
end
