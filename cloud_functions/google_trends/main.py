import os
import datetime
import pandas as pd
from pytrends.request import TrendReq
from google.cloud import storage

# Variáveis de ambiente
SEARCH_TERM = os.environ.get("SEARCH_TERM")
BUCKET_NAME = os.environ.get("BUCKET_NAME")

pytrends = TrendReq(hl="pt-BR", tz=0)
storage_client = storage.Client()

def fetch_trends(term):
    pytrends.build_payload([term], cat=0, timeframe="today 3-m", geo="BR")
    data = pytrends.interest_over_time()

    if data.empty:
        return pd.DataFrame()

    # Resetar o índice e renomear colunas
    df = data.reset_index()[["date", term]]
    df.columns = ["date", "interest"]

    # ✅ Adiciona a coluna search_term ANTES de salvar
    df["search_term"] = term
    return df

def save_to_gcs(df, term):
    today = datetime.datetime.utcnow().strftime("%Y-%m-%d")
    filename = f"google_trends/{today}/{term.lower().replace(' ', '_')}.csv"

    bucket = storage_client.bucket(BUCKET_NAME)
    blob = bucket.blob(filename)
    blob.upload_from_string(
        df.to_csv(index=False),  # ✅ index=False para não salvar a coluna de índice
        content_type="text/csv"
    )
    print(f"Arquivo salvo: {filename}")

def main(request):
    try:
        print(f"Coletando Google Trends para termo: {SEARCH_TERM}")
        df = fetch_trends(SEARCH_TERM)

        if df.empty:
            print("Nenhum dado retornado do Trends.")
            return "Sem dados encontrados.", 200

        save_to_gcs(df, SEARCH_TERM)
        return f"Coleta finalizada para: {SEARCH_TERM}. Linhas: {len(df)}", 200

    except Exception as e:
        print(f"Erro: {str(e)}")
        return f"Erro: {str(e)}", 500
