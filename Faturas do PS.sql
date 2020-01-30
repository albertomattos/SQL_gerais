select distinct a.fatura from fafatcad a, famovcad b, famovprd c, faprdcad d, fapaccad e
where b.comanda = c.comanda
and b.tipo_comanda = c.tipo_comanda
and b.cod_pac = a.cod_pac
and c.codigo = d.codigo
and a.cod_pac = e.cod_pac
and a.data_emiss = "10/10/2008"
and e.tipo_pac = "U"
