{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- ЗАГРУЗЧИК И ДУАЛБУТ С WINDOWS 11 ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10; 

  # --- СЕТЬ И ЛОКАЛИЗАЦИЯ (КИЕВ) ---
  networking.hostName = "david-nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "uk_UA.UTF-8";

  # --- ГРАФИКА И ЖЕЛЕЗО (Твой ASUS Vivobook AMD) ---
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true; # Важно для игр (Roblox/Minecraft)
  };

  # --- РАБОЧЕЕ ОКРУЖЕНИЕ PANTHEON ---
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.pantheon.enable = true;
  };
  # Позволяет настраивать Pantheon (темы, шрифты)
  programs.pantheon-tweaks.enable = true;

  # --- ТВОЙ ЮЗЕР И ГРУППЫ ---
  users.users.david = {
    isNormalUser = true;
    description = "David";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "docker" "video" ];
    shell = pkgs.zsh;
  };

  # --- БОЖЕСТВЕННЫЙ ТЕРМИНАЛ (Zsh + Starship + "T9") ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true; # Автодополнение как в CachyOS
    syntaxHighlighting.enable = true; # Подсветка команд
    promptInit = ''
      eval "$(starship init zsh)"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # --- СИСТЕМНЫЕ ПАКЕТЫ (Кодинг + Инструменты) ---
  environment.systemPackages = with pkgs; [
    # Консоль и системное
    kitty          # Быстрый и современный терминал
    starship       # Дизайн строки запроса
    fastfetch      # Красивое инфо о системе
    git
    wget
    htop
    pciutils
    usbutils

    # Разработка на Python (Django, aiogram)
    python311
    python311Packages.pip
    python311Packages.virtualenv
    vscode-with-extensions

    # Разработка на C++ (Твой Messenger)
    gcc
    cmake
    gnumake
    openssl
    nlohmann_json

    # Сетевой аудит (Для интереса к кибербезу)
    nmap
    wireshark
    aircrack-ng

    # Игры и общение
    prismlauncher  # Лучший лаунчер для Minecraft
    telegram-desktop
    discord
    vlc
  ];

  # --- ДОПОЛНИТЕЛЬНЫЕ СЕРВИСЫ ---
  virtualisation.docker.enable = true; # Для контейнеров
  programs.wireshark.enable = true;    # Разрешаем захват пакетов
  
  # Шрифты (обязательно для иконок в терминале)
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # Версия системы (не менять)
  system.stateVersion = "23.11"; 
}