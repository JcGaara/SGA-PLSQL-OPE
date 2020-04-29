-- Create/Recreate indexes 
create index OPERACION.IX_INSSRV_NUMTIP_001 on OPERACION.INSSRV (numero, numslc, tipinssrv)
TABLESPACE OPERACION_IDX
/