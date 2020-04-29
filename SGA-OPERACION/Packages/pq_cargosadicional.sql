create or replace package operacion.pq_cargosadicional is
  /*********************************************************************************************
      NOMBRE:           pq_cargosadicional
      PROPOSITO:        Permite obtener los tipos de Reconexion.
      PROGRAMADO EN JOB:  NO
      REVISIONES:
      Ver     Fecha       Autor             Solicitado por        Descripcion
      ------  ----------  ---------------   -----------------     -----------------------------------
      1.0     22/03/2011  Giovanni Vasquez  Miguel Londoña        REQ-022 Administrar rangos de fechas de cobro y cargos por reconexión
      2.0     16/03/2012  Miguel Londoña    Edilberto Astulle     Correccion de cursor para discriminar pids que no se encuentren en billing
      3.0     06/08/2012  Miguel Londoña    Edilberto Astulle     Cambio en la identificacion de la instancia de producto
      4.0     05/10/2012  Juan Pablo Ramos  Elver Ramirez         REQ.163439 Soluciones Post Venta BAM-BAF
      5.0     05/07/2012  Edilberto Astulle                       PQT-141358-TSK-21430
  ********************************************************************************************/
  procedure p_proceso_cargoreconexion(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number); -- 1.0
end;
/