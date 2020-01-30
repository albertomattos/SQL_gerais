--drop table relporprofvalor
create table "ADMWPD".relporprofvalor (
cod_pro varchar2(6),
nome_pro varchar2(70) not null,
count_exa_cdi number(7,2),
count_exa_rax number(7,2),
count_exa_rem number(7,2),
count_exa_tom number(7,2),
count_exa_usg number(7,2),
count_exa_end number(7,2),
count_exa_lab number(7,2),
count_consultas number(7,2),
mes_ano varchar2(6)
) tablespace "WPDDADOS";

grant ALL on relporprofvalor to wpd;

insert into relporprofvalor (cod_pro, nome_pro) 
(select cod_pro, nome_pro from faprocad where inativo = 'N' and cod_profissao = 'MEDC');

select * from relporprofvalor;
commit;

--delete from relporprofvalor; --select * from relporprofvalor;

--Consultas no Centro Médico
insert into relporprofvalor (cod_pro, nome_pro, mes_ano, count_consultas)
select tt.cod_pro, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select t.cod_pro, v.nome_pro, count(t.cod_pro) conta, to_char(data_mov,'MMYYYY') dataa
from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and t.cod_pro = v.cod_pro
and u.cod_pac = y.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and substr(to_char(u.data_mov,'MMYYYY'),5,2)<>'11'
and y.tipo_pac = 'A'
group by t.cod_pro, v.nome_pro, u.data_mov 
) tt
group by tt.cod_pro, tt.nome_pro, tt.dataa
order by 2,3;

--Exames solicitados CDI
drop table ex_prof_sol; --select * from ex_prof_sol;
create global temporary table ex_prof_sol (cod_pro varchar2(6), nome_pro varchar2(70), data_mov varchar2(6),
  count_exa_cdi number(7,2));
insert into ex_prof_sol
select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
from (                           --select * from immovprd
select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,'MMYYYY') dataa
from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  where b.COD_PRO = a.COD_PRO_SA
  and c.COD_PAC = a.COD_PAC
  and d.COMANDA = c.COMANDA
  and d.TIPO_COMANDA = c.TIPO_COMANDA
  and e.CODIGO = d.COD_PRD
  and f.TIPO_PRD = e.TIPO_PRD
  and f.tipo_prd in ('RAD','REM','TOM','END','USG')
  and substr(to_char(a.data_ent,'MMYYYY'),5,2)<>'11'
group by a.cod_pro_sa, b.nome_pro, a.data_ent
) tt
group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
order by 2;
merge into relporprof a
using (select * from ex_prof_sol) b
on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
when matched then update set
a.count_exa_cdi = b.count_exa_cdi;

--Exames solicitados CDI (por tipo de produto)
drop table ex_prof_sol;
create global temporary table ex_prof_sol (cod_pro varchar2(6), nome_pro varchar2(70), data_mov varchar2(6),
  count_exa number(4,0));
--Raio-X
insert into ex_prof_sol
select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,'MMYYYY') dataa
from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
  and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'RAD'
  and substr(to_char(a.data_ent,'MMYYYY'),5,2)<>'11'
group by a.cod_pro_sa, b.nome_pro, a.data_ent
) tt
group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
order by 2;
merge into relporprof a
using (select * from ex_prof_sol) b
on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
when matched then update set
a.count_exa_rax = b.count_exa;
--Ressonâncias
delete from ex_prof_sol;
insert into ex_prof_sol
select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,'MMYYYY') dataa
from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
  and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'REM'
  and substr(to_char(a.data_ent,'MMYYYY'),5,2)<>'11'
group by a.cod_pro_sa, b.nome_pro, a.data_ent
) tt
group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
order by 2;
merge into relporprof a
using (select * from ex_prof_sol) b
on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
when matched then update set
a.count_exa_rem = b.count_exa;
--Tomografia
delete from ex_prof_sol;
insert into ex_prof_sol
select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,'MMYYYY') dataa
from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
  and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'TOM'
  and substr(to_char(a.data_ent,'MMYYYY'),5,2)<>'11'
group by a.cod_pro_sa, b.nome_pro, a.data_ent
) tt
group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
order by 2;
merge into relporprof a
using (select * from ex_prof_sol) b
on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
when matched then update set
a.count_exa_tom = b.count_exa;
--Ultrassonografia
delete from ex_prof_sol;
insert into ex_prof_sol
select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,'MMYYYY') dataa
from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
  and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'USG'
  and substr(to_char(a.data_ent,'MMYYYY'),5,2)<>'11'
group by a.cod_pro_sa, b.nome_pro, a.data_ent
) tt
group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
order by 2;
merge into relporprof a
using (select * from ex_prof_sol) b
on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
when matched then update set
a.count_exa_usg = b.count_exa;
--Cintilografia
delete from ex_prof_sol;
insert into ex_prof_sol
select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,'MMYYYY') dataa
from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
  and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'MEN'
  and e.descricao like 'CINTILOG%'
  and substr(to_char(a.data_ent,'MMYYYY'),5,2)<>'11'
group by a.cod_pro_sa, b.nome_pro, a.data_ent
) tt
group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
order by 2;
merge into relporprof a
using (select * from ex_prof_sol) b
on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
when matched then update set
a.count_exa_end = b.count_exa;

--Exames laboratoriais
drop table ex_prof_sol;
create global temporary table ex_prof_sol (cod_pro varchar2(6), nome_pro varchar2(70), data_mov varchar2(6), count_exa_lab number(5,0));
insert into ex_prof_sol
select tt.cod_pro_solic, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select c.cod_pro_solic, b.nome_pro, count(e.descricao) conta, to_char(data_mov,'MMYYYY') dataa
from faprocad b, lbmovcad c, lbmovprd d, faprdcad e
  where b.cod_pro = c.cod_pro_solic
  and d.comanda = c.comanda
  and d.tipo_comanda = c.tipo_comanda
  and e.codigo = d.codigo
  /*and to_char(c.data_mov,'MMYYYY')
  between '012012' and '122012'
  and to_char(c.data_mov,'MMYYYY')
between '012013' and '012013'*/
  and substr(to_char(c.data_mov,'MMYYYY'),5,2)<>'11'
group by c.cod_pro_solic, b.nome_pro, c.data_mov
) tt
group by tt.cod_pro_solic, tt.nome_pro, tt.dataa
order by 2;
merge into relporprof a
using (select * from ex_prof_sol) b
on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
when matched then update set
a.count_exa_lab = b.count_exa_lab;
commit;
