select distinct
(select sum(count(faprdcad.descricao))
    from famovprd, famovcad, faprdcad, fapaccad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and famovcad.data_mov between '01/01/2015' and '31/05/2015'
        and faprdcad.tipo_prd = 'EXA' and faprdcad.cod_cbhpm between '40300000' and '40700000'
        and fapaccad.tipo_pac = 'U'
    group by faprdcad.descricao)
+
(select sum(count(faprdcad.descricao))
    from famovprd, famovcad, faprdcad, fapaccad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and famovcad.data_mov between '01/01/2015' and '31/05/2015'
        and faprdcad.tipo_prd = 'LAB'
        and fapaccad.tipo_pac = 'U'
    group by faprdcad.descricao)
+
(select sum(count(faprdcad.descricao))
    from famovprd, famovcad, faprdcad, fapaccad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda
        and fapaccad.cod_pac = famovcad.cod_pac
        and famovcad.data_mov between '01/01/2015' and '31/05/2015'
        and faprdcad.tipo_prd = 'MEN' and faprdcad.cod_cbhpm between '40300000' and '40700000'
        and fapaccad.tipo_pac = 'U'
    group by faprdcad.descricao)
from famovprd, famovcad, faprdcad, fapaccad
    where faprdcad.codigo = famovprd.codigo
        and famovprd.comanda = famovcad.comanda and famovprd.tipo_comanda = famovcad.tipo_comanda
        and fapaccad.cod_pac = famovcad.cod_pac
