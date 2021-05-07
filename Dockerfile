FROM adoptopenjdk:11-jre-hotspot AS build
WORKDIR application
ARG JAR=*.jar
COPY ${JAR} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM adoptopenjdk:11-jre-hotspot
WORKDIR application
COPY --from=build application/dependencies/ ./
RUN true
COPY --from=build application/spring-boot-loader/ ./
RUN true
COPY --from=build application/snapshot-dependencies/ ./
RUN true
COPY --from=build application/application/ ./
RUN true
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]