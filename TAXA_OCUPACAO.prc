create or replace procedure TX_OCUPACAO is
begin
  execute immediate 'insert into taxa_ocupacao select to_char(sysdate,''DD/MM/YYYY''), t.cod_set,count(*),
  null from faleicad t, fasetcad u where t.cod_set = u.cod_set and t.leito not like ''P%''
  and t.leito not like ''R%'' and t.leito not like ''V%''
  and t.leito not like ''H%'' and t.leito not like ''B%'' and t.desativado is null and t.cod_set <> ''0312''
  group by t.cod_set, u.descricao';
  commit;
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0006'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0006''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0130'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0130''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0132'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0132''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0133'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0133''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0134'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0134''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0191'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0191''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0453'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0453''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0025'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0025''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0121'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0121''';
  execute immediate 'update taxa_ocupacao set num_pac = (SELECT count(*) FROM FAPACCAD, FALEICAD
  WHERE FALEICAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.LEITO = FALEICAD.LEITO AND FAPACCAD.TIPO_PAC = ''I''
  and faleicad.leito not like ''P%'' and faleicad.leito not like ''R%''
  and faleicad.leito not like ''V%'' and faleicad.leito not like ''H%'' and faleicad.leito not like ''B%''
  and faleicad.cod_set = ''0125'' group by faleicad.cod_set) where data = to_char(sysdate,''DD/MM/YYYY'')
  and cod_set = ''0125''';  commit;
  end TX_OCUPACAO;
/
