CREATE OR REPLACE TRIGGER OPERACION.T_SOLOT_AU_TRAKING
 AFTER UPDATE ON SOLOT
FOR EACH ROW
DECLARE
L_ID SOLOT_WEB.IDASUNTO%TYPE;
l_cont number;

BEGIN

	IF UPDATING ('DERIVADO') THEN

		SELECT count(*) INTO l_cont
         FROM SOLOT_WEB W
   	      WHERE W.CODSOLOT = :NEW.CODSOLOT and w.tipo = 'O';

      if l_cont = 1 then
			SELECT W.IDASUNTO INTO L_ID
         FROM SOLOT_WEB W
   	      WHERE W.CODSOLOT = :NEW.CODSOLOT and w.tipo = 'O';

         update solot_web set estado = 'EE' where idasunto = l_id;
      end if;

   END IF;

END;
/



