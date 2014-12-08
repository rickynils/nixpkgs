{ stdenv, fetchurl, ... } @ args:

let

  rev = "b82491cb94745a8cac9ac6b79763a8e281ae7add";

in import ./generic.nix (args // rec {
  version = "3.12.34";
  extraMeta.branch = "3.12";

  src = fetchurl {
    url = "https://github.com/raspberrypi/linux/archive/${rev}.tar.gz";
    sha256 = "08yfsl7l388sr5v62ig1yiq006skmwd0s6ss3bhnn68w4pyi1d35";
  };

  installTargets = [ "zinstall" ];

  features.iwlwifi = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
