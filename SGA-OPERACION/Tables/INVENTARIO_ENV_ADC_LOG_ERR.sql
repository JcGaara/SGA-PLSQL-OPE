-- Create table
create table OPERACION.INVENTARIO_ENV_ADC_LOG_ERR
(
  id_inventario    NUMBER(15) not null,
  tecnologia       VARCHAR2(6),
  nom_archivo      VARCHAR2(200),
  id_recurso_ext   NUMBER(8),
  des_error        VARCHAR2(400),
  fecha_inventario DATE,
  flg_carga        NUMBER(1),
  usureg           VARCHAR2(50) default USER,
  fecreg           DATE default SYSDATE,
  usumod           VARCHAR2(50) default USER,
  fecmod           DATE default SYSDATE
)
tablespace OPERACION_DAT;

-- Add comments to the table 
comment on table OPERACION.INVENTARIO_ENV_ADC_LOG_ERR   is 'Tabla de log de la tabla operacion.inventario_env_adc_log';
-- Add comments to the columns 
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.id_inventario  is 'Código de inventario.';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.tecnologia  is 'tecnologia a usar.';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.nom_archivo   is 'Nombre de archivo.';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.id_recurso_ext   is 'Código de Recurso Externo.';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.des_error   is 'Descripcion de error.';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.fecha_inventario   is 'Fecha de inventario.';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.flg_carga   is 'Flag de carga correcta.';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.usureg   is 'Es el usuario que genere el inventario';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.fecreg   is 'Es la fecha en que se genere el inventario';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.usumod   is 'Usuario de modificación';
comment on column OPERACION.INVENTARIO_ENV_ADC_LOG_ERR.fecmod   is 'Fecha de modificación';