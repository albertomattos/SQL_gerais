select t.*, t.rowid, u.descricao from fapricad t, famodcad u where t.cod_mod = u.cod_mod and t.sistema = u.sistema
and t.sistema = 'FAT'
and cod_grupo in ('REPAL')
order by t.cod_mod


/*
--insert into faccicad values ('127','01','351550','','','P21','C00','C00','C00','0.00','0.00','0.00','0.00')
--insert into faccicad values ('104','01','130135','','','C00','C25','C25','C25','0.00','150.00','150.00','150.00');
--select * from faccicad where codigo = "130135"
select t.*, t.rowid from fapricad t where cod_grupo = 'REPAS' and sistema = 'FAT'
order by cod_mod

-- Dar um unload to XXXXX.sql delimiter ";"
select 'update fapricad set privilegio = '''||privilegio||''' where cod_grupo = ''OPME'' and cod_mod = '''||cod_mod||''';'
from fapricad where cod_grupo = 'ADMBL' and sistema = 'BLO'*/
