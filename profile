
export NVM_DIR="/home/docker/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export PATH="$(yarn global bin):$PATH"
