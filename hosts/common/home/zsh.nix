{config, pkgs, ...}:
{
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
    };

    shellAliases = {
      "lg" = "${pkgs.lazygit}/bin/lazygit";
    };

    initExtra = if pkgs.stdenv.isDarwin then ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      any-nix-shell zsh --info-right | source /dev/stdin
    '' 
    else ''
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };
}
