{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.system.nvidia;
in {
  options.nano.system = {
    nvidia = {
      enable = lib.mkEnableOption "enable nvidia drivers";
      legacy = lib.mkEnableOption "use legacy drivers";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages."${if cfg.legacy then "legacy_470" else "stable"}";
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
    };

    nixpkgs.config.nvidia.acceptLicense = true;
  };
}
