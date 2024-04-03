FROM ubuntu:18.04
# Instalacion de dependencias
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-17-jdk wget unzip gnupg git

# Descargar la biblioteca bcprov-jdk15on
RUN wget --no-verbose -O /tmp/bcprov-jdk15on-1.70.jar https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk15on/1.70/bcprov-jdk15on-1.70.jar

# Mover la biblioteca a una ubicación deseada en la imagen
RUN mkdir -p /opt/lib && \
    mv /tmp/bcprov-jdk15on-1.70.jar /opt/lib/

# Configuracion variables de entorno Java
ENV JAVA_HOME='/usr/lib/jvm/java-17-openjdk-amd64'
ENV PATH=${JAVA_HOME}/bin:${PATH}

# Descargar e instalar Gradle
ENV GRADLE_VERSION=8.5
RUN wget --no-verbose "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    && unzip -d /opt gradle-${GRADLE_VERSION}-bin.zip \
    && rm gradle-${GRADLE_VERSION}-bin.zip \
    && wget "https://repo1.maven.org/maven2/org/eclipse/jgit/org.eclipse.jgit/6.7.0.202309050840-r/org.eclipse.jgit-6.7.0.202309050840-r.jar" \
    && mv org.eclipse.jgit-6.7.0.202309050840-r.jar /opt/gradle-${GRADLE_VERSION}/lib/plugins/  \
    && rm /opt/gradle-${GRADLE_VERSION}/lib/plugins/org.eclipse.jgit-5.7.0.202003110725-r.jar \
    && mv /opt/gradle-${GRADLE_VERSION}/lib/plugins/org.eclipse.jgit-6.7.0.202309050840-r.jar /opt/gradle-${GRADLE_VERSION}/lib/plugins/org.eclipse.jgit-5.7.0.202003110725-r.jar
#    && wget "https://repo1.maven.org/maven2/org/apache/commons/commons-compress/1.26.0/commons-compress-1.26.0.jar" \
#    && mv commons-compress-1.26.0.jar /opt/gradle-${GRADLE_VERSION}/lib/ \
#    && rm /opt/gradle-${GRADLE_VERSION}/lib/commons-compress-1.21.jar \
#    && mv /opt/gradle-${GRADLE_VERSION}/lib/commons-compress-1.26.0.jar /opt/gradle-${GRADLE_VERSION}/lib/commons-compress-1.21.jar

# Configuracion variables de entorno de Gradle
ENV GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
ENV PATH=${GRADLE_HOME}/bin:${PATH}

# Instalacion Google Chrome
RUN wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.198-1_amd64.deb \
  && apt install -y /tmp/chrome.deb \
  && rm /tmp/chrome.deb

# Instalar Xvfb
RUN apt-get install -y xvfb

# Configurar variables de entorno
ENV DISPLAY=:10

# Variables de entorno
ENV RAMA=${RAMA}
ENV REPOSITORIO=${REPOSITORIO}
ENV TAG=${TAG}
ENV NAV=${NAV}
COPY app /opt
WORKDIR /opt/
RUN chmod +x entrypoint.sh
ENTRYPOINT /bin/bash entrypoint.sh ${RAMA} ${REPOSITORIO} ${TAG} ${NAV}
