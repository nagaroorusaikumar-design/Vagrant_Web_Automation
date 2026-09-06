# Vagrant Multi-VM Web Automation

Provisions 4 VMs with Vagrant (`scriptbox`, `web01`, `web02`, `web03`) and uses
`scriptbox` as a control node to push and run a setup script on the web nodes
over SSH, deploying a static site template and starting the web server.

## Topology

| VM        | Box                              | IP              | Role                          |
|-----------|-----------------------------------|-----------------|--------------------------------|
| scriptbox | eurolinux-vagrant/centos-stream-9 | 192.168.10.12   | Control node (runs the scripts) |
| web01     | eurolinux-vagrant/centos-stream-9 | 192.168.10.13   | Web server                     |
| web02     | eurolinux-vagrant/centos-stream-9 | 192.168.10.14   | Web server                     |
| web03     | ubuntu/bionic64                   | 192.168.10.15   | Web server                     |

> `scripts/remote_host_names` currently lists only `web01` and `web02` (that's
> what the recording showed being run). Add a `web03` line to that file once
> you want it included in the automation run.

## Files

- `Vagrantfile` — defines the 4 VMs above.
- `scripts/remote_host_names` — plain list of hostnames (one per line) that
  `remote_web_setup.sh` loops over.
- `scripts/remote_web_setup.sh` — run **from `scriptbox`**. For each host in
  `remote_host_names`, it `scp`s `automating_remote_hosts.sh` to `/tmp/` on
  that host, runs it over SSH, then deletes the copy.
- `scripts/automating_remote_hosts.sh` — run **on each web node**. Detects
  RHEL-family vs Debian-family, installs `httpd`/`apache2` + `wget` + `unzip`,
  starts/enables the service, downloads and unzips a Tooplate template, copies
  it into `/var/www/html/`, and restarts the service.

  ⚠️ Note: in the recorded run, the on-screen "Running Setup on Ubuntu" /
  "Running Setup on CentOS" echoes are swapped relative to which package
  manager each branch actually uses (the `yum` branch prints "...Ubuntu", the
  `apt` branch prints "...CentOS"). This is a cosmetic bug carried over as-is
  from the original script — fix the strings if you want the messages to
  match reality. Also see the note at the top of that file: the exact
  variable declarations and `if` condition were reconstructed from the
  execution output since the top of the file had scrolled out of view in the
  recording — please diff against your real script.

## Prerequisites

- [Vagrant](https://www.vagrantup.com/) + VirtualBox on the host machine.
- Passwordless SSH key auth already set up from `scriptbox` to each web node,
  for a user with passwordless `sudo` (the scripts assume the user `devops`,
  set via `USR='devops'` in `remote_web_setup.sh`):

  ```bash
  # on scriptbox, as the automation user
  ssh-keygen -t ed25519 -C "scriptbox-automation"
  ssh-copy-id devops@web01
  ssh-copy-id devops@web02
  ssh-copy-id devops@web03
  ```

  **Do not commit private keys to this repository.**

## Usage

```bash
vagrant up

# from inside scriptbox (vagrant ssh scriptbox), with keys already deployed:
cd scripts
chmod +x remote_web_setup.sh automating_remote_hosts.sh
./remote_web_setup.sh
```

Then browse to `http://192.168.10.13` / `http://192.168.10.14` (and `.15` once
web03 is added) to confirm the template deployed.
