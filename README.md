# Kubernetis deployment of Grav

[Grav](https://learn.getgrav.org/basics/what-is-grav) is a Fast, Simple, and Flexible file-based Web-platform.
[K8s](https://kubernetes.io/) is decent tool for automating deployment. So why not both? 


## Prerequisites

 - [minikube](https://github.com/kubernetes/minikube)
 - latest macOS (you are free to use any other OS but then you at your own)

## TL; DR

    minikube start
    git clone https://github.com/pinepain/k8s-grav.git
    cd k8s-grav
    minikube mount ./:/data
    # open a new tab in terminal
    kubectl create -f deployment.yml
    kubectl expose deployment pinepain-grav --type=NodePort
    minikube service pinepain-grav
    # at this point you should be pointed to grav main page in your default browser 


## How to run

Suppose, you have minikube up and running. If not, run `minikube start`. For more details please follow official minikube docs.

Clone this repository locally `git clone https://github.com/pinepain/k8s-grav.git`.

Go to `k8s-grav` folder by typing `cd k8s-grav`. **All further actions described as you are in `k8s-grav` folder.** 

First you will need to share local folder to pods, to do that start minikube mount process: `minikube mount ./:/data`.
This process needs to stay alive in order to keep mount folders be accessible. 

*NOTE: By default we share local filesystem to persists grav files and users config.
As we use [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) for volumes to persists grav files
and users config, we can't run more than one pod in this setup. Though in production you will likely to use more advanced
volume type and this limitation won't be relevant.*

Now we can create deployment. Run `kubectl create -f deployment.yml`. In order to expose this deployment as service run
`kubectl expose deployment pinepain-grav --type=NodePort`. After service goes live `minikube service pinepain-grav` will
open grav main page in your default browser. Login page will be located under `/admin` route where you could log in
using default admin credentials `admin:admin`.

*NOTE: At the moment when you log in, grav will improperly redirect you back to main page ignoring port. You will have to 
go back to `/admin` page with proper port and refresh it and then you'll get that admin page.*   

Also you may simply create and edit pages under `data/pages` directory using your favorite text editor and they will be
immediately accessible from pods.

*NOTE: because of how grav handle caching it may not show changes to files under certain circumstances. In production you
should use shared cache and reset it on filesystem changes.*


## Development
 
#### Docker

You need to have docker installed (optionally, you may also want to install `docker-compose`)

To build and publish image use:

    docker build -t grav .
    docker tag grav pinepain/grav
    docker push pinepain/grav

To try grav in docker container run `docker run -p 30080:30080 pinepain/grav` or just `docker-compose up`

#### Generating grav password

You may use `php -r 'echo password_hash(getenv("<YOUR PASSWORD HERE>"), PASSWORD_DEFAULT), PHP_EOL;'` to generate `hashed_password` value.   

