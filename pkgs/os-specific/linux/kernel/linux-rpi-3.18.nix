{ stdenv, fetchurl, ... } @ args:

let

  rev = "18c437ba73dc66c346f1e027ab6f9c7bd3b09df3";

in import ./generic.nix (args // rec {
  version = "3.18.0";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "https://github.com/raspberrypi/linux/archive/${rev}.tar.gz";
    sha256 = "0ya03a9y8zwq32rz0wvk6ixvv8jdf2kgjf1bn6nf6llyk3qny176";
  };

  features.iwlwifi = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
