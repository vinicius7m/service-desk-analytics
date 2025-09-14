FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório de dados antecipadamente
RUN mkdir -p /app/data

COPY ./python/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ./python/gerar_chamados.py .

# Definir usuário não-root para melhor segurança
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser