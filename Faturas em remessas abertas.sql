select c.fantasia, a.fatura, a.remessa, b.data_emiss, b.data_venci, b.data_entre, a.valor_tot
from fafatcad a, faremcad b, faconcad c, fapaccad d
where a.remessa = b.remessa
and a.cod_con = c.cod_con
and a.cod_pac = d.cod_pac
and b.remessa_fechada = 'N'
and b.data_emiss between '01/01/2014' and '30/09/2014'
order by b.remessa
