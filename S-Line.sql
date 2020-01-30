select t.tipo_comanda, t.documento, t.cod_pac, t.rowid from lbmovcad t where t.cod_pac in (
select cod_pac from fapaccad where data_ent = '23/07/2012' and cod_ala = 'LABO')
