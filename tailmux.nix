{
  buildGo127Module,
  fetchFromGitHub,
  lib,
}:

buildGo127Module (finalAttrs: {
  pname = "tailmux";
  version = "1.5.0";

  patches = [ ./0001-fix-systemd-service-path-on-nixos.patch ];

  src = fetchFromGitHub {
    owner = "GrowlyX";
    repo = "tailmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4iUtfB8qm3seAlH4vRpfnWk+4wie6xLfc6OUnZnLpqI=";
  };

  vendorHash = "sha256-FsyqGNg0sZ7sujdaRtgRMzSt24pfMHlUd0wq3n/2/lw=";

  meta = {
    description = "Stay on multiple Tailscale tailnets at once!";
    homepage = "https://github.com/GrowlyX/tailmux";
    license = lib.licenses.bsd3;
  };
})
