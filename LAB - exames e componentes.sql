select a.codigo, a.descricao, a.mnemonico, b.descricao bancada, c.cod_com, d.descricao, c.tipo_edicao
from faprdcad a, lbbancad b, lbexacom c, lbcomcad d
where a.cod_bancada = b.cod_bancada(+) --select * from lbexacom where cod_prd = '051367'
and a.codigo = c.cod_prd and c.cod_com = d.cod_com
and a.tipo_prd = 'LAB'-- and c.cod_com = 'OBS'
and a.codigo = '222325'
order by 4,2,6
--select * from lbexacom where cod_prd = '051367'
--select * from lbexacom where tipo_edicao = 'F'
