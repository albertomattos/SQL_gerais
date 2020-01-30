--Pacientes externos
select sum(count(faprdcad.descricao)) quantidade
    from famovprd, famovcad, faprdcad, fapaccad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and famovcad.data_mov between '01/01/2015' and '31/01/2015'
        and faprdcad.tipo_prd in ('EXA','MEN','LAB')
        and fapaccad.cod_ala = 'LABO'
        and fapaccad.tipo_pac = 'E'
    group by faprdcad.cod_amb
--    order by faprdcad.descricao

--Pacientes internados
select sum(count(faprdcad.descricao)) quantidade
    from famovprd, famovcad, faprdcad, fapaccad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and famovcad.data_mov between '01/01/2015' and '31/01/2015'
        and faprdcad.tipo_prd in ('EXA','MEN','LAB')
        --and fapaccad.cod_ala = 'LABO'
        and fapaccad.tipo_pac = 'I'
    group by faprdcad.cod_amb
