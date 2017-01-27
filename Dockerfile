FROM alpine:edge
MAINTAINER Nathan McAullay <nmcaullay@gmail.com>
ENV PACKAGE "tvheadend-git tvheadend-git-dvb-scan libhdhomerun tzdata"

#Create the HTS user (9981), and add to user group (9981)
RUN addgroup -g 9981 hts
#RUN adduser -u 9981 -g 9981 hts
RUN adduser -g 9981 hts

# Update packages in base image, avoid caching issues by combining statements, install build software and deps
RUN	echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk add --no-cache $PACKAGE
#	mkdir -p /config /recordings && \
#	chown -R hts:hts /config /recordings && \
#	cp /usr/share/zoneinfo/Australia/Sydney /etc/localtime && \
#	echo "Australia/Sydney" > /etc/timezone

#Set the user
USER hts

EXPOSE 9981 9982

ENTRYPOINT ["/usr/bin/tvheadend"]
#CMD ["-C","-c","/config"]
CMD ["/usr/bin/tvheadend","-C","-u","hts","-g","hts","-c","/config"]
