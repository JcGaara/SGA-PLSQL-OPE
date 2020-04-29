CREATE OR REPLACE PROCEDURE OPERACION.P_ENVIA_MAIL_APROB_EF(a_remitente     in varchar2,
                                                            a_destinatarios in varchar2,
                                                            a_usuario       in varchar2) IS
  CURSOR CUR_CONSULTA IS
    SELECT A.NUMSLC || chr(9) || VTATABECT.NOMECT || chr(9) || B.NOMCLI ||
           chr(9) || B.DIRCLI || chr(9) || A.FECPEDSOL || chr(9) ||
           A.IDPRIORIDAD || chr(9) || A.ESTSOLFAC || chr(9) || A.IDCAMPANHA ||
           chr(9) || EF.CODEF || chr(9) || EF.ESTEF || chr(9) ||
           (EF.COSMO + EF.COSMAT + EF.COSEQU) || chr(9) || EF.NUMDIAPLA ||
           chr(9) || CXCPSPCHQ.ESTAPR || chr(9) || A.TIPO || chr(9) ||
           A.FLGPRYESP || chr(9) || a.tipsrv || chr(9) || A.FLGESTCOM ||
           chr(9) || A.IDSOLUCION as linea
      FROM VTATABSLCFAC A,
           EF,
           VTATABCLI B,
           VTATABECT,
           VTATABUSUECT,
           CXCPSPCHQ,
           VTAESTADO C,
           VTATABPSPCLI_V D
     WHERE (A.numslc = ef.numslc(+))
       AND (A.NUMSLC = D.NUMSLC(+))
       AND (B.CODCLI = A.CODCLI)
       AND (VTATABUSUECT.CODECT = VTATABECT.CODECT)
       AND (VTATABECT.CODECT = A.CODSOL)
       AND (A.NUMSLC = CXCPSPCHQ.NUMSLC)
       AND (upper(ltrim(rtrim(VTATABUSUECT.USUARIO))) =
           upper(ltrim(rtrim(a_usuario))))
       AND (A.ESTSOLFAC = C.CODEST)
       AND C.TABEST = '00'
       AND C.GRPEST = 'IN PROCESS'
       AND (D.ESTPSPCLI NOT IN ('01', '02') OR D.NUMPSP IS NULL)
       AND a.flgestcom = 1
       AND a.estsolfac != '01'
     order by fecpedsol;

  ld_fecha   DATE;
  ls_asunto  VARCHAR2(1000);
  ls_archivo VARCHAR2(500);
  conn       UTL_SMTP.connection;
BEGIN
  ld_fecha := SYSDATE;

  ls_asunto  := 'Aprobación de EF - ' ||
                TO_CHAR(ld_fecha, 'DD/MM/YYYY HH24:MI:SS');
  ld_fecha   := SYSDATE;
  ls_archivo := 'AprobacionEF' || TO_CHAR(ld_fecha, 'YYYYMMDDHH24MISS') ||
                '.tsv';
  conn       := DEMO_MAIL.begin_mail(a_remitente,
                                     a_destinatarios,
                                     ls_asunto,
                                     DEMO_MAIL.MULTIPART_MIME_TYPE);
  /*
  -- si se desea enviar algun texto junto con el archivo

  DEMO_MAIL.begin_attachment(conn);
  DEMO_MAIL.write_text(conn, 'CUERPO DEL MENSAJE');
  DEMO_MAIL.end_attachment(conn);
  */

  DEMO_MAIL.begin_attachment(conn,
                             'text/tab-separated-values',
                             FALSE,
                             ls_archivo);
  DEMO_MAIL.write_text(conn,
                       'NUMSLC' || chr(9) || 'NOMECT' || chr(9) || 'NOMCLI' ||
                       chr(9) || 'DIRCLI' || chr(9) || 'FECPEDSOL' ||
                       chr(9) || 'IDPRIORIDAD' || chr(9) || 'ESTSOLFAC' ||
                       chr(9) || 'IDCAMPANHA' || chr(9) || 'CODEF' ||
                       chr(9) || 'ESTEF' || chr(9) || 'COSTO' || chr(9) ||
                       'NUMDIAPLA' || chr(9) || 'ESTAPR' || chr(9) ||
                       'TIPO' || chr(9) || 'FLGPRYESP' || chr(9) ||
                       'TIPSRV' || chr(9) || 'FLGESTCOM' || chr(9) ||
                       'IDSOLUCION' || UTL_TCP.crlf);

  FOR lx IN CUR_CONSULTA LOOP
    DEMO_MAIL.write_text(conn, lx.linea || UTL_TCP.crlf);
  END LOOP;

  DEMO_MAIL.end_attachment(conn, TRUE);
  DEMO_MAIL.end_mail(conn);

END P_ENVIA_MAIL_APROB_EF;
/


