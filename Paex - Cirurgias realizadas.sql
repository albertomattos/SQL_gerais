drop table count_ciru;
create global temporary table count_ciru (cod_pro varchar2(6), nome_pro varchar2(70), count_ciru number(4,0));
insert into count_ciru
--select e.cod_pcn, c.nome_pro, d.descricao, d.tipo_prd, b.cod_pac, a.*
select c.cod_pro, c.nome_pro, count (distinct (b.cod_pac))
from famovprd a, famovcad b, faprocad c, faprdcad d--, fapaccom e
where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
and a.cod_pro = c.cod_pro and a.codigo = d.codigo
and a.tipo_ato = '01' and b.data_mov between &data_mov and &data_mov
and a. tipo_comanda = 'CCIR' and d.tipo_prd = 'PRO'-- and b.cod_pac = e.cod_pac-- and e.cod_pcn <> 'PS'
group by c.cod_pro, c.nome_pro
order by 1;

merge into relporprof a
using (select * from count_ciru) b
on (a.cod_pro = b.cod_pro)
when matched then update set
a.count_cirurgias = b.count_ciru;
commit;