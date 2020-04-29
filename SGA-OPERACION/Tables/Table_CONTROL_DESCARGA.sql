-- Create table
create table OPERACION.CONTROL_DESCARGA
(
  idtrs        NUMBER not null,
  tipo         VARCHAR2(10),
  fecha_inicio DATE default sysdate,
  fecha_fin    DATE,
  mensaje      VARCHAR2(500),
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.CONTROL_DESCARGA.idtrs
  is 'Secuencial tabla';
comment on column OPERACION.CONTROL_DESCARGA.tipo
  is 'tipo de proceso';
comment on column OPERACION.CONTROL_DESCARGA.fecha_inicio
  is 'fecha de inicio';
comment on column OPERACION.CONTROL_DESCARGA.fecha_fin
  is 'Fecha de fin';
comment on column OPERACION.CONTROL_DESCARGA.mensaje
  is 'Mensaje de error';
comment on column OPERACION.CONTROL_DESCARGA.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.CONTROL_DESCARGA.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.CONTROL_DESCARGA.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.CONTROL_DESCARGA.fecusu
  is 'Fecha de creacion del resgitro';
