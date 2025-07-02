FROM ubuntu:noble
ARG DEBIAN_FRONTEND=noninteractive

# Install system packages
# -----------------------------------------------------------------------------------------
RUN : \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends \
	    ca-certificates \
        curl \
		unzip \
		xz-utils \
		openjdk-21-jdk \
        git \
		git-lfs \
        make \
        python3 \
    && rm -rf /var/lib/apt/lists/* \
    && :
	
ADD https://www.silabs.com/documents/login/software/slc_cli_linux.zip /tmp/slc_cli.zip
RUN : \
    && cd /tmp \
    && unzip -d /opt slc_cli.zip \
	&& :
ADD https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz /tmp/arm-gnu-toolchain.tar.xz
RUN :\
    && cd /tmp \
	&& mkdir /opt/gnu_arm \
	&& tar -xf arm-gnu-toolchain.tar.xz --strip 1 -C /opt/gnu_arm \
	&& :
RUN git clone --depth 1 https://github.com/SiliconLabs/simplicity_sdk.git /opt/simplicity_sdk
ENV PATH="$PATH:/opt/slc_cli:/opt/gnu_arm/bin"
RUN : \
    && slc configuration --sdk=/opt/simplicity_sdk --gcc-toolchain=/opt/gnu_arm \
    && slc signature trust --sdk /opt/simplicity_sdk \
	&& :
