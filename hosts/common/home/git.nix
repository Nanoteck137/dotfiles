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
      userName  = "Patrik M. Rosenström";
      userEmail = "patrik.millvik@gmail.com";
  };
}
