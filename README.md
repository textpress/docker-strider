# strider-cd
CI/CD based on Strider-CD

# Requirements
Docker + Docker Composer

# To start
* `docker-compose up -d`

# To stop
* `docker-compose stop`

# To add/upgrade plugin on image rebuild
* add it to docker-image/plugin.txt, lookup proper name here: https://github.com/Strider-CD/ecosystem-index/blob/master/plugins.yml

# To upgrade strider to the latest build
* `docker-compose stop`
* pull new node image if needed
* `docker-compose up -d --build`

# To upgrade strider to a given build
* `docker-compose stop`
* optional: `docker pull node`
* `emacs docker-compose.yml` 
    * STRIDER_VERSION=vX.X.X (desired build tag) 
* `docker-compose up -d --build`

# To upgrade mongo
* `docker-compose stop`
* `docker pull mongo`
* `docker-compose up -d`

# To debug (not sure)
* `docker-compose stop`
* `docker-compose -f docker-compose.yml -f docker-compose.admin.yml up`

# To remove strider container
* `docker rm strider-app`

# To remove strider image
* `docker rmi strider-app` 

# To purge strider container and data disk
* `docker-compose down`
* `docker rmi strider-app`
* `docker volume prune`
