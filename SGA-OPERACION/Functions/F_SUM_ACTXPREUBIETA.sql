CREATE OR REPLACE FUNCTION OPERACION.F_Sum_Actxpreubieta( a_fase IN NUMBER, a_codpre IN NUMBER, a_idubi IN NUMBER, a_codeta IN NUMBER, a_moneda IN CHAR, a_tipo IN NUMBER)  RETURN NUMBER IS

l_costo NUMBER;

BEGIN

   IF a_fase = 1 THEN
   	  l_costo := 0;
   ELSIF  a_fase = 2 THEN
      SELECT SUM(cosdis * candis) INTO l_costo
         FROM PREUBIETAACT,ACTIVIDAD
         WHERE PREUBIETAACT.codact = ACTIVIDAD.codact AND
		 	   codpre = a_codpre AND
               idubi = a_idubi AND
               codeta = a_codeta AND
			   ACTIVIDAD.moneda = a_moneda AND
 			   ACTIVIDAD.espermiso = a_tipo;
   ELSIF a_fase = 3 THEN
      SELECT SUM(cosins * canins) INTO l_costo
         FROM PREUBIETAACT,ACTIVIDAD
         WHERE PREUBIETAACT.codact = ACTIVIDAD.codact AND
		 	   codpre = a_codpre AND
               idubi = a_idubi AND
               codeta = a_codeta AND
				  ACTIVIDAD.moneda = a_moneda AND
				  ACTIVIDAD.espermiso = a_tipo ;
   ELSIF a_fase = 4 THEN
      SELECT SUM(cosliq * canliq) INTO l_costo
         FROM PREUBIETAACT,ACTIVIDAD
         WHERE PREUBIETAACT.codact = ACTIVIDAD.codact AND
		 	   codpre = a_codpre AND
               idubi = a_idubi AND
               codeta = a_codeta AND
				  ACTIVIDAD.moneda = a_moneda AND
				  ACTIVIDAD.espermiso = a_tipo ;
   END IF;

   IF l_costo IS NULL THEN
      RETURN 0;
   ELSE
      RETURN l_costo;
   END IF;

--   EXCEPTION
--      WHEN OTHERS THEN Return 0;

END;
/


