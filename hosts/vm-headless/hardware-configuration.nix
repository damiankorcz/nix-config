{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	# ------------ Storage ------------

	disko.devices = {
		my-disk = {
		device = "/dev/sda"; # Adjust this to your actual disk device
		type = "disk";
		content = {
			type = "gpt";
			partitions = {
			ESP = {
				type = "EF00";
				size = "4192MiB";
				content = {
				type = "filesystem";
				format = "vfat";
				mountpoint = "/boot";
				options = [ "fmask=0022" "dmask=0022" ];
				};
			};
			root = {
				type = "primary";
				size = "100%";
				content = {
				type = "filesystem";
				format = "btrfs";
				mountpoint = "/";
				options = [ "subvol=@" "noatime" ];
				subvolumes = {
					home = {
					mountpoint = "/home";
					options = [ "subvol=@home" ];
					};
					nix = {
					mountpoint = "/nix";
					options = [ "subvol=@nix" "noatime" "compress=zstd" ];
					};
					log = {
					mountpoint = "/var/log";
					options = [ "subvol=@log" "noatime" "compress=zstd" ];
					};
				};
				};
			};
			swap = {
				type = "primary";
				size = "8GiB"; # Adjust the size as needed
				content = {
				type = "swap";
				};
			};
			};
		};
		};
	};

	# ------------ Kernel Modules ------------

	boot = {
		initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "vmw_pvscsi" "vmxnet3" "virtio_net" "virtio_blk" ];
		initrd.kernelModules = [ ];
		kernelModules = [ ];
		extraModulePackages = [ ];

		kernelParams = [ ];

		# kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
		# kernelPackages = pkgs.linuxPackages; # LTS
		kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
	};
}
