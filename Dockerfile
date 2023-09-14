FROM openjdk:17-jre-alpine

# 更换 apline 镜像源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 设置镜像内时区
RUN apk --no-cache add tzdata vim
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
RUN apk del tzdata

WORKDIR application
# jar 相对 Dockerfile 所在的位置
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar

# Forward logs to Docker
# RUN ln -sf /dev/stdout /application/logs/media-sfu.log && \
#    ln -sf /dev/stderr /application/logs/media-sfu-error.log

ENTRYPOINT ["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=0.0.0.0:5005", "-jar", "application.jar"]