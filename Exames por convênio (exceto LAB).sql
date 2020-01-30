select faconcad.fantasia, count (faprdcad.descricao) quantidade
    from famovprd, famovcad, faprdcad, fapaccad, fatipcad, faconcad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and faprdcad.tipo_prd = fatipcad.tipo_prd
        and fapaccad.cod_con = faconcad.cod_con
        and famovcad.data_mov between '01/01/2013' and '30/06/2013'
        and fatipcad.pre_class = 'EXA'
        and faprdcad.tipo_prd <> 'LAB'
        and faprdcad.cod_bancada is null
    group by faconcad.fantasia
    order by faconcad.fantasia
