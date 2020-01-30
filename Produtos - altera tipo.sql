select t.codigo, t.descricao, t.tipo_prd, t.cod_gcn, t.rowid from faprdcad t where t.codigo in
('220697','220659','220660','220661','212568')
/*('219831','219834','219832','219833','219830','219679','222311','219681','222300','222296','222298','219682','222313',
'219678','222301','219683')
'207988','213731','222987','223548'

*/
select codigo, descricao from faprdcad where tipo_prd = 'ENX' order by 2
