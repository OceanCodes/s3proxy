FROM maven:3-jdk-7-onbuild as builder

FROM anapsix/alpine-java:jre7
MAINTAINER Andrew Gaul <andrew@gaul.org>

WORKDIR /opt/s3proxy
COPY --from=builder /usr/src/app/target/s3proxy /opt/s3proxy/
COPY src/main/resources/run-docker-container.sh /opt/s3proxy/

ENV \
    LOG_LEVEL="info" \
    S3PROXY_AUTHORIZATION="aws-v2-or-v4" \
    S3PROXY_IDENTITY="local-identity" \
    S3PROXY_CREDENTIAL="local-credential" \
    S3PROXY_CORS_ALLOW_ALL="false" \
    S3PROXY_IGNORE_UNKNOWN_HEADERS="false" \
    JCLOUDS_PROVIDER="filesystem" \
    JCLOUDS_ENDPOINT="" \
    JCLOUDS_REGION="" \
    JCLOUDS_IDENTITY="remote-identity" \
    JCLOUDS_CREDENTIAL="remote-credential"

EXPOSE 80
VOLUME /data

ENTRYPOINT ["/opt/s3proxy/run-docker-container.sh"]
