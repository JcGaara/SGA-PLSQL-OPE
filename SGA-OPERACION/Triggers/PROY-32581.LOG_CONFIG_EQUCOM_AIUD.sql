CREATE OR REPLACE TRIGGER OPERACION.T_CONFIG_EQUCOM_AIUD
  AFTER INSERT OR UPDATE OR DELETE ON OPERACION.CONFIG_EQUCOM_CP
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
/*********************************************************************************************************************************
    NOMBRE:       T_CONFIG_EQUCOM_AIUD
    REVISIONES:
    Ver        Fecha        Autor             Solicitado por    Descripcion
    ---------  ----------  ----------------  ----------------  ------------------------
    1.0        18/06/2018  LQ                  -                 PROY32581 - CAMBIO PLAN LTE
**********************************************************************************************************************************/
DECLARE
  lc_accion      CHAR(1);
BEGIN
 IF inserting THEN
     lc_accion := 'I';
     INSERT INTO OPERACION.LOG_CONFIG_EQUCOM_CP
      ( CODEQUCOM_NEW ,
        CODEQUCOM_OLD ,
        FLAG_APLICA	,
        ACCION  ,
        USUMOD  ,
        FECMOD  )
     VALUES
      (:new.CODEQUCOM_NEW,
       :new.CODEQUCOM_OLD,
       :new.FLAG_APLICA,
	   lc_accion,
	   :new.usumod,
	   SYSDATE
	   );
  ELSIF updating OR deleting THEN
     IF updating THEN
        lc_accion := 'U';
     ELSIF deleting THEN
        lc_accion := 'D';
     END IF;

     INSERT INTO OPERACION.LOG_CONFIG_EQUCOM_CP
      ( CODEQUCOM_NEW ,
        CODEQUCOM_OLD ,
        FLAG_APLICA	,
        ACCION  ,
        USUMOD  ,
        FECMOD )
     VALUES
      (:old.CODEQUCOM_NEW,
       :old.CODEQUCOM_OLD,
       :old.FLAG_APLICA,
	   lc_accion,
       :old.usumod,
	   SYSDATE
	   );
  END IF;
END;
/