create or replace procedure MEGA_AGN_CONTA_CONTABIL is
begin
  execute immediate 'create global temporary table agentes (agn_in_codigo number(7))';
  execute immediate 'insert into agentes select mgglo.glo_agentes_id.agn_in_codigo from mgglo.glo_agentes_id where agn_st_codigoalt like ''P%'' and agn_in_codigo not in (select agn_in_codigo from mgglo.glo_contasagentes)';
  execute immediate 'insert into mgglo.glo_contasagentes select ''53'',''1'', agentes.agn_in_codigo,''C'',''AGN'',''1'',''2'',''1'',''408'' from agentes';
  execute immediate 'insert into mgglo.glo_contasagentes select ''53'',''1'', agentes.agn_in_codigo,''C'',''AGNAD'',''1'',''2'',''2'',''414'' from agentes';
  execute immediate 'drop table agentes';
  commit;
end MEGA_AGN_CONTA_CONTABIL;
/
