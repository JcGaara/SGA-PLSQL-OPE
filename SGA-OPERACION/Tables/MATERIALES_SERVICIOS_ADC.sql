
create table OPERACION.MATERIALES_SERVICIOS_ADC
(
  id_mat_serv      NUMBER(15) not null,
  idunicosap       VARCHAR2(20),
  cantidad         NUMBER(15),
  descripcion      VARCHAR2(350),
  unidades         VARCHAR2(250),
  categoria        VARCHAR2(30),    
  id_serv_mat      NUMBER(15) ,  
  ipcre            VARCHAR2(20),
  ipmod            VARCHAR2(20),  
  usureg           VARCHAR2(50) default USER,
  fecreg           DATE default SYSDATE,
  usumod           VARCHAR2(50) default USER,
  fecmod           DATE default SYSDATE
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.MATERIALES_SERVICIOS_ADC   is 'Tabla de materiales vs servicio';
-- Add comments to the columns 
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.id_mat_serv   is 'Código de materiales vs inventario';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.idunicosap  is 'Codigo SAP.';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.cantidad  is 'Cantidad.';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.categoria  is 'Modelo.';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.descripcion  is 'Descripcion del modelo.';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.unidades  is 'Unidad';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.id_serv_mat  is 'Codigo de solucion y servicio';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.ipcre  		IS 'IP de Creacion ';
COMMENT ON COLUMN operacion.matriz_tystipsrv_tiptra_adc.ipmod  		IS 'IP de Modificacion';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.usureg  is 'Usuario creacion';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.fecreg  is 'Fecha creacion';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.usumod  is 'Usuario de modificación';
comment on column OPERACION.MATERIALES_SERVICIOS_ADC.fecmod  is 'Fecha de modificación';