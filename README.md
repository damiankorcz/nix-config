# nixos-config

No longer maintained. I've since moved to CachyOS.

---

> ⚠️ WIP - Not intended for direct use. Made for my setup / systems specifically.

# 🌟 Points of Interest

## General
- Auto-mounting a Samba share on boot with all the user permissions working flawlessly: [Samba.nix](https://github.com/damiankorcz/nix-config/blob/main/common/samba.nix). Requires you to create a `smb-secrets` file to store the `username` and `password`.

## Main Desktop
- I run the 5700X3D undervolted -30mv across all cores.
  - Using this script: [undervolt.py](https://github.com/damiankorcz/nix-config/blob/main/scripts/undervolt.py)
  - Ran as a service: [default.nix](https://github.com/damiankorcz/nix-config/blob/main/hosts/desktop/default.nix#L49)
- Using a 15Khz CRT TV (JVC TM-A170GE) as a monitor (for retro gaming)
  - Hardware I use: AMD Radeon R5 340x for analogue signal out -> [RGB-2YC Converter](https://www.axunworks.com/product-p341706.html) for changing the VGA to S-Video -> S-Video to the CRT TV.
  - This setup requires specific 15Khz kernel patches from this repository: [D0023R/linux_kernel_15khz](https://github.com/D0023R/linux_kernel_15khz)
  - How I've implemented it (I pin the kernel to the latest stable kernel supported by the patches): [hardware-configuration.nix](https://github.com/damiankorcz/nix-config/blob/main/hosts/desktop/hardware-configuration.nix#L96)
  - Need to set the default resolution for the CRT TV since there is no EDID info: [hardware-configuration.nix](https://github.com/damiankorcz/nix-config/blob/main/hosts/desktop/hardware-configuration.nix#L87)
  - Since my main GPU is Nvidia (RTX 2080), I need to use the Nvidia Prime Sync option. Then the AMD GPU is simply used as a monitor output and the Nvidia GPU does all the rendering. That is setup here: [hardware-configuration.nix](https://github.com/damiankorcz/nix-config/blob/main/hosts/desktop/hardware-configuration.nix#L65)
  - If you use X11, there is [switchres](https://search.nixos.org/packages?channel=unstable&show=switchres&from=0&size=50&sort=relevance&type=packages&query=switchres) available for changing resolutions on the fly depending on what system you are emulating. This should also work with the switchres setup within RetroArch (I personally prefer all standalone emulators).

# 🎯 Hosts

## 🖥️ Main Desktop - Custom Build
<details>
<summary>Specification</summary>

| **Specification**         | **Description**                                                                        |
| ------------------------- | -------------------------------------------------------------------------------------- |
| **Operating System**      | Windows 11 Pro / NixOS (Dual Boot)                                                     |
| **Case**                  | Phanteks Enthoo Evolv ATX (Galaxy Silver)                                              |
| **CPU**                   | AMD Ryzen R7 5700X3D (8c \/ 16t 3 GHz Base \/ 4.1 GHz Turbo) -30mv All Core Undervolt  |
| **Watercooler**           | Corsair Hydro H115i Pro 280mm                                                          |
| **Motherboard**           | ASUS Prime X470-Pro (AM4)                                                              |
| **RAM**                   | G.SKILL Flare X 32 GB (8 GB x 4) 3200 MHz CL14 (F4-3200C14D-16GFX)                     |
| **GPU (Main)**            | Sapphire AMD Radeon RX 9070 XT Pulse 16GB                                              |
| **GPU (CRT)**             | Dell AMD Radeon R5 340x                                                                |
| **PSU**                   | Corsair RM850x Fully Modular Power Supply                                              |
| **Storage (SSD) Linux**   | Lexar NM790 NVMe (1TB)                                                                 |
| **Storage (SSD) Windows** | Sabrent ROCKET NVMe (1TB)                                                              |
| **Monitor 1 Main**        | LG 27GN800-B 27" 1440p IPS 144Hz                                                       |
| **Monitor 2 Portrait**    | AOC Q2577Pwq 25" 1440p AH-IPS 60hz                                                     |
| **Monitor 3 Top**         | AOC Q2577Pwq 25" 1440p AH-IPS 60hz                                                     |
| **Monitor 4 CRT TV**      | JVC TM-A170GE                                                                          |

</details>

## 💻 Laptop - HP Envy 13 (2020) Model: ba0553na
<details>
<summary>Specification</summary>

| **Specification**                 | **Description**                                                               |
| --------------------------------- | ----------------------------------------------------------------------------- |
| **Operating System**              | Windows 11 Pro / NixOS (Dual Boot)                                            |
| **CPU**                           | Intel Core i5-10210U (4c \/ 8t 1.6 GHz Base \/ 4.2 GHz Turbo)                 |
| **RAM**                           | 8 GB DDR4-2666 SDRAM (onboard)                                                |
| **GPU (Integrated)**              | Intel UHD Graphics 620                                                        |
| **GPU (Discrete)**                | NVIDIA GeForce MX350 (2 GB GDDR5 dedicated)                                   |
| **Storage (SSD) Linux & Windows** | Intel Optane Memory H10 (512 GB NVMe M.2 SSD + 32 GB Intel Optane memory)     |
| **Monitor**                       | 13.3" 1080p IPS 400 nits 100% sRGB 60Hz                                       |
| **Wireless Adapter**              | Intel Wi-Fi 6 AX201 (2x2) and Bluetooth 5 combo                               |

</details>
</br>

**Things that don't work:**
- Fingerprint Scanner (no drivers)
- Brightness FN keys (Using a shortcut with Shift instead)
