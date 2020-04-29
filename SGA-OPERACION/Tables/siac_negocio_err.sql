-- Create table
create table OPERACION.SIAC_NEGOCIO_ERR
(
  idprocess NUMBER(10),
  ora_text  VARCHAR2(4000),
  usureg    VARCHAR2(30) default USER,
  fecreg    TIMESTAMP(6) default SYSTIMESTAMP
);
-- Add comments to the columns 
comment on column OPERACION.SIAC_NEGOCIO_ERR.idprocess
  is 'Identificador del Proceso';
comment on column OPERACION.SIAC_NEGOCIO_ERR.ora_text
  is 'Descripcion del Error';
comment on column OPERACION.SIAC_NEGOCIO_ERR.usureg
  is 'Usuario del Registro';
comment on column OPERACION.SIAC_NEGOCIO_ERR.fecreg
  is 'Fecha del Registro';
