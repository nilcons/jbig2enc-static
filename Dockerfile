FROM debian:11.2

ADD . /code
WORKDIR /code
RUN apt-get update
RUN apt-get install -y build-essential automake libtool libleptonica-dev libz-dev \
        libgif-dev libtiff-dev libpng-dev libwebp-dev libzstd-dev libopenjp2-7-dev sharutils
RUN ./autogen.sh && ./configure && make
WORKDIR /code/src
RUN bash -c "g++ -Wall -O2 -o jbig2 jbig2.o \
        ./.libs/libjbig2enc.a \
        /usr/lib/x86_64-linux-gnu/lib{lept,openjp2,jpeg,gif,tiff,zstd,deflate,lzma,png16,jbig,webp,z}.a \
        -lpthread -static-libstdc++"
RUN strip -s jbig2
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN uuencode jbig2 jbig2.$(sha256sum <jbig2 | awk '{print $1}')
