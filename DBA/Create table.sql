create table admwpd.blcirculante (
  cod_ciru VARCHAR2(6) NOT NULL ENABLE,
  circulante VARCHAR2(15) NOT NULL ENABLE,
  primary key (cod_ciru));
  
  COMMENT ON COLUMN admwpd.blcirculante.cod_ciru IS 'Codigo da cirurgia realizada';
  COMMENT ON COLUMN admwpd.blcirculante.circulante IS 'Nome da circulante do dia';
   
