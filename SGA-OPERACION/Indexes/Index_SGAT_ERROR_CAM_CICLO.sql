create index OPERACION.IX_SGAT_ERROR_CAM_CICLO_001 on OPERACION.SGAT_ERROR_CAM_CICLO (ERCCN_CONTRATO)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255;
  
create index OPERACION.IX_SGAT_ERROR_CAM_CICLO_002 on OPERACION.SGAT_ERROR_CAM_CICLO (ERCCD_FECHA)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255;