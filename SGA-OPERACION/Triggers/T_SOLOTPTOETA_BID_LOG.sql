CREATE OR REPLACE TRIGGER OPERACION.t_solotptoeta_BID_log
BEFORE INSERT or delete ON operacion.solotptoeta    --
FOR EACH ROW
/*********************************************************************************************
     NOMBRE:            OPERACION.T_SOLOTPTOETA_BIU_LOG
     PROPOSITO:
     REVISIONES:
     Ver        Fecha        Autor           Descripcion
     ---------  ----------  ---------------  -----------------------------------
     2.0       20/08/2009   Joseph Asencios  REQ-100650: Se requiere guardar un log de idliq cada vez que se altere su valor.
***********************************************************************************************/
DECLARE
BEGIN

  if INSERTING then  --('esteta')
    INSERT INTO operacion.SOLOTPTOETA_log(FECEJE, USUMOD,ID,ESTANT  ,ESTNUE ,CODSOLOT ,PUNTO ,ORDEN  ,CODETA,TIPO, CODCON,IDLIQANT ,IDLIQNUE )
    VALUES  (sysdate,user,:NEW.codsolot||:NEW.punto||:NEW.orden||:NEW.CODETA,:OLD.esteta,:NEW.esteta,:NEW.codsolot,:NEW.punto,:NEW.orden,:NEW.CODETA,'I',:NEW.CODCON,:old.idliq,:new.idliq);
  elsif DELETING then
    INSERT INTO operacion.SOLOTPTOETA_log(FECEJE, USUMOD,ID,ESTANT  ,ESTNUE ,CODSOLOT ,PUNTO ,ORDEN  ,CODETA,TIPO, CODCON,IDLIQANT ,IDLIQNUE )
    VALUES  (sysdate,user,:old.codsolot||:old.punto||:old.orden||:old.CODETA,:OLD.esteta,:NEW.esteta,:old.codsolot,:old.punto,:old.orden,:old.CODETA,'D',:old.CODCON,:old.idliq,:new.idliq);
  end if;
END ;
/



