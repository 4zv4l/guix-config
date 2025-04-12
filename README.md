# guix-config

- `image.scm` is used to create a bootable image

```bash
$ guix system image -t iso9660 image.scm
```

- `root/config.scm` is the global OS config

```bash
$ guix system reconfigure /etc/config.scm
```

- `home/guix-home-config.scm` is the user home config

```bash
$ guix home reconfigure ~/guix-home-config.scm
```

> The files in this repo are not at the right place (to run the command I listed)
> 
> I simply use this repo to backup my configs
