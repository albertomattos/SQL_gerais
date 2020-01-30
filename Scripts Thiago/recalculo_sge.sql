----------------------------------------------------------------------------------------------------------
--- Recalculo: SALDOMES_SMES                                                                           ---
----------------------------------------------------------------------------------------------------------
ALTER TRIGGER MOVIMENTO_MOV_TRX DISABLE;
COMMIT;
SET TRANSACTION USE ROLLBACK SEGMENT MXMRBS001;
UPDATE
   MOVIMENTO_MOV
SET
   MOV_VALORM = 0
WHERE
   MOV_VALORM IS NULL;
UPDATE
   MOVIMENTO_MOV
SET
   MOV_VALOR = 0
WHERE
   MOV_VALOR IS NULL;

UPDATE
   MOVIMENTO_MOV
SET
   MOV_QTD = 0
WHERE
   MOV_QTD IS NULL;

UPDATE
   MOVIMENTO_MOV
SET
   MOV_QTDAQ = 0
WHERE
   MOV_QTDAQ IS NULL;

UPDATE
   MOVIMENTO_MOV
SET
   MOV_RETREM = 'N'
WHERE
   MOV_RETREM IS NULL;

COMMIT;

--- APAGA TABELA DE SALDO
DROP TABLE SALDOMES_SMES;

CREATE TABLE saldomes_smes
 (
  smes_cdempresa             VARCHAR2(4) NOT NULL,
  smes_tpestoque             VARCHAR2(2) NOT NULL,
  smes_almoxarifado          VARCHAR2(2) NOT NULL,
  smes_item                  VARCHAR2(15) NOT NULL,
  smes_anomes                VARCHAR2(6) NOT NULL,
  smes_qtdentradas           NUMBER(16,8) NOT NULL,
  smes_qtdretornos           NUMBER(16,8) NOT NULL,
  smes_qtdsaidas             NUMBER(16,8) NOT NULL,
  smes_qtdremessas           NUMBER(16,8) NOT NULL,
  smes_vlrentradas           NUMBER(16,8) NOT NULL,
  smes_vlrretornos           NUMBER(16,8) NOT NULL,
  smes_vlrsaidas             NUMBER(16,8) NOT NULL,
  smes_vlrremessas           NUMBER(16,8) NOT NULL,
  smes_vlrentradasm          NUMBER(16,8) NOT NULL,
  smes_vlrretornosm          NUMBER(16,8) NOT NULL,
  smes_vlrsaidasm            NUMBER(16,8) NOT NULL,
  smes_vlrremessasm          NUMBER(16,8) NOT NULL
 ) TABLESPACE mxmdad
/


ALTER TABLE saldomes_smes
 ADD CONSTRAINT saldomes_smes_pkx PRIMARY KEY 
(smes_cdempresa   ,smes_tpestoque,
 smes_almoxarifado,smes_item,
 smes_anomes)
 USING INDEX TABLESPACE mxmidad
/


INSERT INTO
   SALDOMES_SMES
SELECT
   MOV_CDEMPRESA                                                AS SMES_CDEMPRESA,
   MOV_TPESTOQUE                                                AS SMES_TPESTOQUE,
   MOV_ALMOXARIFADO                                             AS SMES_ALMOXARIFADO,
   MOV_ITEM                                                     AS SMES_ITEM,
   TO_CHAR(MOV_DATA, 'YYYYMM')                                  AS SMES_ANOMES,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'EN', MOV_QTDAQ, 0))        AS SMES_QTDENTRADAS,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'ES', MOV_QTDAQ, 0))        AS SMES_QTDRETORNOS,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'SN', MOV_QTDAQ, 0))        AS SMES_QTDSAIDAS,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'SS', MOV_QTDAQ, 0))        AS SMES_QTDREMESSAS,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'EN', MOV_VALOR, 0))        AS SMES_VLRENTRADAS,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'ES', MOV_VALOR, 0))        AS SMES_VLRRETORNOS,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'SN', MOV_VALOR, 0))        AS SMES_VLRSAIDAS,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'SS', MOV_VALOR, 0))        AS SMES_VLRREMESSAS,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'EN', MOV_VALORM, 0))       AS SMES_VLRENTRADASM,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'ES', MOV_VALORM, 0))       AS SMES_VLRRETORNOSM,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'SN', MOV_VALORM, 0))       AS SMES_VLRSAIDASM,
   SUM(DECODE(MOV_TIPO||MOV_RETREM, 'SS', MOV_VALORM, 0))       AS SMES_VLRREMESSASM
FROM
   MOVIMENTO_MOV
GROUP BY
   MOV_CDEMPRESA,
   MOV_TPESTOQUE,
   MOV_ALMOXARIFADO,
   MOV_ITEM,
   TO_CHAR(MOV_DATA, 'YYYYMM');

ALTER TRIGGER MOVIMENTO_MOV_TRX ENABLE;

----------------------------------------------------------------------------------------------------------
--- Procedures e Funções: I N V E N T A R I O                                                          ---
----------------------------------------------------------------------------------------------------------
---create public synonym SALDOMES_SMES for SALDOMES_SMES;
---grant all on SALDOMES_SMES to mxmsys,mxmdba;

set serverout on;
exec mxmvalida_80