React-Docker-Task
=============

Demo project running react application with docker-container.

Clone this repo:

```
git clone https://github.com/rectanglehp/docker-react-demo
```

Chnage working directory:
```
cd docker-react-demo
```

Then you need to build image with application:
```
docker build -t mya:pp .
```

Let's run just created container!
```
docker run -p 8080:3000 mya:pp
```

Then go to http://localhost:8080

Enjoy!

