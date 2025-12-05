{
  lib,
  systemdMinimal,
  hwinfo,
  gcc,
  pkg-config,
  stdenv,
  buildGo124Module,
  versionCheckHook,
}:
let
  fs = lib.fileset;
in
buildGo124Module (final: {
  pname = "nixos-facter";
  version = "0.4.2";

  src = fs.toSource {
    root = ../../..;
    fileset = fs.unions [
      ../../../cmd
      ../../../go.mod
      ../../../go.sum
      ../../../main.go
      ../../../pkg
    ];
  };

  vendorHash = lib.fileContents ./goVendorHash.txt;

  buildInputs = [
    systemdMinimal
    hwinfo
  ];

  nativeBuildInputs = [
    gcc
    pkg-config
    versionCheckHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/numtide/nixos-facter/pkg/build.Name=${final.pname}"
    "-X github.com/numtide/nixos-facter/pkg/build.Version=v${final.version}"
    "-X github.com/numtide/nixos-facter/pkg/build.System=${stdenv.hostPlatform.system}"
  ];

  doInstallCheck = true;
  # Note: We intentionally don't wrap with systemdMinimal in PATH
  # to ensure the program uses the system's udevadm instead of nixpkgs version
  postInstall = '''';

  meta = with lib; {
    description = "nixos-facter: declarative nixos-generate-config";
    homepage = "https://github.com/nix-community/nixos-facter";
    license = licenses.mit;
    mainProgram = "nixos-facter";
  };
})
