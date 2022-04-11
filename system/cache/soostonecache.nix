{
  nix.settings = {
    substituters = [
      s3://soostone-nix-cache?profile=soostone
    ];
    trusted-public-keys = [
      "soostone.com-1:HH1l8F1W1Wt4xW7LBVj3dBlesomw5Qscl66upQkvPMk="
    ];
  };
}
