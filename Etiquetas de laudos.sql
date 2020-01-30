select faprtcad.nome_pac, immovcad.cod_pac, faconcad.fantasia, faplacad.nome_plano,
faprdcad.descricao, faprtcad.nascimento, fapaccad.tipo_pac
from immovcad, immovprd, faprdcad, fapaccad, faprtcad, faconcad, faplacad
where immovcad.comanda = immovprd.comanda and immovcad.tipo_comanda = immovprd.tipo_comanda
and immovprd.cod_prd = faprdcad.codigo
and immovcad.cod_pac = fapaccad.cod_pac
and fapaccad.cod_prt = faprtcad.cod_prt
and fapaccad.cod_con = faconcad.cod_con
and faconcad.cod_con = faplacad.cod_con
and fapaccad.cod_pla = faplacad.cod_pla
and immovcad.documento = '0049784'
and immovcad.cod_pac = "H850351"
