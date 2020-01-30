delete from solic_exa_cdi;

--Consultas no Centro Médico
insert into solic_exa_cdi (cod_pro, nome_pro, mes_ano, count_consultas)
select tt.cod_pro, tt.nome_pro, tt.dataa, sum(tt.conta)
  from (
    select t.cod_pro, v.nome_pro,
           case
         when u.data_mov between '01/01/2015' and '31/01/2015' then '01/01/2015'
         when u.data_mov between '01/02/2015' and '28/02/2015' then '01/02/2015'
         when u.data_mov between '01/03/2015' and '31/03/2015' then '01/03/2015'           
         when u.data_mov between '01/04/2015' and '30/04/2015' then '01/04/2015'
         when u.data_mov between '01/05/2015' and '31/05/2015' then '01/05/2015'
         when u.data_mov between '01/06/2015' and '30/06/2015' then '01/06/2015'
         when u.data_mov between '01/07/2015' and '31/07/2015' then '01/07/2015'           
         when u.data_mov between '01/08/2015' and '31/08/2015' then '01/08/2015'
         when u.data_mov between '01/09/2015' and '30/09/2015' then '01/09/2015'
         when u.data_mov between '01/10/2015' and '31/10/2015' then '01/10/2015'
         when u.data_mov between '01/11/2015' and '30/11/2015' then '01/11/2015'           
         when u.data_mov between '01/12/2015' and '31/12/2015' then '01/12/2015'
       end as dataa, count(t.cod_pro) conta
    from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y
    where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
    and t.sequencial = x.sequencial
    and t.cod_pro = v.cod_pro
    and u.cod_pac = y.cod_pac
    and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
    and u.data_mov between '01/01/2015' and '30/04/2015'
    and y.tipo_pac = 'A'
    group by t.cod_pro, v.nome_pro, u.data_mov
  ) tt
group by tt.cod_pro, tt.nome_pro, tt.dataa
order by 2,3;

--Exames solicitados CDI select x.* from exa_solic_cdi x
--drop table exa_solic_cdi;
--create table exa_solic_cdi (cod_pro varchar2(6), nome_pro varchar2(70), data_ent date, count_exa_cdi number(4,0));
delete from exa_solic_cdi;
insert into exa_solic_cdi
select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
from (
select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta,
         case
         when a.data_ent between '01/01/2015' and '31/01/2015' then '01/01/2015'
         when a.data_ent between '01/02/2015' and '28/02/2015' then '01/02/2015'
         when a.data_ent between '01/03/2015' and '31/03/2015' then '01/03/2015'           
         when a.data_ent between '01/04/2015' and '30/04/2015' then '01/04/2015'
         when a.data_ent between '01/05/2015' and '31/05/2015' then '01/05/2015'
         when a.data_ent between '01/06/2015' and '30/06/2015' then '01/06/2015'
         when a.data_ent between '01/07/2015' and '31/07/2015' then '01/07/2015'           
         when a.data_ent between '01/08/2015' and '31/08/2015' then '01/08/2015'
         when a.data_ent between '01/09/2015' and '30/09/2015' then '01/09/2015'
         when a.data_ent between '01/10/2015' and '31/10/2015' then '01/10/2015'
         when a.data_ent between '01/11/2015' and '30/11/2015' then '01/11/2015'           
         when a.data_ent between '01/12/2015' and '31/12/2015' then '01/12/2015'
       end as dataa
from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  where b.COD_PRO = a.COD_PRO_SA
  and c.COD_PAC = a.COD_PAC
  and d.COMANDA = c.COMANDA
  and d.TIPO_COMANDA = c.TIPO_COMANDA
  and e.CODIGO = d.COD_PRD
  and f.TIPO_PRD = e.TIPO_PRD
  and f.tipo_prd in ('RAD','REM','TOM','END','USG')
  and a.data_ent between '01/01/2015' and '30/04/2015'
group by a.cod_pro_sa, b.nome_pro, a.data_ent
) tt
group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
order by 2;

commit;

merge into solic_exa_cdi a
using (select * from exa_solic_cdi) b
on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_ent)
when matched then update set
a.count_exa_cdi = b.count_exa_cdi;
commit;
