import pandas as pd
from google.cloud import bigquery
from google.oauth2 import service_account
import os

# ---------- Configurações ----------
csv_path = "/app/data/chamados.csv"
service_account_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", "/app/keys/credentials.json")

# ---------- Ler CSV ----------
df = pd.read_csv(csv_path)

# ---------- Conectar ao BigQuery ----------
credentials = service_account.Credentials.from_service_account_file(service_account_path)
client = bigquery.Client(credentials=credentials, project=credentials.project_id)

# Dataset raw e tabela chamados
table_id = f"{credentials.project_id}.raw.chamados"

# ---------- Upload ----------
job = client.load_table_from_dataframe(df, table_id)
job.result()

print(f"✅ Tabela {table_id} atualizada com {len(df)} registros.")
