CREATE OR REPLACE TRIGGER OPERACION.t_solotptoeta_BIU_log
BEFORE update ON operacion.solotptoeta    --
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
   if (:old.esteta <> :new.esteta) or (nvl(:old.idliq,0) <> nvl(:new.idliq,0)) then
    INSERT INTO operacion.SOLOTPTOETA_log(FECEJE, USUMOD,ID,ESTANT  ,ESTNUE ,CODSOLOT ,PUNTO ,ORDEN  ,CODETA,TIPO, CODCON,IDLIQANT ,IDLIQNUE )
    VALUES  (sysdate,user,:NEW.codsolot||:NEW.punto||:NEW.orden||:NEW.CODETA,:OLD.esteta,:NEW.esteta,:NEW.codsolot,:NEW.punto,:NEW.orden,:NEW.CODETA,'U',:NEW.CODCON,:old.idliq,:new.idliq);
  end if;
END ;
/



