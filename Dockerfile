FROM paritytech/ci-linux:production
LABEL AUTHORS="RAGI" 
LABEL VERSION="2022-11-12"

WORKDIR /
ARG WORKING_DIR=/var/www/node-template
ARG CONTAINER_NAME=contracts-node-template-cactus
ARG PORT=9944
ARG DOCKER_PORT=9944
ARG CARGO_HOME=/var/www/node-template/.cargo

ENV CARGO_HOME=${CARGO_HOME}
ENV CACTUS_CFG_PATH=/etc/hyperledger/cactus
VOLUME .:/var/www/node-template

RUN apt update

# Get ubuntu and rust packages
RUN apt install -y build-essential pkg-config git clang curl make libssl-dev llvm libudev-dev

ENV CACTUS_CFG_PATH=/etc/hyperledger/cactus
RUN mkdir -p $CACTUS_CFG_PATH

RUN set -e

RUN echo "*** Instaling Rust environment ***"
RUN curl https://sh.rustup.rs -y -sSf | sh
RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc
RUN rustup default nightly

RUN echo "*** Initializing WASM build environment"
RUN rustup target add wasm32-unknown-unknown --toolchain nightly

RUN echo "*** Installing Substrate node environment ***"
RUN git clone https://github.com/ragi96/substrate-contracts-node.git
RUN cd substrate-contracts-node && echo $(ls -1) && echo $(pwd) && cargo build --release
RUN 

RUN echo "*** Start Substrate node template ***"
CMD [ "/substrate-contracts-node/target/release/substrate-contracts-node", "--dev", "--unsafe-ws-external", "--rpc-cors=all"]