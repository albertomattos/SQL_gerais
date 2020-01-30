select b.nome_pac, '', '12/11/2015', b.nascimento, '', '', b.fone_res, '', '', b.celular, '', '', '', '', 'AM', 'MANAUS', '2018055',
'HOSPITAL SANTA JULIA', A.TIPO_PAC, '', a.nome_rsp, '', '', a.fone_rsp, '', '', ''
from fapaccad a, faprtcad b
where a.cod_prt = b.cod_prt
and a.cod_con in ('069','153')
and a.data_ent between '01/05/2015' and '01/05/2015'
and a.tipo_pac = 'I'
and a.cod_ala = 'HMDA'
