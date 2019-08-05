{ config, pkgs, lib, ... }:

let

  inherit (lib) mkIf any;

in {
  config = mkIf (any (fs: fs == "overlay") config.boot.initrd.supportedFilesystems) {

    boot.initrd.availableKernelModules = [ "overlay" ];

  };
}
