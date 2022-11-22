# Docker formation By hermann.chefouetmeka@utrains.org
## _The Docker and docker-compose training by practice_

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

In this post, we will describe the steps to learn the basics of Docker technology.
- ✨Magic ✨

## Test Environment : Vagrant, virtualBox
### prerequis : 
- Install VirtualBox
- Install Vagrant
- Visual Studio Code
##### Installation of Docker in a centos virtual server 7:
- clone this repository, then follow the steps below: 
```sh
cd centos_os/
vagrant up
```
- Connect via ssh to the server that is started.

##### Docker 1 : Some basic docker command
## _docker ps : see the started containers_
## _docker run -di --name hermann alpine:latest : run the container to detach mode and interractive_
## _docker exec -ti  hermann sh: connect to the container_

```sh
docker ps
docker ps -a
docker pull alpine:latest
docker run -di --name hermann alpine:latest
docker exec -ti hermann sh
```

##### Docker 2 : Start a container Ex. NGINX 
## _docker run -tid -p 8080:80 --name web nginx:latest : run the ngnix server, expose to 8080 port from localhost. in the container we have 80 port open for the nginx server. open the browser and make 127.0.0.1:8080 to see the nginx started page_
## _docker inspect web : display all informations about the web container started_

```sh
docker run -tid -p 8080:80 --name web nginx:latest
docker inspect web
docker stop web
```

##### Docker 3.1 : Persistant Volume (using -v option) 
1. start the web container created with nginx : 
2. connect to this container using exec docker command :
- update this container
- install vi or vim in this container
- edit the /usr/share/nginx/html/index.html then put your name, save and quit
- refresh your browser : you can see your change
- quit to the iterrative mode
- stop the container, and refresh the browser : nothing to display because the container is down
- restart it, then refresh the browser : "welcome hermann 90! .." message displayed
- delete the container, than restart another one. Refresh your browser : you are loose all modification
##### Note : the containers don't store the data. to solve this problem, you can create the volume to store data, them map this volume when you're create container process. 

3. create this folder in you're host machine : /srv/data/nginx
4. delete the web container
5. create the web container again, using the -v option to map volume  (-v /srv/data/ngnix:/usr/share/ngnix/html/)
6. refresh the browser : error web page (403 Forbidden)
7. create the index.html page in your /srv/data/nginx host volume, then put in this file some text or html code
- html example code to put in index.html
```html
<!DOCTYPE html>
<html>
<body>
<h1>My First We Page </h1>
<p>My first paragraph.</p>
</body>
</html>
```
8. refresh the browser: your text or html code result can displayed
9. delete the container, then refresh the browser : nothing to display
10. create again th web container by maping the same volume
10. refresh the browser : you change is dispaly

```sh
docker start web
docker exec -it web sh
apt-get update
apt-get install vim -y
vim /usr/share/nginx/html/index.html
#edit the welcom message and put your name (Welcome to Hermann 90), then save and quit and refresh browser
exit
docker stop web
docker start web
docker rm -f web
docker ps -a
docker run -dit -p 8080:80 --name web nginx
sudo mkdir -p /srv/data/nginx
docker rm -f web
docker run -dit -p 8080:80 --name web -v /srv/data/nginx:/usr/share/nginx/html/ nginx
sudo vim /srv/data/nginx/index.html #copy and paste the html code above in this file
docker rm -f web
docker run -dit -p 8080:80 --name web -v /srv/data/nginx/:/usr/share/nginx/html nginx
```

##### Docker 3.2 : Persistant Volume (using docker volume command) 
###### docker volume command

Docker volume commande have 5 options for utilization :

| Command | Description |
| ------- | ----------- |
| docker volume create volumeName | Create a volume |
| docker volume inspect | Display detailed information on one or more volumes |
| docker volume ls | List volumes |
| docker volume prune | Remove all unused local volumes |
| docker volume rm | Remove one or more volumes |

###### create the volume, using the docker volume commande then use it for our nginx server :
- delete your web container
- create the volume (myFirstVolume)
- list all volume
- List the volume then display only the volume you have created. use the grep command
- create the nginx container, then mount this volume using the --mount option
- inspect the volume, then copy the local directory of this volume
- Edit the index.html in this local volume directory then put your name or some html code 
- refresh the browser
- delete the container
- create again the web conatiner, with the same volume, then refresh your browser
- delete the container, then delete the volume

