CREATE OR REPLACE PROCEDURE OPERACION.p_reporte_ventas_hfc
IS
ld_fecini date;
BEGIN
  select trunc(Add_months(sysdate, -2), 'mm') fecha_ini
    into ld_fecini
    from dual;

  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.REP_VTA_MAS_DAT');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.VTADETPTOENL_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.VTATABSLCFAC_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.VTATABPSPCLI_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.VTASUCCLI_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.VTATABCLI_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.SOLOT_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.SOLOTPTO_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.SOLOTPTO_ID_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.SOLOTCHGEST_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.VTACNDCOMPSPCLI_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.INSPRD_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.VTATABPRECON_A');
  DBMS_UTILITY.EXEC_DDL_STATEMENT('TRUNCATE TABLE SOPFIJA.V_UBICACIONES_A');

  insert into SOPFIJA.rep_vta_mas_dat
    (numslc, codcli, codsolot)
    select b.numslc, b.codcli, c.codsolot
      from sales.vtatabpspcli b, solot c
     where b.estpspcli in
          --realización de la venta
           (select codigoc
              from opedd
             where tipopedd in
                   (select tipopedd
                      from tipopedd
                     where abrev = 'REPORTE_HFC_RVENTA'))
       and b.numslc = c.numslc
       and c.tiptra in
          --Tipos de Trabajo para la Venta
           (select codigon
              from opedd
             where tipopedd in
                   (select tipopedd
                      from tipopedd
                     where abrev = 'REPORTE_HFC_TIPTRAVENA'))
       AND TRUNC(b.fecapr) >= ld_fecini
       AND TRUNC(b.fecapr) <= trunc(sysdate);
  commit;

  INSERT INTO SOPFIJA.VTADETPTOENL_A
     (numslc ,numpto ,ubipto ,codsrv ,codsuc ,estcts ,estcse ,cantidad ,idpaq)
    SELECT
      numslc ,numpto ,ubipto ,codsrv ,codsuc ,estcts ,estcse ,cantidad ,idpaq
      FROM SALES.VTADETPTOENL
     WHERE NUMSLC IN (SELECT NUMSLC FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;

  INSERT INTO SOPFIJA.VTATABSLCFAC_A
     (numslc ,codcli ,fecpedsol ,codsol ,codusu ,idsolucion)
    SELECT
      numslc ,codcli ,fecpedsol ,codsol ,codusu ,idsolucion
      FROM SALES.VTATABSLCFAC
     WHERE NUMSLC IN (SELECT NUMSLC FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;

  INSERT INTO SOPFIJA.VTATABPSPCLI_A
     (numpsp ,numslc ,estpspcli ,idopc ,codcli ,fecapr,codect)
    SELECT
      numpsp ,numslc ,estpspcli ,idopc ,codcli ,fecapr,codect
      FROM SALES.VTATABPSPCLI
     WHERE NUMSLC IN (SELECT NUMSLC FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;

  INSERT INTO SOPFIJA.VTASUCCLI_A
     (codcli ,codsuc ,nomsuc ,dirsuc ,idplano)
    SELECT
      codcli ,codsuc ,nomsuc ,dirsuc ,idplano
      FROM MARKETING.VTASUCCLI
     WHERE CODCLI IN (SELECT CODCLI FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;

  INSERT INTO SOPFIJA.VTATABCLI_A
     (codcli ,tipdide ,nomcli ,ntdide ,telefono1 ,telefono2)
    SELECT
      codcli ,tipdide ,nomcli ,ntdide ,telefono1 ,telefono2
      FROM MARKETING.VTATABCLI
     WHERE CODCLI IN (SELECT CODCLI FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;

  INSERT INTO SOPFIJA.SOLOT_A
    (codsolot ,tiptra ,estsol ,codcli ,numslc ,feccom,docid,fecultest)
    SELECT
     codsolot ,tiptra ,estsol ,codcli ,numslc ,feccom,docid,fecultest
     FROM OPERACION.SOLOT
     WHERE CODSOLOT IN (SELECT CODSOLOT FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;
  --
  INSERT INTO SOPFIJA.SOLOTPTO_A
     (codsolot ,punto ,codsrvnue ,codinssrv ,codubi ,flg_agenda)
    SELECT
      codsolot ,punto ,codsrvnue ,codinssrv ,codubi ,flg_agenda
      FROM OPERACION.SOLOTPTO
     WHERE CODSOLOT IN (SELECT CODSOLOT FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;

  INSERT INTO SOPFIJA.SOLOTPTO_ID_A
     (codsolot ,punto ,estado ,codcon ,fecestprog)
    SELECT
      codsolot ,punto ,estado ,codcon ,fecestprog
      FROM OPERACION.SOLOTPTO_ID
     WHERE (CODSOLOT, PUNTO) IN (SELECT CODSOLOT, PUNTO FROM SOPFIJA.SOLOTPTO_A);
  COMMIT;

  INSERT INTO SOPFIJA.SOLOTCHGEST_A
     (idseq ,codsolot ,estado ,fecha ,observacion,tipo)
    SELECT /*+INDEX(A IDX_SOLOTCHGEST_001)*/
      idseq ,codsolot ,estado ,fecha ,observacion,tipo
      FROM OPERACION.SOLOTCHGEST A
     WHERE CODSOLOT IN (SELECT CODSOLOT FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;

  INSERT INTO SOPFIJA.VTACNDCOMPSPCLI_A
     (numpsp ,idcndcom)
    SELECT /*+INDEX(A PK_VTACNDCOMPSPCLI)*/
      numpsp ,idcndcom
      FROM SALES.VTACNDCOMPSPCLI A
     WHERE (NUMPSP, IDOPC) IN (SELECT NUMPSP, IDOPC FROM SOPFIJA.VTATABPSPCLI_A);
  COMMIT;

  INSERT INTO SOPFIJA.INSPRD_A
     (pid ,codsrv ,codinssrv ,fecini ,numslc)
    SELECT
      pid ,codsrv ,codinssrv ,fecini ,numslc
      FROM OPERACION.INSPRD
     WHERE CODINSSRV IN (SELECT CODINSSRV FROM SOPFIJA.SOLOTPTO_A);
  COMMIT;

  INSERT INTO SOPFIJA.VTATABPRECON_A
     (numslc ,codcli ,nrodoc ,fecace ,codmotivo ,numdepban ,codban ,carrier ,codmotivo_lv ,codmotivo_tc ,codmotivo_co ,codmotivo_tf)
    SELECT /*+INDEX(A PK_VTATABPRECON)*/
      numslc ,codcli ,nrodoc ,fecace ,codmotivo ,numdepban ,codban ,carrier ,codmotivo_lv ,codmotivo_tc ,codmotivo_co ,codmotivo_tf
      FROM SALES.VTATABPRECON A
     WHERE NUMSLC IN (SELECT NUMSLC FROM SOPFIJA.REP_VTA_MAS_DAT);
  COMMIT;

  INSERT INTO SOPFIJA.V_UBICACIONES_A
     (codubi ,nomdst ,nompvc ,nomest)
    SELECT
      codubi ,nomdst ,nompvc ,nomest
      FROM PRODUCCION.V_UBICACIONES A;
  COMMIT;
EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,'OPERACION.P_REPORTE_VENTAS_HFC: ' || SQLERRM);
END;
/
