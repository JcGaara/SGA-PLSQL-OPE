CREATE OR REPLACE TRIGGER OPERACION.T_OT_AU_TRAKING
 AFTER UPDATE ON OT
FOR EACH ROW
DECLARE
l_ID SOLOT_WEB.IDASUNTO%TYPE;
l_cont number;

BEGIN

	IF :NEW.AREA = 21 AND UPDATING ('ESTOT') and :new.estot = 3 THEN

			SELECT count(*) INTO l_cont
	         FROM SOLOT_WEB W
	   	      WHERE W.CODSOLOT = :NEW.CODSOLOT and w.tipo = 'O';

	      if l_cont = 1 then
				SELECT W.IDASUNTO INTO L_ID
	         FROM SOLOT_WEB W
	   	      WHERE W.CODSOLOT = :NEW.CODSOLOT and w.tipo = 'O';

	         update solot_web set estado = 'ER' where idasunto = l_id;
	      end if;

	elsIF :NEW.AREA = 21 AND UPDATING ('ESTOT') and :new.estot = 8 THEN

			SELECT count(*) INTO l_cont
	         FROM SOLOT_WEB W
	   	      WHERE W.CODSOLOT = :NEW.CODSOLOT and w.tipo = 'O';

	      if l_cont = 1 then
				SELECT W.IDASUNTO INTO L_ID
	         FROM SOLOT_WEB W
	   	      WHERE W.CODSOLOT = :NEW.CODSOLOT and w.tipo = 'O';

	         update solot_web set estado = 'SU' where idasunto = l_id;
	      end if;

	elsif :NEW.AREA = 41 AND UPDATING ('ESTOT') and :new.estot = 3 THEN
   null;
   end if;

END;
/



