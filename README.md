# Local Git HTTP Service

A Docker container that will map a directory of Git repos into an HTTP hosted server, so that a local CI service (such as Concourse) can interact them.

Map a 

    docker run -d --volume=/path/to/git/repos/:/repos:ro -p 8081:80 pidster/local-git-http

