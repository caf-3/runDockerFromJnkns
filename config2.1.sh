FROM jenkins/jenkins

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT
# Run this command to find git commit:-
#docker inspect quay.io/shazchaudhry/docker-jenkins | jq '.[].ContainerConfig.Labels'

# Configure Jenkins
COPY config/*.xml $JENKINS_HOME/
COPY config/*.groovy /usr/share/jenkins/ref/init.groovy.d/

USER root

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker
usermod -aG docker jenkins && \
chown -R jenkins:jenkins $JENKINS_HOME/

USER jenkins

VOLUME [$JENKINS_HOME, "/var/run/docker.sock"]

echo 'Done'
