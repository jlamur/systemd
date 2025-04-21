# To run:
# ```
# nix run -f default.nix out -- -c 'meson test -C build'
# ```
let
  npins = import ./npins;
  pkgsUnstable = import npins.nixpkgs-unstable { };
  pkgs = import npins.nixos-24-11 {
    overlays = [(prev: final: {
      mkosi-full = pkgsUnstable.mkosi-full;
    })];
  };
  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.jinja2
  ]);
in pkgs.buildFHSEnv {
  name = "systemd-builder";
  targetPkgs = (pkgs: [
    pkgs.mkosi-full

    pkgs.util-linux.dev
    pkgs.gcc
    pkgs.meson
    pkgs.gperf
    pkgs.openssl
    pkgs.libcap.dev
    pkgs.libxcrypt
    pkgs.pkg-config
    pkgs.ninja
  ]);
  profile = ''
    export PYTHONPATH=${pythonEnv}/${pythonEnv.sitePackages}:$PYTHONPATH
  '';
}
