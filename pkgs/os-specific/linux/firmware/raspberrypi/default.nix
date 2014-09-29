{ stdenv, fetchurl }:

let

  rev = "79acaf6152ef384f05fe2ec90134a6b02348e41d";

in stdenv.mkDerivation {
  name = "raspberrypi-firmware-${rev}";

  src = fetchurl {
    url = "https://github.com/raspberrypi/firmware/archive/${rev}.tar.gz";
    sha256 = "0vv1a85qb4vc1kkjcwnmfawp7xbswgpyv81vl4cnwlf27v1hjaaa";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/boot
    cp -R boot/* $out/share/raspberrypi/boot
    cp -R hardfp/opt/vc/* $out
    cp opt/vc/LICENCE $out/share/raspberrypi
  '';
  
  meta = {
    description = "Firmware for the Raspberry Pi board";
    homepage = https://github.com/raspberrypi;
    license = "non-free";
  };
}
