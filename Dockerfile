FROM tomcat:9.0.11-jre8

COPY google-storage-mgnl-webapp/target/*.war /usr/local/tomcat/webapps/google-storage-mgnl.war

ENV CATALINA_OPTS="-Xmx2048m -Dmagnolia.update.auto=true"

RUN touch /usr/local/tomcat/logs/build-log.out

RUN /bin/bash -c "grep -m 1 'Server startup' <(exec /usr/local/tomcat/bin/catalina.sh run 2>&1) ; kill $! 2> /dev/null" || true

HEALTHCHECK \
  --interval=20s \
  --timeout=3s \
  --start-period=400s \
  CMD curl -f http://localhost:8080/ || exit 1

RUN echo "done"