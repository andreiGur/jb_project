FROM yanivomc/jenkins-slave:baseline-1.0

# Install Jenkins web API for Python
RUN pip install jenkins-webapi

# Create necessary directories
RUN mkdir -p /home/jenkins && mkdir -p /var/lib/jenkins

# Install SonarScanner CLI
RUN curl -o /opt/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip \
    && unzip /opt/sonar-scanner.zip -d /opt/ \
    && ln -s /opt/sonar-scanner-4.6.2.2472-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Start-up script to attach the slave to the master
ADD slave.py /var/lib/jenkins/slave.py

# Set the working directory for Jenkins
WORKDIR /home/jenkins

# Set environment variables for Jenkins slave connection
ENV JENKINS_URL "http://jenkins"
ENV JENKINS_SLAVE_ADDRESS ""
ENV JENKINS_USER "admin"
ENV JENKINS_PASS "admin"
ENV SLAVE_NAME ""
ENV SLAVE_SECRET ""
ENV SLAVE_EXECUTORS "3"
ENV SLAVE_LABELS "docker"
ENV SLAVE_WORING_DIR ""
ENV CLEAN_WORKING_DIR "true"

# Command to run the Jenkins slave
CMD [ "python3", "-u", "/var/lib/jenkins/slave.py" ]
