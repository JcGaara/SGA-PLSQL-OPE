DECLARE

  L_IDCAB NUMBER;
  L_IDSEQ NUMBER;
BEGIN

  SELECT MAX(IDCAB) + 1 INTO L_IDCAB FROM OPERACION.OPE_CAB_XML;
  SELECT MAX(IDSEQ) + 1 INTO L_IDSEQ FROM OPERACION.OPE_DET_XML;

  INSERT INTO OPERACION.OPE_CAB_XML
    (IDCAB,
     PROGRAMA,
     NOMBREXML,
     TITULO,
     RFC,
     METODO,
     DESCRIPCION,
     XML,
     TARGET_URL,
     XMLCLOB)
  VALUES
    (L_IDCAB,
     'PreregistroDatosCCL',
     'Preregistro Datos CCL',
     'Preregistro_Datos_CCL',
     NULL,
     'POST',
     'Pre-registro de datos en CCL',
     NULL,
     'http://172.17.51.38:20000/claro-post-preregistrodatosccl-resource/api/post/preregistrodatosccl/v1.0.0/ejecutarPreRegistro',
     '{
        "idTransaccion" : "@f_idTransaccion",
        "tipoDocumento" : "@f_tipoDocumento",
        "nroDocumento" : "@f_nroDocumento",
        "nombresRazonSocial" : "@f_nombresRazonSocial",
        "apellidoPaterno" : "@f_apellidoPaterno",
        "apellidoMaterno" : "@f_apellidoMaterno",
        "correo" : "@f_correo",
        "customerId" : "@f_customerId",
        "nroSEC" : "@f_nroSEC",
        "nroTelefonoReferencial" : "@f_nroTelefonoReferencial",
        "plataformaOrigen" : "@f_plataformaOrigen",
        "plataformaDestino" : "@f_plataformaDestino"
      }');

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ,
     'f_idTransaccion',
     'select to_number(to_char(sysdate, ''YYYYMMDDHH24MISS'')) from dummy_ope',
     5,
     1,
     1);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 1,
     'f_tipoDocumento',
     'SELECT V.TIPDIDE
  FROM OPERACION.SOLOT S
 INNER JOIN MARKETING.VTATABCLI V
    ON S.CODCLI = V.CODCLI
 WHERE CODSOLOT = :1',
     5,
     1,
     2);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 2,
     'f_nroDocumento',
     'SELECT V.NTDIDE
  FROM OPERACION.SOLOT S
 INNER JOIN MARKETING.VTATABCLI V
    ON S.CODCLI = V.CODCLI
 WHERE CODSOLOT = :1',
     5,
     1,
     3);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 3,
     'f_nombresRazonSocial',
     'SELECT V.NOMCLIRES
  FROM OPERACION.SOLOT S
 INNER JOIN MARKETING.VTATABCLI V
    ON S.CODCLI = V.CODCLI
 WHERE CODSOLOT = :1',
     5,
     1,
     4);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 4,
     'f_apellidoPaterno',
     'SELECT V.APEPATCLI
  FROM OPERACION.SOLOT S
 INNER JOIN MARKETING.VTATABCLI V
    ON S.CODCLI = V.CODCLI
 WHERE CODSOLOT = :1',
     5,
     1,
     5);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 5,
     'f_apellidoMaterno',
     'SELECT V.APEMATCLI
  FROM OPERACION.SOLOT S
 INNER JOIN MARKETING.VTATABCLI V
    ON S.CODCLI = V.CODCLI
 WHERE CODSOLOT = :1',
     5,
     1,
     6);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 6,
     'f_correo',
     'SELECT V.MAIL  FROM OPERACION.SOLOT S
 INNER JOIN MARKETING.VTATABCLI V
    ON S.CODCLI = V.CODCLI
 WHERE CODSOLOT = :1',
     5,
     1,
     7);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 7,
     'f_customerId',
     'SELECT S.CUSTOMER_ID
  FROM OPERACION.SOLOT S
 WHERE S.CODSOLOT = :1',
     5,
     1,
     8);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 8,
     'f_nroSEC',
     'SELECT V.NUMSEC
  FROM OPERACION.SOLOT S
 INNER JOIN SALES.VTATABSLCFAC V
    ON S.NUMSLC = V.NUMSLC
 WHERE S.CODSOLOT = :1',
     5,
     1,
     9);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 9,
     'f_nroTelefonoReferencial',
     'SELECT V.TELEFONO1
  FROM OPERACION.SOLOT S
 INNER JOIN MARKETING.VTATABCLI V
    ON S.CODCLI = V.CODCLI
 WHERE CODSOLOT = :1',
     5,
     1,
     10);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 10,
     'f_plataformaOrigen',
     'SELECT SUBSTR(sys_context(''USERENV'', ''MODULE''),1,6) from dummy_ope',
     4,
     1,
     11);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 11,
     'f_plataformaDestino',
     'SELECT DECODE(FLAG_CLARO_VIDEO,''0'',''CV'',NULL) FROM sisact_info_venta_sga@dbl_pvudb WHERE CODSOLOT = :1',
     5,
     1,
     12);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 12,
     'idTransaccion',
     'select to_number(to_char(sysdate, ''YYYYMMDDHH24MISS'')) from dummy_ope',
     3,
     1,
     1);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 13,
     'msgid',
     'select to_number(to_char(sysdate, ''YYYYMMDDHH24MISS'')) from dummy_ope',
     3,
     1,
     2);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 14,
     'timestamp',
     'select  to_char(sysdate,''yyyy-mm-dd'') || ''T'' ||TO_CHAR(SYSDATE,''hh24:mi:ss'') || ''Z''  from dummy_ope',
     3,
     1,
     3);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB,
     L_IDSEQ + 15,
     'userId',
     'select sys_context(''USERENV'', ''MODULE'') from dummy_ope',
     3,
     1,
     4);

  INSERT INTO OPERACION.OPE_DET_XML
    (IDCAB, IDSEQ, CAMPO, NOMBRECAMPO, TIPO, ESTADO, ORDEN)
  VALUES
    (L_IDCAB, L_IDSEQ + 16, 'accept', 'application/json', 3, 1, 5);

  COMMIT;
END;
/
