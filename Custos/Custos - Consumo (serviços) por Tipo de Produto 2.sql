select a.set_est, f.descricao ccusto, c.tipo_prd , d.descricao tipo_produto, c.descricao item_servico, e.rsocial,
a.data_mov, sum(b.valor_tot) valor
from esmovcad a, esmovite b, faprdcad c, fatipcad d, esforcad e, fasetcad f
where a.documento = b.documento and a.tipo_documento = b.tipo_documento
and b.cod_prd = c.codigo and c.tipo_prd = d.tipo_prd and a.cod_for = e.cod_for
and a.set_est = f.cod_set
and a.tipo_documento = 'PED' and a.data_mov between '01/01/2013' and '31/01/2013'
and d.natureza = 'SERVICOS'-- and a.documento in (select cod_aux from esmovcad)
group by a.set_est, f.descricao, c.tipo_prd, d.descricao, c.descricao, e.rsocial, a.data_mov
order by f.descricao, c.tipo_prd, c.descricao

--select * from esmovcad where tipo_documento = 'PED' and documento = '0013415'