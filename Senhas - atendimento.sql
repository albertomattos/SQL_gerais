select to_char(t.dh_retirada,'HH24:Mi') senha, a.data_ent, to_char(a.hora_ent,'HH24:Mi') atend, t.nu_senha, t.fk_cod_pac
from fapaccad a, tb_sel_senha_fila t where a.cod_pac = t.fk_cod_pac
/*and a.tipo_pac = 'U' and a.cod_ala <> 'LABO'*/ and a.data_ent >= '31/08/2017'
order by a.data_ent desc
select * from fapaccad where tipo_pac = 'E' and cod_ala <> 'LABO' and data_ent >= '01/06/2012'

select a.*, a.rowid from tb_chamada_painel a where a.no_estacao_painel = 'PAINELPSADULTO' order by a.dh_chamada desc

select distinct no_estacao_painel from tb_chamada_painel
