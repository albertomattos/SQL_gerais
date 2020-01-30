select faremcad.remessa, faremcad.protocolo, faremcad.data_emiss, famovprd.codigo, faprdcad.descricao, famovprd.quant,
		famovdestino.valor_tot, fapaccad.cod_pac, faprtcad.nome_pac, fapaccad.matricula
from famovprd, famovdestino, fafatcad, faremcad, fapaccad, faprtcad, faprdcad
where famovprd.sequencial = famovdestino.sequencial
and famovdestino.cod_fatura = fafatcad.fatura
and fafatcad.remessa = faremcad.remessa
and fafatcad.cod_pac = fapaccad.cod_pac
and fapaccad.cod_prt = faprtcad.cod_prt
and famovprd.codigo = faprdcad.codigo
and famovprd.codigo in ('044452','044484')
and fafatcad.cod_con in ('001','004','058')
and faremcad.data_emiss >= "01/02/2007"
order by faremcad.data_emiss
