CREATE OR REPLACE PROCEDURE OPERACION.P_Actualizar_Etapas_SOT(an_codsolot NUMBER, an_codeta NUMBER )
IS
/******************************************************************************
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
06/06/2006 Luis Olarte					 Se copian las etapas desde el EF a las SOT
		   En la SOT Control de Costos el usuario selecciona la opción Copiar Etapa desde EF,
/*******************************************************************************/
l_codef NUMBER;
l_orden NUMBER;
l_cont NUMBER;

CURSOR cur_efpto IS
select ee.punto puntoef,ee.codeta, sp.punto puntosot
from ef, efpto ep, efptoeta ee, solotpto sp
where ef.codef = l_codef
and ef.codef =  ep.codef
and ep.codef = ee.codef
and ep.punto = ee.punto
and ee.codeta = an_codeta
and sp.codsolot = an_codsolot
and sp.efpto =  ep.punto
and sp.punto = 1;

CURSOR cur_efptomat(v_punto number) IS
SELECT e.punto,e.codeta,e.codmat,e.costo,cantidad ,m.moneda_id
FROM EFPTOETAMAT e, matope m
WHERE e.codef = l_codef
and e.punto  = v_punto
and e.codmat =  m.codmat
and e.codeta= an_codeta;

CURSOR cur_efptoact(v_punto number) IS
SELECT punto,codeta,codact,costo,cantidad,observacion,moneda_id,codprec FROM EFPTOETAACT
WHERE codef = l_codef
and punto  = v_punto
and codeta = an_codeta;

CURSOR cur_sotetapa IS
SELECT punto, orden from
SOLOTPTOETA WHERE
codsolot = an_codsolot
and codeta= an_codeta;

BEGIN
 --Se obtiene el numero de ef
   SELECT TO_NUMBER(numslc) INTO l_codef FROM SOLOT WHERE codsolot = an_codsolot;

   FOR r_sotetapa IN cur_sotetapa LOOP
      DELETE solotptoetamat where codsolot=an_codsolot and punto= r_sotetapa.punto and orden= r_sotetapa.orden;
      DELETE solotptoetaact where codsolot=an_codsolot and punto= r_sotetapa.punto and orden= r_sotetapa.orden;
      DELETE SOLOTPTOETA WHERE codsolot = an_codsolot and codeta= an_codeta  and punto= r_sotetapa.punto and orden= r_sotetapa.orden;
   END LOOP;


   --Para cada punto de la sot se busca la informacion del putno en el EF
   FOR r_efptoeta IN cur_efpto LOOP

      --obtengo el orden
      SELECT MAX(NVL(orden,0)) + 1 INTO l_orden FROM solotptoeta
	    WHERE codsolot = an_codsolot AND punto = r_efptoeta.puntosot;
      
      if l_orden is null 
      then 
      l_orden := 1 ;
      end if;

      --inserto la etapa
      INSERT INTO SOLOTPTOETA (codsolot,punto,codeta,orden)
	    VALUES(an_codsolot, r_efptoeta.puntosot,r_efptoeta.codeta,l_orden);

      --insertar materiales
      FOR r_efptoetamat IN cur_efptomat(r_efptoeta.puntoef) LOOP
          INSERT INTO SOLOTPTOETAMAT(codsolot,punto,orden,codmat,candis,cosdis,moneda_id)
	        VALUES(an_codsolot, r_efptoeta.puntosot,l_orden, r_efptoetamat.codmat ,r_efptoetamat.cantidad,r_efptoetamat.costo,r_efptoetamat.moneda_id);
      END LOOP;

      --insertar actividades
       FOR r_efptoetaact IN cur_efptoact(r_efptoeta.puntoef) LOOP
           INSERT INTO SOLOTPTOETAACT(codsolot,punto,orden,moneda_id,codact,candis,cosdis, observacion, codprecdis)
	         VALUES(an_codsolot, r_efptoeta.puntosot,l_orden,r_efptoetaact.moneda_id,r_efptoetaact.codact,r_efptoetaact.cantidad,r_efptoetaact.costo,r_efptoetaact.observacion,r_efptoetaact.codprec);
       END LOOP;
   END LOOP;

END;
/


