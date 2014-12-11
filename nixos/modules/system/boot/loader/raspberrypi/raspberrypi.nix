{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.loader.raspberryPi;

  builder = pkgs.substituteAll {
    src = ./builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    firmware = pkgs.raspberrypifw;
    rpiBootConfig = pkgs.writeText "config.txt" cfg.config;
  };

  platform = pkgs.stdenv.platform;

in

{
  options = {

    boot.loader.raspberryPi = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the Raspberry Pi boot loader. Expects the
          FAT boot partition to be mounted on <literal>/boot</literal>.
          Copies firmware, kernel, initrd and cmdline.txt/config.txt to
          <literal>/boot</literal>. Puts boot files from old system
          generations in <literal>/boot/old</literal>.
        '';
      };

      config = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Configuration added to <literal>/boot/config.txt</literal>
        '';
      };

    };

  };

  config = mkIf config.boot.loader.raspberryPi.enable {
    system.build.installBootLoader = builder;
    system.boot.loader.id = "raspberrypi";
    system.boot.loader.kernelFile = platform.kernelTarget;
  };
}
