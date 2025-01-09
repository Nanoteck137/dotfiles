{config, pkgs, inputs, ...}: {
  imports = [
    inputs.self.outputs.homeManagerModules.default
  ];

  nano.home.zsh.enable = true;
  nano.home.alacritty.enable = true;
  nano.home.nvim.enable = true;
  nano.home.git.enable = true;
  nano.home.tmux.enable = true;

  nano.home.discord.enable = true;
  nano.home.vscode.enable = true;
  nano.home.feh.enable = true;

  home.stateVersion = "23.05";
}
