create or replace view operacion.v_int_logservicio as
select id_cliente,id_producto,id_venta,id_interfase,codinssrv
from (
      select id_cliente,id_producto,id_venta,id_interfase, codinssrv
      from int_mensaje_intraway
      union
      select id_cliente,id_producto,id_venta,id_interfase,codinssrv
      from intraway.int_mensaje_intraway_log@PESGAINT 
     );
     
     
     
