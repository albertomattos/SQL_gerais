drop table count_prof;

create global temporary table count_prof (cod_pro varchar2(6), nome_pro varchar2(70), count_cons number(4,0));

insert into count_prof 
select distinct t.cod_pro, v.nome_pro, count(t.cod_pro)
from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y
where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
and t.sequencial = x.sequencial
and t.cod_pro = v.cod_pro
and u.cod_pac = y.cod_pac
and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
and u.data_mov between &data_mov and &data_mov
and y.tipo_pac = 'A'
group by t.cod_pro, v.nome_pro
order by 2;

merge into relporprof a
using (select * from count_prof) b
on (a.cod_pro = b.cod_pro)
when matched then update set
a.count_consultas = b.count_cons;
commit;