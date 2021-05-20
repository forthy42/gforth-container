FROM alpine:latest
LABEL maintainer="Bernd Paysan <bernd@net2o.de>"
ENV LANG C.UTF-8

ENV VERSION 0.7.9_20210520

RUN adduser -D gforth \
    && apk add --no-cache libltdl libffi \
    && apk add --no-cache --virtual .fetch-deps wget  file xz tar \
    && wget https://www.complang.tuwien.ac.at/forth/gforth/Snapshots/$VERSION/gforth-$VERSION.tar.xz -O /tmp/gforth.tar.xz \
    && xzcat /tmp/gforth.tar.xz | tar xf - -C /tmp  \
    && rm /tmp/gforth.tar.xz \
    && cd /tmp/gforth-* \
    && apk add --no-cache --virtual .build-deps freetype-dev \
        build-base autoconf automake m4 libtool git \
        coreutils gcc libffi-dev mesa-gles mesa-dev glew-dev libx11-dev \
        glfw-dev harfbuzz-dev gstreamer-dev gst-plugins-base-dev \
	bison pcre-dev boost-dev opus-dev pulseaudio-dev unzip
RUN ./install-swig.sh --prefix=/usr --exec-prefix=/usr && rm -rf swig
RUN ./configure --prefix=/usr --exec-prefix=/usr \
    && make  \
    && make install -i \
    && cd /tmp && rm -rf gforth-* \
    && apk del .build-deps \
    && apk del .fetch-deps

USER gforth
CMD [ "gforth" ]
