{ pkgs, inputs, ... }:
{
  # ...

  home-manager.users.zerotens = {
    # ...
    programs.niri = {
      package = niri;
      settings = {
        # ...
        spawn-at-startup = [
          {
            command = [
              "noctalia-shell"
            ];
          }
        ];
      };
    };
  };
}