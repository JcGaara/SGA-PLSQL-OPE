alter table OPERACION.LIQUIDACIONDOCBLOB modify descripcion VARCHAR2(150);
 
-- Add/modify columns 
alter table OPERACION.OPE_SP_MAT_EQU_CAB add tipo number default 0;
-- Add comments to the columns 
comment on column OPERACION.OPE_SP_MAT_EQU_CAB.tipo
  is 'Tipo de Requision 0 Fija 1 Movil';
  
alter table OPERACION.OPE_SP_MAT_EQU_DET add ubitecnica VARCHAR2(50);
alter table OPERACION.OPE_SP_MAT_EQU_DET add id_sitio VARCHAR2(50);
alter table OPERACION.OPE_SP_MAT_EQU_DET add pep VARCHAR2(50);
comment on column OPERACION.OPE_SP_MAT_EQU_DET.ubitecnica
  is 'Ubicacion tecnica';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.id_sitio
  is 'Id SITIO';
comment on column OPERACION.OPE_SP_MAT_EQU_DET.pep
  is 'PEP';
