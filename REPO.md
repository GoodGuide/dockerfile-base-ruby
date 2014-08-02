# Important note about git repo structure

This image is built using Docker automated builds. The automated build feature allows one to create multiple tags on a single Docker repo which are tied to branches in the github repo with which it's associated. Using tags on a docker image repo to differentiate software versions contained therein is a common pattern (see the official [ubuntu](//registry.hub.docker.com/u/_/ubuntu) "library" image and its tags which are tied to the Ubuntu distro version. This is the pattern we're using here, as well.

There are branches for each ruby version we're supporting. Really, the only thing that should differ from one branch to the next is the version given to `ruby-build`, but as improvements are made to the process, we may see reason to change later versions more dramatically. Hopefully, there shouldn't be too many instances where changes like that require back-merging to the various branches, but we'll see...
