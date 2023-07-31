{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    firefox
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ];
}
