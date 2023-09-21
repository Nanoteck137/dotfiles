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

  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  gtk.enable = true;

  gtk.cursorTheme.package = pkgs.simp1e-cursors;
  gtk.cursorTheme.name = "Simp1e-Tokyo-Night-Storm";

  gtk.theme.package = pkgs.tokyo-night-gtk;
  gtk.theme.name = "Tokyonight-Storm-BL";

  # gtk.iconTheme.package = pkgs.papirus-icon-theme;
  # gtk.iconTheme.name = "Papirus-Dark";

  gtk.iconTheme.package = pkgs.dracula-icon-theme;
  gtk.iconTheme.name = "Dracula";

  home.stateVersion = "23.05";
}
