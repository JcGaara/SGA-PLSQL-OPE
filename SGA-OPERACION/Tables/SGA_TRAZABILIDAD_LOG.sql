create table OPERACION.SGA_TRAZABILIDAD_LOG
( 
  ID_TRANSACCION         NUMBER not null,    
  ID_INTERACCION         NUMBER not null,         
  TIPO_TRANSACCION       VARCHAR2(100),
  CODSOLOT               NUMBER(8),
  ID_TAREA               NUMBER(6),
  TAREA                  VARCHAR2(100),
  FECHA_REGISTRO         DATE DEFAULT SYSDATE,
  ERROR_MSG              VARCHAR2(4000),
  RESULTADO              VARCHAR2(400)
)
tablespace OPERACION_DAT ;

comment on column OPERACION.SGA_TRAZABILIDAD_LOG.ID_INTERACCION is 'Identificador unico DE INTERACCION';
comment on column OPERACION.SGA_TRAZABILIDAD_LOG.ID_TRANSACCION is 'IDENTIFICADOR DE LA TRANSACCION';
comment on column OPERACION.SGA_TRAZABILIDAD_LOG.ID_TAREA is 'ID Tarea (Tabla tareawfdef)';
comment on column OPERACION.SGA_TRAZABILIDAD_LOG.TAREA is 'Descripcion de la Tarea';