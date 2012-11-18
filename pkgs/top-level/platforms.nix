rec {
  pc = {
    name = "pc";
    uboot = null;
    kernelHeadersBaseConfig = "defconfig";
    kernelBaseConfig = "defconfig";
    # Build whatever possible as a module, if not stated in the extra config.
    kernelAutoModules = true;
    kernelTarget = "bzImage";
    # Currently ignored - it should be set according to 'system' once it is
    # not ignored. This is for stdenv-updates.
    kernelArch = "i386";
    kernelExtraConfig =
      ''
        # Virtualisation (KVM, Xen...).
        PARAVIRT_GUEST y
        KVM_CLOCK y
        KVM_GUEST y
        XEN y
        KSM y

        # We need 64 GB (PAE) support for Xen guest support.
        HIGHMEM64G? y
      '';
  };

  pc_simplekernel = pc // {
    kernelAutoModules = false;
  };

  sheevaplug = {
    name = "sheevaplug";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "kirkwood_defconfig";
    kernelBaseConfig = "kirkwood_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelExtraConfig =
      ''
        BLK_DEV_RAM y
        BLK_DEV_INITRD y
        BLK_DEV_CRYPTOLOOP m
        BLK_DEV_DM m
        DM_CRYPT m
        MD y
        REISERFS_FS m
        BTRFS_FS m
        XFS_FS m
        JFS_FS m
        EXT4_FS m
        USB_STORAGE_CYPRESS_ATACB m

        # mv cesa requires this sw fallback, for mv-sha1
        CRYPTO_SHA1 y

        IP_PNP y
        IP_PNP_DHCP y
        NFS_FS y
        ROOT_NFS y
        TUN m
        NFS_V4 y
        NFS_V4_1 y
        NFS_FSCACHE y
        NFSD m
        NFSD_V2_ACL y
        NFSD_V3 y
        NFSD_V3_ACL y
        NFSD_V4 y

        IPV6 m
        VLAN_8021Q m

        CIFS y
        CIFS_XATTR y
        CIFS_POSIX y
        CIFS_FSCACHE y
        CIFS_ACL y

        WATCHDOG y
        WATCHDOG_CORE y
        ORION_WATCHDOG m

        ZRAM m
        NETCONSOLE m

        # Fail to build
        DRM n
        SCSI_ADVANSYS n
        USB_ISP1362_HCD n
        SND_SOC n
        SND_ALI5451 n
        FB_SAVAGE n
        SCSI_NSP32 n
        ATA_SFF n
        SUNGEM n
        IRDA n
        ATM_HE n
        SCSI_ACARD n
        BLK_DEV_CMD640_ENHANCED n

        FUSE_FS m

        # nixos mounts some cgroup
        CGROUPS y

        # Latencytop 
        LATENCYTOP y

        # Ubi for the mtd
        MTD_UBI y
        UBIFS_FS y
        UBIFS_FS_XATTR y
        UBIFS_FS_ADVANCED_COMPR y
        UBIFS_FS_LZO y
        UBIFS_FS_ZLIB y
        UBIFS_FS_DEBUG n

        # Netfilter stuff
        NETFILTER y
        NETFILTER_ADVANCED y
        BRIDGE_NETFILTER y
        NETFILTER_NETLINK m
        NETFILTER_NETLINK_QUEUE m
        NETFILTER_NETLINK_LOG m
        NF_CONNTRACK m
        NF_CT_ACCT y
        NF_CONNTRACK_MARK y
        NF_CT_PROTO_DCCP m
        NF_CT_PROTO_GRE m
        NF_CT_PROTO_SCTP m
        NF_CONNTRACK_AMANDA m
        NF_CONNTRACK_FTP m
        NF_CONNTRACK_H323 m
        NF_CONNTRACK_IRC m
        NF_CONNTRACK_NETBIOS_NS m
        NF_CONNTRACK_PPTP m
        NF_CONNTRACK_SANE m
        NF_CONNTRACK_SIP m
        NF_CONNTRACK_TFTP m
        NF_CT_NETLINK m
        NETFILTER_TPROXY m
        NETFILTER_XTABLES m
        NETFILTER_XT_TARGET_CLASSIFY m
        NETFILTER_XT_TARGET_CONNMARK m
        NETFILTER_XT_TARGET_DSCP m
        NETFILTER_XT_TARGET_HL m
        NETFILTER_XT_TARGET_LED m
        NETFILTER_XT_TARGET_MARK m
        NETFILTER_XT_TARGET_NFLOG m
        NETFILTER_XT_TARGET_NFQUEUE m
        NETFILTER_XT_TARGET_NOTRACK m
        NETFILTER_XT_TARGET_RATEEST m
        NETFILTER_XT_TARGET_TRACE m
        NETFILTER_XT_TARGET_TCPMSS m
        NETFILTER_XT_TARGET_TCPOPTSTRIP m
        NETFILTER_XT_MATCH_CLUSTER m
        NETFILTER_XT_MATCH_COMMENT m
        NETFILTER_XT_MATCH_CONNBYTES m
        NETFILTER_XT_MATCH_CONNLIMIT m
        NETFILTER_XT_MATCH_CONNMARK m
        NETFILTER_XT_MATCH_CONNTRACK m
        NETFILTER_XT_MATCH_DCCP m
        NETFILTER_XT_MATCH_DSCP m
        NETFILTER_XT_MATCH_ESP m
        NETFILTER_XT_MATCH_HASHLIMIT m
        NETFILTER_XT_MATCH_HELPER m
        NETFILTER_XT_MATCH_HL m
        NETFILTER_XT_MATCH_IPRANGE m
        NETFILTER_XT_MATCH_LENGTH m
        NETFILTER_XT_MATCH_LIMIT m
        NETFILTER_XT_MATCH_MAC m
        NETFILTER_XT_MATCH_MARK m
        NETFILTER_XT_MATCH_MULTIPORT m
        NETFILTER_XT_MATCH_OWNER m
        NETFILTER_XT_MATCH_POLICY m
        NETFILTER_XT_MATCH_PKTTYPE m
        NETFILTER_XT_MATCH_QUOTA m
        NETFILTER_XT_MATCH_RATEEST m
        NETFILTER_XT_MATCH_REALM m
        NETFILTER_XT_MATCH_RECENT m
        NETFILTER_XT_MATCH_SCTP m
        NETFILTER_XT_MATCH_STATE m
        NETFILTER_XT_MATCH_STATISTIC m
        NETFILTER_XT_MATCH_STRING m
        NETFILTER_XT_MATCH_TCPMSS m
        NETFILTER_XT_MATCH_TIME m
        NETFILTER_XT_MATCH_U32 m
        NETFILTER_XT_MATCH_OSF m
        NF_DEFRAG_IPV4 m
        NF_CONNTRACK_IPV4 m
        NF_CONNTRACK_PROC_COMPAT y
        IP_NF_IPTABLES m
        IP_NF_MATCH_ADDRTYPE m
        IP_NF_MATCH_AH m
        IP_NF_MATCH_ECN m
        IP_NF_MATCH_TTL m
        IP_NF_FILTER m
        IP_NF_TARGET_REJECT m
        IP_NF_TARGET_LOG m
        IP_NF_TARGET_ULOG m
        NF_NAT m
        NF_NAT_NEEDED y
        IP_NF_TARGET_MASQUERADE m
        IP_NF_TARGET_NETMAP m
        IP_NF_TARGET_REDIRECT m
        NF_NAT_SNMP_BASIC m
        NF_NAT_PROTO_DCCP m
        NF_NAT_PROTO_GRE m
        NF_NAT_PROTO_SCTP m
        NF_NAT_FTP m
        NF_NAT_IRC m
        NF_NAT_TFTP m
        NF_NAT_AMANDA m
        NF_NAT_PPTP m
        NF_NAT_H323 m
        NF_NAT_SIP m
        IP_NF_MANGLE m
        IP_NF_TARGET_CLUSTERIP m
        IP_NF_TARGET_ECN m
        IP_NF_TARGET_TTL m
        IP_NF_RAW m
        IP_NF_ARPTABLES m
        IP_NF_ARPFILTER m
        IP_NF_ARP_MANGLE m
        IP_DCCP m
        INET_DCCP_DIAG m
      '';
    kernelTarget = "uImage";
    uboot = "sheevaplug";
    # Only for uboot = uboot :
    ubootConfig = "sheevaplug_config";
  };

  guruplug = sheevaplug // {
    # Define `CONFIG_MACH_GURUPLUG' (see
    # <http://kerneltrap.org/mailarchive/git-commits-head/2010/5/19/33618>)
    # and other GuruPlug-specific things.  Requires the `guruplug-defconfig'
    # patch.

    kernelBaseConfig = "guruplug_defconfig";
    #kernelHeadersBaseConfig = "guruplug_defconfig";
  };

  versatileARM = {
    name = "versatileARM";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "versatile_defconfig";
    kernelBaseConfig = "versatile_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelTarget = "zImage";
    kernelExtraConfig =
      ''
        MMC_ARMMMCI y
        #MMC_SDHCI y
        SERIO_AMBAKMI y

        AEABI y
        RTC_CLASS y
        RTC_DRV_PL031 y
        PCI y
        SCSI y
        SCSI_DMA y
        SCSI_ATA y
        BLK_DEV_SD y
        BLK_DEV_SR y
        SCSI_SYM53C8XX_2 y

        TMPFS y
        IPV6 m
        REISERFS_FS m
        EXT4_FS m

        IP_PNP y
        IP_PNP_DHCP y
        IP_PNP_BOOTP y
        ROOT_NFS y
      '';
    uboot = null;
  };

  integratorCP = {
    name = "integratorCP";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "integrator_defconfig";
    kernelBaseConfig = "integrator_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelTarget = "zImage";
    kernelExtraConfig =
      ''
        # needed for qemu integrator/cp
        SERIAL_AMBA_PL011 y
        SERIAL_AMBA_PL011_CONSOLE y
        SERIAL_AMBA_PL010 n
        SERIAL_AMBA_PL010_CONSOLE n

        MMC_ARMMMCI y
        MMC_SDHCI y
        SERIO_AMBAKMI y

        CPU_ARM926T y
        ARCH_INTEGRATOR_CP y
        VGA_CONSOLE n
        AEABI y
      '';
    uboot = null;
    ubootConfig = "integratorcp_config";
  };

  integratorCPuboot = integratorCP // {
    name = "integratorCPuboot";
    kernelTarget = "uImage";
    uboot = "upstream";
    ubootConfig = "integratorcp_config";
  };

  fuloong2f_n32 = {
    name = "fuloong2f_n32";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "fuloong2e_defconfig";
    kernelBaseConfig = "lemote2f_defconfig";
    kernelArch = "mips";
    kernelAutoModules = false;
    kernelExtraConfig =
      ''
        BLK_DEV_RAM y
        BLK_DEV_INITRD y
        BLK_DEV_CRYPTOLOOP m
        BLK_DEV_DM m
        DM_CRYPT m
        MD y
        REISERFS_FS m
        EXT4_FS m
        USB_STORAGE_CYPRESS_ATACB m

        IP_PNP y
        IP_PNP_DHCP y
        IP_PNP_BOOTP y
        NFS_FS y
        ROOT_NFS y
        TUN m
        NFS_V4 y
        NFS_V4_1 y
        NFS_FSCACHE y
        NFSD m
        NFSD_V2_ACL y
        NFSD_V3 y
        NFSD_V3_ACL y
        NFSD_V4 y

        # Fail to build
        DRM n
        SCSI_ADVANSYS n
        USB_ISP1362_HCD n
        SND_SOC n
        SND_ALI5451 n
        FB_SAVAGE n
        SCSI_NSP32 n
        ATA_SFF n
        SUNGEM n
        IRDA n
        ATM_HE n
        SCSI_ACARD n
        BLK_DEV_CMD640_ENHANCED n

        FUSE_FS m

        # Needed for udev >= 150
        SYSFS_DEPRECATED_V2 n

        VGA_CONSOLE n
        VT_HW_CONSOLE_BINDING y
        SERIAL_8250_CONSOLE y
        FRAMEBUFFER_CONSOLE y
        EXT2_FS y
        EXT3_FS y
        REISERFS_FS y
        MAGIC_SYSRQ y
      '';
    kernelTarget = "vmlinux";
    uboot = null;
  };
}
