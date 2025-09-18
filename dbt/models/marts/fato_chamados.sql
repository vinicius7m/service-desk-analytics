{{ config(materialized='table', schema='marts') }}

with base as (
    select
        int.id_chamado,
        t_ab.id_tempo as id_tempo_abertura,
        t_fc.id_tempo as id_tempo_fechamento,
        dcat.id_categoria,
        dcan.id_canal,
        dpri.id_prioridade,
        dsta.id_status,
        int.tempo_espera_minutos,
        int.tempo_resolucao_horas,
        int.csat_score as pontuacao_csat,
        int.is_sla_atingido as sla_atingido,
        int.is_first_contact as resolvido_primeiro_contato
    from {{ ref('int_chamados') }} int
    left join {{ ref('dim_tempo') }} t_ab
        on int.dt_abertura = t_ab.data
    left join {{ ref('dim_tempo') }} t_fc
        on int.dt_fechamento = t_fc.data
    left join {{ ref('dim_categoria') }} dcat
        on int.categoria = dcat.categoria
    left join {{ ref('dim_canal') }} dcan
        on int.canal = dcan.canal
    left join {{ ref('dim_prioridade') }} dpri
        on int.prioridade = dpri.prioridade
    left join {{ ref('dim_status') }} dsta
        on int.status = dsta.status
)

select * from base
