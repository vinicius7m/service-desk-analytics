

  create or replace view `service-desk-analytics-472019`.`raw_intermediate`.`int_chamados`
  OPTIONS()
  as 

SELECT
    stg.id_chamado,
    stg.data_abertura,
    stg.data_fechamento,
    date(stg.data_abertura) AS dt_abertura,
    date(stg.data_fechamento) AS dt_fechamento,
    stg.categoria,
    stg.canal,
    stg.prioridade,
    stg.status,
    stg.tempo_espera_minutos,
    stg.tempo_resolucao_horas,
    stg.csat_score,
    stg.is_sla_atingido,
    stg.is_first_contact
FROM `service-desk-analytics-472019`.`raw_staging`.`stg_chamados` stg;

