{ stdenv, fetchurl }:

let
  driverdb = fetchurl {
    url = "http://sourceforge.net/p/smartmontools/code/3812/tree/trunk/smartmontools/drivedb.h?format=raw";
    sha256 = "0dr5ggjr3w3rq40pcjd6w2977ilq4zkhx8ylnwjky94pmxwgjflg";
    name = "smartmontools-drivedb.h";
  };
in
stdenv.mkDerivation rec {
  name = "smartmontools-6.2";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "0nq6jvfh8nqwfrvp6fb6qs2rdydi3i9xgpi7p7vb83xvg42ncvs8";
  };

  patchPhase = ''
    : cp ${driverdb} drivedb.h
    sed -i -e 's@which which >/dev/null || exit 1@alias which="type -p"@' update-smart-drivedb.in
  '';

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = "http://smartmontools.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
