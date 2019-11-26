
# ProcImage Uploading Service

## Installation

### Prerequisite

```
Docker
Git
```

### Clone
- Clone this repo to your local machine  
```
git clone git@github.com:harikumar8984/proc_images.git
```

### Development Setup

#### Local Setup
```
docker-compose build
docker-compose run web rake db:create
docker-compose run web rake db:migrate
```

#### Running TestCase

```
docker-compose run web rspec
```

### Start Server
```
docker-compose up
```
#### API endpoints

```
POST http://#{request.host}/api/prog_images                                
```

- Server will up in the local machine *localhost:3000*
