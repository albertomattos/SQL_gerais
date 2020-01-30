select d.nome_pro, count(d.nome_pro) from tb_justific_presc a, TB_PADRAO_JUSTIFIC b, prescricao_pac c, faprocad d, faprdcad e
where a.fk_prepac = c.sequencial and a.fk_padjus = b.pk_padjus and c.cod_pro = d.cod_pro and c.codigo = e.codigo
AND c.DATA_PRESCRICAO >= '01/10/2017'
AND c.DATA_PRESCRICAO <= '31/10/2017'
and e.tipo_prd in ('MED','MQU') and c.item_valido = 'I'
group by d.nome_pro
order by 2 desc
