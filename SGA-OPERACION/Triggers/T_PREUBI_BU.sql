CREATE OR REPLACE TRIGGER OPERACION.T_PREUBI_bU
 before UPDATE ON PREUBI
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
	IF UPDATING('ESTUBI') AND :new.ESTUBI <> :OLD.ESTUBI THEN
		insert into preubiest ( CODSOLOT, PUNTO, IDITEM, FECINI, ESTUBI, CODUSU, ESTUBIOLD )
   	values ( :new.CODSOLOT, :new.PUNTO, null, sysdate, :new.ESTUBI, user, :old.ESTUBI );
   END IF;

   -----------------------------luis olarte 15/11/2006 Req 44386---------------------
   	IF UPDATING('ESTUBI') AND :new.ESTUBI = 14 THEN--luis olarte 15/11/2006 Req 44386
		:new.fecfin := sysdate;
   END IF;
   -----------------------------------------------------------------------------------
END;
/



