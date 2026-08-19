{ config, pkgs, inputs, self, ... }:
let
in {
  imports = [ ];

  nixpkgs.overlays = [ ];

  stylix.enable = true;
  stylix.image = "${self}/wallpaper.png";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
  stylix.polarity = "dark";
  # stylix.base16Scheme = "${self}/theme.yaml";
  stylix.autoEnable = true;
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };

    monospace = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "klink";
  nano.system.enableSwap = true;

  users.users.${config.nano.system.username}.extraGroups = [ "docker" "uinput" "input" ];

  home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
    imports = [
      inputs.self.outputs.homeManagerModules.default
    ];

    nano.home.zsh.enable = true;
    nano.home.alacritty.enable = true;
    # nano.home.nvim.enable = true;
    nano.home.git.enable = true;
    nano.home.tmux.enable = true;

    # nano.home.discord.enable = true;
    nano.home.vscode.enable = true;
    # nano.home.feh.enable = true;

    stylix.targets.vscode.enable = false;
    stylix.targets.waybar.addCss = false;

    services.udiskie = {
      enable = true;
      settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
          # replace with your favorite file manager
          file_manager = "${pkgs.xfce.thunar}/bin/thunar";
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        # pkgs.hyprlandPlugins.hyprscrolling
      ];
      extraConfig = ''
# See https://wiki.hypr.land/Configuring/Monitors/
monitor=,preferred,auto,auto

# Set programs that you use
$terminal = alacritty
$fileManager = dolphin
$menu = wofi --show drun

exec-once = waybar

# See https://wiki.hypr.land/Configuring/Environment-variables/
env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24

# https://wiki.hypr.land/Configuring/Variables/#general
general {
    gaps_in = 2
    gaps_out = 5

    border_size = 2

    # https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
    # col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    # col.inactive_border = rgba(595959aa)

    # Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = true

    # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
    allow_tearing = false

    # layout = dwindle
    layout = scrolling
}

plugin {
    hyprscrolling {
        column_width = 0.7
        fullscreen_on_one_column = true
        focus_fit_method = 1
    }
}

# https://wiki.hypr.land/Configuring/Variables/#decoration
decoration {
    rounding = 10
    rounding_power = 2

    # Change transparency of focused and unfocused windows
    active_opacity = 1.0
    inactive_opacity = 0.7

    shadow {
        enabled = true
        range = 4
        render_power = 3
        # color = rgba(1a1a1aee)
    }

    # https://wiki.hypr.land/Configuring/Variables/#blur
    blur {
        enabled = true
        size = 3
        passes = 1

        vibrancy = 0.1696
    }
}

# https://wiki.hypr.land/Configuring/Variables/#animations
animations {
    enabled = yes

    # Default animations, see https://wiki.hypr.land/Configuring/Animations/ for more

    bezier = easeOutQuint,0.23,1,0.32,1
    bezier = easeInOutCubic,0.65,0.05,0.36,1
    bezier = linear,0,0,1,1
    bezier = almostLinear,0.5,0.5,0.75,1.0
    bezier = quick,0.15,0,0.1,1

    animation = global, 1, 10, default
    animation = border, 1, 5.39, easeOutQuint
    animation = windows, 1, 4.79, easeOutQuint
    animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
    animation = windowsOut, 1, 1.49, linear, popin 87%
    animation = fadeIn, 1, 1.73, almostLinear
    animation = fadeOut, 1, 1.46, almostLinear
    animation = fade, 1, 3.03, quick
    animation = layers, 1, 3.81, easeOutQuint
    animation = layersIn, 1, 4, easeOutQuint, fade
    animation = layersOut, 1, 1.5, linear, fade
    animation = fadeLayersIn, 1, 1.79, almostLinear
    animation = fadeLayersOut, 1, 1.39, almostLinear
    animation = workspaces, 1, 1.94, almostLinear, fade
    animation = workspacesIn, 1, 1.21, almostLinear, fade
    animation = workspacesOut, 1, 1.94, almostLinear, fade
}

# Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
# "Smart gaps" / "No gaps when only"
# uncomment all if you wish to use that.
workspace = w[tv1], gapsout:0, gapsin:0
workspace = f[1], gapsout:0, gapsin:0
# windowrule = bordersize 1, floating:0, onworkspace:w[tv1]
# windowrule = rounding 10, floating:0, onworkspace:w[tv1]
# windowrule = bordersize 2, floating:0, onworkspace:f[1]
# windowrule = rounding 10, floating:0, onworkspace:f[1]

# See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
#dwindle {
    #pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    # preserve_split = true # You probably want this
#}

# See https://wiki.hypr.land/Configuring/Master-Layout/ for more
master {
    new_status = master
}

# https://wiki.hypr.land/Configuring/Variables/#misc
misc {
    force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
}


# https://wiki.hypr.land/Configuring/Variables/#input
input {
    kb_layout = se
    kb_variant = nodeadkeys
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

    touchpad {
        natural_scroll = false
    }
}

# See https://wiki.hypr.land/Configuring/Keywords/
$mainMod = SUPER # Sets "Windows" key as main modifier

# Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
# Old
# bind = $mainMod, Q, exec, $terminal
# bind = $mainMod, C, killactive,
# bind = $mainMod, M, exit,
# bind = $mainMod, E, exec, $fileManager
# bind = $mainMod, V, togglefloating,
# bind = $mainMod, R, exec, $menu
# bind = $mainMod, P, pseudo, # dwindle
# bind = $mainMod, J, togglesplit, # dwindle

