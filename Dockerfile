FROM alpine:edge
MAINTAINER Nathan McAullay <nmcaullay@gmail.com>
#ENV PACKAGE "tvheadend-git tvheadend-git-dvb-scan libhdhomerun tzdata"

#Create the HTS user (9981), and add to user group (9981)
#RUN addgroup -g 9981 hts
#RUN adduser -u 9981 -g 9981 hts

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	cmake \
	coreutils \
	ffmpeg-dev \
	file \
	findutils \
	g++ \
	gcc \
	gettext-dev \
	git \
	libhdhomerun-dev \
	libgcrypt-dev \
	libtool \
	libxml2-dev \
	libxslt-dev \
	make \
	mercurial \
	openssl-dev \
	patch \
	perl-dev \
	pkgconf \
	sdl-dev \
	uriparser-dev \
	wget \
	zlib-dev && \

cd /tmp && \
git clone --depth=1 git://linuxtv.org/media_build.git v4l-dvb && \
cd v4l-dvb && \
cd media_build  && \
./build && \

# build dvb-apps
# hg clone http://linuxtv.org/hg/dvb-apps /tmp/dvb-apps && \
# cd /tmp/dvb-apps && \
# make && \
# make install && \
 
cd /tmp && \
    git clone https://github.com/tvheadend/tvheadend.git && \
    cd tvheadend && \
    git reset --hard HEAD && \
    git pull && \
    ./configure --enable-hdhomerun_client --enable-hdhomerun_static --enable-libffmpeg_static --prefix=/usr && \
    make && \
    make install && \
    
#Expose the TVH ports
EXPOSE 9981 9982

#Expose the volumes
VOLUME ["/config"]
VOLUME ["/media"]

#Set the user
USER hts

#Start tvheadend when container starts 
CMD ["/usr/bin/tvheadend","-C","-u","hts","-g","hts","-c","/config"]
#ENTRYPOINT ["/usr/bin/tvheadend","-C","-u","hts","-g","hts","-c","/config"]
