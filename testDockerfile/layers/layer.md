#### Layers of the docker images (layers)
=========


__Principes__

* two types of layers:
	- read-only
	- read-write (container)

* layers can be shared between the images

	image 1       |     image 2
  ==============================
  couche 1           couche A
  couche 2           couche B
             couche 3
  couche 4           couche D

<br>
* Write

	 conteneur 1  |     conteneur 2
   ==============================
R  couche 1           couche A
R  couche 2           couche B
R            couche 3
R  couche 4           couche D
RW couche 5           couche E

-------------------------------------------------

-> The layers of an image <-

if Dockerfile

```
FROM centos:7
RUN yum update
RUN yum install -y --no-install-recommends vim
RUN yum install -y --no-install-recommends git
```

<br>
List the layers

```
docker history monimage:maversion
```

Result

```
└─ $ ▶ docker history test:v1.0 --format "{{.ID}}\t{{.CreatedBy}}"
7c995f4a51d8	/bin/sh -c apt-get install -y --no-install-r…
71a2fedce726	/bin/sh -c apt-get install -y --no-install-r…
7b957bd8d60d	/bin/sh -c apt-get update
ea4c82dcd15a	/bin/sh -c #(nop)  CMD ["/bin/bash"]
<missing>	/bin/sh -c mkdir -p /run/systemd && echo 'do…
<missing>	/bin/sh -c rm -rf /var/lib/apt/lists/*
<missing>	/bin/sh -c set -xe   && echo '#!/bin/sh' > /…
<missing>	/bin/sh -c #(nop) ADD file:bcd068f67af2788db…
```


-------------------------------------------------

__The layers of an image__

IF Dockerfile

```
FROM ubuntu:latest
RUN apt-get update apt-get install -y --no-install-recommends vim git
```

<br>
Result

```
└─ $ ▶ docker history test:v1.0 --format "{{.ID}}\t{{.CreatedBy}}"
82b658850e03	/bin/sh -c apt-get update && apt-get install…
ea4c82dcd15a	/bin/sh -c #(nop)  CMD ["/bin/bash"]
<missing>	/bin/sh -c mkdir -p /run/systemd && echo 'do…
<missing>	/bin/sh -c rm -rf /var/lib/apt/lists/*
<missing>	/bin/sh -c set -xe   && echo '#!/bin/sh' > /…
<missing>	/bin/sh -c #(nop) ADD file:bcd068f67af2788db…

```

-------------------------------------------------

__In write mode with a run__

```
docker run -tid --name test monimage:maversion
docker exec -ti test sh
touch toto
rm -rf srv/
```

__What's going on?__

```
└─ $ ▶ docker diff test
A /toto
D /srv
```

we see that layers are understood as a git repository. 
here, the __srv__ folder has been __deleted (D)__ and the __toto__ file has been __added (A)__