# New Bindings
bind = $mainMod, Return, exec, $terminal
bind = $mainMod, Q, killactive,
bind = $mainMod SHIFT, Q, exit,
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, V, togglefloating,
bind = $mainMod, S, exec, $menu
# bind = $mainMod, P, pseudo, # dwindle
# bind = $mainMod, J, togglesplit, # dwindle

bind = $mainMod, period, layoutmsg, move +col
bind = $mainMod, comma, layoutmsg, move -col
bind = $mainMod SHIFT, period, layoutmsg, movewindowto r
bind = $mainMod SHIFT, comma, layoutmsg, movewindowto l
bind = $mainMod SHIFT, up, layoutmsg, movewindowto u
bind = $mainMod SHIFT, down, layoutmsg, movewindowto d

bind = $mainMod, left, layoutmsg, focus l
bind = $mainMod, right, layoutmsg, focus r
bind = $mainMod, up, layoutmsg, focus u
bind = $mainMod, down, layoutmsg, focus d

# Move focus with mainMod + arrow keys
# bind = $mainMod, left, movefocus, l
# bind = $mainMod, right, movefocus, r
# bind = $mainMod, up, movefocus, u
# bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Example special workspace (scratchpad)
# bind = $mainMod, S, togglespecialworkspace, magic
# bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Laptop multimedia keys for volume and LCD brightness
bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

# Requires playerctl
bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPause, exec, playerctl play-pause
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous

# See https://wiki.hypr.land/Configuring/Window-Rules/ for more
# See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

# Example windowrule
# windowrule = float,class:^(kitty)$,title:^(kitty)$

# Ignore maximize requests from apps. You'll probably like this.
# windowrule = suppress_event maximize, class:.*

# Fix some dragging issues with XWayland
# windowrule = no_focus true,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

windowrule {
  name = windowrule-1
  suppress_event = maximize
  match:class = .*
}


# Fix some dragging issues with XWayland
windowrule {
  name = windowrule-2
  no_focus = true
  match:class = ^$
  match:title = ^$
  match:xwayland = 1
  match:float = 1
  match:fullscreen = 0
  match:pin = 0
}

      '';
    };

    programs.waybar = {
      enable = true;
      style = (builtins.readFile "${self}/configs/waybar/test4.css");

      settings.main = {
        height = 40;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [ 
          "hyprland/window" 
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "tray"
          "clock"
        ];

        "hyprland/window" = { 
          format = "{}"; 
          max-length = 10; 
        };

        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          all-outputs = true;
          on-click = "activate";
        };

        # "tray" = {
        #     "icon-size" = 21;
        #     "spacing" = 10;
        # };

        "pulseaudio" = {
          "format" = "{icon}  {volume}%";
          "format-muted" = "";
          "format-icons" = {
            "default" = ["" ""];
          };
          "scroll-step" = 1;
          "on-click" = "pavucontrol";
        };
      };
    };

    home.packages = with pkgs; [
      rofi
      lxappearance
      pavucontrol
      xfce.thunar
      xfce.tumbler
      # feh
      qimgv
    ];

    # xdg.configFile.awesome.source = "${self}/configs/awesome";
    # xdg.configFile.rofi.source = "${self}/configs/rofi";
    # xdg.configFile.crustle.source = "${self}/configs/crustle";

    home.file."wallpaper.png".source = "${self}/wallpaper.png";

    # services.picom = {
    #   enable = true;
    #   opacityRules = [
    #     "100:fullscreen"
    #     "100:!fullscreen"
    #   ];
    # };

    # programs.feh = {
    #   enable = true;
    # };

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    # qt.enable = true;
    # qt.platformTheme = "gtk";
    # qt.style.name = "adwaita-dark";
    # qt.style.package = pkgs.adwaita-qt;
    #
    # gtk.enable = true;
    #
    gtk.cursorTheme.package = pkgs.simp1e-cursors;
    gtk.cursorTheme.name = "Simp1e-Tokyo-Night-Storm";
    #
    # gtk.theme.package = pkgs.tokyo-night-gtk;
    # gtk.theme.name = "Tokyonight-Storm-BL";
    #
    # # gtk.iconTheme.package = pkgs.papirus-icon-theme;
    # # gtk.iconTheme.name = "Papirus-Dark";
    #
    gtk.iconTheme.package = pkgs.dracula-icon-theme;
    gtk.iconTheme.name = "Dracula";

    home.stateVersion = "23.05";
  };


  nano.system.enableSSH = true;
  nano.nvim.enable = true;
  # nano.ftp.enable = true;
  nano.mullvad.enable = true;

  nano.system.nvidia = {
    enable = true;
  };

  nano.system.enableDesktop = true;
  nano.system.desktopType = "wayland";
  
  # services.xserver = {
  #   displayManager.lightdm = {
  #     enable = true;
  #   };
  #
  #   windowManager.awesome.enable = true;
  # };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };

    autoLogin = {
      enable = true;
      user = config.nano.system.username;
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # services.xserver.desktopManager.budgie.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;

  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = false;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.defaultSession = "plasmax11";

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    wofi
    wl-clipboard

    # CAD / 3D Printing
    freecad
    prusa-slicer
  ];

  # USB Auto-Mounting (used for prusa-slicer)
  services.udisks2.enable = true;

  # 3D Printing
  services.octoprint = {
    enable = true;
    openFirewall = true;
  };

  services.flatpak.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  hardware.uinput.enable = true;

  # services.tailscale.enable = true;
  # services.tailscale.useRoutingFeatures = "both";

  fileSystems."/mnt/other" = {
      device = "//10.28.28.7/other";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  fileSystems."/mnt/media" = {
      device = "//10.28.28.7/media";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
  ];

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

