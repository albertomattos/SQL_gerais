CREATE tablespace DBJS04_DATA datafile 'H:\oradata\HOMOL\DATAFILE\01_MF_DBJS04.DBF' size 200m autoextend on next 50m;
CREATE USER DBJS04 IDENTIFIED BY Plann3ta;
GRANT ALL PRIVILEGES TO DBJS04;
CREATE USER js00001 IDENTIFIED BY a1234;
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE, CREATE SESSION TO js00001;
CREATE SEQUENCE  "DBJS04"."SEQ_ID_ASSINATURA"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."SEQ_ID_ASSINATURA" TO "JS00001";
--------------------------------------------------------
--  DDL for Sequence SEQ_ID_CHAVE
--------------------------------------------------------

   CREATE SEQUENCE  "DBJS04"."SEQ_ID_CHAVE"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."SEQ_ID_CHAVE" TO "JS00001";
--------------------------------------------------------
--  DDL for Sequence SEQ_ID_DOCUMENTO
--------------------------------------------------------

   CREATE SEQUENCE  "DBJS04"."SEQ_ID_DOCUMENTO"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."SEQ_ID_DOCUMENTO" TO "JS00001";
--------------------------------------------------------
--  DDL for Sequence SEQ_ID_FLUXO
--------------------------------------------------------

   CREATE SEQUENCE  "DBJS04"."SEQ_ID_FLUXO"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 2 CACHE 20 ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."SEQ_ID_FLUXO" TO "JS00001";
--------------------------------------------------------
--  DDL for Sequence SEQ_ID_REGRA
--------------------------------------------------------

   CREATE SEQUENCE  "DBJS04"."SEQ_ID_REGRA"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."SEQ_ID_REGRA" TO "JS00001";
--------------------------------------------------------
--  DDL for Sequence SEQ_ID_SERVIDOR
--------------------------------------------------------

   CREATE SEQUENCE  "DBJS04"."SEQ_ID_SERVIDOR"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."SEQ_ID_SERVIDOR" TO "JS00001";
--------------------------------------------------------
--  DDL for Sequence SEQ_ID_TRANSACAO
--------------------------------------------------------

   CREATE SEQUENCE  "DBJS04"."SEQ_ID_TRANSACAO"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."SEQ_ID_TRANSACAO" TO "JS00001";
--------------------------------------------------------
--  DDL for Sequence TBJS_CERTIFICATE_ID_CERTIFICAT
--------------------------------------------------------

   CREATE SEQUENCE  "DBJS04"."TBJS_CERTIFICATE_ID_CERTIFICAT"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."TBJS_CERTIFICATE_ID_CERTIFICAT" TO "JS00001";
