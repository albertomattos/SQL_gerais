select faprdcad.descricao exame, count (faprdcad.descricao) quantidade
    from famovprd, famovcad, faprdcad, fapaccad, fatipcad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and faprdcad.tipo_prd = fatipcad.tipo_prd
        and famovcad.data_mov between '01/01/2015' and '31/01/2015'
        and fatipcad.pre_class = 'EXA'
        --and fapaccad.tipo_pac = 'U'
    group by faprdcad.descricao, faprdcad.cod_amb
    order by faprdcad.descricao
