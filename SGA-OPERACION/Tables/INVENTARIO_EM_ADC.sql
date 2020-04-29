-- Create table
create table OPERACION.INVENTARIO_EM_ADC
(
  idunico     VARCHAR2(20) not null,
  nombre      VARCHAR2(350),
  categoria   VARCHAR2(30),
  serializado VARCHAR2(1),
  notas       VARCHAR2(250),
  ipcre       VARCHAR2(20),
  ipmod       VARCHAR2(20),
  usucre      VARCHAR2(30),
  usumod      VARCHAR2(30),
  feccre      DATE,
  fecmod      DATE
)
tablespace OPERACION_DAT;


-- Add comments to the columns 
comment on column OPERACION.INVENTARIO_EM_ADC.idunico
  is 'Identificador Unico';
comment on column OPERACION.INVENTARIO_EM_ADC.nombre
  is 'Descripcion del Equipo';
comment on column OPERACION.INVENTARIO_EM_ADC.categoria
  is 'Catogoria';
comment on column OPERACION.INVENTARIO_EM_ADC.serializado
  is 'Indicador de Serializado';
comment on column OPERACION.INVENTARIO_EM_ADC.notas
  is 'Notas sobre el Equipo';
comment on column OPERACION.INVENTARIO_EM_ADC.ipcre
  is 'IP creacion';
comment on column OPERACION.INVENTARIO_EM_ADC.ipmod
  is 'IP modificacion';
comment on column OPERACION.INVENTARIO_EM_ADC.usucre
  is 'Usuario creacion';
comment on column OPERACION.INVENTARIO_EM_ADC.usumod
  is 'Usuario modificacion';
comment on column OPERACION.INVENTARIO_EM_ADC.feccre
  is 'Fecha creacion';
comment on column OPERACION.INVENTARIO_EM_ADC.fecmod
  is 'Fecha modificacion';