```sh
docker ps
docker rm -f web
docker volume create myFirstVolume
docker volume ls
docker volume ls | myFirstVolume
docker run -tid --name web -p 8080:80 --mount source=myFirstVolume,target=/usr/share/nginx/html/ nginx:latest
docker ps
docker volume inspect myFirstVolume
sudo vim /var/lib/docker/volumes/myFirstVolume/_data/index.html
docker rm -f web
docker run -dit --name web -p 8080:80 --mount source=myFirstVolume,target=/usr/share/nginx/html/ nginx:latest
docker rm -f web
docker volume rm myFirstVolume
```

##### Docker 5 : Environment Variable (ENV, ENVFILE) 
1. create a ubuntu container with the environment variable MYENV that the value is 12345
2. connect you to this container then display this environment variable

```sh
docker run -tid --name testEnv --env MYENV="12345" ubuntu:latest
docker exec -ti testEnv sh
env
echo $MYENV
exit
```
###### Note: the problem with this method is that it is not secure because anyone can see the value of the environment variable.
3. delete the testEnv container
4. create a file named db_access.txt, then put DB_PASSWORD="my_p@ssword" and DB_USER_NAME="root". save the file and quit
5. create again the container, call this file using __--env-file__ option to load these environment variable
6. connect you to this container, then display all environment variable

```sh
docker rm -f testEnv
sudo vim db_access.txt # put these values in the file DB_PASSWORD="my_p@ssword" and DB_USER_NAME="root" then save and quit
docker run -tid --name testEnv --env-file db-access.txt ubuntu:latest
docker exec -ti testEnv sh
env
echo $DB_PASSWORD
echo $DB_USER_NAME
exit
```

##### Docker 6 : Dockerfile
__what is the dockerfile ?__
- a configuration file
- objective : creation of a docker image
- instruction sequences : 
1. __RUN :__ launch command (apt, yum, ...)
2. __ENV :__ environment variable
3. __EXPOSE :__ exposure of ports
4. __VOLUME :__ definition of volumes
5. __ENTRYPOINT :__ master process

__Interests of dockerfile__
* restart an image creation at any time
* better visibility on what is done
* easy sharing and possibility to save in Git
* docker file editing script (variables...)
* no need to ask questions during the docker run of the container
* creation of prod // dev - CI // CD images

__Example of dockerfile__
1. create a __testDockerFile__ folder, enter in this folder, then create a file using vim named __Dockerfile__ with the content bellow.
__Note :__ you can find this file in the directory __docker-formation/testDockerfile/ubuntuUpdat__ or click on this link : [Dockerfile](./testDockerfile/ubuntuUpdate/Dockerfile). 
```sh
FROM centos:7
MAINTAINER Hermann90
RUN yum update -y
RUN yum install -y vim 
RUN yum install -y git 
RUN rm -rf /tmp/* /var/tmp/*
```

__Node :__ 
With the box generator with vagrant, it is likely that you have the time that is not correct. Use this command to synchronize the time between your vagrant server and your local machine. This may cause the generation of docker images from the dockerfile to fail.

```sh
date
sudo date -s "2022-11-13 23:15:00"
date
```

__command to build image__
2. create the docker image, using the command bellow
```
docker build -t myimage:v1 .
docker images 
```
3. See the execution sequence of the Dockerfile
```sh
docker history myimage:v1
```
4. launch a container with this image, connect to it, then check that git and vim are installed
```sh
docker run -dit --name testdockerfile myimage:v1
docker exec -ti testdockerfile sh
git
vim
exit
```
5. delete the container, then create the image (__docker rmi command__)
```sh
docker ps
docker rm -f testdockerfile
docker images
docker rmi -f myimage:v1
```

#### Docker 7 : Layers

[Layers](./testDockerfile/layers/layer.md)


### Docker 8 : Microservices principles and demo

[Click here for Microservice example](./testDockerfile/microservices/microservice.md)
