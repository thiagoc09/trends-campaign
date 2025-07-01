import os
import requests
import datetime
import json
from google.cloud import storage

# Variáveis de ambiente
ACCESS_TOKEN = os.environ.get("FB_ADS_TOKEN")  # seu token da Meta
SEARCH_TERM = os.environ.get("SEARCH_TERM")     # termo de busca, ex: "Natura"
BUCKET_NAME = os.environ.get("BUCKET_NAME")     # nome do bucket no GCS

# Cliente do GCS
storage_client = storage.Client()

def fetch_facebook_ads(term):
    url = "https://graph.facebook.com/v18.0/ads_archive"
    params = {
        "access_token": ACCESS_TOKEN,
        #"ad_type": "POLITICAL_AND_ISSUE_ADS",  # necessário para acessar anúncios
        "search_terms": term,
        "ad_reached_countries": ["BR"],
        "limit": 100
    }

    response = requests.get(url, params=params)
    response.raise_for_status()
    return response.json()

def save_to_gcs(data, term):
    today = datetime.datetime.utcnow().strftime("%Y-%m-%d")
    filename = f"facebook_ads/{today}/{term.lower().replace(' ', '_')}.json"

    # Corrigir: garantir que data["data"] está presente e válido
    ads_list = data.get("data", [])
    if not ads_list:
        print("Nenhum anúncio retornado.")
        return

    # Converte cada objeto em uma linha JSON (NDJSON)
    json_lines = "\n".join([json.dumps(ad) for ad in ads_list])

    bucket = storage_client.bucket(BUCKET_NAME)
    blob = bucket.blob(filename)
    blob.upload_from_string(
        data=json_lines,
        content_type="application/json"
    )

    print(f"Arquivo salvo corretamente como NDJSON: {filename}")

def fetchFacebookAds(request):
    try:
        print(f"Iniciando coleta para termo: {SEARCH_TERM}")
        ads_data = fetch_facebook_ads(SEARCH_TERM)
        save_to_gcs(ads_data, SEARCH_TERM)
        return f"Coleta finalizada para: {SEARCH_TERM}. Total: {len(ads_data.get('data', []))} anúncios.", 200
    except Exception as e:
        print(f"Erro: {str(e)}")
        return f"Erro: {str(e)}", 500
