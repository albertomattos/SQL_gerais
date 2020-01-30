--create global temporary table ex_prof_sol (cod_pro varchar2(6), nome_pro varchar2(70), descricao varchar2(30), count_exa number(4,0));
drop table ex_prof_sol;
create global temporary table ex_prof_sol (cod_pro varchar2(6), nome_pro varchar2(70), count_exa number(4,0));

insert into ex_prof_sol
SELECT a.COD_PRO_SA, b.NOME_PRO, count(f.descricao)
FROM FAPACCAD a, FAPROCAD b, IMMOVCAD c, IMMOVPRD d, FAPRDCAD e, FATIPCAD f
  WHERE b.COD_PRO = a.COD_PRO_SA
  AND c.COD_PAC = a.COD_PAC
  AND d.COMANDA = c.COMANDA
  AND d.TIPO_COMANDA = c.TIPO_COMANDA
  AND e.CODIGO = d.COD_PRD
  AND f.TIPO_PRD = e.TIPO_PRD
  AND f.tipo_prd in ('RAD','REM','TOM','END','USG')
  AND a.DATA_ENT BETWEEN &DATA_ENT AND &DATA_ENT
GROUP BY a.COD_PRO_SA, b.NOME_PRO
ORDER BY b.NOME_PRO;
select * from ex_prof_sol;
merge into relporprof a
using (select * from ex_prof_sol) b
on (a.cod_pro = b.cod_pro)
when matched then update set
a.count_exames = b.count_exa;
commit;