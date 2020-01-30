/*create table "ADMWPD".est_med_mensal (
data_est date not null,
valor_tot number(10,2),
constraint pk_data_est PRIMARY KEY (data_est)
) tablespace "WPDDADOS";
grant ALL on est_med_mensal to wpd;*/

insert into est_med_mensal (
select ('01'||'/'||SUBSTR(a.ano_mes, 5 ,2)||'/'||SUBSTR(a.ano_mes, 1 ,4)),
round(sum(a.est_atu_mes * b.custo_med),2) from eshiscad a, eshiscus b where a.cod_prd = b.cod_prd and a.ano_mes = b.ano_mes
and a.ano_mes = '201806'
and a.COD_BARRA_INT NOT IN (SELECT COD_BARRA_INT FROM ESLOTE_VALIDADE WHERE FK_DOCUMENTO IS NOT NULL)
and a.est_atu_mes <> 0 and b.custo_med <> 0
and a.COD_PRD in (select codigo from faprdcad where tipo_prd = 'MED')
group by a.ano_mes)

--drop table est_med_mensal
--select a.*, a.rowid from est_med_mensal a
