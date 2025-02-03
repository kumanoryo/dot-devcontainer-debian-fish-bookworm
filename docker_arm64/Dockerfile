FROM arm64v8/debian:bookworm-slim
#
# set argument
ARG USER_NAME=kumano_ryo
ARG USER_ID=501
ARG GROUP_ID=$USER_ID
#
# install packages and tools
ENV DEBIAN_FRONTEND=noninteractive
#
# create noroot user
RUN mkdir -p /etc/sudoers.d \
    && groupadd --gid ${GROUP_ID} ${USER_NAME} \
    && useradd -s "/usr/bin/fish" --uid ${USER_ID} --gid ${GROUP_ID} -m ${USER_NAME} \
    && echo "${USER_NAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME} \
    && chmod 0440 /etc/sudoers.d/${USER_NAME}
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
        less \
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
    # crean up
    && apt-get autoremove -y \
    && apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

# Download 1Password for arm64
RUN curl -sSO https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz -o 1password-latest.tar.gz \
    && tar -xf 1password-latest.tar.gz \
    && mkdir -p /opt/1Password \
    && mv 1password-*/* /opt/1Password \
    && /opt/1Password/after-install.sh \
    && ln -s /opt/1Password/1password /usr/local/bin/1password \
    && rm -rf 1password-latest.tar.gz 1password-*/
#
# install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update -y \
    && apt-get install -y \
        google-cloud-sdk \
        kubectl \
        google-cloud-cli-gke-gcloud-auth-plugin \
    # crean up
    && apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*
# install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install
#
# install git (required git >=  2.35)
WORKDIR /usr/local/src
RUN git clone git://git.kernel.org/pub/scm/git/git.git \
    && apt-get remove -y git \
    && cd git \
    && make prefix=/usr all \
    && make prefix=/usr install \
    && cd ../ \
    && rm -fr git
#
# install docker
    # Add Docker's official GPG key:
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    # Add the repository to Apt sources:
    && echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    # Install the Docker packages.
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && usermod -aG docker $USER_NAME \
    # crean up
    && apt-get autoremove -y \
    && apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*
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

# set env
ENV DEBIAN_FRONTEND=dialog
LABEL org.opencontainers.image.source=https://github.com/bearfield/dot-devcontainer-debian-fish-bookworm