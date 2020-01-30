select max(t.pk_tclrea) from tb_cont_log_rea t
--ver sequence e alterar (SQ_TCLREA)
select max(u.pk_tcllic) from tb_cont_log_lic u
--ver sequence e alterar (SQ_TCLLIC)
select max(v.cod_seq_log) from falogcad v
--ver sequence e alterar (SQ_TRG_FALOGCAD)
select max(x.pk_plgcad) from tl_parlogcad x
--ver sequence e alterar (SQ_SEQ_PLGCAD)
select max(t.sequencial) from famovprd t
--ver sequence e alterar (SQ_SEQ_FAMOVPRD)
select max(z) from famovcad z

-- verifica a relacao entre sequence e tabela
SET linesize 120
SET pages 100

CREATE OR REPLACE FUNCTION verifica_coluna_seq (ptabela VARCHAR2, ptrigger VARCHAR2)
   RETURN VARCHAR2
IS
   vtexto    VARCHAR2 (32600);
   vcoluna   VARCHAR2 (30);
BEGIN
   vcoluna := '';

   SELECT trigger_body
     INTO vtexto
     FROM user_triggers
    WHERE trigger_name = ptrigger;

   FOR reg IN (SELECT column_name
                 FROM user_tab_columns
                WHERE table_name = ptabela)
   LOOP
      IF INSTR (UPPER (vtexto), reg.column_name) > 1
      THEN
         vcoluna := reg.column_name;
      END IF;
   END LOOP;

   RETURN vcoluna;
END;
/

COL TABELA FOR A18
COL coluna for a17
COL SEQUENCE for a25

CREATE TABLE tmp_coluna_seq
AS
SELECT trg.table_name tabela,
       verifica_coluna_seq(trg.table_name,trg.trigger_name) coluna,
       trg.trigger_name ,
       seq.sequence_name SEQUENCE
  FROM user_dependencies dep,
       user_triggers trg,
       user_sequences seq
 WHERE dep.referenced_name=seq.sequence_name
   AND dep.TYPE='TRIGGER'
   AND dep.NAME=trg.trigger_name
ORDER BY 1,2;

DROP FUNCTION verifica_coluna_seq;

CREATE TABLE tmp_coluna_seq2 (
   tabela VARCHAR2(30),
   coluna VARCHAR2(30),
   SEQUENCE VARCHAR2(30),
   maxval NUMBER,
   valseq NUMBER);

DECLARE
   valmax   NUMBER;
   valseq   NUMBER;
BEGIN
   FOR reg IN (SELECT *
                 FROM tmp_coluna_seq)
   LOOP
      begin
         EXECUTE IMMEDIATE 'select max(' || reg.coluna || ') from ' || reg.tabela
                      INTO valmax;

         EXECUTE IMMEDIATE    'SELECT '||reg.SEQUENCE||'.NEXTVAL FROM DUAL'
                      INTO valseq;

         INSERT INTO tmp_coluna_seq2
                     (tabela, coluna, SEQUENCE, maxval, valseq)
              VALUES (reg.tabela, reg.coluna, reg.SEQUENCE, valmax, valseq);
      exception
         when others then
            null;
      end;
   END LOOP;
END;
/

DROP TABLE tmp_coluna_seq;

SELECT tabela, coluna, SEQUENCE, maxval, valseq,
       DECODE ((valseq - NVL (maxval, 0)) / decode(ABS (valseq - NVL (maxval, 0)),0,0.0001,ABS (valseq - NVL (maxval, 0))),
               1, 'OK',
               'VALOR INFERIOR'
              ) status
  FROM tmp_coluna_seq2;

SET serveroutput on

BEGIN
   FOR reg IN (SELECT tabela, coluna, SEQUENCE, maxval, valseq,
                      DECODE ((valseq - NVL (maxval, 0)) / decode(ABS (valseq - NVL (maxval, 0)),0,0.0001,ABS (valseq - NVL (maxval, 0))),
                              1, 'OK',
                              'VALOR INFERIOR'
                             ) status
                 FROM tmp_coluna_seq2
                WHERE DECODE ((valseq - NVL (maxval, 0)) / decode(ABS (valseq - NVL (maxval, 0)),0,0.0001,ABS (valseq - NVL (maxval, 0))),
                              1, 'OK',
                              'VALOR INFERIOR'
                             ) <> 'OK')
   LOOP
      EXECUTE IMMEDIATE 'DROP SEQUENCE ' || reg.SEQUENCE;

      EXECUTE IMMEDIATE    'CREATE SEQUENCE '
                        || reg.SEQUENCE
                        || ' START WITH '
                        || TO_CHAR (reg.maxval + 1);

      DBMS_OUTPUT.put_line (   'Recriado a sequence '
                            || reg.SEQUENCE
                            || ' com o valor de '
                            || TO_CHAR (reg.maxval + 1)
                           );
   END LOOP;
END;
/

BEGIN
   FOR reg IN (SELECT tabela, SEQUENCE
                 FROM tmp_coluna_seq2
                WHERE maxval is null
                  and valseq<>1)
   LOOP
      EXECUTE IMMEDIATE 'DROP SEQUENCE ' || reg.SEQUENCE;

      EXECUTE IMMEDIATE    'CREATE SEQUENCE '
                        || reg.SEQUENCE
                        || ' START WITH 1';

      DBMS_OUTPUT.put_line (   'Recriado a sequence '
                            || reg.SEQUENCE
                            || ' com o valor de 1'
                           );
   END LOOP;
END;
/

DROP TABLE tmp_coluna_seq2;
