##################
# Docker Aliases #
##################

# Manual start for the Docker deamon
alias dos='sudo $(which dockerd)'

# Delete the VM image on macOS
alias doclean='rm ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2'

# General aliases
alias doi='docker info'
alias doa='docker attach --sig-proxy=false'
alias dor='docker run'
alias dost='docker start'
alias dosp='docker stop'

# Docker image management
alias doil='docker image ls'
alias doir='docker image rm'
alias doip='docker image prune'
alias doib='docker image build'
alias doilo='docker image load'
alias dois='docker image save'

# Docker container management
alias docl='docker container ls'
alias docla='docker container ls --all'
alias docr='docker container rm'
alias docp='docker container prune'

# Docker volume management
alias dovl='docker volume ls'
alias dovr='docker volume rm'
alias dovp='docker volume prune'
