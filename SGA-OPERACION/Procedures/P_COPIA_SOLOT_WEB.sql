CREATE OR REPLACE PROCEDURE OPERACION.P_Copia_Solot_Web(an_idasunto solot_web.idasunto%TYPE) IS
  n_solot NUMBER;
  n_tipo  NUMBER;
  n_codot NUMBER;

BEGIN

  --   SELECT NVL(MAX(codsolot),0) + 1 INTO n_solot FROM solot;

  --la solicitud se crea en estado 10-generado
  insert into solot
    (CODSOLOT, TIPTRA, ESTSOL, CODCLI, NUMSLC, DERIVADO)
    select codsolot, 138, 11, solot_web.codcli, otp, 1
      from solot_web, inssrv_web
     where solot_web.nro_servicio = inssrv_web.nro_servicio
       and solot_web.idasunto = an_idasunto;

  insert into solotpto
    (codsolot, punto, codsrvant, bwant, codsrvnue, bwnue)
    select codsolot, b.CODINSSRV, b.codsrv, b.bw, b.codsrv, b.bw
      from inssrv_webxinssrv a, inssrv b, solot_web c
     where a.codinssrv = b.codinssrv
       and a.nro_servicio = c.nro_servicio
       and c.idasunto = an_idasunto;

  --   SELECT NVL(MAX(codot),0) + 1 INTO n_codot FROM ot;
  select f_get_clave_ot into n_codot from dual;

  INSERT INTO ot
    (codot, tiptra, estot, coddpt, observacion)
    SELECT n_codot, 138, 10, '0111  ', descripcion
      FROM solot_web
     WHERE idasunto = an_idasunto;
END;
/


