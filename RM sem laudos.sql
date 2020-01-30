select distinct a.cod_pac, e.nome_pac, b.cod_prd, c.descricao, a.data_mov
from immovcad a, immovprd b, faprdcad c, famovcad d, faprtcad e, fapaccad f
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.cod_pac = d.cod_pac
and b.cod_prd = c.codigo
and a.cod_pac = f.cod_pac
and e.cod_prt = f.cod_prt
and a.data_mov between '26/02/2012' and '25/03/2012'
and c.tipo_prd = 'REM'
and b.dt_dig_laudo is null
