{ pkgs, ... }:
{
  services.signaldctl = {
    enable = true;
    user = "kayvan";
  };
}
