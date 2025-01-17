# Fake Shop

## CLOUD AWS

### Criação de Role para o EKS

1. Crie uma Role:
   - AWS Service
   - Selecione EKS
   - EKS Cluster
   - O sistema sugere uma role; clique em **Next**
   - Dê um nome à role e siga em frente.

### Criação de Role para os Worker Nodes

1. Crie uma Role:
   - AWS Service
   - Selecione EC2
   - EC2 e avance.
   
2. Defina as políticas:
   - `AmazonEKSWorkerNodePolicy`
   - `AmazonEKS_CNI_Policy`
   - `AmazonEC2ContainerRegistryReadOnly`
   
3. Dê um nome à role e avance.

### Próximo Passo: Criar a Rede Utilizando CloudFormation

1. Crie uma Stack:
   - Use o template e utilize a URL fornecida pela AWS:
   
     ```
     https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml
     ```

2. Avance, dê um nome à Stack e, por fim, clique em **Submit** para criá-la.

### Criar o EKS

Ao clicar em **Criar EKS**, há duas opções de configuração:

- **EKS Auto Mode**: Uma configuração rápida que facilita a gestão do cluster.
- **Custom Configuration**: Criação de forma mais detalhada.

Escolha **Custom Configuration**:
- Desabilite o **EKS Auto Mode**.
- Nome do Cluster: `aula-eks`.
- Selecione a role criada anteriormente: `EKS-CLUSTER`.
- Marque a opção **Allow Cluster Administrator Access** para garantir que você possa acessar o cluster.

Deixe o resto como está e avance para a próxima página.

### Configurações de Rede

1. Selecione a **VPC** que criamos: `aula-vpc`.
2. Selecione todas as subnets disponíveis nessa VPC.
3. **Security Group**: Selecione o criado, chamado `aula-eks-ControlPlaneSecurityGroup`.
4. **Cluster Endpoint Access**:
   - **Public**: Quando os worker nodes precisam acessar o cluster Kubernetes pela internet.
   - **Public e Privada (Mix)**: Melhor para permitir que os worker nodes se comuniquem e também o acesso externo.
   - **Privada**: Apenas acessível de dentro da AWS.

Avance para a próxima página. 

- Não ative o **Control Plane Logs** (para evitar cobranças adicionais em um ambiente de teste, mas é importante ativar em produção).

Na próxima página, selecione os **Addons** padrão e avance até a criação do cluster.

### Autenticação e Instalação do AWS CLI

1. Instale o AWS CLI.
2. No terminal, execute:
   ```bash
   aws configure
Insira a Access Key e Secret Key. O resto pode ser deixado como padrão.

# Configuração de Acesso ao EKS no CLI

Para configurar o acesso ao EKS no CLI, execute o seguinte comando no terminal:

```
aws eks update-kubeconfig --name <nome-do-cluster>
```

### Criar os Worker Nodes

1. No console da AWS, navegue até a aba **Computing**.
2. Adicione um **Node Group**:
   - **Nome**: `default`
   - **Role**: `eks-worker` (a role que você criou anteriormente)
   
3. Selecione o tipo de instância e a quantidade de escala:
   - Tipo de instância: **t3.medium** (você pode escolher outra conforme necessário, se for menor que essa o eks vai ter problemas para subir)
   - Instância **SPOT** para melhorar a precificação
   - Quantidade de instâncias: **2,2,2** (isso definirá a escala automática)

4. Em **Quantidade de atualização**, deixe como **1**, o que determinará o comportamento durante atualizações.

5. Em **Specify Networking**, selecione apenas as **Subnets privadas**.

6. Clique em **Next** até que o Node Group seja criado.

> **Observação**: A mesma conta que foi criada o cluster precisa estar conectada no seu local de origem. Caso contrário, você não conseguirá acessar o cluster.

---

## Criando o Deploy da Aplicação

1. Clone o repositório do projeto de ecommerce exemplo:
   - [Fake Shop GitHub](https://github.com/luuucasmoreira/fake-shop)
   - Faça um **fork** do repositório.

2. Crie a **imagem Docker** da aplicação para colocá-la no EKS:
   
   ```bash
   docker build -t luuucasmoreira/fake-shop:v1 --push .
   ```

3. Com o arquivo de **deployment** na pasta `k8s` do projeto, execute o seguinte comando:

   ```bash
   kubectl apply -f k8s/deployment.yaml
   ```

4. Verifique o status da aplicação com o comando:

   ```bash
   kubectl get all
   ```

---

## Necessidades no AWS

Como a aplicação precisa de um banco de dados PostgreSQL, será necessário fazer dois deploys.

---

## Deletando o Ambiente para Evitar Custos

1. Para deletar o deployment, execute:

   ```bash
   kubectl delete -f k8s/deployment.yaml
   ```

2. No console da AWS, delete o **Node Group** primeiro.

3. Em seguida, delete o **Cluster** (no nosso caso, `aula-eks`).

> **Observação**: A exclusão pode demorar alguns minutos.

4. No **CloudFormation**, acesse a stack e delete a `aula-eks`.

---

## Variáveis de Ambiente

- **DB_HOST**: Host do banco de dados PostgreSQL.
- **DB_USER**: Nome do usuário do banco de dados PostgreSQL.
- **DB_PASSWORD**: Senha do usuário do banco de dados PostgreSQL.
- **DB_NAME**: Nome do banco de dados PostgreSQL.
- **DB_PORT**: Porta de conexão com o banco de dados PostgreSQL.
