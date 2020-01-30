create or replace package PCKLEITO is

  -- Author  : MARIO.ANDRE
  -- Created : 25/01/2013 14:36:29
  -- Purpose : Para o sistema de leitos e apartamentos
  -- Alteração: 01/08/2013 (Alberto e Nelson)
  
  procedure consulta( vAndar in varchar2, vResultado OUT SYS_REFCURSOR );

end PCKLEITO;
/
