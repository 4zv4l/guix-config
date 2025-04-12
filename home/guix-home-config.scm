(define-module (guix-home-config)
  #:use-module (ice-9 string-fun)
  #:use-module (gnu packages)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services shells)
  #:use-module (gnu services)
  #:use-module (gnu system shadow))

(define %PATH
  (string-replace-substring
    (string-join
      (list "$HOME/.local/bin"
            "$HOME/perl5/bin"
            "$PATH") ":")
    "$HOME" (getenv "HOME")))

(display %PATH)

(home-environment
  (packages
    (specifications->packages
      (list "tmux"
            "neovim"
            "bat"
            "lsd"
            "perl"
            "python"
            "nushell"
            "zoxide"
            "nmap")))

  (services
    (cons*
      ;; basic bash setup
      (service home-bash-service-type
               (home-bash-configuration
                 (environment-variables
                   `(("PATH"   . ,%PATH)
                     ("PS1"    . "$(history -a;history -n)$PS1")
                     ("EDITOR" . "nvim")))
                 (aliases
                   '(("cat" . "bat")
                     ("ls"  . "lsd")
                     ("v"   . "nvim")
                     ("nu"  . "clear;nu")))))
      ;; copy dotfiles as symlinks
	  (service home-dotfiles-service-type
	      (home-dotfiles-configuration
	      (directories (list "./dotfiles"))))
      %base-home-services)))
