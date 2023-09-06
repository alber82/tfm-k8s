kubectl create namespace kafka

echo "6.1 Installing Kafka operator"

kubectl apply -f resources/dependencies/kafka/01-kafka-operator.yaml
sleep 5
kubectl -n kafka wait --for=condition=ready --timeout=120s pod -l name=strimzi-cluster-operator

echo "6.2 Installing Kafka cluster server"
kubectl apply -f resources/dependencies/kafka/02-kafka-cluster.yaml
sleep 5
kubectl -n apply wait --for=condition=ready --timeout=240s pod -l strimzi.io/cluster=kafka-cluster

echo "Kafka cluster installed"

#kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.34.0-kafka-3.4.0 --rm=true --restart=Never -- bin/kafka-producer-perf-test.sh --producer-props bootstrap.servers=kafka-cluster-kafka-bootstrap:9092 --topic my-topic --num-records  5000000 --record-size 512 --throughput 1000



