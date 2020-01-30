--delete from relporprofps;
insert into relporprofps (desc_esp, cod_pro, nome_pro, mes_ano, count_consultas)
      select tt.descricao, tt.cod_pro, tt.nome_pro, tt.dataa, sum(tt.conta)
        from (
          select a.descricao, t.cod_pro, v.nome_pro, count(t.cod_pro) conta,
          ('01'||'/'||SUBSTR(to_char(data_mov,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_mov,'MMYYYY'), 3 ,4)) dataa
          from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y, faespcad a, faesppro b
          where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
          and t.sequencial = x.sequencial
          and t.cod_pro = v.cod_pro
          and u.cod_pac = y.cod_pac
          and v.cod_pro = b.cod_pro and b.cod_esp = a.cod_esp and b.sn_principal = 'S'
          and t.codigo in (select codigo from faprdcad where tipo_prd = 'CON')
          and u.data_mov between '01/07/2016' and '16/03/2017'
          and y.tipo_pac = 'U'
          group by a.descricao, t.cod_pro, v.nome_pro, u.data_mov
        ) tt
      group by tt.descricao, tt.cod_pro, tt.nome_pro, tt.dataa
      order by 1,2,3;
drop table count_ciru2;
create table count_ciru2 (cod_pro varchar2(6), nome_pro varchar2(70), count_ciru number(4,0), data_mov date);
insert into count_ciru2
      select tt.cod_pro, tt.nome_pro, sum(tt.conta), tt.dataa
      from (
      select c.cod_pro, c.nome_pro, count (distinct (b.cod_pac)) conta,
      ('01'||'/'||SUBSTR(to_char(data_mov,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_mov,'MMYYYY'), 3 ,4)) dataa
      from famovprd a, famovcad b, faprocad c, faprdcad d
      where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
      and a.cod_pro = c.cod_pro and a.codigo = d.codigo
      and a.tipo_ato = '01'
      and b.data_mov between '01/07/2016' and '16/03/2017'
      and a. tipo_comanda = 'CCIR' and d.tipo_prd = 'PRO'
      group by c.cod_pro, c.nome_pro, b.data_mov) tt
      group by tt.cod_pro, tt.nome_pro, tt.dataa
      order by 2;
merge into relporprofps a using (select * from count_ciru2) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
      when matched then update set a.count_cirurgias = b.count_ciru;
drop table ex_prof_sol_ps;
create table ex_prof_sol_ps (cod_pro varchar2(6), nome_pro varchar2(70), data_mov date, count_exa_cdi number(4,0));

insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (
      select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta,
     ('01'||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 3 ,4)) dataa
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA
        and c.COD_PAC = a.COD_PAC
        and d.COMANDA = c.COMANDA
        and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD
        and f.TIPO_PRD = e.TIPO_PRD
        and f.tipo_prd in ('RAD','REM','TOM','END','USG')
        and a.data_ent between '01/07/2016' and '16/03/2017'
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2;

merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set a.count_exa_cdi = b.count_exa_cdi;
drop table ex_prof_sol_ps;
create table ex_prof_sol_ps (cod_pro varchar2(6), nome_pro varchar2(70), data_mov date, count_exa number(4,0));
insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (
      select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta,
     ('01'||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 3 ,4)) dataa      
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'RAD'
        and a.data_ent between '01/07/2016' and '16/03/2017'
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2;
merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set a.count_exa_rax = b.count_exa;
delete from ex_prof_sol_ps;

insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta,
      ('01'||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 3 ,4)) dataa
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'REM'
        and a.data_ent between '01/07/2016' and '16/03/2017'
        group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2;
merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set a.count_exa_rem = b.count_exa;
delete from ex_prof_sol_ps;

insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta,
      ('01'||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 3 ,4)) dataa      
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'TOM'
        and a.data_ent between '01/07/2016' and '16/03/2017'
        group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2;
merge into relporprofps a using (select * from ex_prof_sol_ps) b
      on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set
      a.count_exa_tom = b.count_exa;

delete from ex_prof_sol_ps;
insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta,
      ('01'||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 3 ,4)) dataa      
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'USG'
        and a.data_ent between '01/07/2016' and '16/03/2017'
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2;
merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
      when matched then update set a.count_exa_usg = b.count_exa;
delete from ex_prof_sol_ps;
insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta,
      ('01'||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_ent,'MMYYYY'), 3 ,4)) dataa      
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = 'MEN'
        and e.descricao like 'CINTILOG%'
        and a.data_ent between '01/07/2016' and '16/03/2017'
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2;
merge into relporprofps a using (select * from ex_prof_sol_ps) b
      on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set
      a.count_exa_end = b.count_exa;
drop table ex_prof_sol_ps;
create table ex_prof_sol_ps (cod_pro varchar2(6), nome_pro varchar2(70), data_mov date, count_exa_lab number(5,0));
insert into ex_prof_sol_ps
      select tt.cod_pro_solic, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select c.cod_pro_solic, b.nome_pro, count(e.descricao) conta,
      ('01'||'/'||SUBSTR(to_char(data_mov,'MMYYYY'), 1 ,2)||'/'||SUBSTR(to_char(data_mov,'MMYYYY'), 3 ,4)) dataa 
      from faprocad b, lbmovcad c, lbmovprd d, faprdcad e where b.cod_pro = c.cod_pro_solic
        and d.comanda = c.comanda and d.tipo_comanda = c.tipo_comanda
        and e.codigo = d.codigo
        and c.data_mov between '01/07/2016' and '16/03/2017'
      group by c.cod_pro_solic, b.nome_pro, c.data_mov
      ) tt
      group by tt.cod_pro_solic, tt.nome_pro, tt.dataa
      order by 2;
merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
      when matched then update set a.count_exa_lab = b.count_exa_lab;
  commit;
