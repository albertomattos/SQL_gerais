select documento, data_mov, desc_ger, desc_ger_val from esmovcad where tipo_documento = 'PED'
and cod_prd in (
select codigo from faprdcad where tipo_prd = 'OPM')
and data_mov between '01/09/2012' and '30/09/2012'
