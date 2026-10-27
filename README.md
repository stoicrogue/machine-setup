# machine-setup

Rebuilds my laptop on top of a fresh [Omarchy](https://omarchy.org/) install.
Omarchy sets up the base system, desktop, services and firewall. This adds my
extra packages, dotfiles, tools, user services and NAS mount.

## Rebuild

On a fresh Omarchy install:

```bash
git clone https://github.com/stoicrogue/machine-setup.git ~/Projects/machine-setup
~/Projects/machine-setup/bootstrap.sh
```

`bootstrap.sh` updates the system, installs Ansible, asks for the dotfiles repo
and NAS address (saved to `vars/local.yml`, which git ignores), and runs the
playbook. It asks for your sudo password once.

## Preview or re-run

```bash
ansible-playbook site.yml --check --diff --ask-become-pass
ansible-playbook site.yml --ask-become-pass
```

Running it again changes nothing unless something is missing. It only adds
things: it never removes or downgrades.

## What it does

| Role | What |
|---|---|
| packages | Installs the extras in `roles/packages/defaults/main.yml` |
| dotfiles | `chezmoi init --apply` from your dotfiles repo (skipped if already set up) |
| tools | `mise install` for the tools in your chezmoi-managed mise config |
| services | Enables the user services in `roles/services/defaults/main.yml` |
| nas | Adds an NFS automount at `~/nas` to fstab |
| reminders | Prints the manual steps below |

## Not automated, on purpose

- **Omarchy itself.** Install it from its ISO first. It also handles the
  firewall, Docker and the hardware-specific packages.
- **Disk layout, encryption, fstab entries for local disks, bootloader,
  snapshots.** These are tied to the hardware.
- **Secrets.** Restore your SSH key by hand, then log in to `gh`, `claude`
  and `codex`. Open your KeePassXC database by hand.
- **Fingerprint and dictation.** Run `omarchy setup security fingerprint` and
  `omarchy voxtype install` yourself. Both are interactive.
- **Docker group.** Omarchy leaves you out of the `docker` group on purpose,
  because membership is equivalent to root. Use
  `omarchy setup security sudoless docker` if you want it.
- **Hostname, Wi-Fi, usernames and addresses.** Kept out so this repo can be
  public.
