alter table OPERACION.LIQUIDACIONDOCBLOB modify descripcion VARCHAR2(100);
alter table OPERACION.OPE_SP_MAT_EQU_CAB drop column tipo;
alter table OPERACION.OPE_SP_MAT_EQU_DET drop column ubitecnica;
alter table OPERACION.OPE_SP_MAT_EQU_DET drop column id_sitio;
alter table OPERACION.OPE_SP_MAT_EQU_DET drop column pep;