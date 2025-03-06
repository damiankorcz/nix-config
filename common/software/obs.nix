{ pkgs, config, ... }:
{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };

  security.polkit.enable = true;

  # OBS + Plugins
  environment.systemPackages = with pkgs; [
    obs-studio # Open Broadcasting Studio

    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs # Screen capture on wlroots based wayland compositors
        obs-pipewire-audio-capture # Audio device and application capture for OBS Studio using PipeWire
        obs-vkcapture # Vulkan/OpenGL game capture
        obs-backgroundremoval # Replace the background in portrait images and video
        droidcam-obs # Capture Droidcam as a source
        obs-nvfbc # Plugin for NVIDIA FBC API
      ];
    })
  ];
}
