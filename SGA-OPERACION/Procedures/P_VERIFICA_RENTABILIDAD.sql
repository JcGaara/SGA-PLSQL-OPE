CREATE OR REPLACE PROCEDURE OPERACION.P_VERIFICA_RENTABILIDAD(A_CODEF IN NUMBER) IS
  /************************************************************
      NOMBRE:           OPERACION.P_VERIFICA_RENTABILIDAD
      PROPOSITO:        Valida si un EF requiere rentabilidad, solo se ejecuta cuando cumple algunos de los sgtes.
                          Adicionalmente, este proc rechazara los proyectos de: Telefonia Analogica, cuando cumplan
                          algunos de los siguientes
    PROGRAMADO EN JOB:  NO

      REVISIONES:
      Ver       Fecha        Autor           Descripción
      --------- ----------  ---------------  ------------------------
      1.0       13/12/2004  Carlos Corrales  Req. 23675 -> Los proyectos internos pasan a Rentabilidad
  ***********************************************************/
  L_TIPSRV CHAR(4);
  L_CODSRV CHAR(4);
  L_NUMSLC CHAR(10);
  l_tipo   number;

  /* anlaogicas */
  ln_campanha number;

BEGIN

  L_NUMSLC := LTRIM(TO_CHAR(A_CODEF, '0000000000'));

  SELECT TIPSRV, CODSRV, TIPO, IDCAMPANHA
    INTO L_TIPSRV, L_CODSRV, L_TIPO, LN_CAMPANHA
    FROM VTATABSLCFAC
   WHERE NUMSLC = L_NUMSLC;
  -- Cambio Solicitado para que los proyectos INTERNOS tengan AR
  IF LN_CAMPANHA IS NULL OR LN_CAMPANHA NOT IN (22,26) THEN
  P_GEN_AR(A_CODEF);
  END IF;

  RETURN;
END;
/


