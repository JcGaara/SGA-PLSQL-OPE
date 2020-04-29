CREATE OR REPLACE FUNCTION OPERACION.F_Sum_Actxpreubi( a_fase IN NUMBER, a_codpre IN NUMBER, a_idubi IN NUMBER, a_moneda IN CHAR, a_tipo IN NUMBER)  RETURN NUMBER IS

l_costo NUMBER;

BEGIN
IF a_tipo < 2 THEN
   IF a_fase = 1 THEN
   	  l_costo := 0 ;
   ELSIF  a_fase = 2 THEN
      SELECT SUM(nvl(cosdis * candis,0)) INTO l_costo
         FROM PREUBIETAACT, ACTIVIDAD
         WHERE codpre = a_codpre AND
               idubi = a_idubi AND
               PREUBIETAACT.codact = ACTIVIDAD.codact AND
               ACTIVIDAD.moneda = a_moneda AND
   			   ACTIVIDAD.espermiso = a_tipo;
   ELSIF  a_fase = 3 THEN
      SELECT SUM(cosins * canins) INTO l_costo
         FROM PREUBIETAACT, ACTIVIDAD
         WHERE codpre = a_codpre AND
               idubi = a_idubi AND
               PREUBIETAACT.codact = ACTIVIDAD.codact AND
               ACTIVIDAD.moneda = a_moneda AND
   			   ACTIVIDAD.espermiso = a_tipo;
   ELSIF  a_fase = 4 THEN
      SELECT SUM(cosliq * canliq) INTO l_costo
         FROM PREUBIETAACT, ACTIVIDAD
         WHERE codpre = a_codpre AND
               idubi = a_idubi AND
               PREUBIETAACT.codact = ACTIVIDAD.codact AND
               ACTIVIDAD.moneda = a_moneda AND
   			   ACTIVIDAD.espermiso = a_tipo;
   END IF;
 ELSE
   SELECT SUM(cosdis * candis) INTO l_costo
      FROM PREUBIETAACT, ACTIVIDAD
         WHERE codpre = a_codpre AND
               idubi = a_idubi AND
               PREUBIETAACT.codact = ACTIVIDAD.codact AND
               ACTIVIDAD.moneda = a_moneda AND
   			   ACTIVIDAD.espermiso = 1 AND
			   ACTIVIDAD.flgcan = 1;
 END IF;
   RETURN l_costo;

   EXCEPTION
      WHEN OTHERS THEN RETURN 0;

END;
/


