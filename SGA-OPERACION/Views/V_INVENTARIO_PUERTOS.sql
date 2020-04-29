CREATE OR REPLACE VIEW OPERACION.V_INVENTARIO_PUERTOS
AS 
SELECT /*+ FIRST_ROWS */ equipored.codequipo codigo_equipo,
       puertoxequipo.cid numero_cid,
       v_dd_estado_puerto.descripcion estado_puerto,
       tarjetaxequipo.descripcion descripcion_tarjeta,
       tt.descripcion tipo_tarjeta,
       puertoxequipo.puerto descripcion_Interface,
       vtatabcli.nomcli nombre_Cliente,
       acceso.bw bw_cid,
       productocorp.descripcion Descripcion_Producto,
       acceso.estbw Estado_bw,
       acceso.estprod Estado_producto,
       acceso.descripcion descripcion_cid,
       acceso.direccion direccion_cid,
       puertoxequipo.descripcion descripcion_puerto
  FROM puertoxequipo,
       acceso,
       equipored,
       tarjetaxequipo,
       vtatabcli,
       productocorp,
       v_dd_estado_puerto,
       TIPOTARJETA tt
 WHERE puertoxequipo.cid = acceso.cid (+)
   AND equipored.codequipo (+) = puertoxequipo.codequipo
   AND tarjetaxequipo.codtarjeta (+) = puertoxequipo.codtarjeta
   AND vtatabcli.codcli (+) = acceso.codcli
   AND productocorp.codprd (+) = puertoxequipo.codprd
   AND puertoxequipo.estado = v_dd_estado_puerto.estado
   AND tarjetaxequipo.CODTIPTARJ = tt.CODTIPTAR (+);


