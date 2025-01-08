{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    htop
  ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
