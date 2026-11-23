{
  buildGo127Module,
  fetchFromGitHub,
  lib,
}:

buildGo127Module (finalAttrs: {
  pname = "tailmux";
  version = "1.9.0";

  patches = [ ./0001-fix-systemd-service-path-on-nixos.patch ];

  src = fetchFromGitHub {
    owner = "GrowlyX";
    repo = "tailmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qi+f86StUlIQt+l9zANm0eUnbmbVo0gHjPNhaibtIFw=";
  };

  vendorHash = "sha256-cCdGBcJhZp+8hdMaayeGDiGPw8HHarS3YevNOZdwiVc=";

  meta = {
    description = "Stay on multiple Tailscale tailnets at once!";
    homepage = "https://github.com/GrowlyX/tailmux";
    license = lib.licenses.bsd3;
  };
})
