select distinct cod_prd, faprdcad.tipo_prd,cod_simpro,cod_bras_tiss, descricao
from fafatprd, faprdcad where fafatprd.cod_prd = faprdcad.codigo
and fatura in (select fatura from fafatcad where data_emiss > "01/02/2010")
and cod_prd in (
select codigo from faprdcad
where tipo_prd in ("DES", "DCN", "ESP", "MEP")
and bloqueado = "N" and cod_bras_tiss = "72150011"
)
