helm repo add timescale 'https://charts.timescale.com'
helm repo update

echo "4.1 Installing Timescale server"

helm install timescaledb timescale/timescaledb-single -f resources/dependencies/timescale/values.yaml -n monitoring
sleep 120
kubectl -n monitoring wait --for=condition=ready --timeout=120s pod -l app=timescaledb

kubectl -n monitoring exec -i --tty "$(kubectl get pod -o name --namespace monitoring -l role=master,release=timescaledb)" -- psql -U postgres -c "CREATE DATABASE tsdb WITH OWNER postgres;"

echo "4.2 Installing promscale"

helm install -n monitoring promscale timescale/promscale -f resources/dependencies/promscale/values.yaml
sleep 120
kubectl -n monitoring wait --for=condition=ready --timeout=120s pod -l app=promscale