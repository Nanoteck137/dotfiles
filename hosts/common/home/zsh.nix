{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    any-nix-shell
  ];

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
    };

    shellAliases = {
      "lg" = "${pkgs.lazygit}/bin/lazygit";
      "nvim-dev" = "NVIM_APPNAME=nvim-dev nvim";
      "dev-shell" = "nix develop --command zsh";
    };

    initExtra = if pkgs.stdenv.isDarwin then ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      any-nix-shell zsh --info-right | source /dev/stdin

      export PATH=~/.npm-global/bin:$PATH
    '' 
    else ''
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };
}
