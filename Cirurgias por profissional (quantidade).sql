select faprocad.nome_pro, faprdcad.descricao, count(faprdcad.descricao), faconcad.fantasia, faplacad.nome_plano
    from faprccad, faprocad, fapaccad, faconcad, faplacad, faprdcad
    where faprccad.cod_pac = fapaccad.cod_pac
    and faprocad.cod_pro = faprccad.cod_pro
    and faconcad.cod_con = fapaccad.cod_con
    and faplacad.cod_pla = fapaccad.cod_pla
    and faplacad.cod_con = fapaccad.cod_con
    and faprccad.cod_prd = faprdcad.codigo
    and faprccad.cod_pro in ('007250','000197')
    and data_real between '01/07/2013' and '31/07/2013'
    and faprdcad.tipo_prd in (select tipo_prd from fatipcad where pre_class = 'HON')
    and faprdcad.tipo_prd <> 'CON'
    and faprdcad.descricao not like 'CONSULTA%'
    and faprdcad.descricao not like 'VISITA%'
    and faprdcad.descricao not like 'PLANTAO%'
    and faprdcad.descricao not like 'UTI PEDIATRICA%'
    and faprdcad.descricao not like 'HEMODIALISE%'
    group by faprdcad.descricao, faconcad.fantasia, faplacad.nome_plano, faprocad.nome_pro
    order by faprdcad.descricao
