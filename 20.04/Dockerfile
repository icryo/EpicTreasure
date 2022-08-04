############################################################
# Dockerfile to build Epictreasure container
# Based on Ubuntu
############################################################
 
FROM ubuntu:20.04
ENV test false
MAINTAINER Maintainer Austin Marck
 
# Set up locale. Required for `tzdata`
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
 
# Update and unminimize. Docker installs a minimal version of Ubuntu 20.04
RUN apt update && \
    yes | unminimize
 
RUN apt -y install locales
 
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
 
RUN mkdir -p /root/tools
 
RUN apt update && \
    apt -y install man manpages-posix python3-dev python3-pip && \
    apt clean
 
RUN apt update && \
    apt install --no-install-recommends -y build-essential curl gdb \
    gdb-multiarch gdbserver git  zip\
    libncursesw5-dev python3-setuptools python-setuptools pkg-config\
    tmux tree stow virtualenvwrapper \
    wget nano vim unzip gcc-aarch64-linux-gnu\
    libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev \
    squashfs-tools zlib1g-dev liblzma-dev python-magic cmake \
    z3 net-tools strace ltrace libglib2.0-dev\
    gcc-multilib g++-multilib ruby-full binutils-mips-linux-gnu sudo
 
# Symlink `python3` and `pip3`
RUN ln -fs /usr/bin/python3 /usr/bin/python && \
    ln -fs /usr/bin/pip3 /usr/bin/pip
 
# Upgrade pip and ipython
RUN python3 -m pip install --upgrade pip && \
    pip3 install ipython
 
# Install 32bit dependencies
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt --no-install-recommends -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386 && \
    apt clean
 
#capstone keystone unicorn
RUN cd /root/tools && \
    wget https://raw.githubusercontent.com/icryo/EpicTreasure/master/update-trinity.sh && \
    sed 's/sudo//g' update-trinity.sh > no_sudo_trinity.sh && \
    chmod +x no_sudo_trinity.sh && \
    bash ./no_sudo_trinity.sh && \
    ldconfig
 
# Install radare
RUN git clone --depth 1 https://github.com/radare/radare2 && \
    cd radare2 && \
    ./sys/install.sh && \
    pip3 install r2pipe
 
# Install pwntools and pwndbg
RUN pip3 install git+https://github.com/Gallopsled/pwntools && \
    cd /root/tools && \
    git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && \
    ./setup.sh
 
# Install apktool
RUN apt update && \
    apt install --no-install-recommends -y default-jre && \
    wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool && \
    wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.6.1.jar && \
    mv apktool_2.6.1.jar /bin/apktool.jar && \
    mv apktool /bin/ && \
    chmod 755 /bin/apktool && \
    chmod 755 /bin/apktool.jar
 
# Install PIL
RUN pip3 install Pillow
 
# Install frida and the frida tools
RUN pip3 install frida frida-tools
 
# Install ROPgadget
RUN cd /root/tools && \
    git clone --depth 1 https://github.com/JonathanSalwan/ROPgadget.git && \
    cd ROPgadget && \
    python3 setup.py install
 
# Install fzf
RUN cd /root/tools && \
    git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf && \
    /root/.fzf/install --all --key-bindings --completion
 
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common
 
# Install qemu with multiarchs
RUN apt --no-install-recommends -y install qemu qemu-user qemu-user-static && \
    apt -m update && \
    apt install -y libc6-arm64-cross libcc6-dev-i386 \
    libc6-i386 libffi-dev libssl-dev libncurses5-dev && \
    apt --no-install-recommends -y install 'binfmt*' && \
    apt --no-install-recommends -y install libc6-armhf-armel-cross && \
    apt --no-install-recommends -y install debian-keyring && \
    apt --no-install-recommends -y install debian-archive-keyring && \
    apt --no-install-recommends -y install emdebian-archive-keyring && \
    apt -m update; echo 0 && \
    apt --no-install-recommends -y install libc6-mipsel-cross && \
    apt --no-install-recommends -y install libc6-armel-cross libc6-dev-armel-cross && \
    apt --no-install-recommends -y install libc6-dev-armhf-cross && \
    apt --no-install-recommends -y install binutils-arm-linux-gnueabi && \
    apt --no-install-recommends -y install libncurses5-dev && \
    mkdir /etc/qemu-binfmt && \
    ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel && \
    ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm && \
    apt clean
 
