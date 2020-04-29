CREATE OR REPLACE TRIGGER OPERACION."T_TRSSOLOT_AU"
AFTER UPDATE
ON OPERACION.TRSSOLOT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE

  /*********************************************************************************************
  NOMBRE:            OPERACION.T_INSPRD_BU
  PROPOSITO:
  REVISIONES:
  Ver     Fecha       Autor             Solicitado por        Descripcion
  ------  ----------  ---------------   -----------------     -----------------------------------
  1.0     15/06/2004  Carlos Corrales                         Se modifico el MAX por un sequence
  2.0     17/12/2010  Widmer Quispe     Edilberto Astulle     Req: 123054 y 123052, Asignación de plataforma por default.
  ***********************************************************************************************/

   tmpvar   NUMBER;
BEGIN
   SELECT sq_trssolot_log_id.NEXTVAL
     INTO tmpvar
     FROM DUAL;

   INSERT INTO trssolot_log
               (ID, codtrs, codinssrv, codsolot,
                tipo, tiptrs, esttrs, estinssrv,
                estinssrvant, codsrvnue, bwnue,
                codsrvant, bwant, feceje, fectrs,
                numslc, numpto, idadd, fecusu,
                codusu, codusueje, punto, pid,
                pid_old, flgbil, fecinifac, flgpost,
                IDPLATAFORMA --<2.0>
               )
        VALUES (tmpvar, :OLD.codtrs, :OLD.codinssrv, :OLD.codsolot,
                :OLD.tipo, :OLD.tiptrs, :OLD.esttrs, :OLD.estinssrv,
                :OLD.estinssrvant, :OLD.codsrvnue, :OLD.bwnue,
                :OLD.codsrvant, :OLD.bwant, :OLD.feceje, :OLD.fectrs,
                :OLD.numslc, :OLD.numpto, :OLD.idadd, :OLD.fecusu,
                :OLD.codusu, :OLD.codusueje, :OLD.punto, :OLD.pid,
                :OLD.pid_old, :OLD.flgbil, :OLD.fecinifac, :OLD.flgpost,
                :old.IDPLATAFORMA --<2.0>
               );
END;
/



