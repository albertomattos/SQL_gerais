--Laboratório - pacientes da urgência:
select c.cod_pac, d.dh_retirada, c.data_ent coleta1, c.hora_ent coleta2,/* b.data_mov as coleta1, b.hora_mov as coleta2,*/ a.dt_dig_laudo, a.hr_dig_laudo, a.dt_lib_res, a.hr_lib_res
from lbmovprd a, lbmovcad b, fapaccad c, tb_sel_senha_fila d where a.tipo_comanda = b.tipo_comanda and a.comanda = b.comanda
and b.cod_pac = c.cod_pac and c.cod_pac = d.fk_cod_pac
and c.tipo_pac = 'U'
and b.data_mov = '05/10/2012'

--Laboratório - pacientes internos:
select c.cod_pac, b.data_mov coleta1, b.hora_mov coleta2, a.dt_dig_laudo, a.hr_dig_laudo, a.dt_lib_res, a.hr_lib_res
from lbmovprd a, lbmovcad b, fapaccad c where a.tipo_comanda = b.tipo_comanda and a.comanda = b.comanda
and b.cod_pac = c.cod_pac
and c.tipo_pac = 'I'
and b.data_mov = '05/10/2012'

--Laboratório - pacientes externos:
select c.cod_pac, d.dh_retirada, c.data_ent chamada1, c.hora_ent chamada2, e.dh_chamada coleta, a.dt_dig_laudo, a.hr_dig_laudo,
a.dt_lib_res, a.hr_lib_res
from lbmovprd a, lbmovcad b, fapaccad c, tb_sel_senha_fila d, tb_chamada_painel e
where a.tipo_comanda = b.tipo_comanda and a.comanda = b.comanda
and b.cod_pac = c.cod_pac and c.cod_pac = d.fk_cod_pac
and c.cod_ala = 'LABO'
and c.data_ent = '05/10/2012'

--CDI - externo e urgência (tratar pelo tipo_pac_:
select c.cod_pac, d.dh_retirada, c.data_ent chamada1, c.hora_ent chamada2--, e.dh_chamada chamada_exame
from immovcad a, fapaccad c, tb_sel_senha_fila d--, select * from tb_chamada_painel e
where a.cod_pac = c.cod_pac and c.cod_pac = d.fk_cod_pac
--and c.cod_ala = 'LABO'
and c.data_ent = '05/10/2012'
and a.tipo_comanda = 'CDI'
and c.tipo_pac = 'E' --(ou 'U' para urgência)

--Urgência
select c.cod_pac, d.dh_retirada, c.data_ent chamada1_recepcao, c.hora_ent chamada1_recepcao--, e.dh_chamada chamada_2
from fapaccad c, tb_sel_senha_fila d--, select * from tb_chamada_painel e
where c.cod_pac = d.fk_cod_pac
and c.data_ent = '05/10/2012'
and c.tipo_pac = 'U'
