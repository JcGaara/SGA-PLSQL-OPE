-- Create table 
create table OPERACION.AREAOPE_CAMPO
(
  area       NUMBER(4) not null,
  codquery   NUMBER(8) not null,
  item       NUMBER(8) not null,
  campo      VARCHAR2(50) not null,
  alias      VARCHAR2(100),
  tipo       VARCHAR2(50),
  opcfil     NUMBER(1),
  condicion  NUMBER(8),
  boton      NUMBER(1),
  windfil    VARCHAR2(50),
  dwfil      VARCHAR2(50),
  dddfil     VARCHAR2(50),
  disdddfil  VARCHAR2(50),
  datadddfil VARCHAR2(50)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column OPERACION.AREAOPE_CAMPO.area
  is 'Código del Area';
comment on column OPERACION.AREAOPE_CAMPO.codquery
  is 'Código del Reporte';
comment on column OPERACION.AREAOPE_CAMPO.item
  is 'Númeración de los campos de la ventana para el área asignada';
comment on column OPERACION.AREAOPE_CAMPO.campo
  is 'Nombre del campo';
comment on column OPERACION.AREAOPE_CAMPO.alias
  is 'Alias con la cual se identificara el campo tanto en la ventana como en el filtro.';
comment on column OPERACION.AREAOPE_CAMPO.tipo
  is 'El tipo de campo con su dimensión';
comment on column OPERACION.AREAOPE_CAMPO.opcfil
  is '(1/0) Si el campo va a estar en el filtro de la ventana ';
comment on column OPERACION.AREAOPE_CAMPO.condicion
  is '1 igual, 2 in, 3 between';
comment on column OPERACION.AREAOPE_CAMPO.boton
  is '(1/0) Si se mostrará el botón para abrir una ventana para el filtro del campo';
comment on column OPERACION.AREAOPE_CAMPO.windfil
  is 'Ventana de filtro';
comment on column OPERACION.AREAOPE_CAMPO.dwfil
  is 'Datawindow de la ventana de filtro';
comment on column OPERACION.AREAOPE_CAMPO.dddfil
  is 'Datawindow para el Dropdowndatawindow del campo';
comment on column OPERACION.AREAOPE_CAMPO.disdddfil
  is 'Nombre del Display para el Dropdowndatawindow del campo';
comment on column OPERACION.AREAOPE_CAMPO.datadddfil
  is 'Nombre de la Data para el Dropdowndatawindow del campo';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.AREAOPE_CAMPO
  add constraint PK_AREAOPE_CAMPO primary key (AREA, CODQUERY, ITEM)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );