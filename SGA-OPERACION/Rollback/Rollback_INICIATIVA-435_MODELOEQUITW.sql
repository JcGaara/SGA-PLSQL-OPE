DECLARE
CURSOR CU_LISTA IS
    SELECT DISTINCT T.TIPO,
                E.CODEQUCOM,
                E.DSCEQU,
                E.MODELOEQUITW,
                A.COD_SAP,
                A.CODMAT,
                A.ABRMAT,
                A.DESMAT
    FROM SALES.VTAEQUCOM  E,
         OPERACION.TIPEQU     T,
         PRODUCCION.ALMTABMAT  A,
         OPERACION.EQUCOMXOPE X
    WHERE X.CODEQUCOM = E.CODEQUCOM
    AND T.CODTIPEQU = X.CODTIPEQU
    AND A.CODMAT = T.CODTIPEQU
    AND T.TIPO IN ('EMTA')
    AND A.COD_SAP IS NOT NULL
    AND E.MODELOEQUITW IS NOT NULL;

  V_REG   INTEGER;
  V_CANT  INTEGER;

BEGIN

  V_REG  := 0;
  V_CANT := 0;

  DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ||' INICIO : ACTUALIZACION DE CAMPO: MODELOEQUITW (INCOGNITO) ');

  FOR N IN CU_LISTA LOOP

    IF N.COD_SAP = '000000000004008635' THEN
      IF (N.CODEQUCOM = 'AHLI' Or N.CODEQUCOM = 'AGIN' Or
         N.CODEQUCOM = '9824' Or N.CODEQUCOM = 'AHRG' Or
         N.CODEQUCOM = 'AGFK' Or N.CODEQUCOM = 'AHHQ' Or
         N.CODEQUCOM = 'AIQY' Or N.CODEQUCOM = 'AIQX') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004036468' THEN
      IF (N.CODEQUCOM = 'AHLJ' Or N.CODEQUCOM = 'AHGH') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004008010' THEN
      IF (N.CODEQUCOM = 'AGFJ' Or N.CODEQUCOM = 'AHLH') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004043623' THEN
      IF (N.CODEQUCOM = 'AHNX') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF (N.CODEQUCOM = 'AHRS') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = 'Cisco_DPC3940L'
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004008640' THEN
      IF (N.CODEQUCOM = 'AAOT' Or N.CODEQUCOM = 'AHRH' Or
         N.CODEQUCOM = 'AAOX' Or N.CODEQUCOM = 'AGAL' Or
         N.CODEQUCOM = '9823' Or N.CODEQUCOM = 'AAOP') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004047000' THEN
      IF (N.CODEQUCOM = 'AIJY' Or N.CODEQUCOM = 'AJJS') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004037093' THEN
      IF (N.CODEQUCOM = 'AHKS' Or N.CODEQUCOM = 'AHNK') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004045541' THEN
      IF (N.CODEQUCOM = 'AIBP' Or N.CODEQUCOM = 'AIBK') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004008015' THEN
      IF (N.CODEQUCOM = 'AGFH') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004008657' THEN
      IF (N.CODEQUCOM = 'AFJJ' Or N.CODEQUCOM = 'AFJK' Or
         N.CODEQUCOM = '9756' Or N.CODEQUCOM = 'AAXV') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004048528' THEN
      IF (N.CODEQUCOM = 'AJCL') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004050441' THEN
      IF (N.CODEQUCOM = 'AJWT') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

    IF N.COD_SAP = '000000000004051209' THEN
      IF (N.CODEQUCOM = 'AJCM') THEN
        UPDATE vtaequcom v
           SET v.modeloequitw = NULL
         WHERE v.codequcom = N.CODEQUCOM;
        V_REG := SQL%ROWCOUNT;
      END IF;

      IF V_REG > 0 THEN
        V_CANT := V_REG + 1;
      END IF;
    END IF;

  END LOOP;

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('REGISTROS ACTUALIZADOS : '||V_CANT);
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') ||' FIN : ACTUALIZACION DE CAMPO: MODELOEQUITW (INCOGNITO) ');
  DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE) || ' ' || SQLERRM);
END;
/