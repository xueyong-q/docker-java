FROM openjdk:11-jdk

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ENV LANG C.UTF-8
ENV MAVEN_CONFIG /root/.m2

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG MAVEN_VERSION=3.6.3
ARG MAVEN_SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG MAVEN_HOME=/usr/local/maven

ARG TOMCAT_VERSION=9.0.41
ARG TOMCAT_SHA=b6450e590a37c5bccf049b1176c441f0964796995e80d4c7c7d9fb74f9ad817107c303b6b83ed3d71c9251b2b8acf334b90a4abdf9deea122e338643cece0766
ARG CATALINA_HOME=/usr/local/tomcat

ARG JAVA_HOME=/usr/local/openjdk-11
ARG GRADLE_VERSION=6.5.1
ARG GRADLE_HOME=/usr/local/gradle

COPY maven-settings.xml ${MAVEN_HOME}/ref/
COPY ohmyzsh.sh /tmp/

# Configure apt
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog zsh jq 2>&1 \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/zsh --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    #
    # Verify git, needed tools installed
    && apt-get -y install git openssh-client less iproute2 procps curl lsb-release unzip vim jq \
    #
    # add bin dir
    && sudo -u ${USERNAME} mkdir /home/${USERNAME}/bin \
    #
    # Install Maven
    && mkdir -p ${MAVEN_HOME} ${MAVEN_HOME}/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && echo "${MAVEN_SHA} /tmp/apache-maven.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/apache-maven.tar.gz -C ${MAVEN_HOME} --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s ${MAVEN_HOME}/bin/mvn /home/${USERNAME}/bin/mvn \
    #
    # Install Tomcat
    && mkdir ${CATALINA_HOME} \
    && curl -fsSL -o /tmp/apache-tomcat.tar.gz https://mirrors.bfsu.edu.cn/apache/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && echo "${TOMCAT_SHA} /tmp/apache-tomcat.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/apache-tomcat.tar.gz -C ${CATALINA_HOME} --strip-components=1 \
    && chown ${USERNAME}:${USERNAME} -R ${CATALINA_HOME} \
    && rm -f /tmp/apache-tomcat.tar.gz \
    && ln -s ${CATALINA_HOME}/bin/startup.sh /home/${USERNAME}/bin/tomcatup \
    && ln -s ${CATALINA_HOME}/bin/shutdown.sh /home/${USERNAME}/bin/tomcatdown \
    #
    # Install Gradle
    && curl -fsSL -o /tmp/gradle-bin.zip https://downloads.gradle-dn.com/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    && unzip -o /tmp/gradle-bin.zip -d /tmp \
    && mv /tmp/gradle-${GRADLE_VERSION} ${GRADLE_HOME} \
    && rm -rf /tmp/gradle-* \
    #
    # 设置环境变量
    && echo "export JAVA_HOME=${JAVA_HOME}" >> /home/${USERNAME}/.envrc \
    && echo "export CATALINA_HOME=${CATALINA_HOME}" >> /home/${USERNAME}/.envrc \
    && echo "export MAVEN_HOME=${MAVEN_HOME}" >> /home/${USERNAME}/.envrc \
    && echo "export GRADLE_HOME=${GRADLE_HOME}" >> /home/${USERNAME}/.envrc \
    && echo "export PATH=${GRADLE_HOME}/bin:\$PATH" >> /home/${USERNAME}/.envrc \
    && echo "export PATH=/home/${USERNAME}/bin:\$PATH" >> /home/${USERNAME}/.envrc \
    && sudo -u ${USERNAME} touch /home/${USERNAME}/.zshrc \
    && echo ". ~/.envrc" > /home/${USERNAME}/.zshrc \
    #
    # add permissions
    && chmod +x /tmp/ohmyzsh.sh \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
