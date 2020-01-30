select  c.remessa, a.num_guia, d.nome_pac, c.data_emiss, c.data_venci, e.fantasia, b.valor_tot, b.valor_guia, b.valor_pago
from fapaccad a, fafatcad b, faremcad c, faprtcad d, faconcad e
where a.cod_pac = b.cod_pac and b.remessa = c.remessa and a.cod_prt = d.cod_prt and a.cod_con = e.cod_con
--and fafatcad.cod_con = '007'
and b.data_emiss between '01/11/2014' and '30/11/2014'
--and fafatcad.remessa="033219"
