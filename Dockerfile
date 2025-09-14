FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Criar diretórios necessários
RUN mkdir -p /app/data /app/keys

COPY ./python/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar ambos os scripts
COPY ./python/gerar_chamados.py .
COPY ./python/upload_bigquery.py .

# Definir usuário não-root
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser