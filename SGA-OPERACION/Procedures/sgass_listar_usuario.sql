create or replace procedure operacion.sgass_listar_usuario (po_cursor OUT SYS_REFCURSOR) IS
    /*
    ****************************************************************
    * Nombre SP         : sgass_listar_usuario
    * Propósito         : Lista de clientes 
    * Output            : po_cursor - Cursor con los registros obtenidos de la tabla 
    * Creado por        : Cesar Rengifo Aliaga
    * Fec Creación      : 26/11/2018
    * Proyeto           : PROY-140119
    * Fec Actualización : N/A
    ****************************************************************
    */
  begin
  open po_cursor for
    SELECT O.DESCRIPCION, O.CODIGOC
      FROM OPEDD O, TIPOPEDD T
     WHERE T.ABREV = 'CON_ATT_REQ'
       AND T.TIPOPEDD = O.TIPOPEDD
     ORDER BY O.CODIGON;
 END;
/