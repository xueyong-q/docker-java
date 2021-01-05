ARG JAVA_VERSION
FROM openjdk:${JAVA_VERSION}

ARG USERNAME
ARG USER_UID
ARG USER_GID=${USER_UID}
ARG LANG

ARG MAVEN_VERSION
ARG MAVEN_SHA
ARG MAVEN_HOME

ARG TOMCAT_VERSION
ARG TOMCAT_SHA
ARG CATALINA_HOME

ARG GRADLE_VERSION
ARG GRADLE_HOME

ENV LANG=${LANG}
ENV MAVEN_CONFIG /home/${USERNAME}/.m2

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
    && mkdir -p ${MAVEN_HOME} \
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
