# terraform-basico-modulo

Esse módulo:

- Cria instância
- Security Group
- Elastic IP

Dependências:

Para usar o make você precisa:

- terraform >= 0.12
- make

Usando:

Crie um arquivo terrafile.tf na raiz do seu projeto, você pode seguir esse exemplo:

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
}

terraform {
  backend "s3" {
    # Lembre de trocar o bucket para o seu
    bucket = "iaasweek-tfstates-terraform"
    key    = "terraform-test.tfstate"
    region = "us-east-1"
  }
}

module "produto" {
  source                  = "git@github.com:gomex/terraform-module?ref=v0.1"
  name                    = "produto"
}

output "ip_address" {
  value = module.produto.ip_address
}

Crie seu arquivo .env a partir do exemplo .env.example

Inputs

Nome	Descrição	Tipo	Default	Requerido
name	Nome do projeto	string	n/a	sim
hash_commit	Hash commit da imagem AMI	string	n/a	não

ToDo

 Colocar suporte a autoscaling