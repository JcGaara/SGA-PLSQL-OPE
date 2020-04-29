-- Add/modify columns 
alter table OPERACION.TIPTRABAJO add SELPUNTOSSOT NUMBER default 0;
-- Add comments to the columns 
comment on column OPERACION.TIPTRABAJO.SELPUNTOSSOT
  is '0: Punto de la Incidencia : 1 : Todos los puntos del paquete del Servicio enla incidencia';

-- Add/modify columns 
alter table HISTORICO.TIPTRABAJO_LOG add SELPUNTOSSOT NUMBER;
-- Add comments to the columns 
comment on column HISTORICO.TIPTRABAJO_LOG.SELPUNTOSSOT
  is '0: Punto de la Incidencia : 1 : Todos los puntos del paquete del Servicio enla incidencia';


-- Add/modify columns 
alter table OPEWF.TAREAWFDEF add AREA_DERIVA_CORREO VARCHAR2(400);
-- Add comments to the columns 
comment on column OPEWF.TAREAWFDEF.AREA_DERIVA_CORREO
  is 'Correos enviados al derivar tarea a otra area';

