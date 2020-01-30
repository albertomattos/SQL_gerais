create or replace procedure Fila_Senha_Zerar is
begin
  execute immediate 'update tb_triagem_fila set nu_prox_senha = ''1'' where sn_zera_novo_dia = ''N''';
  commit;
end Fila_Senha_Zerar;
/
