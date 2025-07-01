# Projeto AdTrends Insight
Este projeto tem como objetivo investigar o impacto de campanhas de mídia paga no aumento do interesse orgânico do público, usando dados da Facebook Ads Library API e do Google Trends. A análise foca em entender se determinados anúncios promovem picos de busca pelos termos anunciados, e se isso varia de acordo com o tema ou narrativa da campanha.

## Motivação
A ideia nasceu da pergunta: "Será que uma campanha publicitária aumenta o interesse real das pessoas pela marca?". Para responder isso, o projeto propõe cruzar dados de campanhas públicas da Meta com tendências de busca do Google, criando uma métrica clara de impacto.

Meu foco inicial foi na marca Nike, mas a estrutura foi pensada para ser reutilizável e escalável para qualquer marca ou setor.

## Stack Utilizada
Google Cloud Platform (GCP)

Cloud Functions (Python)

Cloud Storage

BigQuery

Terraform (Infraestrutura como código)

Dataform (Modelagem de dados e criação da camada Gold)

Python (extração de dados via APIs públicas)

## O Que Foi Construído
Pipelines de Coleta
Cloud Function 1: coleta anúncios da Facebook Ads Library, filtrando por termos relacionados à marca.

Cloud Function 2: coleta dados do Google Trends com os mesmos termos.

Os dados são armazenados no Cloud Storage como JSONs e ingeridos no BigQuery via tabelas externas.

Camadas de Modelagem no Dataform
Bronze: dados brutos (JSONs).

Silver: limpeza e padronização.

Gold: criação de métricas comparativas, como:

Média de interesse orgânico antes e depois do início de uma campanha.

Cálculo do impact rate.

Indicador binário de impacto positivo.

## Insight Estratégico
Durante o projeto, descobri que as campanhas com maior impacto orgânico da palavra "Nike" não estavam ligadas diretamente à própria marca, mas sim à camisa vermelha da Seleção Brasileira, um tema que gerou repercussão política e social.

Isso revelou que o aumento nas buscas não foi consequência de campanhas institucionais tradicionais, mas de narrativas externas que geraram atenção pública.

## Por que foi necessário usar APIs públicas
A API oficial do Facebook Ads requer acesso restrito, com permissões específicas para contas de anunciantes. Sem essa permissão, optei por explorar a Facebook Ads Library, que oferece dados públicos de anúncios ativos, embora com algumas limitações de granularidade e autenticidade das campanhas.

Apesar disso, consegui construir um pipeline funcional e confiável, utilizando somente dados públicos.

## Desafios Superados
Configuração da conta gratuita no GCP, com controle de billing e permissões.

Setup do Terraform: criação e gerenciamento das funções em Cloud Functions com infraestrutura como código.

Integração com o Dataform: estruturação de schemas, configuração de repositórios Git, segredos e permissões.

Criação de funções Python desacopladas e reutilizáveis, preparadas para escalabilidade.

Ajuste de autenticação e políticas do Service Account para acessar segredos e recursos.

## Aprendizados Técnicos
Estruturar um projeto de ponta a ponta no GCP.

Aprofundei conhecimentos em Terraform, Dataform e deploy automatizado com Git.

Refinei minha habilidade de resolver problemas de permissão, autenticação e dependência entre recursos.

Desenvolvi raciocínio analítico para tirar insights de comportamento a partir de dados públicos.

##  Próximos Passos
Criar uma visualização interativa dos dados com Looker Studio ou Streamlit.

Aprimorar o modelo para detectar campanhas que geram buzz mesmo fora da marca principal.

Estender a análise para outros termos de busca e segmentos, como saúde, alimentação, imóveis ou política.

Integrar sinais sociais (Twitter, notícias) para enriquecer a análise de contexto.

## Conclusão
Mesmo com as limitações naturais de acesso a dados proprietários, consegui construir uma solução técnica robusta, escalável e com potencial analítico real. O projeto mostra que engenharia de dados e análise de marketing podem caminhar juntas para gerar valor de negócio e inteligência de mercado.

Esse projeto vai além de um exercício técnico: ele demonstra a minha capacidade de investigar, construir e transformar dados em respostas concretas, mesmo com desafios e dados públicos 