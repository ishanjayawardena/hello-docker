# Golang hello world multistage Docker build

A skeleton of a Golang project with multistage Docker build

### Usage
#### Binary
`make all` runs the tests, builds the binary, and runs the binary found in the `bin/` director.

### Docker image
`make dockerbuild`

Creates a multi stage docker image

`make dockerrun` 

Runs a container from the built docker image.

#### Cleanin up
`make clean_all`

Cleans up the `bin/` directory and the docker image that has been built with `make dockerbuild`

### Sources and references

Multi stage Docker build
https://www.youtube.com/watch?v=LOuFYTYVmIg

