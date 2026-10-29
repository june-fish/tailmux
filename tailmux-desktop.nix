{
  lib,
  stdenv,
  rustPlatform,
  fetchPnpmDeps,
  cargo-tauri,
  glib-networking,
  nodejs,
  pnpm,
  pnpmConfigHook,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  fetchgit,
  libayatana-appindicator,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tailmux";
  version = "v1.3.0";
  src = fetchgit {
    url = "https://github.com/GrowlyX/tailmux";
    tag = "v1.3.0";
    hash = "sha256-ql5Jp5OxL6dNU/VVBC7xhCJVVeUK4MXHrH/dVHXWL8E=";
  };

  cargoHash = "sha256-ZBBeKOjK187J6Ti1AClNgbVpqrrcqshL7g2Xya7Y0dA=";

  pnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-pnpm-deps";
    inherit (finalAttrs) src;
    fetcherVersion = 4;
    hash = "sha256-wJgH2eAfut/aTlwieMKOaTvaKFtnACDhZErbodXpccs=";
    sourceRoot = "${finalAttrs.src.name}/desktop";
  };
  pnpmRoot = "desktop";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpmConfigHook
    pnpm
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
    libayatana-appindicator
  ];

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  cargoRoot = "desktop/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  meta = {
    description = "Stay on multiple Tailscale tailnets at once!";
    homepage = "https://github.com/GrowlyX/tailmux";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
