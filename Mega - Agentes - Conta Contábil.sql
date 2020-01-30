/*select t.agn_st_fantasia, t.agn_st_nome, t.agn_st_cgc, u.agn_st_codigoalt, t.rowid
from mgglo.glo_agentes t, mgglo.glo_agentes_id u
where t.agn_in_codigo = u.agn_in_codigo and u.agn_tau_st_codigo = 'F'
order by 3
*/

select a.*, a.rowid from mgglo.glo_agentes_id a where a.agn_st_codigoalt like 'P%'
and a.agn_in_codigo not in (select agn_in_codigo from mgglo.glo_contasagentes)--58254

select b.*, b.rowid from mgglo.glo_contasagentes b where b.pla_in_reduzido in ('408','414')

create global temporary table agentes (agn_in_codigo number(7))

--select a.*, a.rowid from mgglo.glo_agentes_id a where a.agn_in_codigo = '5753'

select t.*, t.rowid from mgglo.glo_contasagentes t where t.agn_in_codigo = '34915'

insert into mgglo.glo_contasagentes
select '53','1', mgglo.glo_agentes_id.agn_in_codigo,'C','AGN','1','2','1','408'
from mgglo.glo_agentes_id
where agn_st_codigoalt like 'P%'
and agn_in_codigo not in (select agn_in_codigo from mgglo.glo_contasagentes);

--Antes do commit, abrir uma nova sessão do PL/SQL e rodar o insert abaixo

insert into mgglo.glo_contasagentes
select '53','1', mgglo.glo_agentes_id.agn_in_codigo,'C','AGNAD','1','2','2','414'
from mgglo.glo_agentes_id
where agn_st_codigoalt like 'P%'
and agn_in_codigo not in (select agn_in_codigo from mgglo.glo_contasagentes);
