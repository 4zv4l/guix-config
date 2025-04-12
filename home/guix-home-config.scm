(define-module (guix-home-config)
  #:use-module (gnu packages)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services shells)
  #:use-module (gnu services)
  #:use-module (gnu system shadow))

(home-environment
  (packages (list
    (specification->package "tmux")
    (specification->package "neovim")
    (specification->package "bat")
    (specification->package "lsd")
    (specification->package "perl")
    (specification->package "python")
    (specification->package "nushell")
    (specification->package "zoxide")
    (specification->package "nmap")))

  (services
    (cons*
      ;; basic bash setup
      (service home-bash-service-type)
      ;; copy dotfiles as symlinks
	  (service home-dotfiles-service-type
	      (home-dotfiles-configuration
	      (directories (list "./dotfiles"))))
      %base-home-services)))
