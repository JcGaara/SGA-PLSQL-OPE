-- Create table
create table OPERACION.IW_SERVICIOS
(
  IDTRANSACCION   NUMBER,
  IDSERVICIO      VARCHAR2(20),
  IDPRODUCTO      VARCHAR2(20),
  IDVENTA         VARCHAR2(20),
  IDSERVICIOPADRE VARCHAR2(20),
  IDPRODUCTOPADRE VARCHAR2(20),
  IDVENTAPADRE    VARCHAR2(20),
  SERVICE         VARCHAR2(50),
  FECHAALTA       VARCHAR2(30),
  IPAPLICACION    VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  USUARIOAPP      VARCHAR2(30) default USER,
  FECUSU          DATE default SYSDATE,
  PCAPLICACION    VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT ;
-- Add comments to the columns 
comment on column OPERACION.IW_SERVICIOS.IDTRANSACCION
  is 'Ticket de IW';
comment on column OPERACION.IW_SERVICIOS.IDSERVICIO
  is 'Id Servicio';
comment on column OPERACION.IW_SERVICIOS.IDPRODUCTO
  is 'Id Producto';
comment on column OPERACION.IW_SERVICIOS.IDVENTA
  is 'IDVENTA';
comment on column OPERACION.IW_SERVICIOS.IDSERVICIOPADRE
  is 'Srv Padre';
comment on column OPERACION.IW_SERVICIOS.IDPRODUCTOPADRE
  is 'Prd Padre';
comment on column OPERACION.IW_SERVICIOS.IDVENTAPADRE
  is 'Vta Padre';
comment on column OPERACION.IW_SERVICIOS.SERVICE
  is 'Servicio';
comment on column OPERACION.IW_SERVICIOS.FECHAALTA
  is 'Fecha de alta';
comment on column OPERACION.IW_SERVICIOS.IPAPLICACION
  is 'IP Aplicacion';
comment on column OPERACION.IW_SERVICIOS.USUARIOAPP
  is 'Usuario APP';
comment on column OPERACION.IW_SERVICIOS.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.IW_SERVICIOS.PCAPLICACION
  is 'PC Aplicacion';
-- Create/Recreate indexes 
create index OPERACION.IDX_IW_SERVICIOS on OPERACION.IW_SERVICIOS (IDTRANSACCION)
  tablespace OPERACION_DAT ;