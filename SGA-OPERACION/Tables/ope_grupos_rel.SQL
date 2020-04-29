-- Create table
create table OPERACION.OPE_GRUPOS_REL
(
  IDGRUPO        NUMBER not null,
  DESCABR        VARCHAR2(15),
  DESCRIPCION    VARCHAR2(35),
  APLICASOLUCION NUMBER,
  ESTADO         NUMBER,
  USUREG         VARCHAR2(30) default USER,
  FECREG         DATE default SYSDATE,
  USUMOD         VARCHAR2(30) default USER,
  FECMOD         DATE default SYSDATE
)
tablespace OPERACION_DAT
;
-- Add comments to the table 
comment on table OPERACION.OPE_GRUPOS_REL
  is 'TABLA DE GRUPOS DE MENSAJES';
-- Add comments to the columns 
comment on column OPERACION.OPE_GRUPOS_REL.IDGRUPO
  is 'ID GRUPO';
comment on column OPERACION.OPE_GRUPOS_REL.DESCABR
  is 'DESCRIPCION ABREVIADA';
comment on column OPERACION.OPE_GRUPOS_REL.DESCRIPCION
  is 'DESCRIPCION';
comment on column OPERACION.OPE_GRUPOS_REL.APLICASOLUCION
  is 'APLICA SOLUCION';
comment on column OPERACION.OPE_GRUPOS_REL.ESTADO
  is 'ESTADO';
comment on column OPERACION.OPE_GRUPOS_REL.USUREG
  is 'USAURIO DE REGISTRO';
comment on column OPERACION.OPE_GRUPOS_REL.FECREG
  is 'FECAHA DE REGSITRO';
comment on column OPERACION.OPE_GRUPOS_REL.USUMOD
  is 'USUARIO DE MODIFICACION';
comment on column OPERACION.OPE_GRUPOS_REL.FECMOD
  is 'FECHA DE MODIFICACION';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_GRUPOS_REL
  add constraint PK_OPE_GRUPOS_REL primary key (IDGRUPO)
  using index 
  tablespace OPERACION_DAT
 ;

grant delete on operacion.ope_grupos_rel to R_PROD;