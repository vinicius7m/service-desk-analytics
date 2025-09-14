import random
import numpy as np
import pandas as pd
from faker import Faker
from datetime import timedelta
import os

# ---------- SEEDS (reprodutibilidade) ----------
random.seed(42)
np.random.seed(42)
fake = Faker("pt_BR")
Faker.seed(42)

# ---------- Configurações ----------
n_registros = 100

canais = ["WhatsApp", "Telefone", "Chat", "E-mail"]
canais_probs = [0.4, 0.3, 0.2, 0.1]  # Soma = 1.0

categorias = ["Financeiro", "Técnico", "Cadastro", "Outros"]
categorias_probs = [0.25, 0.35, 0.25, 0.15]  # Soma = 1.0

# CORREÇÃO DEFINITIVA - listas separadas com soma = 1.0
prioridades_opcoes = ["Baixa", "Média", "Alta", "Crítica", None]
prioridades_probs = [0.285, 0.285, 0.19, 0.19, 0.05]  # Soma = 1.0

status_list = ["Aberto", "Em andamento", "Fechado"]
status_probs = [0.2, 0.3, 0.5]  # Soma = 1.0

csat_opcoes = [1, 2, 3, 4, 5, None]
csat_probs = [0.15, 0.2, 0.3, 0.25, 0.05, 0.05]  # Soma = 1.0

# ---------- Funções auxiliares ----------
def gerar_datas():
    meses_pesos = [1.5 if m in [1, 7] else 1 for m in range(1, 13)]
    mes = np.random.choice(range(1, 13), p=np.array(meses_pesos)/sum(meses_pesos))
    ano = 2024
    dia = np.random.randint(1,28)
    data_abertura = fake.date_time_between_dates(
        datetime_start=pd.Timestamp(ano, mes, dia),
        datetime_end=pd.Timestamp(ano, mes, dia)+timedelta(days=1)
    )
    horas_resolucao = max(1, int(np.random.normal(24, 12)))
    data_fechamento = data_abertura + timedelta(hours=horas_resolucao)
    return data_abertura, data_fechamento, horas_resolucao

# ---------- Geração ----------
dados = []
for i in range(n_registros):
    data_abertura, data_fechamento, horas_resolucao = gerar_datas()

    canal = np.random.choice(canais, p=canais_probs)
    categoria = np.random.choice(categorias, p=categorias_probs)
    
    # USAR AS NOVAS VARIÁVEIS CORRETAS:
    prioridade = np.random.choice(prioridades_opcoes, p=prioridades_probs)
    status = np.random.choice(status_list, p=status_probs)

    tempo_espera = round(np.random.exponential(scale=5), 2)
    csat = np.random.choice(csat_opcoes, p=csat_probs)
    sla_atingido = np.random.choice([True, False], p=[0.8, 0.2])
    first_contact = np.random.choice([True, False], p=[0.6, 0.4])

    dados.append([
        i+1, data_abertura, data_fechamento, categoria, canal, prioridade,
        status, tempo_espera, horas_resolucao, csat, sla_atingido, first_contact
    ])

# ---------- DataFrame ----------
df = pd.DataFrame(dados, columns=[
    "id_chamado", "data_abertura", "data_fechamento", "categoria", "canal",
    "prioridade", "status", "tempo_espera", "tempo_resolucao",
    "csat", "sla_atingido", "first_contact_resolution"
])

# ---------- Salvar CSV ----------
output_dir = "/app/data"
os.makedirs(output_dir, exist_ok=True)

output_path = os.path.join(output_dir, "chamados.csv")
df.to_csv(output_path, index=False, encoding="utf-8")

print(f"✅ Arquivo '{output_path}' gerado com {len(df)} linhas.")
print(df.head(3))