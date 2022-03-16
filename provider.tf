provider "aws" {
  region = "sa-east-1"
}

terraform {
  backend "s3" {
    # Lembre de trocar o bucket para o seu, não pode ser o mesmo nome
    /* passar os parâmetros no terraform init -backend-config
    # terraform init \
     -backend-config "bucket=bucket-name" \
     -backend-config "region=sa-east-1" \
     -backend-config "key=chave"
     */
  }
}
