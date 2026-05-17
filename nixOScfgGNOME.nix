{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- ДОЗВОЛЯЄМО ДРАЙВЕРИ ТА VS CODE (Виправляє твою помилку) ---
  nixpkgs.config.allowUnfree = true;

  # --- ЯДРО ТА ДРАЙВЕРИ ДЛЯ WI-FI ---
  boot.kernelPackages = pkgs.linuxPackages_latest; # Нове ядро для нового заліза
  hardware.enableAllFirmware = true; # Качає драйвери для MediaTek/Realtek

  # --- ЗАВАНТАЖУВАЧ ТА DUALBOOT ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # --- МЕРЕЖА ТА ЛОКАЛІЗАЦІЯ ---
  networking.hostName = "david-nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "uk_UA.UTF-8";

  # --- ГРАФІКА AMD (Оновлений синтаксис) ---
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Для ігор
  };

  # --- РОБОЧИЙ СТІЛ GNOME (Замість Pantheon) ---
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

  # --- ТЕРМІНАЛ (Zsh + Starship + "T9") ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    promptInit = ''
      eval "$(starship init zsh)"
    '';
  };

  # --- ПРОГРАМИ ---
  environment.systemPackages = with pkgs; [
    # Консоль
    kitty
    starship
    fastfetch
    git
    wget
    htop
    gnome-tweaks

    # Кодінг (Python + C++)
    python311
    python311Packages.pip
    vscode # Тепер запрацює!
    gcc
    cmake
    gnumake

    # Мережа та ігри
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

  system.stateVersion = "24.11"; 
}
