#!/bin/bash
export SPARK_NAMESPACE=sparktst5
export SA=spark-exes
export K8S_CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export K8S_TOKEN=/var/run/secrets/kubernetes.io/serviceaccount/token

# Docker runtime image
export DOCKER_IMAGE=shuvamoy008/sparkops
export SPARK_DRIVER_NAME=spark-test2-pi

export topic=$1
export table=$2
export databasenm=$3

export KafkaBootstrapIP=`kubectl get all -n kafka | grep -i mykafka-kafka-external-bootstrap | awk '{print $4}'`
export mySQLIP=`kubectl get svc | grep -i mysql | awk '{print $4}'`
KUBERNET_IP=`kubectl exec -it deployment.apps/spark-master -n $SPARK_NAMESPACE  -- /bin/bash -c printenv | grep -i KUBERNETES_PORT_443_TCP_ADDR`
KUBERNET_IP=`echo $KUBERNET_IP | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'`
K8ip="k8s://https://${KUBERNET_IP}"

#echo $K8ip
port=443
echo "Running the spark command $K8ip:$port"
echo "with  $topic $KafkaBootstrapIP $table $databasenm"

kubectl exec -it deployment.apps/spark-master -n $SPARK_NAMESPACE -- /bin/bash -c "/opt/spark/bin/spark-submit --name sparkkafka-test123 \
   --master $K8ip:$port \
  --deploy-mode cluster  \
  --class org.apache.spark.examples.kafkaToMysql  \
  --conf spark.kubernetes.driver.pod.name=$SPARK_DRIVER_NAME  \
  --conf spark.kubernetes.authenticate.subdmission.caCertFile=$K8S_CACERT  \
  --conf spark.kubernetes.authenticate.submission.oauthTokenFile=$K8S_TOKEN  \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=$SA  \
  --conf spark.kubernetes.namespace=$SPARK_NAMESPACE  \
  --conf spark.executor.instances=2  \
  --conf spark.kubernetes.container.image=$DOCKER_IMAGE  \
  --conf spark.kubernetes.container.image.pullPolicy=Always \
  local:///opt/spark/examples/jars/mygcp-1.0-SNAPSHOT.jar $topic $KafkaBootstrapIP $table $databasenm $mySQLIP"



echo "Completed Data Push"
