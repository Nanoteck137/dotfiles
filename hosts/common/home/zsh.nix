{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "dev-shell" ''
      export REALSHELL=$SHELL
      nix develop --command $SHELL
    '')
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
      # "dev-shell" = "nix develop --command zsh";
    };

    initExtra = if pkgs.stdenv.isDarwin then ''
      eval "$(/opt/homebrew/bin/brew shellenv)"

      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin

      export PATH=~/.npm-global/bin:$PATH
      export PATH=~/opt/flutter/bin:$PATH

      if [[ -n $REALSHELL ]]; then
        export SHELL=$REALSHELL
      fi
      
    '' else "";
  };
}
