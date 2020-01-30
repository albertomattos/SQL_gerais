select faprdcad.descricao exame, count (faprdcad.descricao) quantidade
    from famovprd, famovcad, faprdcad, fapaccad, fatipcad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and faprdcad.tipo_prd = fatipcad.tipo_prd
        and famovcad.data_mov between '01/01/2012' and '30/06/2012'
        and fatipcad.pre_class = 'EXA'
    group by faprdcad.descricao, faprdcad.cod_amb
    order by faprdcad.descricao
