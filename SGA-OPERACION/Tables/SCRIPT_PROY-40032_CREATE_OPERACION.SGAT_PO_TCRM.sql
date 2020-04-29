-- Create table
create table OPERACION.SGAT_PO_TCRM
(
  idpo        VARCHAR2(5),
  codpo       VARCHAR2(50),
  idps        NUMBER(4),
  descripcion VARCHAR2(100),
  estado      NUMBER(1) default 1,
  tipo        VARCHAR2(1),
  ipcre       VARCHAR2(20) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  ipmod       VARCHAR2(20),
  fecre       DATE default sysdate,
  fecmod      DATE,
  usucre      VARCHAR2(30) default user,
  usumod      VARCHAR2(30)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 255
  maxtrans 255
  storage
  (
    initial 64K
    next 128K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table OPERACION.SGAT_PO_TCRM
  is 'Entidad guarda la configuracion de las PO configuradas en el Catalogo de Ericsson';
-- Add comments to the columns 
comment on column OPERACION.SGAT_PO_TCRM.idpo
  is 'Indicador de PO';
comment on column OPERACION.SGAT_PO_TCRM.codpo
  is 'Codigo de PO';
comment on column OPERACION.SGAT_PO_TCRM.idps
  is 'Indicador de PS';
comment on column OPERACION.SGAT_PO_TCRM.descripcion
  is 'Descripción de PS';
comment on column OPERACION.SGAT_PO_TCRM.estado
  is 'Estado';
comment on column OPERACION.SGAT_PO_TCRM.tipo
  is 'Tipo de PO, P: Principal/Base, A: Adicional/Opcional (para identificar si un equipo pertenece a un servicio principal o adicional)';
comment on column OPERACION.SGAT_PO_TCRM.ipcre
  is 'IP creación';
comment on column OPERACION.SGAT_PO_TCRM.ipmod
  is 'IP modificación';
comment on column OPERACION.SGAT_PO_TCRM.fecre
  is 'Fecha de Creación';
comment on column OPERACION.SGAT_PO_TCRM.fecmod
  is 'Fecha de modificación';
comment on column OPERACION.SGAT_PO_TCRM.usucre
  is 'Usuario Creación';
comment on column OPERACION.SGAT_PO_TCRM.usumod
  is 'Usuario Modificación';
