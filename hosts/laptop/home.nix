{
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./modules/home/zsh.nix
    ./modules/home/git.nix
    ./modules/home/tmux.nix
    ./modules/home/copyq.nix
    ./modules/home/dconf.nix
    ./modules/home/flameshot.nix
    ./modules/home/extensions.nix
    ./modules/home/associations.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";

  sops = {
    age.sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets/default.yaml;
    secrets."user/keys/sops/private" = {};
  };

  sops.templates."keys.txt" = {
    content = ''${config.sops.placeholder."user/keys/sops/private"}'';
    path = "/home/${username}/.config/sops/age/keys.txt";
  };

  home.sessionVariables = {
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bat
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
