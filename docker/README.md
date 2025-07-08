An example Dockerfile for a Python Hello Direct Ferries Application few dependencies:

 * Python 3.11

Prerequisites
-----

Docker Installed locally

See the [Docker website](http://www.docker.io/gettingstarted/#h_installation) for installation instructions.

Build
-----

Steps to build a Docker image:

1. Clone this repo

        git clone https://github.com/tonydwilliams616/engineering-tasks.git

2. 

        cd docker

4. Build the image

        docker build -t="my-app" docker-direct

    This will take a few minutes.

5. Run the image's default command, which should start everything up. The `-p` option forwards the container's port 80 to port 8000 on the host.

        docker run -p="8000:80" docker-direct

6. Once everything has started up, you should be able to access the webapp via [http://localhost:8000/](http://localhost:8000/) on your host machine.

        open http://localhost:8000/

You can also login to the image and have a look around:

    docker run -i -t my-app /bin/bash