-- Create table
create table OPERACION.SGAT_PO_EQUIPO_TCRM
(
  idpo            VARCHAR2(5),
  codtipequ       VARCHAR2(15),
  descripcion     VARCHAR2(100),
  cantidad        NUMBER(2) default 1,
  modalidad       VARCHAR2(3),
  estado          NUMBER(1) default 0,
  ipcre           VARCHAR2(20),
  ipmod           VARCHAR2(20),
  fecre           DATE default sysdate,
  fecmod          DATE default sysdate,
  usucre          VARCHAR2(30) default user,
  usumod          VARCHAR2(30) default user,
  tipo_tecnologia VARCHAR2(10)
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
comment on table OPERACION.SGAT_PO_EQUIPO_TCRM
  is 'Entidad guarda la configuración de las PO y sus equipos configurados ';
-- Add comments to the columns 
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.idpo
  is 'Identificador de PO enviado por CRM';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.codtipequ
  is 'Codigo de Tipo de Equipo';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.descripcion
  is 'Descripción del Equipo';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.cantidad
  is 'Cantidad';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.modalidad
  is 'Modalidad de Entrega';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.estado
  is 'Estado del Registro';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.ipcre
  is 'IP de creación';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.ipmod
  is 'IP de modificación';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.fecre
  is 'Fecha de creación';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.fecmod
  is 'Fecha de modificación';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.usucre
  is 'Usuario de creación';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.usumod
  is 'Usuario de modificación ';
comment on column OPERACION.SGAT_PO_EQUIPO_TCRM.tipo_tecnologia
  is 'Tipo de tecnologia (HFC, DTH ... Otros )';
