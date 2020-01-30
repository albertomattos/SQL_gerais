select famovcad.tipo_pac, famovcad.cod_pac, fafatcad.remessa, famovcad.fat_con, famovcad.comanda,
faprtcad.nome_pac, famovcad.data_mov, faconcad.fantasia,
faprdcad.descricao, famovprd.tipo_pgto, famovprd.valor_tot
from famovcad, fapaccad, faprtcad, famovprd, faconcad, faprdcad, fafatcad
where famovcad.comanda = famovprd.comanda and famovcad.cod_pac = fapaccad.cod_pac
and fafatcad.cod_pac = fapaccad.cod_pac
and fapaccad.cod_prt = faprtcad.cod_prt
and fapaccad.cod_con = faconcad.cod_con
and famovprd.codigo = faprdcad.codigo
and famovcad.fat_con <> ""
and fafatcad.remessa <> ""
and famovcad.tipo_pac = "I"
and famovcad.data_mov between "01/10/2005" and "31/03/2006"
and famovprd.cod_pro = "001420" and famovprd.tipo_pgto <> "R"

