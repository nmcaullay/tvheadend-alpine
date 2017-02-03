FROM alpine:edge
MAINTAINER Nathan McAullay <nmcaullay@gmail.com>
ENV PACKAGE "tvheadend-git tvheadend-git-dvb-scan libhdhomerun tzdata"

#Create the HTS user (9981), and add to user group (9981)
#RUN addgroup -g 9981 hts
#RUN adduser -u 9981 -g 9981 hts

# Update packages in base image, avoid caching issues by combining statements, install build software and deps
RUN	echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk add --no-cache $PACKAGE

USER tvheadend
    
#Expose the TVH ports
EXPOSE 9981 9982

#Expose the volumes
VOLUME ["/config"]
VOLUME ["/media"]

#Start tvheadend when container starts 
CMD ["-u","tvheadend","-g","tvheadend","-c","/config"]
ENTRYPOINT ["/usr/bin/tvheadend"]
#ENTRYPOINT ["/usr/bin/tvheadend"]
#CMD ["-C","-c","/config"]
