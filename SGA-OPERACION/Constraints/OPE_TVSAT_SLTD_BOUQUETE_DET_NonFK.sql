ALTER TABLE OPERACION.OPE_TVSAT_SLTD_BOUQUETE_DET ADD (
  CONSTRAINT PK_OPE_TVSAT_SLTD_BOUQUETE_DET
 PRIMARY KEY
 (IDDET),
  CONSTRAINT UK_OPE_TVSAT_SLTD_BOUQ_DET_1
 UNIQUE (IDSOL, SERIE, BOUQUETE));