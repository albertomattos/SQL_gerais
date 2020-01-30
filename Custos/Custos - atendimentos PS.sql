select count(*) from wpd.fapaccad@prod where tipo_pac = 'U' and data_ent between '01/05/2013' and '31/05/2013'
-- Atendimentos pediátricos
--and cod_ala = 'PSPE'
-- Atendimentos não pediátricos
and cod_ala <> 'PSPE'

--SQL para NCI:
select :P_MES, :P_ITEM, c.codigo
from wpd.fapaccad@prod a, wpd.fapaccom@prod b, usr_nci.vec_ccus c
where a.cod_pac = b.cod_pac and b.cod_set = c.cod_cliente
and a.tipo_pac = 'U' and a.data_ent between :P_DATA_INICIAL and :P_DATA_FINAL
and a.cod_ala <> 'PSPE'
group by c.codigo

--Correçao de setores PS Adulto:
update fapaccom set cod_set = '0118' where cod_pac in (
select cod_pac from wpd.fapaccad@prod where tipo_pac = 'U' and data_ent between '01/08/2013' and '31/08/2013'
and cod_ala <>'PSPE') and cod_set <> '0118'

--Correçao de setores PS Pediátrico:
update fapaccom set cod_set = '0026' where cod_pac in (
select cod_pac from wpd.fapaccad@prod where tipo_pac = 'U' and data_ent between '01/08/2013' and '31/08/2013'
and cod_ala ='PSPE') and cod_set <> '0026'
