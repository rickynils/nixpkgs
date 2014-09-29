{ stdenv, fetchurl }:

let

  rev = "9d58d7bcc9d1442610ee82a18fbb203d49e915a1";

in stdenv.mkDerivation {
  name = "raspberrypi-firmware-${rev}";

  src = fetchurl {
    url = "https://github.com/raspberrypi/firmware/archive/${rev}.tar.gz";
    sha256 = "0s7fhziqj2l90qcdj4dm90x2axsy4b6m9pxbiq8m3qqwz2inrqk8";
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
