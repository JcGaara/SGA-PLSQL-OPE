-- TABLA: OPERACION.SGAT_EF_ETAPA_SRVC
-- ADD/MODIFY COLUMNS 
ALTER TABLE OPERACION.SGAT_EF_ETAPA_SRVC MODIFY EFESV_MODNEG NULL;
ALTER TABLE OPERACION.SGAT_EF_ETAPA_SRVC ADD EFESC_CODACT CHAR(5) NOT NULL;
ALTER TABLE OPERACION.SGAT_EF_ETAPA_SRVC ADD EFESV_ACTIVIDAD VARCHAR2(100) NOT NULL;

-- ADD COMMENTS TO THE COLUMNS 
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESC_CODACT
  IS 'CODIGO DE ACTIVIDAD EN MATRIZ';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_SRVC.EFESV_ACTIVIDAD
  IS 'DESCRIPCION DE ACTIVIDAD EN MATRIZ';

  
-- TABLA: OPERACION.SGAT_EF_ETAPA_CNFG
-- ADD/MODIFY COLUMNS 
ALTER TABLE OPERACION.SGAT_EF_ETAPA_CNFG ADD EFECN_COSTO NUMBER(7,2) DEFAULT 0 NOT NULL;
ALTER TABLE OPERACION.SGAT_EF_ETAPA_CNFG ADD EFECN_COSTO_PROV NUMBER(7,2) DEFAULT 0 NOT NULL;

-- ADD COMMENTS TO THE COLUMNS 
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_COSTO
  IS 'COSTO DE ACTIVIDAD EN ZONA LIMA';
COMMENT ON COLUMN OPERACION.SGAT_EF_ETAPA_CNFG.EFECN_COSTO_PROV
  IS 'COSTO DE ACTIVIDAD EN ZONA PROVINCIA';
