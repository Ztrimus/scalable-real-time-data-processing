FROM confluentinc/cp-kafka-connect:latest

USER root

# Install unzip
# Install unzip using microdnf (used in Red Hat UBI-based images)
RUN microdnf update && microdnf install -y unzip && microdnf clean all

# Create directory for plugins
RUN mkdir -p /etc/kafka-connect/jars

# Download Neo4j Kafka Connector release ZIP and extract JARs
ADD https://github.com/neo4j-contrib/neo4j-streams/releases/download/5.0.8/neo4j-kafka-connect-neo4j-5.0.8.zip /tmp/neo4j-kafka-connect.zip
RUN unzip /tmp/neo4j-kafka-connect.zip -d /tmp/neo4j-kafka \
    && cp /tmp/neo4j-kafka/neo4j-kafka-connect-neo4j-5.0.8/lib/*.jar /etc/kafka-connect/jars/ \
    && rm -rf /tmp/neo4j-kafka*


# Set plugin path for Kafka Connect
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/etc/kafka-connect/jars"

# Make sure init.sh can be executed if needed
RUN chmod +x /etc/confluent/docker/run

USER appuser


# FROM confluentinc/cp-server-connect-base:7.3.3

# ENV CONNECT_BOOTSTRAP_SERVERS="kafka-service:29092" \
#     CONNECT_REST_PORT="8083" \
#     CONNECT_GROUP_ID="kafka-connect" \
#     CONNECT_CONFIG_STORAGE_TOPIC="_connect-configs" \
#     CONNECT_OFFSET_STORAGE_TOPIC="_connect-offsets" \
#     CONNECT_STATUS_STORAGE_TOPIC="_connect-status" \
#     CONNECT_KEY_CONVERTER="org.apache.kafka.connect.storage.StringConverter" \
#     CONNECT_VALUE_CONVERTER="org.apache.kafka.connect.json.JsonConverter" \
#     # CONNECT_VALUE_CONVERTER="io.confluent.connect.avro.AvroConverter" \
#     CONNECT_VALUE_CONVERTER_SCHEMAS_ENABLE="false" \
#     CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL="http://schema-registry:8081" \
#     CONNECT_REST_ADVERTISED_HOST_NAME="kafka-connect" \
#     CONNECT_LOG4J_APPENDER_STDOUT_LAYOUT_CONVERSIONPATTERN="[%d] %p %X{connector.context}%m (%c:%L)%n" \
#     CONNECT_LOG4J_LOGGERS="org.apache.zookeeper=ERROR,org.I0Itec.zkclient=ERROR,org.reflections=ERROR" \
#     CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR="1" \
#     CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR="1" \
#     CONNECT_STATUS_STORAGE_REPLICATION_FACTOR="1" \
#     CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components,/etc/kafka-connect/jars,/data/connect-jars"

# # Install neo4j plugin
# RUN confluent-hub install --no-prompt neo4j/kafka-connect-neo4j:latest

# COPY sink.neo4j.json sink.neo4j.json
# COPY init.sh init.sh

# EXPOSE 8083

# # Run the script on startup
# CMD /bin/sh -c "./init.sh && tail -f /dev/null"
