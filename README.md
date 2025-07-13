# Teste Prático: Implantação de Serviço Web em Alta Disponibilidade

![Build Status](https://github.com/hignicao/bry-test/actions/workflows/deploy.yaml/badge.svg)

Este projeto foi desenvolvido como parte de um teste técnico, com o objetivo de provisionar e manter um serviço web em um ambiente de alta disponibilidade, utilizando as melhores práticas de Infraestrutura como Código (IaC), automação e monitoramento.

---

## Arquitetura da Solução

A solução foi construída para ser 100% local e gratuita, simulando um ambiente de produção na nuvem.

Os principais componentes da arquitetura são:

* **Ambiente de Execução:** Um ambiente com suporte a contêineres Linux (Docker).
* **Motor de Contêineres:** **Docker** para criar e gerenciar os contêineres.
* **Orquestrador (Kubernetes):** **K3d** para criar um cluster **K3s** leve e multi-node (1 master, 2 workers), simulando um ambiente de alta disponibilidade.
* **Infraestrutura como Código (IaC):**
    * **Shell Scripts:** Para automação da criação e destruição do cluster.
    * **Manifestos Kubernetes (YAML):** Para a declaração de todos os recursos da aplicação.
    * **Helm:** Para o gerenciamento e instalação de pacotes de software complexos.
* **Gateway de API / Roteamento:** **NGINX Ingress Controller** para gerenciar o tráfego externo.
* **Segurança (SSL):** **Cert-Manager** configurado para atuar como uma Autoridade Certificadora (CA) local e emitir certificados SSL.
* **Monitoramento e Observabilidade:** **Kube-Prometheus-Stack**, que inclui Prometheus e Grafana.
* **Automação de CI/CD:** **GitHub Actions** para simular o processo de deploy da aplicação.

---

## ✨ Principais Funcionalidades

-   [x] **Alta Disponibilidade:** Cluster Kubernetes com 2 nós workers e aplicação com 2 réplicas.
-   [x] **Infraestrutura como Código:** Todo o ambiente é provisionado via código.
-   [x] **Segurança:** Acesso protegido com SSL e gerenciamento de tráfego através de um gateway central.
-   [x] **Monitoramento Completo:** Métricas de cluster e aplicações disponíveis no Grafana.
-   [x] **Automação de Deploy (CI/CD):** Pipeline configurada para orquestrar o deploy.
-   [x] **Portabilidade:** Funciona em qualquer sistema operacional com as ferramentas necessárias.
-   [x] **Custo Zero:** Solução 100% local e gratuita.

---

## 🛠️ Stack de Tecnologias

* **Containers:** Docker, K3s, K3d
* **Orquestração:** Kubernetes
* **IaC & Automação:** Shell Script (`bash`), Helm, GitHub Actions
* **Rede & Segurança:** NGINX Ingress Controller, Cert-Manager
* **Monitoramento:** Prometheus, Grafana

---

## Como Executar

Siga os passos abaixo para provisionar todo o ambiente na sua máquina.

### Pré-requisitos

Antes de começar, certifique-se de que você tem as seguintes ferramentas de linha de comando instaladas e funcionando em seu sistema:

* **Docker:**
    * [Docker Engine (Linux)](https://docs.docker.com/engine/install/) ou [Docker Desktop (Mac/Windows)](https://www.docker.com/products/docker-desktop/).
* **kubectl:**
    * [Install Tools | Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
* **helm:**
    * [Helm | Installing Helm](https://helm.sh/docs/intro/install/).
* **k3d:**
    * [k3d](https://k3d.io/v5.6.3/#installation).

### 1. Clonar o Repositório

```bash
git clone https://github.com/hignicao/bry-test.git
cd bry-test
```

### 2. Configurar o Domínio Local
Este projeto requer um domínio para roteamento. Para simular isso localmente:

1.  **Crie um domínio gratuito** em um serviço como [CloudNS](https://www.cloudns.net/) (ex: `exemplo-teste.cloudns.com`).
2.  Configure um registro do tipo `A` apontando o domínio (`@`) e um wildcard (`*`) para o endereço IP `127.0.0.1`.
3.  **Edite o arquivo `hosts` do seu sistema operacional** com privilégios de administrador/sudo.
    * **Linux/macOS:** `/etc/hosts`
    * **Windows:** `C:\Windows\System32\drivers\etc\hosts`
4.  Adicione a seguinte linha, substituindo pelo seu domínio:
    ```
    127.0.0.1 whoami.exemplo-teste.cloudns.com grafana.exemplo-teste.cloudns.com
    ```

### 4. Subir o Ambiente

Com o Docker Desktop rodando, execute os seguintes comandos no seu terminal WSL:

```bash
# 1. Cria o cluster K3d (1 master, 2 workers)
bash create-cluster.sh

# 2. Instala os serviços essenciais via Helm (NGINX, Cert-Manager, Prometheus)
bash deploy-services.sh

# 3. Instala a aplicação whoami, o Ingress do Grafana e o Issuer de certificados
kubectl apply -f k8s/
```

### 5. Acessar os Serviços

Após alguns minutos, o ambiente estará pronto.

- Acesse a aplicação em `https://whoami.exemplo-teste.cloudns.com`.
- Acesse o Grafana em `https://grafana.exemplo-teste.cloudns.com`.
  - **Usuário:** `admin`
  - **Senha:** Execute o comando abaixo para obter a senha gerada:
    ```bash
    kubectl get secret prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode
    ```

---

## Pipeline de CI/CD

Este projeto utiliza **GitHub Actions** para automação. O workflow se encontra em `.github/workflows/deploy.yaml`.

- **Gatilho:** A pipeline é acionada a cada `push` na branch `main`.
- **Funcionamento:** Em um cenário real de nuvem, a pipeline se autenticaria no cluster e executaria `kubectl apply` para atualizar a aplicação. Como nosso cluster é local, a pipeline **simula** esses passos, instalando as ferramentas e listando os arquivos que seriam aplicados, validando a integridade do processo de CI/CD.

---

## Estrutura do Projeto

```
.
├── .github/workflows/         # Definições da pipeline de CI/CD
│   └── deploy.yaml
├── k8s/                       # Manifestos Kubernetes
│   ├── grafana-ingress.yaml   # Ingress para o Grafana
│   ├── local-issuer.yaml      # Emissor de certificados SSL locais
│   └── whoami-app.yaml        # Deployment, Service e Ingress do app
├── create-cluster.sh          # Script para CRIAR o cluster k3d
├── deploy-services.sh         # Script para INSTALAR os serviços com Helm
└── README.md                  # Esta documentação
```

---

## Autor

- **Hugo Ignacio**
- **LinkedIn:** `https://www.linkedin.com/in/hugoignacio/`
- **GitHub:** `https://github.com/hignicao`
