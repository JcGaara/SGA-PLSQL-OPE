CREATE OR REPLACE PACKAGE OPERACION.pq_abierta IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  PROCEDURE alta;

  PROCEDURE baja;

  PROCEDURE cambio_plan;

  PROCEDURE no_interviene;

END;
/
