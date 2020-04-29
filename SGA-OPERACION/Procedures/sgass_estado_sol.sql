create or replace procedure operacion.sgass_estado_sol(an_idcod varchar2,po_cursor OUT SYS_REFCURSOR) IS
    /*
    ****************************************************************
    * Nombre SP         : sgass_estado_sol
    * Propósito         : Lista de clientes ,
    * Output            : po_cursor - Cursor con los registros obtenidos de la tabla
    * Creado por        : Cesar Rengifo Aliaga
    * Fec Creación      : 26/11/2018
    * Proyeto           : PROY-140119
    * Fec Actualización : N/A
    ****************************************************************
    */
  begin
  open po_cursor for
    SELECT O.CODIGON,
         O.DESCRIPCION,
         O.CODIGON_AUX
    FROM OPEDD O,
         TIPOPEDD T
   WHERE ( T.TIPOPEDD = O."TIPOPEDD" ) and
         ( ( t.abrev = 'EST_SOL_PED' ) AND
         ( o.codigoc = '1' ) AND
         ( O.ABREVIACION = an_idcod ) ) ;

 END;
/