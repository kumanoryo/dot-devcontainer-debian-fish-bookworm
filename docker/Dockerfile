FROM debian:bookworm-slim
#
# set argument
ARG USER_NAME=kumano_ryo
ARG USER_ID=501
ARG GROUP_NAME=$USER_NAME
ARG GROUP_ID=$USER_ID
#
# install packages and tools
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    # install debian packages
    && apt-get install  --no-install-recommends -y \
        ca-certificates \
        git \
        lsb-release \
        sudo \
        curl \
        gnupg \
        make \
        peco \
        fish \
        locales \
        openssh-client \
        unzip \
        shellcheck \
        libcurl4-gnutls-dev \
        libexpat1-dev gettext \
        libz-dev \
        libssl-dev \
        gcc \
#
# set locale
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && update-locale LC_CTYPE=en_US.UTF-8 \
#
# install powerline patched fonts
    && apt-get install -y \
        fonts-powerline \
# setup 1password apt repository
    && curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg \
    && echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list \
    && sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ \
    && curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol \
    && sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 \
    && curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg \
#
# install 1password
    && apt-get update \
    && apt-get install -y \
        1password \
    # crean up
    && apt-get autoremove -y \
    && apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*
#
# create noroot user
RUN groupadd --gid $GROUP_ID $GROUP_NAME \
    && useradd -s $(which fish) --uid $USER_ID --gid $GROUP_ID -m $USER_NAME \
    && echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME \
    && chmod 0440 /etc/sudoers.d/$USER_NAME
#
# install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && sudo apt-get update && sudo apt-get install google-cloud-sdk
# install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install
#
# isntall fisher
USER $USER_NAME
SHELL ["fish", "-c"]
RUN curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
# insetall my fish plugin
RUN fisher install bearfield/peco_select_gce_ssh
RUN fisher install bearfield/peco_select_gcp_project
# power line style
RUN fisher install oh-my-fish/theme-bobthefish
#
# copy config.fish
COPY config.fish /home/$USER_NAME/.config/fish/config.fish
#
# install git (required git >=  2.35)
WORKDIR /usr/local/src
RUN sudo git clone git://git.kernel.org/pub/scm/git/git.git \
    && sudo apt-get remove -y git \
    && cd git \
    && sudo make prefix=/usr all \
    && sudo make prefix=/usr install \
    && cd ../ \
    && sudo rm -fr git
# set env
ENV DEBIAN_FRONTEND=dialog
LABEL org.opencontainers.image.source https://github.com/bearfield/dot-devcontainer-debian-fish-bookworm