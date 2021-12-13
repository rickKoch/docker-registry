# Docker Registry Playground

This is just a test version from
[distribution](https://github.com/distribution/distribution) repository

## Usage
```
git clone https://github.com/rickKoch/docker-registry.git
docker build -t localhost:5000/example/registry .
```

Run the registry with a restart flag so the container gets restarted
whenever you restart Docker:
```
docker container run -d -p 5000:5000 --restart always localhost:5000/example/registry
```

Push your tagged image:
```
docker image push localhost:5000/example/registry
```
