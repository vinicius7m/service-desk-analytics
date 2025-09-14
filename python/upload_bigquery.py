import pandas as pd
from google.cloud import bigquery
from google.oauth2 import service_account
import os
import time

# ---------- Configurações ----------
csv_path = "/app/data/chamados.csv"
service_account_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", "/app/keys/credentials.json")

# ---------- Ler CSV ----------
print("📖 Lendo arquivo CSV...")
try:
    df = pd.read_csv(csv_path)
    print(f"✅ CSV lido com {len(df)} registros")
    print(f"📋 Colunas: {df.columns.tolist()}")
    print(f"📊 Primeiras 2 linhas:\n{df.head(2)}")
except Exception as e:
    print(f"❌ Erro ao ler CSV: {e}")
    exit(1)

# ---------- Conectar ao BigQuery ----------
print("🔗 Conectando ao BigQuery...")
try:
    credentials = service_account.Credentials.from_service_account_file(service_account_path)
    client = bigquery.Client(credentials=credentials, project=credentials.project_id)
    print(f"✅ Conectado ao projeto: {credentials.project_id}")
    
    # Verificar se o dataset existe
    dataset_ref = client.dataset('raw')
    try:
        dataset = client.get_dataset(dataset_ref)
        print(f"✅ Dataset 'raw' encontrado")
    except Exception:
        print(f"❌ Dataset 'raw' não encontrado. Criando...")
        dataset = bigquery.Dataset(dataset_ref)
        dataset.location = "US"  # ou sua região
        client.create_dataset(dataset)
        print(f"✅ Dataset 'raw' criado")
        
except Exception as e:
    print(f"❌ Erro de conexão: {e}")
    exit(1)

# ---------- Configurar tabela ----------
table_id = f"{credentials.project_id}.raw.chamados"
print(f"🎯 Tabela de destino: {table_id}")

# ---------- Upload ----------
try:
    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
        autodetect=True
    )
    
    print("⬆️  Iniciando upload...")
    job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
    job.result()  # Aguarda conclusão
    
    print(f"✅ Upload concluído! {len(df)} registros enviados")
    print(f"📊 Tabela agora tem {job.output_rows} linhas")
    
    # Verificar se a tabela realmente existe e tem dados
    print("🔍 Verificando tabela no BigQuery...")
    table = client.get_table(table_id)
    print(f"📋 Schema da tabela: {len(table.schema)} colunas")
    
    # Contar linhas na tabela
    query = f"SELECT COUNT(*) as total FROM `{table_id}`"
    query_job = client.query(query)
    result = query_job.result()
    for row in result:
        print(f"🔢 Total de linhas na tabela: {row.total}")
    
    # Mostrar algumas linhas
    sample_query = f"SELECT * FROM `{table_id}` LIMIT 3"
    sample_job = client.query(sample_query)
    sample_result = sample_job.result()
    
    print("📝 Amostra de dados na tabela:")
    for i, row in enumerate(sample_result):
        print(f"  Linha {i+1}: {dict(row)}")
    
except Exception as e:
    print(f"❌ Erro no upload: {e}")
    # Tentar ver detalhes do erro
    if hasattr(e, 'errors'):
        for error in e.errors:
            print(f"   → {error}")