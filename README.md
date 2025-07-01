# AdTrends Insight

Projeto de coleta e análise de dados públicos de anúncios no Facebook + Google Trends com Terraform e Cloud Functions.

## Estrutura

- Terraform para infraestrutura (BigQuery, Functions, Storage)
- Google Cloud Functions para ingestão de dados
- BigQuery com tabelas externas (raw layer)
- Dataform (futuramente) para camada silver/gold

## Deploy rápido

```bash
terraform init
terraform apply
