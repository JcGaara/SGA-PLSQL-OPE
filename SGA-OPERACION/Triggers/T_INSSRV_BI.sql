CREATE OR REPLACE TRIGGER "OPERACION"."T_INSSRV_BI" 
BEFORE INSERT
ON OPERACION.INSSRV
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW


/*******************************************************************************************************
     NAME:       T_INSSRV_BI
     PURPOSE:    Trigger de la tabla INSSRV

     Ver        Date        Author           Solicitado por                  Description
     ---------  ----------  ---------------  --------------                  ----------------------
     1.0        21/05/2014  Hector Huaman                                   Considerar el servicio Movil para completar el campo NUMERO
     
*********************************************************************************************************/

DECLARE
  as_cliente   vtatabcli.nomcli%TYPE;
  as_servicio  CHAR(4);
  tmp_var      VARCHAR2(10);
  maxcodinssrv NUMBER;
  loginssrv    NUMBER;

BEGIN

  IF :new.codinssrv IS NULL THEN
    :new.codinssrv := f_get_clave_sid;
  ELSE
    SELECT SQ_ID_INSSRV.Currval INTO maxcodinssrv FROM dual;
    WHILE (:new.codinssrv > maxcodinssrv) LOOP
      maxcodinssrv := f_get_clave_sid;
      SELECT operacion.SQ_LOG_INSSRV.Nextval INTO loginssrv FROM dual;
      SELECT SQ_ID_INSSRV.Currval INTO maxcodinssrv FROM dual;
    END LOOP;
  END IF;

  :new.codusu := USER;
  :new.fecusu := SYSDATE;

  BEGIN
    SELECT tipsrv INTO as_servicio FROM tystabsrv WHERE codsrv = :new.codsrv;
    :new.tipsrv := as_servicio;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20500, 'No hay tipo de servicio');
  END;

  -- Customización PERU
  --IF :new.tipinssrv = 1 AND :new.numero IS NULL THEN
  IF :new.tipinssrv IN(1,5) AND :new.numero IS NULL THEN
    SELECT PQ_CONSTANTES.f_get_cfg INTO tmp_var FROM dual;
    IF tmp_var = 'PER' THEN
      :new.numero := 'SID.' || TRIM(to_char(:new.codinssrv));
    END IF;
  END IF;

END;
/
