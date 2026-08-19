{config, pkgs, ...}:
{
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;

    settings = {
      version = 1;
    };
  };

  programs.git = {
      enable = true;
      settings = {
        user = {
          name  = "Patrik M. Rosenström";
          email = "patrik.millvik@gmail.com";
        };
      };
  };
}
