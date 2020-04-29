CREATE OR REPLACE TRIGGER OPERACION.T_EF_BI
BEFORE INSERT
ON OPERACION.EF
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
tmpVar NUMBER;
l_cad VARCHAR2(10);

BEGIN
   tmpVar := 0;

   SELECT DOCID.NEXTVAL INTO tmpVar FROM dual;
   INSERT INTO DOC (docid,doctipid) VALUES (tmpVar,3);  -- inserta en la tabla documentos
   :NEW.docid := tmpVar;
   INSERT INTO DOCESTHIS (docid,docest,docestold,fecha) VALUES (:NEW.docid,:NEW.ESTEF,NULL,:NEW.fecusu);

   -- Se actualiza el flag de derivado
   UPDATE vtatabslcfac SET derivado = 1 WHERE vtatabslcfac.numslc = :NEW.numslc AND derivado <> 1;
/*   E1CEPTION
     WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR (-20500, 'No se pudo insertar el correspondiente documento');
*/
 --El Preciario por Default
	l_cad := Pq_Constantes.f_get_cfg;

	IF l_cad IN ('PER') THEN
	    IF :NEW.codprec IS NULL THEN
	   		  BEGIN
			  	   SELECT codprec INTO :NEW.codprec FROM PRECIARIO WHERE flg_default = '1';
			  EXCEPTION
			  WHEN OTHERS THEN
			   	   RAISE_APPLICATION_ERROR (-20500, 'Codigo de PRECIARIO invalido.');
			 END;
		END IF;
	END IF;
END;
/



