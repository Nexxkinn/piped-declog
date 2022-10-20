Declog-piped
------------

Providing an independent Piped service for self-hosted instance


Background
----------

Piped is deeply build upon Docker and made it impossible to run it on
self-hosted environment such as Proxmox LXC and require user to install
a redudancy hypervisor docker alongside docker-compose to run it.

https://github.com/TeamPiped/Piped/issues/398#issuecomment-908261932

This script is an attempt to break free of such integration into a single
bash script that can be installed on an Alpine LXC container or other similar
distro.


Notes
-----

- This script is only targeting Alpine LXC.
- This script is meant for private, self-hosted instance.


Requirements
------------
bash
yarn
openjdk17-jdk
postgresql14
nginx


Usage
-----

1. spawn a container
2. run install.sh in it
3. wait while the script is compiling frontend, backend, and nginx script
4. assign container into your own reverse proxy
5. done


Updating Piped
--------------

0. Change your RAM size to 900MB at minimum and has 500-600 MB of free space
1. run piped-updater.sh
2. done


Specification
-------------

1. Make sure your container has at least 2 GB+ of storage due to the
   minimum space required to compile Java-based Piped-backend
2. 1024 MB of RAM for compiling Piped services.
