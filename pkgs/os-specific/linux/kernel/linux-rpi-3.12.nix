{ stdenv, fetchurl, ... } @ args:

let

  rev = "549d2c181429cf9767ac3cc79415eaca62442af8";

in import ./generic.nix (args // rec {
  version = "3.12.34";
  extraMeta.branch = "3.12";

  src = fetchurl {
    url = "https://github.com/raspberrypi/linux/archive/${rev}.tar.gz";
    sha256 = "1hbhdnahsszhsbn5xrnr197gp8681800dgxv7vn294zkbz0w13k6";
  };

  features.iwlwifi = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
