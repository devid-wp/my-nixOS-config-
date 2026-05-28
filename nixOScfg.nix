{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Настройки графики
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Используем самое свежее ядро
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Модули ядра: amdgpu для графики, btusb для Bluetooth, 
  # и rtw88_8821au (встроенный драйвер для твоего TP-Link AC600)
  boot.kernelModules = [ "amdgpu" "btusb" "rtw88_8821au" ];
  
  # Включаем абсолютно все прошивки, чтобы ядро подтянуло бинарники для Realtek
  hardware.enableAllFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Чистый список кастомных модулей (пусть ядро использует только встроенные)
  boot.extraModulePackages = [ ];

  # Очистили старые tmpfiles-костыли
  systemd.tmpfiles.rules = [];

  # Блеклист неиспользуемых модулей Mediatek
  boot.blacklistedKernelModules = [ "mt7925e" "mt7925_common" ];

  # Настройка загрузчика GRUB с твоей любимой темой OneShot
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    theme = ./OneshotGrubTheme;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Сеть и локализация
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Kyiv";

  # Разрешаем Unfree пакеты
  nixpkgs.config.allowUnfree = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Рабочее окружение KDE Plasma 6 и дисплейный менеджер SDDM
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Настройка пользователя devid
  users.defaultUserShell = pkgs.zsh;
  users.users.devid = {
    isNormalUser = true;
    description = "David";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
    shell = pkgs.zsh;
  };

  # Настройки оболочки Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      bindkey '^[[C' forward-word
    '';
  };

  # Включаем системный сервис Wireshark для управления правами
  programs.wireshark.enable = true;

  # Системные пакеты (Твой софт + инструменты для ИИ-агента и свистка)
  environment.systemPackages = with pkgs; [
    kitty
    papirus-icon-theme
    kdePackages.plasma-browser-integration
    firefox
    fastfetch
    telegram-desktop
    vscode
    wget
    curl
    pciutils
    usbutils
    wpa_supplicant

    # Глаза для твоего ИИ-агента (чтобы работал автоматический поиск по папкам)
    git
    ripgrep

    # Набор для мониторинга и анализа сетей
    iw
    aircrack-ng
    wirelesstools
    wireshark
    tcpdump
  ];

  # Шрифты
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.symbols-only
  ];

  system.stateVersion = "24.11";
}
