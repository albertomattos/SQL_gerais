select t.COD_PAC, t.cod_prt, u.nome_pac, t.data_alta, t.tipo_pac from fapaccad t, faprtcad u where t.cod_prt = u.cod_prt
and t.data_alta between '01/01/2016' and '31/08/2017'
and t.tipo_pac = 'I' and t.cod_ala <> 'HMDA' and u.nome_pac not like 'RN%'
and t.cod_pac not in (
SELECT b.cod_pac FROM item_protocolo a, fadocumentos b, protocolo c, fapaccad f WHERE b.sequencial = a.sequencial AND c.cod_protocolo = a.cod_protocolo AND f.cod_pac = b.cod_pac AND c.COD_SETOR_DESTINO = '0197')
and t.cod_mae is null order by 4
