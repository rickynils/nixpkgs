{ stdenv, fetchurl, ... } @ args:

let

  rev = "0d99826d097cf015e950b05440a71b503a51ef40";

in import ./generic.nix (args // rec {
  version = "3.16.1";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "https://api.github.com/repos/raspberrypi/linux/tarball/${rev}";
    name = "linux-raspberrypi-${rev}.tar.gz";
    sha256 = "0bk2cg1vl34dah67q18dvbgs12i4g33shlyq9vf33sq1g42396qd";
  };

  installTargets = [ "zinstall" ];

  features.iwlwifi = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