# Install Rust
RUN wget https://sh.rustup.rs && \
    chmod +x index.html && \
    ./index.html --default-toolchain nightly -y && \
    rm index.html
 
# Install ripgrep from Releases
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb && \
    dpkg -i ripgrep_13.0.0_amd64.deb && \
    rm ripgrep_13.0.0_amd64.deb
 
# Install one_gadget
RUN gem install one_gadget
 
# Install arm_now
RUN apt update && \
    apt install e2tools && \
    pip3 install https://github.com/nongiach/arm_now/archive/master.zip --upgrade && \
    apt clean
 
# Install DrMemory
RUN cd /root/tools && \
    wget https://github.com/DynamoRIO/drmemory/releases/download/cronbuild-2.5.19128/DrMemory-Linux-2.5.19128.tar.gz && \
    tar zxvf DrMemory* && \
    cd DrMemory* && \
    ln -s $PWD/bin/drmemory /usr/bin/drmemory-32 && \
    ln -s $PWD/bin64/drmemory /usr/bin/drmemory-64
 
# Install DynamoRIO
RUN cd /root/tools && \
    wget https://github.com/DynamoRIO/dynamorio/releases/download/cronbuild-9.0.19181/DynamoRIO-AArch64-Linux-9.0.19181.tar.gz && \
    tar zxvf DynamoRIO*tar.gz && \
    rm DynamoRIO*tar.gz && \
    wget https://github.com/DynamoRIO/dynamorio/releases/download/cronbuild-9.0.19181/DynamoRIO-Linux-9.0.19181.tar.gz && \
    tar zxvf DynamoRIO*tar.gz && \
    rm DynamoRIO*tar.gz
 
# Install Valgrind
Run apt update && \
    apt install valgrind && \
    apt clean
 
# Install gdb 8.2
# Run apt update && \
    # apt install -y texinfo && \
    # cd /root/tools && \
    # wget https://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz && \
    # xz -d < gdb-8.2.tar.xz > gdb-8.2.tar && \
    # tar xvf gdb-8.2.tar && \
    # cd gdb-8.2 && \
    # ./configure && \
    # make -j4 && \
    # make install && \
    # apt clean
 
 
RUN cd /root/tools && \
    git clone --depth 1 https://github.com/ReFirmLabs/binwalk && \
    cd binwalk && \
    python3 setup.py install
 
# Install angr
RUN python3 -m pip install angr
 
# Install zeratool
RUN python3 -m pip install zeratool
 
# Install Rust binaries
RUN /root/.cargo/bin/cargo install ripgrep exa bat
 
# Install gef but keep pwndbg downloaded
RUN wget -O ~/.gdbinit-gef.py -q https://raw.githubusercontent.com/hugsy/gef/dev/gef.py && echo source ~/.gdbinit-gef.py > ~/.gdbinit
RUN wget -O ~/.gdbinit-gef-extras.sh -q https://raw.githubusercontent.com/hugsy/gef/dev/scripts/gef-extras.sh && \
    chmod +x ~/.gdbinit-gef-extras.sh && \
    ~/.gdbinit-gef-extras.sh
 
# Install go
RUN wget https://go.dev/dl/go1.19.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go*tar.gz
 
COPY .tmux.conf /root/.tmux.conf
COPY test.sh /root/test.sh
CMD sh -c 'if [ "$test" = true ]; then echo "Running tests"; chmod +x /root/test.sh; /root/test.sh; else /bin/bash; fi'
