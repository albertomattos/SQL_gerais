Select round(sum(valor_tot),2) from esmovite where tipo_documento = 'ACE' and documento in (
--Select * from esmovite where tipo_documento = 'ACE' and documento in (
select t.documento from esmovcad t where t.tipo_documento = 'ACE'
and t.data_mov >= '01/01/2017'
and t.data_mov <= '31/01/2017'
and t.cod_mot = '006')
and cod_prd in (select codigo from faprdcad where tipo_prd = 'MED')
