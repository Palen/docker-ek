Elasticsearch & Kibana.
================================

Creating an EK stack could not be easier.

**Important:** this image embeds Elasticsearch 5.0  and Kibana 5.0.

Quick Start
-----------
```
$ mkdir elki
```

```
$ cd elki/ && git clone https://github.com/Palen/docker-elk .

```
$ docker build -t elki . --rm
```

```
docker run -p 80:80 -p 9200:9200 -it --rm elki
```

Alternative, you can share the elasticsearch data with the current one of your workspace.
```
docker run -p 80:80 -p 9200:9200 -it -v /path/to/your/elastic/data:/data/ --rm elki
```

Then, browse: [http://localhost:80](http://localhost:80) (replace
`localhost` with your public IP address).
