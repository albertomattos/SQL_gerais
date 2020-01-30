create or replace trigger TR_EST_PROD_NCM
  before update on faprdcad  
  for each row
declare
  tipo_prd varchar2(3);
  cod_ant varchar2(8);
begin
  if tipo_prd = 'MED' then
    if cod_ant is null then
      RAISE_APPLICATION_ERROR(-20502,'Código NCM obrigatório');
    end if;
  end if;
end TR_EST_PROD_NCM;
/
