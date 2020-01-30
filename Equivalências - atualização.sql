select min(codigo) as codigo, cod_amb, count(*) as num
    from faprdcad
    where tipo_prd in (select TIPO_PRD  FROM FATIPCAD WHERE PRE_CLASS IN ("EXA","HON"))
    and bloqueado = "N"
    group by cod_amb order by codigo
into temp tt2;

delete from tt2 where cod_amb is null;

delete from tt2 where cod_amb = "";

select "001" as cod_con, faprdcad.cod_amb as cod_equ, descricao from faprdcad, tt2
    where tipo_prd in (select TIPO_PRD  FROM FATIPCAD WHERE PRE_CLASS IN ("EXA","HON"))
    and faprdcad.cod_amb not in
    (select cod_equ from faequcad where cod_con = "001") and bloqueado = "N"
    and faprdcad.codigo = tt2.codigo
into temp eqcon;
insert into faequcad
select * from eqcon;

select "001" as cod_con, faprdcad.cod_amb as cod_equ, faprdcad.codigo, "" as cod_pla, "" as tipo_set, "" as tipo_equ
    from faprdcad,tt2 where tipo_prd in (select TIPO_PRD  FROM FATIPCAD WHERE PRE_CLASS IN ("EXA","HON"))
    and faprdcad.codigo not in (select codigo from faecpcad where cod_con = "001") and bloqueado = "N"
    and faprdcad.codigo=tt2.codigo
    into temp eq2;

update eq2 set cod_pla = null where cod_pla="";

insert into faecpcad
select * from eq2;
/*
select "004" as cod_con, faprdcad.cod_amb as cod_equ, faprdcad.codigo, "" as cod_pla, "" as tipo_set, "" as tipo_equ
    from faprdcad where tipo_prd = "LAB"
    and faprdcad.codigo not in (select codigo from faecpcad where cod_con = "004") and bloqueado = "N"
    and cod_amb in (select cod_equ from faecpcad where cod_con = "004")
    into temp eq2;

update eq2 set cod_pla = null where cod_pla="";

insert into faecpcad
select * from eq2;
