select distinct d.tipo_pac, b.fantasia, a.remessa, a.data_emiss, a.data_venci, a.valor_guia, a.valor_pago
from faremcad a, faconcad b, fafatcad c, fapaccad d where a.cod_con = b.cod_con
and a.remessa = c.remessa and c.cod_pac = d.cod_pac
and a.remessa not in (
select distinct faremcad.remessa from loteguiatiss, guiatiss, faremcad, xmltiss, transtiss, tptrantiss
where loteguiatiss.id_loteguiatiss = guiatiss.id_loteguiatiss
and faremcad.remessa = loteguiatiss.remessa
and guiatiss.id_transtiss = transtiss.id_transtiss
and transtiss.id_tptrantiss = tptrantiss.id_tptrantiss
and guiatiss.id_xmltiss = xmltiss.id_xmltiss
and transtiss.sit_transtiss in ('0','1','2','3','4','5')
and tptrantiss.id_er_tptrantiss = 'E'
) and a.data_emiss between '01/01/2013' and '30/06/2014' and a.valor_guia <> a.valor_pago
order by 1,2,4
