--insert into faccicad values ('127','01','351550','','','P21','C00','C00','C00','0.00','0.00','0.00','0.00')
--insert into faccicad values ('104','01','130135','','','C00','C25','C25','C25','0.00','150.00','150.00','150.00');
--select * from faccicad where codigo = "130135"
select t.*, t.rowid from faccicad t where codigo = '209972' order by cod_con

--select t.*, t.rowid from faccicad t where t.cod_con = '014' and t.cod_pla = '01'

/*
-- Dar um unload to XXXXX.sql delimiter ";"
select 'insert into faccicad values('''||cod_con||''','''||cod_pla||''','229287','','','C01','C01','C01','C01',0,0,0,0)'
from faplacad where
--not exists (select * from faccicad t2 where t2.codigo="229287" and
t2.cod_con = faplacad.cod_con and t2.cod_pla = faplacad.cod_pla)
and suspenso='N'
 select cod_con, cod_pla from faplacad where suspenso = 'N'


select t.cod_con, v.fantasia, x.nome_plano, u.codigo, u.descricao, t.tab_int, t.tab_ext, t.tab_urg, t.tab_amb
from faccicad t, faprdcad u, faconcad v, faplacad x where t.codigo = u.codigo and t.cod_con = v.cod_con
and v.cod_con = x.cod_con and t.cod_con = x.cod_con
and t.tab_int like 'C%'
and t.tab_amb like 'H%'*/
