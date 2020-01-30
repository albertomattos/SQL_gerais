SELECT case when b.ds_justificativa is null then 'SEM JUSTIFICATIVA' else b.ds_justificativa end,
COUNT(NVL(b.ds_justificativa, 0)) COUNT FROM tb_justific_presc a, TB_PADRAO_JUSTIFIC b, prescricao_pac c, faprdcad e
where a.fk_prepac(+) = c.sequencial and a.fk_padjus = b.pk_padjus(+) and c.codigo = e.codigo
AND c.DATA_PRESCRICAO >= '01/12/2017'
AND c.DATA_PRESCRICAO <= '31/12/2017'
and e.tipo_prd in ('MED','MQU') and c.item_valido = 'I'
group by b.ds_justificativa
order by 2 desc
