select faprdcad.descricao, count(faprdcad.descricao)
    from faprccad, faprocad, fapaccad, faconcad, faplacad, faprdcad
    where faprccad.cod_pac = fapaccad.cod_pac
    and faprocad.cod_pro = faprccad.cod_pro
    and faconcad.cod_con = fapaccad.cod_con
    and faplacad.cod_pla = fapaccad.cod_pla
    and faplacad.cod_con = fapaccad.cod_con
    and faprccad.cod_prd = faprdcad.codigo
    and data_real > "01/04/2006"
    group by faprdcad.descricao
    order by faprdcad.descricao
