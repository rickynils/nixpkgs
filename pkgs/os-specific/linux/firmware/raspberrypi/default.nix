{ stdenv, fetchurl }:

let

  rev = "833534cacc4bd0ce1ed2c077bb42aa466c468536";

in stdenv.mkDerivation {
  name = "raspberrypi-firmware-${rev}";

  src = fetchurl {
    url = "https://github.com/raspberrypi/firmware/archive/${rev}.tar.gz";
    sha256 = "1ihl075l96qnpd3zxb0k1cl4pi3wbz1977z5h2hh9lxxal9ivmlr";
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
    license = stdenv.lib.licenses.unfree;
  };
}
