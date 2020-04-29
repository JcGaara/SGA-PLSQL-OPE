create table OPERACION.SERVICIO_MAT_ADC
(
  id_serv_mat      NUMBER(15) not null,
  id_solucion      NUMBER(15),
  id_servicio      NUMBER(15),
  usureg           VARCHAR2(50) default USER,
  fecreg           DATE default SYSDATE,
  usumod           VARCHAR2(50) default USER,
  fecmod           DATE default SYSDATE
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.SERVICIO_MAT_ADC   is 'Tabla de soluciones con servicio';
-- Add comments to the columns 
comment on column OPERACION.SERVICIO_MAT_ADC.id_serv_mat   is 'Código de inventario';
comment on column OPERACION.SERVICIO_MAT_ADC.id_solucion  is 'Tecnologia a usar.';
comment on column OPERACION.SERVICIO_MAT_ADC.id_servicio  is 'Descripcion.';
comment on column OPERACION.SERVICIO_MAT_ADC.usureg  is 'Usuario de registro';
comment on column OPERACION.SERVICIO_MAT_ADC.fecreg  is 'Fecha de registro';
comment on column OPERACION.SERVICIO_MAT_ADC.usumod  is 'Usuario de modificación';
comment on column OPERACION.SERVICIO_MAT_ADC.fecmod  is 'Fecha de modificación';