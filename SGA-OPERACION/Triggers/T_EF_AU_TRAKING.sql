CREATE OR REPLACE TRIGGER OPERACION.T_EF_AU_TRAKING
 AFTER UPDATE ON EF
FOR EACH ROW
DECLARE
l_ID SOLOT_WEB.IDASUNTO%TYPE;
l_cont number;

BEGIN

	IF UPDATING ('ESTEF') THEN

   	IF :new.estef in ( 2, 4) THEN

			SELECT count(*) INTO l_cont
	         FROM SOLOT_WEB W
	   	      WHERE W.NUMSLC = :NEW.NUMSLC and w.tipo = 'F';

	      if l_cont = 1 then
				SELECT W.IDASUNTO INTO L_ID
	         FROM SOLOT_WEB W
	   	      WHERE W.NUMSLC = :NEW.NUMSLC and w.tipo = 'F';

	         update solot_web set estado = 'ER' where idasunto = l_id;
	      end if;

   	elsIF :new.estef = 3 THEN

			SELECT count(*) INTO l_cont
	         FROM SOLOT_WEB W
	   	      WHERE W.NUMSLC = :NEW.NUMSLC and w.tipo = 'F';

	      if l_cont = 1 then
				SELECT W.IDASUNTO INTO L_ID
	         FROM SOLOT_WEB W
	   	      WHERE W.NUMSLC = :NEW.NUMSLC and w.tipo = 'F';

	         update solot_web set estado = 'EE' where idasunto = l_id;
	      end if;

      end if;

   END IF;

END;
/



