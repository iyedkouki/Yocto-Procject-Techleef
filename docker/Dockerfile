# ubnutu 22.04
FROM ubuntu:22.04

LABEL description=""
LABEL version="1.0"


ENV DEBIAN_FRONTEND=noninteractive

# Dependencies for yocto scarthgap from this site https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html
RUN apt-get update && \
    apt-get install -y \
    sudo build-essential chrpath cpio debianutils diffstat file gawk gcc git \
    iputils-ping libacl1 liblz4-tool locales python3 python3-git python3-jinja2 \
    python3-pexpect python3-pip python3-subunit socat texinfo unzip wget \
    xz-utils zstd \
    && rm -rf /var/lib/apt-lists/*


# LOCALE CONFIGURATION TIME LANG
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALl=en_US.utf-8

# Group and user permission

ARG USERNAME=yocto_project
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${USERNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} && \
    usermod -aG sudo ${USERNAME} && \
    mkdir -p /etc/sudoers.d && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 440 /etc/sudoers.d/${USERNAME}

#########
RUN pip3 install kas

# Working directory
USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD ["/bin/bash"]
