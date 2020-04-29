-- Create table
create table OPERACION.OPE_ESTADOSERVICIO_REL
(
  IDMENSAJE   NUMBER not null,
  ESTINSSRV   NUMBER(2),
  ESTADO      NUMBER(1) not null,
  USUREG      VARCHAR2(30),
  FECREG      DATE,
  USUMOD      VARCHAR2(30),
  FECMOD      DATE,
  DESCRIPCION VARCHAR2(20)
)
tablespace OPERACION_DAT
;
-- Add comments to the table 
comment on table OPERACION.OPE_ESTADOSERVICIO_REL
  is 'TABLA DE ESTADO DE SERVICIO';
-- Add comments to the columns 
comment on column OPERACION.OPE_ESTADOSERVICIO_REL.IDMENSAJE
  is 'ID DEL MENSAJE';
comment on column OPERACION.OPE_ESTADOSERVICIO_REL.ESTINSSRV
  is 'ESTADO INSTANCIA DE SERVICIO';
comment on column OPERACION.OPE_ESTADOSERVICIO_REL.ESTADO
  is 'ESTADO';
comment on column OPERACION.OPE_ESTADOSERVICIO_REL.USUREG
  is 'USUARIO DE REGSITRO';
comment on column OPERACION.OPE_ESTADOSERVICIO_REL.FECREG
  is 'FECHA DE REGSITRO';
comment on column OPERACION.OPE_ESTADOSERVICIO_REL.USUMOD
  is 'USUARIO DE MODIFICACION';
comment on column OPERACION.OPE_ESTADOSERVICIO_REL.FECMOD
  is 'FECHA DE MODIFICACION';
comment on column OPERACION.OPE_ESTADOSERVICIO_REL.DESCRIPCION
  is 'DESCRIPCION';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_ESTADOSERVICIO_REL
  add constraint PK_OPE_ESTADOSERVICIO_REL primary key (IDMENSAJE, ESTADO)
  using index 
  tablespace OPERACION_DAT
  ;

grant delete on operacion.ope_estadoservicio_rel to R_PROD;