--------------------------------------------------------
--  DDL for Sequence TBJS_PROPRIETARIO_ID_PROPRIETA
--------------------------------------------------------

   CREATE SEQUENCE  "DBJS04"."TBJS_PROPRIETARIO_ID_PROPRIETA"  MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE ;
  GRANT SELECT ON "DBJS04"."TBJS_PROPRIETARIO_ID_PROPRIETA" TO "JS00001";
  
  **********
  CREATE TABLE "DBJS04"."TBJS_ALGORITMO" 
   (	"ID_ALGORITMO" NUMBER(*,0), 
	"NM_ALGORITMO" VARCHAR2(64 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_ALGORITMO"."ID_ALGORITMO" IS 'Identificador do Algoritmo';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_ALGORITMO"."NM_ALGORITMO" IS 'Nome do Algoritmo';
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_ALGORITMO" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_CACHE_CHAVE
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_CACHE_CHAVE" 
   (	"ID_CHAVE" NUMBER(28,0), 
	"DS_SENHA" CLOB, 
	"DT_INSERCAO" TIMESTAMP (6)
   );
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CACHE_CHAVE" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_CERTIFICATE
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_CERTIFICATE" 
   (	"ID_CERTIFICATE" NUMBER(*,0), 
	"ID_AUTHORITY_KEY" CHAR(40 CHAR), 
	"ID_SUBJECT_KEY" CHAR(40 CHAR), 
	"NB_VALID_FROM_DATE" TIMESTAMP (6), 
	"NB_VALID_TO_DATE" TIMESTAMP (6), 
	"DS_CERTIFICATE_DATA" CLOB, 
	"DS_SERIAL_NUMBER" VARCHAR2(150 CHAR), 
	"TP_CERTIFICATE" CHAR(1 CHAR), 
	"DS_HASH" VARCHAR2(512 BYTE), 
	"ID_ALGORITMO" NUMBER(*,0), 
	"ID_CERTIFICATE_P" NUMBER(38,0), 
	"DS_SUBJECT" VARCHAR2(255 CHAR)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."ID_CERTIFICATE" IS 'Identificador auto-incremental dos certificados';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."ID_AUTHORITY_KEY" IS 'Key identifier  do campo Authority Key Identifier do certificado.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."ID_SUBJECT_KEY" IS 'key Identifier do campo Subject Key Identifier do certificado.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."NB_VALID_FROM_DATE" IS 'Data de início da validade do certificado.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."NB_VALID_TO_DATE" IS 'Data do fim da validade do certificado.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."DS_CERTIFICATE_DATA" IS 'Conteúdo do certificado da cadeia no formato base64.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."DS_SERIAL_NUMBER" IS 'Serial Number do certificado.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."TP_CERTIFICATE" IS 'Tipo do certificado: F - Usuário Final; I - AC Intermediária; R - AC Raiz.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."DS_HASH" IS 'Hash do certificado';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."ID_ALGORITMO" IS 'Algoritmo usado para geral o hash do certificado';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."ID_CERTIFICATE_P" IS 'Referência para montagem de cadeia de certificados.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CERTIFICATE"."DS_SUBJECT" IS 'Identificador do proprietário do certificado.';
 
   COMMENT ON TABLE "DBJS04"."TBJS_CERTIFICATE"  IS 'Tabela contendo os certificados';
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CERTIFICATE" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_CHAVE
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_CHAVE" 
   (	"ID_CHAVE" NUMBER(*,0), 
	"ID_ESTADO_CHAVE" NUMBER(*,0), 
	"NM_CHAVE" VARCHAR2(50 BYTE), 
	"SUJEITO" VARCHAR2(255 BYTE), 
	"THUMBPRINT" VARCHAR2(40 BYTE), 
	"DT_EMISSAO" TIMESTAMP (6), 
	"DT_VALIDADE" TIMESTAMP (6), 
	"TICKET_COUNT" NUMBER(*,0) DEFAULT 0, 
	"PIN_COUNT" NUMBER(*,0) DEFAULT 0, 
	"ID_TICKET" VARCHAR2(64 BYTE), 
	"TP_LOCAL_ARMAZENAMENTO" VARCHAR2(4 BYTE) DEFAULT 'SO', 
	"DS_INFO_CHAVE" CLOB, 
	"TP_ATIVACAO" CHAR(1 BYTE) DEFAULT 'P', 
	"ID_CERTIFICATE" NUMBER(*,0), 
	"DS_SENHA_RECUPERACAO" VARCHAR2(64 BYTE), 
	"DS_SALT" VARCHAR2(256 BYTE), 
	"TP_CHAVE" VARCHAR2(3 CHAR)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."ID_CHAVE" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."ID_ESTADO_CHAVE" IS 'Estado da chave, da tabela TBJS_ESTADO_CHAVE';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."NM_CHAVE" IS 'Label da chave';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."SUJEITO" IS 'Sujeito obtido do certificado';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."THUMBPRINT" IS 'Hash SHA-1 do certificado';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."DT_EMISSAO" IS 'Data de emissão do certificado';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."DT_VALIDADE" IS 'Data de validade do certificado';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."TICKET_COUNT" IS 'Contador de Tickets';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."PIN_COUNT" IS 'Contador de PINs';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."ID_TICKET" IS 'Identificador do ultimo Ticket';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."TP_LOCAL_ARMAZENAMENTO" IS 'Local onde a chave está armazenada: BD: Base de Dados, SO: Sistema Operacional';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."DS_INFO_CHAVE" IS 'Campo responsável por armazenar a Chave';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."TP_ATIVACAO" IS 'Tipo de ativação da chave. P: Permanente D: Diária S: Sem Ativação';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."ID_CERTIFICATE" IS 'Identificador do Certificado vinculado a chave';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."DS_SENHA_RECUPERACAO" IS 'Uma das partes da senha dividida';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."DS_SALT" IS 'Salt da Chave';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CHAVE"."TP_CHAVE" IS 'Tipo da chave: P8 ou P12';
   
   COMMENT ON TABLE "DBJS04"."TBJS_CHAVE"  IS 'Tabela que armazena a chave utilizada.';   
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CHAVE" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_CONFIG
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_CONFIG" 
   (	"TICKET_MAX" NUMBER(*,0), 
	"PIN_MAX" NUMBER(*,0), 
	"FL_USE_TICKET" CHAR(1 BYTE), 
	"HR_ATIVACAO_CHAVE" VARCHAR2(20 BYTE) DEFAULT '08:00:00', 
	"HR_DESATIVACAO_CHAVE" VARCHAR2(20 BYTE) DEFAULT '20:00:00', 
	"DS_SEMENTE" VARCHAR2(256 CHAR)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_CONFIG"."TICKET_MAX" IS 'Valor maximo de tickets, de 1 a 16';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CONFIG"."PIN_MAX" IS 'Valor maximo de pins, de 1 a 16';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CONFIG"."FL_USE_TICKET" IS 'Indicador de uso dos tickets';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CONFIG"."HR_ATIVACAO_CHAVE" IS 'Horário que serão ativadas as chaves.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CONFIG"."HR_DESATIVACAO_CHAVE" IS 'Horário que serão desativadas as chaves.';
   
   COMMENT ON COLUMN "DBJS04"."TBJS_CONFIG"."DS_SEMENTE" IS 'Semente para proteção do cache de PINs.';
 
   COMMENT ON TABLE "DBJS04"."TBJS_CONFIG"  IS 'Tabela de Configuração';
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CONFIG" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_CRL
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_CRL" 
   (	"DS_DISTRIBUTION_POINT" VARCHAR2(255 CHAR), 
	"DS_SERIAL_NUMBER" VARCHAR2(150 CHAR), 
	"DS_CRL_DATA" CLOB, 
	"ID_AUTHORITY_KEY" CHAR(40 CHAR), 
	"NB_NEXT_UPDATE_DATE" TIMESTAMP (6), 
	"NB_THIS_UPDATE_DATE" TIMESTAMP (6), 
	"DS_HASH" VARCHAR2(512 BYTE), 
	"FL_COMPRESSED" CHAR(1 BYTE), 
	"ID_ALGORITMO" NUMBER(*,0), 
	"ID_CRL" NUMBER(20,0), 
	"ID_CERTIFICATE" NUMBER(20,0), 
	"DS_ISSUER" VARCHAR2(255 CHAR)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."DS_DISTRIBUTION_POINT" IS 'URL do Distribution Point da CRL';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."DS_SERIAL_NUMBER" IS 'Serial Number da CRL.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."DS_CRL_DATA" IS 'CRL no formato base64.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."ID_AUTHORITY_KEY" IS 'Key Identifier do campo Authority Key Identifier da CRL.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."NB_NEXT_UPDATE_DATE" IS 'Data da próxima publicação da CRL.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."NB_THIS_UPDATE_DATE" IS 'Data da geração da CRL.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."DS_HASH" IS 'Hash do CRL';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."FL_COMPRESSED" IS 'Indica se CRL está amazenada de forma comprimida: 1 - Sim 0 - Não';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."ID_ALGORITMO" IS 'Algoritmo usado para geral o hash da CRL';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."ID_CRL" IS 'Identificador único da CRL.';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."ID_CERTIFICATE" IS 'Identificador de referência ao certificado na tabela de certificados (TBJS_CERTIFICATE).';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_CRL"."DS_ISSUER" IS 'Identificador do emissor do certificado.';
 
   COMMENT ON TABLE "DBJS04"."TBJS_CRL"  IS 'Tabela responsável por armazenar os CRLs';
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CRL" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_ESTADO_CHAVE
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_ESTADO_CHAVE" 
   (	"ID_ESTADO_CHAVE" NUMBER(*,0), 
	"NM_ESTADO_CHAVE" VARCHAR2(10 BYTE), 
	"DS_ESTADO_CHAVE" VARCHAR2(255 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_ESTADO_CHAVE"."ID_ESTADO_CHAVE" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_ESTADO_CHAVE"."NM_ESTADO_CHAVE" IS 'Nome do estado';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_ESTADO_CHAVE"."DS_ESTADO_CHAVE" IS 'Descrição do estado da chave';
   
   COMMENT ON TABLE "DBJS04"."TBJS_ESTADO_CHAVE"  IS 'Tabela que armazena os tipos de estado que a chave pode possuir.';   
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_ESTADO_CHAVE" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_FLUXO
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_FLUXO" 
   (	"ID_FLUXO" NUMBER(*,0), 
	"NM_FLUXO" VARCHAR2(255 BYTE), 
	"DS_FLUXO" VARCHAR2(255 BYTE), 
	"FL_REQUIRE_CLIENT_AUTH" CHAR(1 BYTE) DEFAULT '0', 
	"DS_THUMBPRINT_CLIENT_AUTH" VARCHAR2(40 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_FLUXO"."ID_FLUXO" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_FLUXO"."NM_FLUXO" IS 'Nome do Fluxo/Aplicação';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_FLUXO"."DS_FLUXO" IS 'Descrição do Fluxo/Aplicação';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_FLUXO"."FL_REQUIRE_CLIENT_AUTH" IS 'Flag que indica se o cliente precisa se autenticar (certificado digital)';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_FLUXO"."DS_THUMBPRINT_CLIENT_AUTH" IS 'Hash SHA-1 do certificado cliente';
   
   COMMENT ON TABLE "DBJS04"."TBJS_FLUXO"  IS 'Tabela que armazena o fluxo utilizado.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_FLUXO" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_FLUXO_CHAVE
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_FLUXO_CHAVE" 
   (	"ID_CHAVE" NUMBER(*,0), 
	"ID_FLUXO" NUMBER(*,0)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_FLUXO_CHAVE"."ID_CHAVE" IS 'Índice da chave privada, da tabela TBJS_CHAVE';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_FLUXO_CHAVE"."ID_FLUXO" IS 'Índice da aplicação, da tabela TBJS_FLUXO';
   
   COMMENT ON TABLE "DBJS04"."TBJS_FLUXO_CHAVE"  IS 'Tabela que armazena a associação do fluxo utilizado com a chave utilizada.';   
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_FLUXO_CHAVE" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_HIST_TRANS_CONTEXTO
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" 
   (	"ID_TRANSACAO" NUMBER(*,0), 
	"DS_BUFFER_REQUISICAO" CLOB, 
	"DS_BUFFER_RESPOSTA" CLOB
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_HIST_TRANS_CONTEXTO"."ID_TRANSACAO" IS 'Índice na tabela TBJS_TRANSACAO_CONTEXTO';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_HIST_TRANS_CONTEXTO"."DS_BUFFER_REQUISICAO" IS 'Buffer de requisição';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_HIST_TRANS_CONTEXTO"."DS_BUFFER_RESPOSTA" IS 'Buffer de resposta';
   
   COMMENT ON TABLE "DBJS04"."TBJS_HIST_TRANS_CONTEXTO"  IS 'Tabela que armazena o histórico de transações realizadas.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_REGRA
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_REGRA" 
   (	"ID_REGRA" NUMBER(*,0), 
	"ID_TIPO_REGRA" NUMBER(*,0), 
	"NM_REGRA" VARCHAR2(50 BYTE), 
	"DS_REGRA" VARCHAR2(255 BYTE), 
	"XML_REGRA" CLOB
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_REGRA"."ID_REGRA" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_REGRA"."ID_TIPO_REGRA" IS 'Tipo da política, da tabela TBJS_TIPO_REGRA';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_REGRA"."NM_REGRA" IS 'Nome usado pela aplicação cliente identificar a política';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_REGRA"."DS_REGRA" IS 'Descrição da política';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_REGRA"."XML_REGRA" IS 'XML com a configuração da política';
   
   COMMENT ON TABLE "DBJS04"."TBJS_REGRA"  IS 'Tabela que armazena as políticas utilizadas.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_REGRA" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_SERVIDOR
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_SERVIDOR" 
   (	"ID_SERVIDOR" NUMBER(*,0), 
	"DS_NOME" VARCHAR2(255 BYTE), 
	"FL_ATUALIZAR_CONFIG" CHAR(1 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_SERVIDOR"."ID_SERVIDOR" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_SERVIDOR"."DS_NOME" IS 'Nome do servidor (toda máquina onde o WSCrypto é executado fica registrado nesta tabela)';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_SERVIDOR"."FL_ATUALIZAR_CONFIG" IS 'Quando alguma configuração é modificada no Manager, este flag é ativado para que o WSCrypto recarregue as configurações';
   
   COMMENT ON TABLE "DBJS04"."TBJS_SERVIDOR"  IS 'Tabela que armazena os dados dos servidores utilizados.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_SERVIDOR" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_TIPO_REGRA
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_TIPO_REGRA" 
   (	"ID_TIPO_REGRA" NUMBER(*,0), 
	"NM_TIPO_REGRA" VARCHAR2(50 BYTE), 
	"DS_TIPO_REGRA" VARCHAR2(255 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_TIPO_REGRA"."ID_TIPO_REGRA" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TIPO_REGRA"."NM_TIPO_REGRA" IS 'Nome da política, ToDo ou Response';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TIPO_REGRA"."DS_TIPO_REGRA" IS 'Descrição do tipo';
   
   COMMENT ON TABLE "DBJS04"."TBJS_TIPO_REGRA"  IS 'Tabela que armazena os tipos de regra.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TIPO_REGRA" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_TRANSACAO_ASSINATURA
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" 
   (	"ID_TRANSACAO" NUMBER(*,0), 
	"ID_DOCUMENTO" NUMBER(*,0), 
	"ID_ASSINATURA" NUMBER(*,0), 
	"DS_ASSINATURA" VARCHAR2(255 BYTE), 
	"DS_NOME_CHAVE" VARCHAR2(50 BYTE), 
	"DS_CPF" VARCHAR2(11 CHAR), 
	"DS_SUJEITO" VARCHAR2(255 BYTE), 
	"ID_ESTADO" NUMBER(*,0)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ASSINATURA"."ID_TRANSACAO" IS 'Índice na tabela TBJS_TRANSACAO_DOCUMENTO';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ASSINATURA"."ID_DOCUMENTO" IS 'Índice na tabela TBJS_TRANSACAO_DOCUMENTO';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ASSINATURA"."ID_ASSINATURA" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ASSINATURA"."DS_ASSINATURA" IS 'Identificador da assinatura, obtido na requisição (tipo Verify)';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ASSINATURA"."DS_NOME_CHAVE" IS 'Identificador da chave, obtido na requisição (tipo Sign)';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ASSINATURA"."DS_CPF" IS 'CPF do Proprietário do certificado assinante, relativo a chave (tipo Sign)';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ASSINATURA"."DS_SUJEITO" IS 'Sujeito do certificado assinante, relativo a chave (tipo Sign)';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ASSINATURA"."ID_ESTADO" IS 'Estado da assinatura, da tabela TBJS_TRANSACAO_ESTADO';
   
   COMMENT ON TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA"  IS 'Tabela que armazena as transações de assinatura.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_ASSINATURA" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_TRANSACAO_CONTEXTO
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_TRANSACAO_CONTEXTO" 
   (	"ID_TRANSACAO" NUMBER(*,0), 
	"ID_THREAD" NUMBER(*,0), 
	"DS_SERVIDOR" VARCHAR2(255 BYTE), 
	"DS_ORIGEM" VARCHAR2(255 BYTE), 
	"ID_FORMATO" NUMBER(*,0), 
	"DS_BUFFER_REQUISICAO" CLOB, 
	"DT_REQUISICAO" TIMESTAMP (6), 
	"DS_BUFFER_RESPOSTA" CLOB, 
	"DT_RESPOSTA" TIMESTAMP (6)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."ID_TRANSACAO" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."ID_THREAD" IS 'Identificador da thread que processou a requisição';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."DS_SERVIDOR" IS 'Nome do servidor que processou a requisição';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."DS_ORIGEM" IS 'IP de origem da requisição';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."ID_FORMATO" IS 'Formato da requisição, onde 1 = SOAP ; 2 = XML';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."DS_BUFFER_REQUISICAO" IS 'Buffer da requisição';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."DT_REQUISICAO" IS 'Data/Hora do início do processamento';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."DS_BUFFER_RESPOSTA" IS 'Buffer da resposta';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_CONTEXTO"."DT_RESPOSTA" IS 'Data/Hora do término do processamento';
   
   COMMENT ON TABLE "DBJS04"."TBJS_TRANSACAO_CONTEXTO"  IS 'Tabela que armazena o contexto das transações.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_CONTEXTO" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_TRANSACAO_DOCUMENTO
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" 
   (	"ID_TRANSACAO" NUMBER(*,0), 
	"ID_DOCUMENTO" NUMBER(*,0), 
	"DS_DOCUMENTO" VARCHAR2(255 BYTE), 
	"DS_ESTADO" VARCHAR2(1024 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_DOCUMENTO"."ID_TRANSACAO" IS 'Índice na tabela TBJS_TRANSACAO_REQUISICAO';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_DOCUMENTO"."ID_DOCUMENTO" IS 'Índice auto-incremental';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_DOCUMENTO"."DS_DOCUMENTO" IS 'Identificador do documento, obtido da requisição';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_DOCUMENTO"."DS_ESTADO" IS 'Estado do documento, obtido da resposta';
   
   COMMENT ON TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO"  IS 'Tabela que armazena os dados de documentos utilizados em transações.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_TRANSACAO_ESTADO
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_TRANSACAO_ESTADO" 
   (	"ID_ESTADO" NUMBER(*,0), 
	"DS_ESTADO" VARCHAR2(1024 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ESTADO"."ID_ESTADO" IS 'Código de estado da assinatura';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_ESTADO"."DS_ESTADO" IS 'Descrição do estado';
   
   COMMENT ON TABLE "DBJS04"."TBJS_TRANSACAO_ESTADO"  IS 'Tabela que armazena os tipos de estado que uma assinatura pode possuir.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_ESTADO" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_TRANSACAO_FUNCAO
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_TRANSACAO_FUNCAO" 
   (	"ID_FUNCAO" NUMBER(*,0), 
	"DS_FUNCAO" VARCHAR2(50 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_FUNCAO"."ID_FUNCAO" IS 'Índice da função, onde 1 = Sign; 2 = Verify';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_FUNCAO"."DS_FUNCAO" IS 'Descrição da função';
   
   COMMENT ON TABLE "DBJS04"."TBJS_TRANSACAO_FUNCAO"  IS 'Tabela que armazena os tipos de função que uma requisição pode possuir.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_FUNCAO" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_TRANSACAO_REQUISICAO
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" 
   (	"ID_TRANSACAO" NUMBER(*,0), 
	"ID_FUNCAO" NUMBER(*,0), 
	"DS_APLICACAO" VARCHAR2(50 BYTE), 
	"DS_POLITICA_TODO" VARCHAR2(50 BYTE), 
	"DS_POLITICA_RESPONSE" VARCHAR2(50 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_REQUISICAO"."ID_TRANSACAO" IS 'Índice na tabela TBJS_TRANSACAO_CONTEXTO';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_REQUISICAO"."ID_FUNCAO" IS 'Indica a função executada, de acordo com tabela TBJS_TRANSACAO_FUNCAO';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_REQUISICAO"."DS_APLICACAO" IS 'Nome da aplicação requisitante';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_REQUISICAO"."DS_POLITICA_TODO" IS 'Nome da política de ToDo';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_REQUISICAO"."DS_POLITICA_RESPONSE" IS 'Nome da política de Response';
   
   COMMENT ON TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO"  IS 'Tabela que armazena as requisições realizadas.';   
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_REQUISICAO" TO "JS00001";
--------------------------------------------------------
--  DDL for Table TBJS_TRANSACAO_RESPOSTA
--------------------------------------------------------

  CREATE TABLE "DBJS04"."TBJS_TRANSACAO_RESPOSTA" 
   (	"ID_TRANSACAO" NUMBER(*,0), 
	"ID_ESTADO" NUMBER(*,0), 
	"DS_ESTADO" VARCHAR2(1024 BYTE)
   );
 

   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_RESPOSTA"."ID_TRANSACAO" IS 'Índice na tabela TBJS_TRANSACAO_CONTEXTO';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_RESPOSTA"."ID_ESTADO" IS 'Estado da transação (MessageStatus)';
 
   COMMENT ON COLUMN "DBJS04"."TBJS_TRANSACAO_RESPOSTA"."DS_ESTADO" IS 'Descrição do estado da transação';
   
   COMMENT ON TABLE "DBJS04"."TBJS_TRANSACAO_RESPOSTA"  IS 'Tabela que armazena as respostas enviadas.';
   
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_RESPOSTA" TO "JS00001";
--------------------------------------------------------
--  DDL for Index PK_TBJS_CERTIFICATE
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_CERTIFICATE" ON "DBJS04"."TBJS_CERTIFICATE" ("ID_CERTIFICATE");
--------------------------------------------------------
--  DDL for Index PK_TBJS_CHAVE
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_CHAVE" ON "DBJS04"."TBJS_CHAVE" ("ID_CHAVE");
--------------------------------------------------------
--  DDL for Index PK_TBJS_CRL
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_CRL" ON "DBJS04"."TBJS_CRL" ("DS_DISTRIBUTION_POINT", "ID_AUTHORITY_KEY", "DS_SERIAL_NUMBER");
--------------------------------------------------------
--  DDL for Index PK_TBJS_ESTADO_CHAVE
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_ESTADO_CHAVE" ON "DBJS04"."TBJS_ESTADO_CHAVE" ("ID_ESTADO_CHAVE");
--------------------------------------------------------
--  DDL for Index PK_TBJS_FLUXO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_FLUXO" ON "DBJS04"."TBJS_FLUXO" ("ID_FLUXO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_FLUXO_CHAVE
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_FLUXO_CHAVE" ON "DBJS04"."TBJS_FLUXO_CHAVE" ("ID_CHAVE", "ID_FLUXO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_HIST_TRANS_CONTEXTO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_HIST_TRANS_CONTEXTO" ON "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" ("ID_TRANSACAO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_REGRA
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_REGRA" ON "DBJS04"."TBJS_REGRA" ("ID_REGRA");
--------------------------------------------------------
--  DDL for Index PK_TBJS_SERVIDOR
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_SERVIDOR" ON "DBJS04"."TBJS_SERVIDOR" ("ID_SERVIDOR");
--------------------------------------------------------
--  DDL for Index PK_TBJS_TIPO_REGRA
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_TIPO_REGRA" ON "DBJS04"."TBJS_TIPO_REGRA" ("ID_TIPO_REGRA");
--------------------------------------------------------
--  DDL for Index PK_TBJS_TRANSACAO_ASSINATURA
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_TRANSACAO_ASSINATURA" ON "DBJS04"."TBJS_TRANSACAO_ASSINATURA" ("ID_ASSINATURA");
--------------------------------------------------------
--  DDL for Index PK_TBJS_TRANSACAO_CONTEXTO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_TRANSACAO_CONTEXTO" ON "DBJS04"."TBJS_TRANSACAO_CONTEXTO" ("ID_TRANSACAO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_TRANSACAO_DOCUMENTO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_TRANSACAO_DOCUMENTO" ON "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" ("ID_DOCUMENTO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_TRANSACAO_ESTADO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_TRANSACAO_ESTADO" ON "DBJS04"."TBJS_TRANSACAO_ESTADO" ("ID_ESTADO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_TRANSACAO_FUNCAO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_TRANSACAO_FUNCAO" ON "DBJS04"."TBJS_TRANSACAO_FUNCAO" ("ID_FUNCAO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_TRANSACAO_REQUISICAO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_TRANSACAO_REQUISICAO" ON "DBJS04"."TBJS_TRANSACAO_REQUISICAO" ("ID_TRANSACAO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_TRANSACAO_RESPOSTA
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_TRANSACAO_RESPOSTA" ON "DBJS04"."TBJS_TRANSACAO_RESPOSTA" ("ID_TRANSACAO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_ALGORITMO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_ALGORITMO" ON "DBJS04"."TBJS_ALGORITMO" ("ID_ALGORITMO");
--------------------------------------------------------
--  DDL for Index PK_TBJS_CACHE_CHAVE
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."PK_TBJS_CACHE_CHAVE" ON "DBJS04"."TBJS_CACHE_CHAVE" ("ID_CHAVE");
--------------------------------------------------------
--  DDL for Index UK_TBJS_CERTIFICATE
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."UK_TBJS_CERTIFICATE" ON "DBJS04"."TBJS_CERTIFICATE" ("ID_AUTHORITY_KEY", "ID_SUBJECT_KEY", "NB_VALID_FROM_DATE", "NB_VALID_TO_DATE", "DS_SERIAL_NUMBER");
--------------------------------------------------------
--  DDL for Index UK_TBJS_CHAVE
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."UK_TBJS_CHAVE" ON "DBJS04"."TBJS_CHAVE" ("NM_CHAVE", "SUJEITO", "THUMBPRINT");
--------------------------------------------------------
--  DDL for Index UK_TBJS_ESTADO_CHAVE
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."UK_TBJS_ESTADO_CHAVE" ON "DBJS04"."TBJS_ESTADO_CHAVE" ("NM_ESTADO_CHAVE");
--------------------------------------------------------
--  DDL for Index UK_TBJS_TIPO_REGRA
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."UK_TBJS_TIPO_REGRA" ON "DBJS04"."TBJS_TIPO_REGRA" ("NM_TIPO_REGRA");
--------------------------------------------------------
--  DDL for Index UK_TBJS_TRANSACAO_DOCUMENTO
--------------------------------------------------------

  CREATE UNIQUE INDEX "DBJS04"."UK_TBJS_TRANSACAO_DOCUMENTO" ON "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" ("ID_TRANSACAO", "ID_DOCUMENTO");
--------------------------------------------------------
--  Constraints for Table TBJS_ALGORITMO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_ALGORITMO" MODIFY ("ID_ALGORITMO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_ALGORITMO" MODIFY ("NM_ALGORITMO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_ALGORITMO" ADD CONSTRAINT "PK_TBJS_ALGORITMO" PRIMARY KEY ("ID_ALGORITMO");
  
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_ALGORITMO" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_CACHE_CHAVE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CACHE_CHAVE" MODIFY ("ID_CHAVE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CACHE_CHAVE" ADD CONSTRAINT "PK_TBJS_CACHE_CHAVE" PRIMARY KEY ("ID_CHAVE");
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CACHE_CHAVE" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_CERTIFICATE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" ADD CONSTRAINT "PK_TBJS_CERTIFICATE" PRIMARY KEY ("ID_CERTIFICATE");
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" MODIFY ("ID_CERTIFICATE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" MODIFY ("ID_AUTHORITY_KEY" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" MODIFY ("NB_VALID_FROM_DATE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" MODIFY ("NB_VALID_TO_DATE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" MODIFY ("DS_SERIAL_NUMBER" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" MODIFY ("TP_CERTIFICATE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" MODIFY ("DS_HASH" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" MODIFY ("ID_ALGORITMO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" ADD CONSTRAINT "CK_TBJS_CERTIFICATE" CHECK (TP_CERTIFICATE IN ('F','I','R')) ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" ADD CONSTRAINT "UK_TBJS_CERTIFICATE" UNIQUE ("ID_AUTHORITY_KEY", "ID_SUBJECT_KEY", "NB_VALID_FROM_DATE", "NB_VALID_TO_DATE", "DS_SERIAL_NUMBER");
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CERTIFICATE" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_CHAVE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CHAVE" ADD CONSTRAINT "CK_TBJS_CHAVE" CHECK (TP_LOCAL_ARMAZENAMENTO IN ('BD','SO','HSM','HSMS')) ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" ADD CONSTRAINT "PK_TBJS_CHAVE" PRIMARY KEY ("ID_CHAVE");
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" MODIFY ("ID_CHAVE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" MODIFY ("ID_ESTADO_CHAVE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" MODIFY ("TICKET_COUNT" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" MODIFY ("PIN_COUNT" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" MODIFY ("TP_LOCAL_ARMAZENAMENTO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" MODIFY ("TP_ATIVACAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" ADD CONSTRAINT "CK2_TBJS_CHAVE" CHECK (TP_ATIVACAO     IN ('P','D','S')) ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" ADD CONSTRAINT "UK_TBJS_CHAVE" UNIQUE ("NM_CHAVE", "SUJEITO", "THUMBPRINT");
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CHAVE" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_CONFIG
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CONFIG" ADD CONSTRAINT "CK1_TBJS_CONFIG" CHECK ( TICKET_MAX BETWEEN 1 AND 16) ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CONFIG" ADD CONSTRAINT "CK2_TBJS_CONFIG" CHECK ( PIN_MAX BETWEEN 1 AND 16) ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CONFIG" ADD CONSTRAINT "CK3_TBJS_CONFIG" CHECK ( FL_USE_TICKET IN ('0', '1')) ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CONFIG" MODIFY ("TICKET_MAX" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CONFIG" MODIFY ("PIN_MAX" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CONFIG" MODIFY ("FL_USE_TICKET" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CONFIG" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_CRL
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CRL" ADD CONSTRAINT "PK_TBJS_CRL" PRIMARY KEY ("DS_DISTRIBUTION_POINT", "ID_AUTHORITY_KEY", "DS_SERIAL_NUMBER");
 
  ALTER TABLE "DBJS04"."TBJS_CRL" MODIFY ("DS_DISTRIBUTION_POINT" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CRL" MODIFY ("DS_SERIAL_NUMBER" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CRL" MODIFY ("ID_AUTHORITY_KEY" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CRL" MODIFY ("NB_NEXT_UPDATE_DATE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CRL" MODIFY ("NB_THIS_UPDATE_DATE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CRL" MODIFY ("DS_HASH" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CRL" MODIFY ("FL_COMPRESSED" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_CRL" MODIFY ("ID_ALGORITMO" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CRL" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_ESTADO_CHAVE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_ESTADO_CHAVE" ADD CONSTRAINT "PK_TBJS_ESTADO_CHAVE" PRIMARY KEY ("ID_ESTADO_CHAVE");
 
  ALTER TABLE "DBJS04"."TBJS_ESTADO_CHAVE" MODIFY ("ID_ESTADO_CHAVE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_ESTADO_CHAVE" MODIFY ("NM_ESTADO_CHAVE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_ESTADO_CHAVE" ADD CONSTRAINT "UK_TBJS_ESTADO_CHAVE" UNIQUE ("NM_ESTADO_CHAVE");
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_ESTADO_CHAVE" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_FLUXO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_FLUXO" ADD CONSTRAINT "CK_TBJS_FLUXO" CHECK ( FL_REQUIRE_CLIENT_AUTH IN ('0', '1')) ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_FLUXO" ADD CONSTRAINT "PK_TBJS_FLUXO" PRIMARY KEY ("ID_FLUXO");
 
  ALTER TABLE "DBJS04"."TBJS_FLUXO" MODIFY ("ID_FLUXO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_FLUXO" MODIFY ("NM_FLUXO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_FLUXO" MODIFY ("FL_REQUIRE_CLIENT_AUTH" NOT NULL ENABLE);
 
  --ALTER TABLE "DBJS04"."TBJS_FLUXO" MODIFY ("DS_THUMBPRINT_CLIENT_AUTH" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_FLUXO" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_FLUXO_CHAVE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_FLUXO_CHAVE" ADD CONSTRAINT "PK_TBJS_FLUXO_CHAVE" PRIMARY KEY ("ID_CHAVE", "ID_FLUXO");
 
  ALTER TABLE "DBJS04"."TBJS_FLUXO_CHAVE" MODIFY ("ID_CHAVE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_FLUXO_CHAVE" MODIFY ("ID_FLUXO" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_FLUXO_CHAVE" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_HIST_TRANS_CONTEXTO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" ADD CONSTRAINT "PK_TBJS_HIST_TRANS_CONTEXTO" PRIMARY KEY ("ID_TRANSACAO");
 
  ALTER TABLE "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" MODIFY ("ID_TRANSACAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" MODIFY ("DS_BUFFER_REQUISICAO" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_REGRA
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_REGRA" ADD CONSTRAINT "PK_TBJS_REGRA" PRIMARY KEY ("ID_REGRA");
 
  ALTER TABLE "DBJS04"."TBJS_REGRA" MODIFY ("ID_REGRA" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_REGRA" MODIFY ("ID_TIPO_REGRA" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_REGRA" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_SERVIDOR
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_SERVIDOR" ADD CONSTRAINT "CK_TBJS_SERVIDOR" CHECK ( FL_ATUALIZAR_CONFIG IN ('0', '1')) ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_SERVIDOR" ADD CONSTRAINT "PK_TBJS_SERVIDOR" PRIMARY KEY ("ID_SERVIDOR");
 
  ALTER TABLE "DBJS04"."TBJS_SERVIDOR" MODIFY ("ID_SERVIDOR" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_SERVIDOR" MODIFY ("DS_NOME" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_SERVIDOR" MODIFY ("FL_ATUALIZAR_CONFIG" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_SERVIDOR" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_TIPO_REGRA
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TIPO_REGRA" ADD CONSTRAINT "PK_TBJS_TIPO_REGRA" PRIMARY KEY ("ID_TIPO_REGRA");
 
  ALTER TABLE "DBJS04"."TBJS_TIPO_REGRA" MODIFY ("ID_TIPO_REGRA" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TIPO_REGRA" MODIFY ("NM_TIPO_REGRA" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TIPO_REGRA" ADD CONSTRAINT "UK_TBJS_TIPO_REGRA" UNIQUE ("NM_TIPO_REGRA");
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TIPO_REGRA" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_TRANSACAO_ASSINATURA
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" ADD CONSTRAINT "PK_TBJS_TRANSACAO_ASSINATURA" PRIMARY KEY ("ID_ASSINATURA");
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" MODIFY ("ID_TRANSACAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" MODIFY ("ID_DOCUMENTO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" MODIFY ("ID_ASSINATURA" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" MODIFY ("DS_ASSINATURA" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" MODIFY ("DS_NOME_CHAVE" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" MODIFY ("DS_CPF" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" MODIFY ("DS_SUJEITO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" MODIFY ("ID_ESTADO" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_ASSINATURA" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_TRANSACAO_CONTEXTO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_CONTEXTO" ADD CONSTRAINT "PK_TBJS_TRANSACAO_CONTEXTO" PRIMARY KEY ("ID_TRANSACAO");
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_CONTEXTO" MODIFY ("ID_TRANSACAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_CONTEXTO" MODIFY ("ID_THREAD" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_CONTEXTO" MODIFY ("DS_SERVIDOR" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_CONTEXTO" MODIFY ("DT_REQUISICAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_CONTEXTO" MODIFY ("DT_RESPOSTA" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_CONTEXTO" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_TRANSACAO_DOCUMENTO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" ADD CONSTRAINT "PK_TBJS_TRANSACAO_DOCUMENTO" PRIMARY KEY ("ID_DOCUMENTO");
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" MODIFY ("ID_TRANSACAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" MODIFY ("ID_DOCUMENTO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" MODIFY ("DS_DOCUMENTO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" MODIFY ("DS_ESTADO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" ADD CONSTRAINT "UK_TBJS_TRANSACAO_DOCUMENTO" UNIQUE ("ID_TRANSACAO", "ID_DOCUMENTO");
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_TRANSACAO_ESTADO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ESTADO" ADD CONSTRAINT "PK_TBJS_TRANSACAO_ESTADO" PRIMARY KEY ("ID_ESTADO");
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ESTADO" MODIFY ("ID_ESTADO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ESTADO" MODIFY ("DS_ESTADO" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_ESTADO" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_TRANSACAO_FUNCAO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_FUNCAO" ADD CONSTRAINT "PK_TBJS_TRANSACAO_FUNCAO" PRIMARY KEY ("ID_FUNCAO");
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_FUNCAO" MODIFY ("ID_FUNCAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_FUNCAO" MODIFY ("DS_FUNCAO" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_FUNCAO" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_TRANSACAO_REQUISICAO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" ADD CONSTRAINT "PK_TBJS_TRANSACAO_REQUISICAO" PRIMARY KEY ("ID_TRANSACAO");
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" MODIFY ("ID_TRANSACAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" MODIFY ("ID_FUNCAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" MODIFY ("DS_APLICACAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" MODIFY ("DS_POLITICA_TODO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" MODIFY ("DS_POLITICA_RESPONSE" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_REQUISICAO" TO "JS00001";
--------------------------------------------------------
--  Constraints for Table TBJS_TRANSACAO_RESPOSTA
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_RESPOSTA" ADD CONSTRAINT "PK_TBJS_TRANSACAO_RESPOSTA" PRIMARY KEY ("ID_TRANSACAO");
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_RESPOSTA" MODIFY ("ID_TRANSACAO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_RESPOSTA" MODIFY ("ID_ESTADO" NOT NULL ENABLE);
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_RESPOSTA" MODIFY ("DS_ESTADO" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_RESPOSTA" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_ALGORITMO" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_CACHE_CHAVE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CACHE_CHAVE" ADD CONSTRAINT "FK1_TBJS_CACHE_CHAVE_TBJS_CHA" FOREIGN KEY ("ID_CHAVE")
	  REFERENCES "DBJS04"."TBJS_CHAVE" ("ID_CHAVE") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CACHE_CHAVE" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_CERTIFICATE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" ADD CONSTRAINT "FK1_TBJS_CERTIFICATE" FOREIGN KEY ("ID_CERTIFICATE_P")
	  REFERENCES "DBJS04"."TBJS_CERTIFICATE" ("ID_CERTIFICATE") ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CERTIFICATE" ADD CONSTRAINT "FK_TBJS_CERTIFICATE_TBJS_ALG" FOREIGN KEY ("ID_ALGORITMO")
	  REFERENCES "DBJS04"."TBJS_ALGORITMO" ("ID_ALGORITMO") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CERTIFICATE" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_CHAVE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CHAVE" ADD CONSTRAINT "FK_TBJS_CHAVE_TBJS_CERTIFICATE" FOREIGN KEY ("ID_CERTIFICATE")
	  REFERENCES "DBJS04"."TBJS_CERTIFICATE" ("ID_CERTIFICATE") ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CHAVE" ADD CONSTRAINT "FK_TBJS_CHAVE_TBJS_ESTADO_CH" FOREIGN KEY ("ID_ESTADO_CHAVE")
	  REFERENCES "DBJS04"."TBJS_ESTADO_CHAVE" ("ID_ESTADO_CHAVE") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CHAVE" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CONFIG" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_CRL
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_CRL" ADD CONSTRAINT "FK1_TBJS_CRL" FOREIGN KEY ("ID_CERTIFICATE")
	  REFERENCES "DBJS04"."TBJS_CERTIFICATE" ("ID_CERTIFICATE") ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_CRL" ADD CONSTRAINT "FK_TBJS_CRL" FOREIGN KEY ("ID_ALGORITMO")
	  REFERENCES "DBJS04"."TBJS_ALGORITMO" ("ID_ALGORITMO") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_CRL" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_ESTADO_CHAVE" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_FLUXO" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_FLUXO_CHAVE
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_FLUXO_CHAVE" ADD CONSTRAINT "FK1_TBJS_FLUXO_CHAVE" FOREIGN KEY ("ID_CHAVE")
	  REFERENCES "DBJS04"."TBJS_CHAVE" ("ID_CHAVE") ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_FLUXO_CHAVE" ADD CONSTRAINT "FK2_TBJS_FLUXO_CHAVE" FOREIGN KEY ("ID_FLUXO")
	  REFERENCES "DBJS04"."TBJS_FLUXO" ("ID_FLUXO") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_FLUXO_CHAVE" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_HIST_TRANS_CONTEXTO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" ADD CONSTRAINT "FK_TBJS_HIST_TRANS_CONTEXTO" FOREIGN KEY ("ID_TRANSACAO")
	  REFERENCES "DBJS04"."TBJS_TRANSACAO_CONTEXTO" ("ID_TRANSACAO") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_HIST_TRANS_CONTEXTO" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_REGRA
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_REGRA" ADD CONSTRAINT "FK_TBJS_REGRA_TBJS_TIPO_REGR" FOREIGN KEY ("ID_TIPO_REGRA")
	  REFERENCES "DBJS04"."TBJS_TIPO_REGRA" ("ID_TIPO_REGRA") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_REGRA" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_SERVIDOR" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TIPO_REGRA" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_TRANSACAO_ASSINATURA
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" ADD CONSTRAINT "FK1_TBJS_TRANSACAO_ASSINATURA" FOREIGN KEY ("ID_TRANSACAO", "ID_DOCUMENTO")
	  REFERENCES "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" ("ID_TRANSACAO", "ID_DOCUMENTO") ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_ASSINATURA" ADD CONSTRAINT "FK2_TBJS_TRANSACAO_ASSINATURA" FOREIGN KEY ("ID_ESTADO")
	  REFERENCES "DBJS04"."TBJS_TRANSACAO_ESTADO" ("ID_ESTADO") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_ASSINATURA" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_CONTEXTO" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_TRANSACAO_DOCUMENTO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" ADD CONSTRAINT "FK_TBJS_TRANSACAO_DOCUMENTO" FOREIGN KEY ("ID_TRANSACAO")
	  REFERENCES "DBJS04"."TBJS_TRANSACAO_CONTEXTO" ("ID_TRANSACAO") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_DOCUMENTO" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_ESTADO" TO "JS00001";
GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_FUNCAO" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_TRANSACAO_REQUISICAO
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" ADD CONSTRAINT "FK1_TBJS_TRANSACAO_REQUISICAO" FOREIGN KEY ("ID_TRANSACAO")
	  REFERENCES "DBJS04"."TBJS_TRANSACAO_CONTEXTO" ("ID_TRANSACAO") ENABLE;
 
  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_REQUISICAO" ADD CONSTRAINT "FK2_TBJS_TRANSACAO_REQUISICAO" FOREIGN KEY ("ID_FUNCAO")
	  REFERENCES "DBJS04"."TBJS_TRANSACAO_FUNCAO" ("ID_FUNCAO") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_REQUISICAO" TO "JS00001";
--------------------------------------------------------
--  Ref Constraints for Table TBJS_TRANSACAO_RESPOSTA
--------------------------------------------------------

  ALTER TABLE "DBJS04"."TBJS_TRANSACAO_RESPOSTA" ADD CONSTRAINT "FK1_TBJS_TRANSACAO_RESPOSTA" FOREIGN KEY ("ID_TRANSACAO")
	  REFERENCES "DBJS04"."TBJS_TRANSACAO_CONTEXTO" ("ID_TRANSACAO") ENABLE;
  GRANT DELETE, INSERT, SELECT, UPDATE ON "DBJS04"."TBJS_TRANSACAO_RESPOSTA" TO "JS00001";
--------------------------------------------------------
--  DDL for Procedure SP_LIMPA_TRANSACOES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "DBJS04"."SP_LIMPA_TRANSACOES" 
(
  P_DIAS IN NUMBER  
, P_LINHAS OUT NUMBER  
) AS 
BEGIN
  
  -- REMOVENDO TBJS_TRANSACAO_ASSINATURA
  DELETE FROM DBJS04.TBJS_TRANSACAO_ASSINATURA
  WHERE (ID_TRANSACAO, ID_DOCUMENTO) IN 
    (SELECT ID_TRANSACAO, ID_DOCUMENTO
     FROM DBJS04.TBJS_TRANSACAO_DOCUMENTO
     WHERE ID_TRANSACAO IN 
      (SELECT ID_TRANSACAO 
       FROM DBJS04.TBJS_TRANSACAO_CONTEXTO
       WHERE DT_REQUISICAO < SYSTIMESTAMP - P_DIAS
      )
    );
    
  DBMS_OUTPUT.put_line(TO_CHAR(SQL%ROWCOUNT)||' rows deleted');
  
  -- REMOVENDO TBJS_TRANSACAO_DOCUMENTO
  DELETE FROM DBJS04.TBJS_TRANSACAO_DOCUMENTO
  WHERE ID_TRANSACAO IN 
   (SELECT ID_TRANSACAO 
    FROM DBJS04.TBJS_TRANSACAO_CONTEXTO
    WHERE DT_REQUISICAO < SYSTIMESTAMP - P_DIAS
   );
  
  DBMS_OUTPUT.put_line(TO_CHAR(SQL%ROWCOUNT)||' rows deleted');
  
  -- REMOVENDO TBJS_TRANSACAO_RESPOSTA
  DELETE FROM DBJS04.TBJS_TRANSACAO_RESPOSTA
  WHERE ID_TRANSACAO IN 
   (SELECT ID_TRANSACAO 
    FROM DBJS04.TBJS_TRANSACAO_CONTEXTO
    WHERE DT_REQUISICAO < SYSTIMESTAMP - P_DIAS
   );
  
  DBMS_OUTPUT.put_line(TO_CHAR(SQL%ROWCOUNT)||' rows deleted');
   
  -- REMOVENDO TBJS_TRANSACAO_REQUISICAO
  DELETE FROM DBJS04.TBJS_TRANSACAO_REQUISICAO 
  WHERE ID_TRANSACAO IN 
   (SELECT ID_TRANSACAO 
    FROM DBJS04.TBJS_TRANSACAO_CONTEXTO
    WHERE DT_REQUISICAO < SYSTIMESTAMP - P_DIAS
   );
  
  DBMS_OUTPUT.put_line(TO_CHAR(SQL%ROWCOUNT)||' rows deleted');
  
  -- REMOVENDO TBJS_TRANSACAO_CONTEXTO
  DELETE FROM DBJS04.TBJS_TRANSACAO_CONTEXTO
  WHERE DT_REQUISICAO < SYSTIMESTAMP - P_DIAS;
  
  DBMS_OUTPUT.put_line(TO_CHAR(SQL%ROWCOUNT)||' rows deleted');
  
  P_LINHAS := SQL%ROWCOUNT;
  
  COMMIT;
END SP_LIMPA_TRANSACOES;

/
--------------------------------------------------------
--  DDL for Synonymn DBMS_OUTPUT
--------------------------------------------------------

  CREATE OR REPLACE PUBLIC SYNONYM "DBMS_OUTPUT" FOR "SYS"."DBMS_OUTPUT";

  
  
  
  Insert into DBJS04.TBJS_ALGORITMO (ID_ALGORITMO,NM_ALGORITMO) values (1,'SHA-1');
Insert into DBJS04.TBJS_ALGORITMO (ID_ALGORITMO,NM_ALGORITMO) values (2,'SHA-256');
Insert into DBJS04.TBJS_ALGORITMO (ID_ALGORITMO,NM_ALGORITMO) values (3,'SHA-512');
Insert into DBJS04.TBJS_ALGORITMO (ID_ALGORITMO,NM_ALGORITMO) values (4,'MD5');
Insert into DBJS04.TBJS_ALGORITMO (ID_ALGORITMO,NM_ALGORITMO) values (5,'SHA-224');
Insert into DBJS04.TBJS_ALGORITMO (ID_ALGORITMO,NM_ALGORITMO) values (6,'SHA-384');
COMMIT;

Insert into DBJS04.TBJS_CONFIG (TICKET_MAX,PIN_MAX,FL_USE_TICKET,HR_ATIVACAO_CHAVE,HR_DESATIVACAO_CHAVE,DS_SEMENTE) values (10,10,'0','08:00:00','20:00:00',NULL);
COMMIT;

Insert into DBJS04.TBJS_TIPO_REGRA (ID_TIPO_REGRA,NM_TIPO_REGRA,DS_TIPO_REGRA) values (1,'EXECUÇÃO','Regra de execução para o Servidor Criptografico');
Insert into DBJS04.TBJS_TIPO_REGRA (ID_TIPO_REGRA,NM_TIPO_REGRA,DS_TIPO_REGRA) values (2,'RESPOSTA','Regra de resposta para o Servidor Criptografico');
COMMIT;

Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'EXECUÇÃO'),'VerifyBasicData','VerifyBasicData','<?xml version="1.0" encoding="iso-8859-1"?>  <!DOCTYPE ToDoPolicy SYSTEM "ToDoPolicy.dtd">  <ToDoPolicy policyName="VerifyBasicData">    <Content type="Data" />    <SigningType />    <Package type="None" />    <Certificate insert="Yes" type="EntireChainExceptRoot" restriction="None" verifyChain="Yes" verifyCrl="Yes" verifyOcsp="No" referenceTime="SigningTime" />    <Crl />    <Ocsp />    <TimeStamp type="Local" />    <SigningTime verify="Yes" />    <SignaturePolicyId verify="Yes" type="Basica" />    <SigningCertificate verify="Yes" />  </ToDoPolicy>');
Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'EXECUÇÃO'),'BasicSignedData','BasicSignedData','<?xml version="1.0" encoding="iso-8859-1"?><!DOCTYPE ToDoPolicy SYSTEM "ToDoPolicy.dtd"><ToDoPolicy policyName="BasicSignedData"><Content type="Data" /><SigningType type="Detached" /><Package type="None" /><Certificate insert="Yes" type="EntireChainExceptRoot" restriction="None" verifyChain="Yes" verifyCrl="No" verifyOcsp="No" referenceTime="Now" /><Crl insert="No" verify="No" /><Ocsp verify="No" /><TimeStamp insert="No" type="Local" /><SigningTime insert="Yes" type="Server" /><SignaturePolicyId insert="Yes" type="Basica" /><SigningCertificate insert="Yes" /></ToDoPolicy>');
Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'EXECUÇÃO'),'Mount','Mount','<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE ToDoPolicy SYSTEM "ToDoPolicy.dtd"><ToDoPolicy policyName="Mount"> <Content type="SignedData" /> <SigningType type="Detached" /> <Package type="Mount" /> <TimeStamp insert="Yes" /> <SigningTime insert="Yes" type="Parameter" /></ToDoPolicy>');
Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'EXECUÇÃO'),'EvalRemoteSignature','EvalRemoteSignature','<?xml version="1.0" encoding="iso-8859-1"?>  <!DOCTYPE ToDoPolicy SYSTEM "ToDoPolicy.dtd">  <ToDoPolicy policyName="EvalRemoteSignature">    <SigningType />    <Package type="None" />    <Certificate insert="Yes" type="EntireChainExceptRoot" restriction="None" verifyChain="Yes" verifyCrl="Yes" verifyOcsp="No" referenceTime="Now" />    <Crl verify="No" />    <Ocsp verify="No" />    <TimeStamp />    <SigningTime insert="Yes" type="Server" />    <SignaturePolicyId insert="No" type="None" />    <SigningCertificate insert="Yes" />  </ToDoPolicy>');
COMMIT;
Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'RESPOSTA'),'Sign','Sign','<?xml version="1.0" encoding="iso-8859-1"?><!DOCTYPE ResponsePolicy SYSTEM "ResponsePolicy.dtd"><ResponsePolicy policyName="Sign"><Content /><Signature><Pkcs7 present="Yes" /><Signer present="Yes"><CertificateType present="Yes" /><Issuer present="Yes" /><Subject present="Yes" /><SerialNumber present="Yes" /><ValidFrom present="Yes" /><ValidTo present="Yes" /><Cpf present="Yes" /><Cnpj present="Yes" /><Crl /><Tst /><Ocsp /></Signer></Signature></ResponsePolicy>');
Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'RESPOSTA'),'Verify','Verify', '<?xml version="1.0" encoding="iso-8859-1"?><!DOCTYPE ResponsePolicy SYSTEM "ResponsePolicy.dtd"><ResponsePolicy policyName="Verify"><Content present="Yes" content="SignedData" /><Signature><Pkcs7 present="Yes" /><Mount present="Yes" /><SigningTime present="Yes" /><Signer present="Yes"><Chain present="Yes" /><CertificateType present="Yes" /><Issuer present="Yes" /><Subject present="Yes" /><SerialNumber present="Yes" /><ValidFrom present="Yes" /><ValidTo present="Yes" /><Hash present="Yes" /><Icp_Brasil present="Yes" /><Name present="Yes" /><Cpf present="Yes" /><Cnpj present="Yes" /><SigningTime present="Yes" /><Crl><EffectiveDate present="Yes" /><NextUpdate present="Yes" /><Issuer present="Yes" /></Crl><Tst /><Ocsp><EffectiveDate present="No" /><Issuer present="No" /></Ocsp></Signer></Signature></ResponsePolicy>');
Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'RESPOSTA'),'VerifyAndExtract','VerifyAndExtract', '<?xml version="1.0" encoding="iso-8859-1"?><!DOCTYPE ResponsePolicy SYSTEM "ResponsePolicy.dtd"><ResponsePolicy policyName="VerifyAndExtract"><Content present="Yes" content="SignedData" /><Signature><Signer present="Yes"><CertificateType present="Yes" /><Issuer present="Yes" /><Subject present="Yes" /><SerialNumber present="Yes" /><ValidFrom present="Yes" /><ValidTo present="Yes" /><Cpf present="Yes" /><Cnpj present="Yes" /><Crl /><Tst /><Ocsp /></Signer></Signature></ResponsePolicy>');
Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'RESPOSTA'),'Mount','Mount','<?xml version="1.0" encoding="iso-8859-1"?><!DOCTYPE ResponsePolicy SYSTEM "ResponsePolicy.dtd"><ResponsePolicy policyName="Mount"><Content /><Signature><Pkcs7 present="Yes" /><Signer present="Yes"><Chain present="Yes" /><CertificateType present="Yes" /><Issuer present="Yes" /><Subject present="Yes" /><SerialNumber present="Yes" /><ValidFrom present="Yes" /><ValidTo present="Yes" /><Hash present="Yes" /><Icp_Brasil present="Yes" /><Name present="Yes" /><RazaoSocial present="Yes" /><BirthDate present="Yes" /><Rg present="Yes" /><Cpf present="Yes" /><Cnpj present="Yes" /><SigningTime present="Yes" /><Crl /><Tst /><Ocsp /></Signer></Signature></ResponsePolicy>');
Insert into DBJS04.TBJS_REGRA (ID_REGRA,ID_TIPO_REGRA,NM_REGRA,DS_REGRA,XML_REGRA) values (DBJS04.SEQ_ID_REGRA.NEXTVAL,(SELECT ID_TIPO_REGRA FROM DBJS04.TBJS_TIPO_REGRA WHERE NM_TIPO_REGRA = 'RESPOSTA'),'EvalRemoteSignature','EvalRemoteSignature','<?xml version="1.0" encoding="iso-8859-1"?>  <!DOCTYPE ResponsePolicy SYSTEM "ResponsePolicy.dtd">  <ResponsePolicy policyName="EvalRemoteSignature">    <Content />    <Signature>      <Pkcs7 present="Yes" />      <Signer present="Yes">        <CertificateType present="Yes" />        <Issuer present="Yes" />        <Subject present="Yes" />        <SerialNumber present="Yes" />        <ValidFrom present="Yes" />        <ValidTo present="Yes" />        <Cpf present="Yes" />        <Cnpj present="Yes" />        <Crl />        <Tst />        <Ocsp />      </Signer>    </Signature>  </ResponsePolicy>');
COMMIT;

Insert into DBJS04.TBJS_FLUXO (ID_FLUXO,NM_FLUXO,DS_FLUXO,FL_REQUIRE_CLIENT_AUTH) values (1,'Eval','Eval WSCryptoTester','0');
COMMIT;

Insert into DBJS04.TBJS_ESTADO_CHAVE (ID_ESTADO_CHAVE,NM_ESTADO_CHAVE,DS_ESTADO_CHAVE) values (1,'ATIVO','Chave ativa');
Insert into DBJS04.TBJS_ESTADO_CHAVE (ID_ESTADO_CHAVE,NM_ESTADO_CHAVE,DS_ESTADO_CHAVE) values (2,'INATIVO','Chave inativa');
Insert into DBJS04.TBJS_ESTADO_CHAVE (ID_ESTADO_CHAVE,NM_ESTADO_CHAVE,DS_ESTADO_CHAVE) values (3,'BLOQUEADO','Chave bloqueada');
COMMIT;

Insert into DBJS04.TBJS_TRANSACAO_FUNCAO (ID_FUNCAO,DS_FUNCAO) values (1,'Sign');
Insert into DBJS04.TBJS_TRANSACAO_FUNCAO (ID_FUNCAO,DS_FUNCAO) values (2,'Verify');
COMMIT;