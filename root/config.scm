(use-modules (gnu) (guix channels) (nongnu packages linux))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (locale "en_HK.utf8")
  (timezone "Asia/Hong_Kong")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "lexi-guix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "azz")
                  (comment "azz")
                  (group "users")
                  (home-directory "/home/azz")
                  (password "sab.QvncGluos")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
         %base-user-accounts))

  ;; global packages
  (packages
    (cons* (specification->package "neovim")
           (specification->package "htop")
           (specification->package "git")
           (specification->package "perl")
           (specification->package "util-linux")
           (specification->package "tmux")
           (specification->package "flatpak")
           (specification->package "openssh")
           (specification->package "firefox")
           (specification->package "wireguard-tools")
           (specification->package "net-tools")
           (specification->package "ncurses") ;; provide clear
           %base-packages))

  ;; global services
  (services
    (cons*
      ;; basic GNOME setup
      (service gnome-desktop-service-type)
      ;; openssh server
      (service openssh-service-type
        (openssh-configuration (port-number 2200)))
      ;; CUPS printer
      (service cups-service-type)
      ;; Xorg server
      (set-xorg-configuration
        (xorg-configuration
        (keyboard-layout keyboard-layout)))

      ;; modify default desktop services
      (modify-services %desktop-services
        (guix-service-type config => (guix-configuration
          (inherit config)

          ;; add substitutes (and their pubkey)
          (substitute-urls
            (cons* "https://substitutes.nonguix.org"
                   %default-substitute-urls))
          (authorized-keys
            (cons* (plain-file "non-guix.pub"
                     "(public-key (ecc (curve Ed25519)
                     (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))")
                   %default-authorized-guix-keys))

          ;; add channels
          (channels (cons* (channel
                             (name 'nonguix)
                             (url "https://gitlab.com/nonguix/nonguix")
                             (introduction
                               (make-channel-introduction
                                 "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                                 (openpgp-fingerprint
                                   "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
                            %default-channels)))))))
  ;; end services

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/sda"))
                (keyboard-layout keyboard-layout)))

  (mapped-devices (list (mapped-device
                          (source (uuid "4340e0a7-e856-4b8c-9e65-1b52a8c64990"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices))
                       %base-file-systems)))
