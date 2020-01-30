CREATE OR REPLACE VIEW admwpd.vw_epimed (
   medicalrecord,
   documenttypecode,
   documentnumber,
   patientname,
   gender,
   birthdate,
   hospitalcode,
   hospitaladmissionnumber,
   hospitaladmissiondate,
   unitcode,
   unitadmissionnumber,
   unitadmissiondatetime,
   bedcode,
   icdcode,
   unitdischargedatetime,
   dischargecause,
   responsiblename,
   responsibledocument,
   hospitaldischargedate,
   medicaldischargedate )
AS
SELECT FAPRTCAD.COD_PRT AS MEDICALRECORD,
          CASE
             WHEN TRIM (FAPRTCAD.CPF) IS NULL
                  AND FAPRTCAD.IDENTIDADE IS NOT NULL
             THEN
                'BR.RG'
             ELSE
                'BR.CPF'
          END
             AS DOCUMENTTYPECODE,
          CASE
             WHEN TRIM (FAPRTCAD.CPF) IS NOT NULL THEN FAPRTCAD.CPF
             ELSE FAPRTCAD.IDENTIDADE
          END
             AS DOCUMENTNUMBER,
          FAPRTCAD.NOME_PAC AS PATIENTNAME,
          FAPRTCAD.SEXO AS GENDER,
          TO_CHAR (FAPRTCAD.NASCIMENTO, 'YYYY/MM/DD') AS BIRTHDATE,
          FATAB.CLIENTE || FAPACCAD.COD_UNI AS HOSPITALCODE,
          FAPACCAD.COD_PAC AS HOSPITALADMISSIONNUMBER,
          TO_CHAR (FAPACCAD.DATA_ENT, 'YYYY/MM/DD') AS HOSPITALADMISSIONDATE,
          FAAPTCAD.COD_SET AS UNITCODE,
          FAPACCAD.COD_PAC AS UNITADMISSIONNUMBER,
             TO_CHAR (FALEHCAD.DATA, 'YYYY/MM/DD')
          || ' '
          || TO_CHAR (FALEHCAD.HORA, 'HH24:MI:SS')
             AS UNITADMISSIONDATETIME,
          FALEHCAD.LEITO AS BEDCODE,
          '' AS ICDCODE,
             TO_CHAR (FALEHCAD.DATA, 'YYYY/MM/DD')
          || ' '
          || TO_CHAR (FALEHCAD.HORA, 'HH24:MI:SS')
             AS UNITDISCHARGEDATETIME,
          FAPACCAD.COD_MOT_ALTA AS DISCHARGECAUSE,
          FAPACCAD.NOME_RSP AS RESPONSIBLENAME,
          FAPACCAD.CPF_RSP AS ResponsibleDocument,
          to_date(nvl(TO_CHAR (FAPACCAD.DATA_ALTA, 'DD/MM/YYYY'),'01/01/1900')
          || ' '
          || nvl(TO_CHAR (FAPACCAD.HORA_ALTA, 'HH24:MI:SS'),'00:00:00'),'DD/MM/YYYY HH24:MI:SS')
             AS HospitalDischargeDate,
          TO_CHAR (FAPACCAD.DATA_ALTA_MEDICA, 'DD/MM/YYYY HH24:MI:SS')
             AS MedicalDischargeDate
     FROM FAPACCAD
          INNER JOIN FAPRTCAD ON FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT
          INNER JOIN FALEHCAD ON FAPACCAD.COD_PAC = FALEHCAD.COD_PAC
          INNER JOIN FAAPTCAD ON FALEHCAD.COD_APT = FAAPTCAD.COD_APT          
          INNER JOIN FATAB
             ON 1 = 1
    WHERE FAPACCAD.TIPO_PAC = 'I'
          AND (FAPACCAD.DATA_ALTA >= TRUNC (SYSDATE) - 30
               OR FALEHCAD.DATA >= TRUNC (SYSDATE) - 30)
               
               GRANT SELECT ON admwpd.vw_epimed TO wpd
