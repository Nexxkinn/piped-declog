Declog-piped
------------

Providing an independent Piped service for self-hosted instance


Background
----------

Piped is an open-source alternative webapp for Youtube.

Piped is deeply integrated with Docker and made it impossible to run on
self-hosted environment such as Proxmox LXC and require user to install
a redudancy hypervisor Docker alongside docker-compose to run it.

https://github.com/TeamPiped/Piped/issues/398#issuecomment-908261932

This script is an attempt to break free of such integration into a single
bash script that can be installed on an Alpine LXC container or other similar
distro.


Notes
-----

- This script is only targeting Alpine LXC.
- This script is meant for private, self-hosted instance.
- This script requires you to edit the script to your own need.
- This script works in my environment, YMMV.


Requirements
------------
bash
yarn
openjdk17-jre-headless
postgresql14
nginx
alpine >= 3.16

Usage
-----

1. spawn a container
2. run piped-build.sh in it
3. wait while the script is compiling frontend, backend, and proxy
4. open piped-install.sh and edit to your own need.
5. run piped-install.sh
6. assign container into your own reverse proxy
7. done


Updating Piped
--------------

0. Change your RAM size to 900MB at minimum and has 500-600 MB of free space
1. stop all piped services
2. run piped-build.sh
3. edit or replace new configs with backup configs
4. start all piped services
5. done


Specification
-------------

1. Make sure your container has at least 3 GB+ of storage due to the
   minimum space required to compile Java-based Piped-backend
2. 2048 MB of RAM for compiling Piped services.
