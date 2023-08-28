{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    htop
  ];

  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}
