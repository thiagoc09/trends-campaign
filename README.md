# adtrends-campaign

Este projeto cruza dados públicos de anúncios ativos da **Facebook Ads Library** com o interesse orgânico do **Google Trends**, permitindo identificar padrões entre investimento em mídia paga e intenção de busca em termos como "Nike", "Adidas", entre outros.

> 🔍 *A principal pergunta de negócio que o projeto responde é:*  
> **"O aumento nos anúncios de uma marca está alinhado com picos de busca no Google?"**

---

## Objetivos do Projeto

- Criar uma pipeline **100% serverless** e versionada, com foco em:
  - Engenharia de dados.
  - Marketing analytics.
  - Integração entre dados de mídia paga e orgânica.
- Explorar tecnologias modernas de cloud e orquestração de dados como:
  - **Dataform** (modelagem no estilo dbt).
  - **Terraform** (infraestrutura como código).
  - **BigQuery** (armazenamento e análise).
- Gerar uma tabela final `trends_summary` com cruzamentos úteis para tomada de decisão de marketing.

---

## Arquitetura e Stack


         ┌──────────────┐
         │ Facebook Ads│
         │   Library    │
         └─────┬────────┘
               │
               ▼
     [Cloud Function Python]
               │
     ▼ (JSON no Cloud Storage)
               │
     ▼ Ingestão no BigQuery (RAW)
               │
     ▼ Transformações com Dataform
      ┌────────────┬────────────┐
      │  silver    │   silver    │
      │ facebook   │  trends     │
      └────┬───────┴──────┬──────┘
           ▼              ▼
      LEFT JOIN por termo e data
           ▼
    `gold.trends_summary`
           ▼
   Visualização ou Exportação

---

## 🧱 Camadas e Modelagem

- **Raw**: dados brutos vindos das APIs (Facebook Ads e Google Trends).
- **Silver**: limpeza, normalização de nomes e estruturação por termo, data, duração e URL do anúncio.
- **Gold**: cruzamento final com agregações (volume de anúncios, interesse médio, duração média, criativo de destaque).

Tabela final `gold.trends_summary` contém:

| Campo         | Descrição                             |
|---------------|----------------------------------------|
| date          | Data da análise                        |
| search_term   | Termo pesquisado (ex: Nike)            |
| ads_count     | Nº de anúncios ativos no período       |
| avg_duration  | Duração média das campanhas            |
| top_ad_url    | Link do criativo mais recente          |
| interest      | Nível de interesse do Google Trends    |

---

## 🚀 Por que Dataform?

- Permite versionar os modelos SQL com `Git`.
- Define camadas (silver, gold) com dependências explícitas.
- Facilita testes, execução incremental e organização modular.
- Substituto moderno ao dbt dentro do GCP.

## 🌍 Por que Terraform?

- Provisiona toda a estrutura de forma automatizada:
- Tabelas, datasets, funções, secrets, permissões.
- Permite reuso do projeto por outras equipes ou tópicos (ex: substituir "Nike" por "Coca-Cola").
- Evita erros manuais e garante reprodutibilidade.

---

## ⚠️ Desafios encontrados

- A **Facebook Ads Library** tem limitações: não oferece valores de investimento nem quantidade total de impressões.
- Necessário criar lógica para calcular o volume de anúncios por data e termo.
- Integração com Dataform e Git exigiu configuração de token com permissões de escrita.
- Algumas APIs têm limites de data ou requisições por minuto — foi necessário tratar isso.

---

## 📈 Resultados e próximos passos

A tabela final já permite:

- Ver **quais termos** tiveram campanhas em andamento.
- Ver **quando** o interesse orgânico subiu ou caiu.
- Cruzar criativos com intenção de busca.

Próximos passos possíveis:

- Adicionar novos termos no Terraform (`terraform.tfvars`).
- Criar dashboard em Looker Studio ou Streamlit.
- Incorporar análise de sentimento dos anúncios via NLP.
- Automatizar coleta diária.

---

## 🧠 Aprendizados

Este projeto foi uma excelente forma de unir:
- Engenharia de dados (ETL, camadas, modelagem).
- Estratégia de marketing digital (ads + comportamento).
- Boas práticas de infraestrutura com Terraform.
- Stack moderna 100% GCP-friendly (Dataform + BigQuery + Cloud Functions).

---

## 📂 Organização dos arquivos

| Pasta/Arquivo               | Descrição                                    |
|----------------------------|-----------------------------------------------|
| `cloud_functions/`         | Script Python de ingestão de dados da API     |
| `definitions/`             | Modelos Dataform SQL (`silver`, `gold`)       |
| `includes/`                | Parâmetros e helpers                          |
| `terraform/`               | Scripts de infraestrutura                     |
| `terraform.tfvars`         | Termos buscados, parâmetros do projeto        |
| `README.md`                | Este arquivo                                  |

---

## 🤝 Autor

**Thiago Araújo**  
Engenheiro de Dados | Marketing Analytics | GCP & Python  
[linkedin.com/in/thiagoc09](https://linkedin.com/in/thiagoc09)