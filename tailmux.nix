{
  buildGo127Module,
  fetchFromGitHub,
  lib,
}:

buildGo127Module (finalAttrs: {
  pname = "tailmux";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "GrowlyX";
    repo = "tailmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ql5Jp5OxL6dNU/VVBC7xhCJVVeUK4MXHrH/dVHXWL8E=";
  };

  go_latest = true;

  vendorHash = "sha256-NlCTbjSMD0aW7pZjbff2UJ0zE6OnOPFPVt8BdJZG3eg=";

  meta = {
    description = "Stay on multiple Tailscale tailnets at once!";
    homepage = "https://github.com/GrowlyX/tailmux";
    license = lib.licenses.bsd3;
  };
})
