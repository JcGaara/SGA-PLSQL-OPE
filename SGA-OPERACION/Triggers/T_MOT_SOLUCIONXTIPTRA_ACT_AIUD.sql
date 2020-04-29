CREATE OR REPLACE TRIGGER OPERACION.T_MOT_SOLUCIONXTIPTRA_ACT_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.MOT_SOLUCIONXTIPTRA_ACT REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_MOT_SOLUCIONXTIPTRA_ACT_AIUD
   1.0        16/09/2012  Edilberto Astulle PROY-4854_Modificación de work flow de Wimax y HFC Claro Empresas
   **************************************************************************/

DECLARE
nSecuencial number;
BEGIN
  IF INSERTING THEN
     INSERT INTO HISTORICO.MOT_SOLUCIONXTIPTRA_ACT_LOG
     ( TIPO_ACC  ,TIPTRA,CODMOT_SOLUCION, CANTIDAD, CODACT , CODETA  )
     VALUES('I', :NEW.TIPTRA, :NEW.CODMOT_SOLUCION, :NEW.CANTIDAD, :NEW.CODACT, :NEW.CODETA);
  ELSIF UPDATING THEN
     INSERT INTO HISTORICO.MOT_SOLUCIONXTIPTRA_ACT_LOG
     ( TIPO_ACC  ,TIPTRA,CODMOT_SOLUCION, CANTIDAD, CODACT , CODETA  )
     VALUES('U', :NEW.TIPTRA, :NEW.CODMOT_SOLUCION, :NEW.CANTIDAD, :NEW.CODACT, :NEW.CODETA);
  ELSIF DELETING THEN
     INSERT INTO HISTORICO.MOT_SOLUCIONXTIPTRA_ACT_LOG
     ( TIPO_ACC  ,TIPTRA,CODMOT_SOLUCION, CANTIDAD, CODACT  , CODETA )
     VALUES('D', :NEW.TIPTRA, :NEW.CODMOT_SOLUCION, :NEW.CANTIDAD, :NEW.CODACT, :NEW.CODETA);
  END IF;

END;
/