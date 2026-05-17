{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- ЗАВАНТАЖУВАЧ ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- МЕРЕЖА ТА ЛОКАЛІЗАЦІЯ ---
  networking.hostName = "david-nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "uk_UA.UTF-8";

  # --- ГРАФІКА (AMD) ---
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # --- GNOME (Замість Pantheon) ---
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # --- КОРИСТУВАЧ ---
  users.users.david = {
    isNormalUser = true;
    description = "David";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "docker" "video" ];
    shell = pkgs.zsh;
  };

  # --- ТЕРМІНАЛ (Zsh + Starship + Auto-suggestions) ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    promptInit = ''
      eval "$(starship init zsh)"
    '';
  };

  # --- ПРОГРАМИ ТА ІНСТРУМЕНТИ ---
  environment.systemPackages = with pkgs; [
    # Системне
    kitty
    starship
    fastfetch
    git
    wget
    htop
    gnome-tweaks # Щоб налаштувати GNOME під себе

    # Твій Кодінг
    python311
    python311Packages.pip
    gcc
    cmake
    gnumake
    vscode

    # Мережа та Ігри
    nmap
    wireshark
    prismlauncher
    telegram-desktop
    discord
  ];

  # --- СЕРВІСИ ---
  virtualisation.docker.enable = true;
  programs.wireshark.enable = true;
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  system.stateVersion = "24.11"; # Актуальна версія
}
