k3d cluster create devops-test \
  --servers 1 \
  --agents 2 \
  --port "443:443@loadbalancer" \
  --port "80:80@loadbalancer" \
  --k3s-arg "--disable=traefik@server:0"

echo "Cluster 'devops-test' criado com sucesso!"
echo "Execute 'kubectl get nodes' para verificar."