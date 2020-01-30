select a.codigo, a.descricao, a.mnemonico, b.descricao bancada from faprdcad a, lbbancad b
where a.cod_bancada = b.cod_bancada(+)
and a.tipo_prd = 'LAB' and codigo not in (
select cod_prd from lbexacom) order by 4,2
