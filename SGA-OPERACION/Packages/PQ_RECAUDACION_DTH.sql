create or replace package operacion.pq_recaudacion_dth is
  /*********************************************************************************************
      NOMBRE:           pq_recaudacion_solicitud
      PROPOSITO:        Permite obtener informacion para la recaudacion DTH.
      PROGRAMADO EN JOB:  NO
      REVISIONES:
      Ver     Fecha       Autor             Solicitado por        Descripcion
      ------  ----------  ---------------   -----------------     -----------------------------------
      1.0     29/08/2011  Widmer Quispe     Jose Ramos            Proy. Recaudacion DTH
      2.0     14/10/2011  Widmer Quispe     Jose Ramos            Proy. Recaudacion DTH
  ********************************************************************************************/

  --<1.0
  procedure p_carga_inicial_cliente_dth;

  procedure p_carga_diaria_cliente_dth;
  --1.0>
end;
/