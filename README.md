

## Prerequisites

 - latest macOS
 - docker installed (optionally, you may also want to install `docker-compose`)

## Docker

To try grav in docker container run `docker run -p 30080:30080 pinepain/grav` or just `docker-compose up`

### Development

    docker build -t grav .
    docker tag grav pinepain/grav
    docker push pinepain/grav

## Grav

Grav setup served with default admin user (login: `admin` password: `admin`) for testing purposes. You shall not use it
in production.

NOTE: you may use `php -r 'echo password_hash(getenv("<YOUR PASSWORD HERE>"), PASSWORD_DEFAULT), PHP_EOL;'` to generate `hashed_password` value.   

