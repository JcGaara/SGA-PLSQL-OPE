CREATE OR REPLACE PROCEDURE OPERACION.p_insertar_cab_requisicion
(numrequisicion out number, numcontrata in number,
nummes in number, dtfechaentrega in date, nummoneda in number, nummonto in number,
nummulta in number, numtotal in number, numtipocambio in number default null, flgtipo in number)

IS

BEGIN
  insert into financial.z_ps_transacciones_spw
  (id_requisicion,
  contrata,
  mes,
  fecha_entrega,
  estado_linea,requisitor,usuario_registro,fecha_registro,modificado_por,fecha_modificacion, monto_soles,multa,total,moneda_id,tipo_cambio,flg_genera)
  values(financial.z_ps_spw_requisicion_s.nextVal,numcontrata , nummes, dtfechaentrega,'1',null,user,sysdate,user,sysdate,nummonto,nummulta,numtotal,nummoneda, numtipocambio,flgtipo)
  returning id_requisicion into numrequisicion;

END;
/


