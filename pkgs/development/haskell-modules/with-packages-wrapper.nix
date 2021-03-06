{ stdenv, lib, ghc, llvmPackages, packages, buildEnv
, makeWrapper
, ignoreCollisions ? false, withLLVM ? false }:

# This wrapper works only with GHC 6.12 or later.
assert lib.versionOlder "6.12" ghc.version || ghc.isGhcjs;

# It's probably a good idea to include the library "ghc-paths" in the
# compiler environment, because we have a specially patched version of
# that package in Nix that honors these environment variables
#
#   NIX_GHC
#   NIX_GHCPKG
#   NIX_GHC_DOCDIR
#   NIX_GHC_LIBDIR
#
# instead of hard-coding the paths. The wrapper sets these variables
# appropriately to configure ghc-paths to point back to the wrapper
# instead of to the pristine GHC package, which doesn't know any of the
# additional libraries.
#
# A good way to import the environment set by the wrapper below into
# your shell is to add the following snippet to your ~/.bashrc:
#
#   if [ -e ~/.nix-profile/bin/ghc ]; then
#     eval $(grep export ~/.nix-profile/bin/ghc)
#   fi

let
  isGhcjs       = ghc.isGhcjs or false;
  ghc761OrLater = isGhcjs || lib.versionOlder "7.6.1" ghc.version;
  packageDBFlag = if ghc761OrLater then "--global-package-db" else "--global-conf";
  ghcCommand    = if isGhcjs then "ghcjs" else "ghc";
  libDir        = "$out/lib/${ghcCommand}-${ghc.version}";
  docDir        = "$out/share/doc/ghc/html";
  packageCfgDir = "${libDir}/package.conf.d";
  paths         = lib.filter (x: x ? isHaskellLibrary) (lib.closePropagation packages);
  hasLibraries  = lib.any (x: x.isHaskellLibrary) paths;
  # CLang is needed on Darwin for -fllvm to work:
  # https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/code-generators.html
  llvm          = lib.makeSearchPath "bin"
                  ([ llvmPackages.llvm ]
                   ++ lib.optional stdenv.isDarwin llvmPackages.clang);
in
if paths == [] && !withLLVM then ghc else
buildEnv {
  inherit (ghc) name;
  paths = paths ++ [ghc];
  inherit ignoreCollisions;
  postBuild = ''
    . ${makeWrapper}/nix-support/setup-hook

    ${lib.optionalString isGhcjs ''
    cp -r "${ghc}/${ghc.libDir}/"* ${libDir}/
    ''}

    if test -L "$out/bin"; then
      binTarget="$(readlink -f "$out/bin")"
      rm "$out/bin"
      cp -r "$binTarget" "$out/bin"
      chmod u+w "$out/bin"
    fi

    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg             \
        --add-flags '"-B$NIX_GHC_LIBDIR"'                   \
        --set "NIX_GHC"        "$out/bin/${ghcCommand}"     \
        --set "NIX_GHCPKG"     "$out/bin/${ghcCommand}-pkg" \
        --set "NIX_GHC_DOCDIR" "${docDir}"                  \
        --set "NIX_GHC_LIBDIR" "${libDir}"                  \
        ${lib.optionalString withLLVM ''--prefix "PATH" ":" "${llvm}"''}
    done

    for prg in runghc runhaskell; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg             \
        --add-flags "-f $out/bin/ghc"                       \
        --set "NIX_GHC"        "$out/bin/${ghcCommand}"     \
        --set "NIX_GHCPKG"     "$out/bin/${ghcCommand}-pkg" \
        --set "NIX_GHC_DOCDIR" "${docDir}"                  \
        --set "NIX_GHC_LIBDIR" "${libDir}"
    done

    for prg in ${ghcCommand}-pkg ${ghcCommand}-pkg-${ghc.version}; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "${packageDBFlag}=${packageCfgDir}"
    done

    ${lib.optionalString hasLibraries "$out/bin/${ghcCommand}-pkg recache"}
    $out/bin/${ghcCommand}-pkg check
  '';
} // {
  preferLocalBuild = true;
  inherit (ghc) version meta;
}
