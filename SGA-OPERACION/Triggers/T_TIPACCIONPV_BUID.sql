CREATE OR REPLACE TRIGGER OPERACION.T_TIPACCIONPV_BUID
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.TIPACCIONPV REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_TIPACCIONPV_BUID
   PROPOSITO:  Genera log de TIPACCIONPV
   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2010  Edilberto Astulle PROY-4386 Gestión automática de Cobranza entre los planes BAM y BAF
   **************************************************************************/

DECLARE
nSecuencial number;
BEGIN
  SELECT operacion.SQ_TIPACCIONPV_LOG.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO HISTORICO.TIPACCIONPV_HIS
      (IDLOG,
      IDACCPV ,
      DESACCPV ,
      ORIGEN ,
      ESTADO ,
      USUARIO ,
      FECREG  ,
      FECMODIF ,
      IDTRANCORTE  ,
      TIPO    ,
      FLG_CNR  ,
      TIPO_ACC_LOG )
     VALUES
      (nSecuencial,
      :NEW.IDACCPV ,
      :NEW.DESACCPV ,
      :NEW.ORIGEN ,
      :NEW.ESTADO ,
      USER,
      SYSDATE ,
      :NEW.FECMODIF ,
      :NEW.IDTRANCORTE  ,
      :NEW.TIPO    ,
      :NEW.FLG_CNR  ,
      'I' );
  ELSIF UPDATING THEN
     INSERT INTO HISTORICO.TIPACCIONPV_HIS
      (IDLOG,
      IDACCPV ,
      DESACCPV ,
      ORIGEN ,
      ESTADO ,
      USUARIO ,
      FECREG  ,
      FECMODIF ,
      IDTRANCORTE  ,
      TIPO    ,
      FLG_CNR  ,
      TIPO_ACC_LOG )
     VALUES
      (nSecuencial,
      :OLD.IDACCPV ,
      :OLD.DESACCPV ,
      :OLD.ORIGEN ,
      :OLD.ESTADO ,
      USER,
      SYSDATE ,
      :OLD.FECMODIF ,
      :OLD.IDTRANCORTE  ,
      :OLD.TIPO    ,
      :OLD.FLG_CNR  ,
      'U' );
  ELSIF DELETING THEN
     INSERT INTO HISTORICO.TIPACCIONPV_HIS
      (IDLOG,
      IDACCPV ,
      DESACCPV ,
      ORIGEN ,
      ESTADO ,
      USUARIO ,
      FECREG  ,
      FECMODIF ,
      IDTRANCORTE  ,
      TIPO    ,
      FLG_CNR  ,
      TIPO_ACC_LOG )
     VALUES
      (nSecuencial,
      :NEW.IDACCPV ,
      :NEW.DESACCPV ,
      :NEW.ORIGEN ,
      :NEW.ESTADO ,
      USER,
      SYSDATE ,
      :NEW.FECMODIF ,
      :NEW.IDTRANCORTE  ,
      :NEW.TIPO    ,
      :NEW.FLG_CNR  ,
      'D' );
  END IF;

END;
/