create or replace procedure FILA_SENHA_ZERAR is
begin
  execute immediate 'update tb_triagem_fila set nu_prox_senha = ''1'' where sn_zera_novo_dia = ''N''';
  commit;
end;
/
