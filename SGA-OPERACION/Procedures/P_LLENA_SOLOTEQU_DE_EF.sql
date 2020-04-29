CREATE OR REPLACE PROCEDURE OPERACION.P_Llena_Solotequ_De_Ef (
   an_codsolot solotpto.codsolot%TYPE
) IS
/******************************************************************************
NAME:       P_Llena_Solotequ_De_EF.
PURPOSE:    Llena los equipos desde el EF a la SOLOT

REVISIONS:
Ver        Date        Author           Description
---------  ----------  ---------------  ------------------------------------
1.0        09/05/2005  VValqui               Se considera el campo pcgasto y pcorg del oracle.
2.0        01/03/2006      EOchoa, LO   Se considera el campo de etapa del mismo estudio de factibilidad,
                                                            tanto para equipos como para componentes.
3.0        24/12/2009  MEchevarria/EAstulle  REQ.114053: Las sot de tipo de trabajo 368 no va insertar información en la tabla SOLOTPTOEQUCMP.

******************************************************************************************/
ln_codef ef.codef%TYPE;
ln_orden solotptoequ.orden%TYPE;
tmp NUMBER;
lv_valido                                  varchar2(1);
lv_error                                    varchar2(100);

CURSOR cur_equ2 IS
  SELECT solot.codsolot,
         s.punto,
       ROWNUM orden,
         efptoequ.codtipequ,
         efptoequ.tipequ,
         efptoequ.tipprp,
         efptoequ.cantidad,
         tipequ.costo,
           efptoequ.codequcom,
           efptoequ.codef ,
         efptoequ.punto punto_ef,
         efptoequ.orden orden_ef,
         s.efpto,
         efptoequ.codeta,
         solot.tiptra    --<3.0>
    FROM efptoequ,
         solot,
         solotpto s,
         efpto,
         tipequ
   WHERE efpto.codef = efptoequ.codef AND
         efpto.punto = efptoequ.punto AND
         solot.codsolot = s.codsolot AND
         efpto.punto = s.efpto AND
         efptoequ.tipequ = tipequ.tipequ AND
         efpto.codef = ln_codef AND
       solot.codsolot = an_codsolot;

l_cont NUMBER;
l_cantidad NUMBER;
l_etapa solotptoequ.codeta%TYPE;

BEGIN

/* 20070221 Comentado para utilizar la Etapa del EF
   BEGIN
     SELECT codeta INTO l_etapa FROM preusufas WHERE codusu = USER
         AND codfas = 2 AND ROWNUM = 1
         ORDER BY 1 DESC;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20500,'El usuario '||USER||' no tiene accesos en la tabla PREUSUFAS');
   END;
*/
   -- Se obtiene el EF asociado al proyecto
   SELECT codef INTO ln_codef FROM ef,solot
   WHERE solot.codsolot = an_codsolot AND solot.numslc = ef.numslc;

   DELETE solotptoequcmp WHERE codsolot = an_codsolot;
   DELETE solotptoequ WHERE codsolot = an_codsolot;

   -- Se determina si tiene enlace con el EF
   SELECT COUNT(*) INTO tmp FROM solotpto s WHERE
   s.codsolot = an_codsolot AND
   s.efpto IS NOT NULL;

   IF tmp > 0 THEN -- Si se tiene enlace con el proyecto


      FOR lc1 IN cur_equ2 LOOP
         -- Se insertan los equipos desde el EF
         IF lc1.cantidad > 1 THEN
            SELECT COUNT(*) INTO l_cont FROM solotpto WHERE
               codsolot = an_codsolot AND efpto = lc1.efpto;
            IF l_cont = lc1.cantidad THEN -- Se multiplicaron equipos -> la cantidad es 1
               l_cantidad := 1;
            ELSE
               l_cantidad := lc1.cantidad;
            END IF;
         ELSE
            l_cantidad := lc1.cantidad;
         END IF;

         INSERT INTO solotptoequ(codsolot,punto,orden,tipequ,tipprp,cantidad,costo,codequcom,codeta, pctipgasto, pcidorggasto)
         VALUES (lc1.codsolot,lc1.punto,lc1.orden,lc1.tipequ,lc1.tipprp,l_cantidad,lc1.costo,lc1.codequcom,lc1.codeta,null,null);
         -- Se agrego la etapa.
        IF lc1.tiptra <> 368 THEN --<3.0>
         INSERT INTO solotptoequcmp(codsolot,punto,orden,ordencmp, tipequ,cantidad,costo,codeta)
         SELECT lc1.codsolot,
                lc1.punto,
              lc1.orden,
              ROWNUM,
                efptoequcmp.tipequ,
                efptoequcmp.cantidad,
                tipequ.costo,
                efptoequcmp.codeta
           FROM efptoequcmp,
              tipequ
          WHERE efptoequcmp.codef = lc1.codef AND
                efptoequcmp.punto = lc1.punto_ef AND
                efptoequcmp.orden = lc1.orden_ef AND
                efptoequcmp.tipequ = tipequ.tipequ;
        END IF;

       END LOOP;

       ---Popula los elementos pep---
       FINANCIAL.PQ_Z_MM_PEP_MISC.Sp_Popula_Peps_EquPI
                                                   (
                                                    an_codsolot ,
                                                     null,
                                                     lv_valido,
                                                     lv_error
                                                                          );

   END IF;

END;
/


