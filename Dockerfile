FROM registry.hub.docker.com/antora/antora:3.1.2

# Install lunr that is not installed by default yet
CMD npm i @antora/lunr-extension

