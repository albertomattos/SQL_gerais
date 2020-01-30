create or replace procedure Integracao_manutencao is
begin
  execute immediate 'delete from int_xml x where x.trn_in_id in (select tr.trn_in_id from int_transacao tr
          where tr.trn_dt_datatranscao < sysdate-120)';
  commit;          
  execute immediate 'delete int_transacao t where t.trn_dt_datatranscao < sysdate-120';
  commit;
end Integracao_manutencao;
/
