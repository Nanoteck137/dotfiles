{ config, pkgs, inputs, ... }: 
let
  haunter = inputs.haunter.packages.x86_64-linux.default;
in {
  systemd.services.sewaddle = {
    enable = true;
    description = "Sewaddle Pocketbase Backend";

    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type           = "simple";
      User           = "sewaddle";
      Group          = "sewaddle";
      LimitNOFILE    = 4096;
      Restart        = "always";
      RestartSec     = "5s";
      ExecStart      = "${haunter}/bin/haunter serve --dir /mnt/tank/appdata/test/pb_data";

      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectHome = false;
    };
  };

  users.users = {
    sewaddle = {
      isSystemUser = true;
      group = "sewaddle";
      home = "/var/lib/sewaddle";
    };
  };

  users.groups = {
    sewaddle = {};
  };
}
