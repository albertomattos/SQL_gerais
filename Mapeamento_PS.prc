create or replace procedure Mapeamento_PS is
begin
  execute immediate 'delete from relporprofps';
  execute immediate 'insert into relporprofps (desc_esp, cod_pro, nome_pro, mes_ano, count_consultas)
      select tt.descricao, tt.cod_pro, tt.nome_pro, tt.dataa, sum(tt.conta)
        from (
          select a.descricao, t.cod_pro, v.nome_pro, count(t.cod_pro) conta, to_char(data_mov,''MMYYYY'') dataa
          from famovprd t, famovcad u, faprocad v, famovdestino x, fapaccad y, faespcad a, faesppro b
          where t.comanda = u.comanda and t.tipo_comanda = u.tipo_comanda
          and t.sequencial = x.sequencial
          and t.cod_pro = v.cod_pro
          and u.cod_pac = y.cod_pac
          and v.cod_pro = b.cod_pro and b.cod_esp = a.cod_esp and b.sn_principal = ''S''
          and t.codigo in (select codigo from faprdcad where tipo_prd = ''CON'')
          and substr(to_char(u.data_mov,''MMYYYY''),5,2)<>''11''
          and y.tipo_pac = ''U''
          group by a.descricao, t.cod_pro, v.nome_pro, u.data_mov
        ) tt
      group by tt.descricao, tt.cod_pro, tt.nome_pro, tt.dataa
      order by 1,2,3';
  execute immediate 'drop table count_ciru2';
  execute immediate 'create table count_ciru2 (cod_pro varchar2(6), nome_pro varchar2(70), count_ciru number(4,0), data_mov varchar2(6))';
  execute immediate 'insert into count_ciru2
      select tt.cod_pro, tt.nome_pro, sum(tt.conta), tt.dataa
      from (
      select c.cod_pro, c.nome_pro, count (distinct (b.cod_pac)) conta, to_char(data_mov,''MMYYYY'') dataa
      from famovprd a, famovcad b, faprocad c, faprdcad d
      where a.comanda = b.comanda and a.tipo_comanda = b.tipo_comanda
      and a.cod_pro = c.cod_pro and a.codigo = d.codigo
      and a.tipo_ato = ''01''
      and substr(to_char(b.data_mov,''MMYYYY''),5,2)<>''11''
      and a. tipo_comanda = ''CCIR'' and d.tipo_prd = ''PRO''
      group by c.cod_pro, c.nome_pro, b.data_mov) tt
      group by tt.cod_pro, tt.nome_pro, tt.dataa
      order by 2';
  execute immediate 'merge into relporprofps a using (select * from count_ciru2) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
      when matched then update set a.count_cirurgias = b.count_ciru';
  execute immediate 'drop table ex_prof_sol_ps';
  execute immediate 'create table ex_prof_sol_ps (cod_pro varchar2(6), nome_pro varchar2(70), data_mov varchar2(6), count_exa_cdi number(4,0))';
  execute immediate 'insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (
      select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,''MMYYYY'') dataa
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA
        and c.COD_PAC = a.COD_PAC
        and d.COMANDA = c.COMANDA
        and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD
        and f.TIPO_PRD = e.TIPO_PRD
        and f.tipo_prd in (''RAD'',''REM'',''TOM'',''END'',''USG'')
        and substr(to_char(a.data_ent,''MMYYYY''),5,2)<>''11''
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2';
  execute immediate 'merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set a.count_exa_cdi = b.count_exa_cdi';
  execute immediate 'drop table ex_prof_sol_ps';
  execute immediate 'create table ex_prof_sol_ps (cod_pro varchar2(6), nome_pro varchar2(70), data_mov varchar2(6), count_exa number(4,0))';
  execute immediate 'insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (
      select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,''MMYYYY'') dataa
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = ''RAD''
        and substr(to_char(a.data_ent,''MMYYYY''),5,2)<>''11''
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2';
  execute immediate 'merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set a.count_exa_rax = b.count_exa';
  execute immediate 'delete from ex_prof_sol_ps';
  execute immediate 'insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,''MMYYYY'') dataa
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = ''REM''
        and substr(to_char(a.data_ent,''MMYYYY''),5,2)<>''11''
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2';
  execute immediate 'merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set a.count_exa_rem = b.count_exa';
  execute immediate 'delete from ex_prof_sol_ps';
  execute immediate 'insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,''MMYYYY'') dataa
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = ''TOM''
        and substr(to_char(a.data_ent,''MMYYYY''),5,2)<>''11''
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2';
  execute immediate 'merge into relporprofps a using (select * from ex_prof_sol_ps) b
      on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set
      a.count_exa_tom = b.count_exa';
  execute immediate 'delete from ex_prof_sol_ps';
  execute immediate 'insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,''MMYYYY'') dataa
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = ''USG''
        and substr(to_char(a.data_ent,''MMYYYY''),5,2)<>''11''
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2';
  execute immediate 'merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
      when matched then update set a.count_exa_usg = b.count_exa';
  execute immediate 'delete from ex_prof_sol_ps';
  execute immediate 'insert into ex_prof_sol_ps
      select tt.cod_pro_sa, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select a.cod_pro_sa, b.nome_pro, count(f.tipo_prd) conta, to_char(data_ent,''MMYYYY'') dataa
      from FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
        where b.COD_PRO = a.COD_PRO_SA and c.COD_PAC = a.COD_PAC and d.COMANDA = c.COMANDA and d.TIPO_COMANDA = c.TIPO_COMANDA
        and e.CODIGO = d.COD_PRD and f.TIPO_PRD = e.TIPO_PRD and f.tipo_prd = ''MEN''
        and e.descricao like ''CINTILOG%''
        and substr(to_char(a.data_ent,''MMYYYY''),5,2)<>''11''
      group by a.cod_pro_sa, b.nome_pro, a.data_ent
      ) tt
      group by tt.cod_pro_sa, tt.nome_pro, tt.dataa
      order by 2';
  execute immediate 'merge into relporprofps a using (select * from ex_prof_sol_ps) b
      on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov) when matched then update set
      a.count_exa_end = b.count_exa';
  execute immediate 'drop table ex_prof_sol_ps';
  execute immediate 'create table ex_prof_sol_ps (cod_pro varchar2(6), nome_pro varchar2(70), data_mov varchar2(6), count_exa_lab number(5,0))';
  execute immediate 'insert into ex_prof_sol_ps
      select tt.cod_pro_solic, tt.nome_pro, tt.dataa, sum(tt.conta)
      from (select c.cod_pro_solic, b.nome_pro, count(e.descricao) conta, to_char(data_mov,''MMYYYY'') dataa
      from faprocad b, lbmovcad c, lbmovprd d, faprdcad e where b.cod_pro = c.cod_pro_solic
        and d.comanda = c.comanda and d.tipo_comanda = c.tipo_comanda
        and e.codigo = d.codigo and substr(to_char(c.data_mov,''MMYYYY''),5,2)<>''11''
      group by c.cod_pro_solic, b.nome_pro, c.data_mov
      ) tt
      group by tt.cod_pro_solic, tt.nome_pro, tt.dataa
      order by 2';
  execute immediate 'merge into relporprofps a using (select * from ex_prof_sol_ps) b on (a.cod_pro = b.cod_pro and a.mes_ano = b.data_mov)
      when matched then update set a.count_exa_lab = b.count_exa_lab';
  commit;
end Mapeamento_PS;
/
