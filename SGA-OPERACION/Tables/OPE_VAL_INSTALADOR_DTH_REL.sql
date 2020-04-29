-- Create table
create table OPERACION.OPE_VAL_INSTALADOR_DTH_REL
(
  IDVALINSTAL NUMBER not null,
  CODSOLOT    NUMBER(8),
  IDUSUARIO   NUMBER(11),
  IDTAREAWF   NUMBER(8),
  FECREG      DATE default sysdate,
  USUREG      VARCHAR2(30) default user,
  FECMOD      DATE default sysdate,
  USUMOD      VARCHAR2(30) default user
);
-- Add comments to the table 
comment on table OPERACION.OPE_VAL_INSTALADOR_DTH_REL
  is 'Tabla donde se guardar la Validación del Instalador del Servicio Claro TV Sat por SOT';
-- Add comments to the columns 
comment on column OPERACION.OPE_VAL_INSTALADOR_DTH_REL.IDVALINSTAL
  is 'ID de la Tabla';
comment on column OPERACION.OPE_VAL_INSTALADOR_DTH_REL.CODSOLOT
  is 'Indentificador de la SOLOT';
comment on column OPERACION.OPE_VAL_INSTALADOR_DTH_REL.IDUSUARIO
  is 'Identificación del Instalador del Servicio Claro TV Sat';
comment on column OPERACION.OPE_VAL_INSTALADOR_DTH_REL.IDTAREAWF
  is 'ID de la tarea.';
comment on column OPERACION.OPE_VAL_INSTALADOR_DTH_REL.FECREG
  is 'Fecha de Registro';
comment on column OPERACION.OPE_VAL_INSTALADOR_DTH_REL.USUREG
  is 'Usuario de Registro';
comment on column OPERACION.OPE_VAL_INSTALADOR_DTH_REL.FECMOD
  is 'Fecha de Modificación';
comment on column OPERACION.OPE_VAL_INSTALADOR_DTH_REL.USUMOD
  is 'Usuario de Modificación';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_VAL_INSTALADOR_DTH_REL
  add constraint PK_OPE_VAL_INSTALADOR_DTH_REL primary key (IDVALINSTAL);
