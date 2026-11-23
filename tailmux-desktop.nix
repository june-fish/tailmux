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
  fetchFromGitHub,
  libayatana-appindicator,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tailmux";
  version = "1.9.0";
  src = fetchFromGitHub {
    owner = "GrowlyX";
    repo = "tailmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qi+f86StUlIQt+l9zANm0eUnbmbVo0gHjPNhaibtIFw=";
  };

  cargoHash = "sha256-rY4a4SugMrJAvZTfZllaUHP7QM3M7zYtt6Gw/A8b9/g=";

  pnpmDeps = fetchPnpmDeps {
    pname = "${finalAttrs.pname}-${finalAttrs.version}-pnpm-deps";
    inherit (finalAttrs) src;
    fetcherVersion = 4;
    hash = "sha256-8zLbpIbKCNBR8rPaz7eu3eFYPb5a/yxZcsajz7mFpFU=";
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
