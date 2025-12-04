# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  user,
  hostname,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    ../modules/northstar-server.nix # actual server

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  networking.hostName = hostname;

  users.users = {
    ${user} = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      # TODO: change this
      hashedPassword = "$6$/z6YyegHnNgDP/M7$tzSStC8OBpp8O/SGnQHFnM1dv.2g.agZTS7IGvUSgyqdS9bjTV5oLGFMDIU3LLwmvkhfK7n5AaPZzTX31AjRC0"; # password
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      UseDns = true;
      X11Forwarding = true;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      StrictModes = true;
    };
  };

  # TODO: add packages to the system; this just kind of my personal preference
  environment.systemPackages = with pkgs; [
    git
    helix
    gitui
    fzf
    yazi
  ];

  # TODO: maybe update the state version based on what nixos infect generated check in /etc/nixos
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
