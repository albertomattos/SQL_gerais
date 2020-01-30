select faalacad.descricao clinica, faprdcad.descricao exame, count (faprdcad.descricao) quantidade, faprdcad.cod_amb
    from famovprd, famovcad, faprdcad, fapaccad, faalacad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and faalacad.cod_ala = fapaccad.cod_ala
        and famovcad.data_mov between "01/05/2006" and "05/05/2006"
        and faprdcad.tipo_prd = "EXA"
    group by faalacad.descricao, faprdcad.descricao, faprdcad.cod_amb
    order by faalacad.descricao, faprdcad.descricao
