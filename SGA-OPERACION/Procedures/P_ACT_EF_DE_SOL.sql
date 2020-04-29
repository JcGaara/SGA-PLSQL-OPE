CREATE OR REPLACE PROCEDURE OPERACION.p_act_ef_de_sol (a_codef IN NUMBER)
IS
/******************************************************************************
Actualizar los puntos del EF en base al proyecto.

Fecha        Autor           Descripcion
----------  ---------------  ------------------------
16/10/2002  Carlos Corrales
18/07/2003  Carlos Corrales  Se modifico P_ASIG_WF
01/09/2003  Carlos Corrales  Se hizo los cambios
09/06/2004  Carlos Corrales  Se mejoro los querys de delete
                             de acuerdo a la nueva estructura de vtadetptoenl
                             Se dio nuevo formato
14/06/2004  Carlos Corrales  Se incluyo el delete sobre EFPTOMET
11/07/2004  Victor Valqui  	 En el update se actualiza los puntos cuyo equipo sea nulo y si no es nulo,
				   			 debe ser un punto principal.
******************************************************************************/
BEGIN
-- se actualiza los datos de los puntos
   UPDATE efpto
      SET (descripcion, direccion, codsuc, codubi, codsrv, bw, codinssrv,
           tiptra, nrolineas, nrofacrec, nrohung, nroigual, nrocanal,
           tiptraef) =
             (SELECT descpto, dirpto, codsuc, ubipto, codsrv, NVL (banwid, 0),
                     numckt, tiptra, nrolineas, nrofacrec, nrohung, nroigual,
                     nrocanal, tiptraef
                FROM vtadetptoenl
               WHERE numslc = LPAD (efpto.codef, 10, '0')
                 AND numpto = LPAD (efpto.punto, 5, '0'))
    WHERE efpto.codef = a_codef
      AND efpto.punto IN (
               SELECT TO_NUMBER (numpto)
                 FROM vtadetptoenl
                WHERE numslc = LPAD (efpto.codef, 10, '0')
--                  AND codequcom IS NULL);
                  AND ((codequcom IS NULL) OR (codequcom IS NOT NULL AND numpto = numpto_prin)));

-- se insertan los puntos nuevos
   INSERT INTO efpto
               (codef, punto, descripcion, direccion, codsuc, codubi, codsrv,
                bw, codinssrv, tiptra, coordx1, coordy1, coordx2, coordy2,
                nrolineas, nrofacrec, nrohung, nroigual, nrocanal, tiptraef)
      SELECT a_codef, TO_NUMBER (numpto), descpto, dirpto, codsuc, ubipto,
             codsrv, NVL (banwid, 0), numckt, tiptra, merabs1, merord1,
             merabs2, merord2, nrolineas, nrofacrec, nrohung, nroigual,
             nrocanal, tiptraef
        FROM vtadetptoenl
       WHERE crepto = '1'
         AND numslc = LPAD (a_codef, 10, '0')
         AND (   (codequcom IS NULL)
              OR (codequcom IS NOT NULL AND numpto = numpto_prin)
             )
         AND TO_NUMBER (numpto) NOT IN (SELECT punto
                                          FROM efpto
                                         WHERE codef = a_codef);

-- se borran los puntos sobrantes
   DELETE      efptoetafor
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efptoetadat
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efptoetaact
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efptoetamat
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efptoetainf
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efptoequcmp
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efptoequ
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efptoeta
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efptomet
         WHERE codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));

   DELETE      efpto
         WHERE efpto.codef = a_codef
           AND punto NOT IN (
                  SELECT TO_NUMBER (numpto)
                    FROM vtadetptoenl
                   WHERE numslc = LPAD (a_codef, 10, '0')
                     AND crepto = '1'
                     AND (   (codequcom IS NULL)
                          OR (codequcom IS NOT NULL AND numpto = numpto_prin
                             )
                         ));
END;
/


