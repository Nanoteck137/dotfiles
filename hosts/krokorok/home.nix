{config, pkgs, inputs, ...}: {
  imports = [
    ../common/home/kitty.nix
    ../common/home/tmux.nix
    ../common/home/nvim.nix
    ../common/home/zsh.nix
    ../common/home/git.nix
    ../common/home/misc.nix
  ];

  home.username = "nanoteck137";
  home.homeDirectory = "/home/nanoteck137";
  home.packages = with pkgs; [
    rofi
    adapta-gtk-theme
    lxappearance
    discord
    pocketbase
    pavucontrol
  ];

  programs.home-manager.enable = true;
  
  programs.vscode = {
    enable = true;
  };

  xdg.configFile.awesome.source = ../../configs/awesome;
  xdg.configFile.rofi.source = ../../configs/rofi;
  # xdg.configFile.picom.source = ./picom/.config/picom;

  home.file."wallpaper.png".source = ../../wallpaper.png;

  services.picom = {
    enable = true;
    opacityRules = [
      "100:fullscreen"
      "100:!fullscreen"
    ];
  };

  programs.feh = {
    enable = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.stateVersion = "23.05";
}
