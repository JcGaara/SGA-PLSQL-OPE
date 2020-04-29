
drop package BODY OPERACION.PKG_MIGRACION_SGA_BSCS;
drop package operacion.PKG_MIGRACION_SGA_BSCS;

DELETE from opedd o
where o.tipopedd = (select tipopedd from tipopedd where abrev = 'MIGR_SGA_BSCS');

DELETE from tipopedd where abrev = 'MIGR_SGA_BSCS';

COMMIT;

delete from opedd  o
where o.tipopedd = 260 and 
      ((o.codigon = 1147 and  o.DESCRIPCION = 'INSTALACION HFC SISACT') or (o.DESCRIPCION = 'HFC/SIAC MIGRACION SGA BSCS SISTEMA'));

COMMIT;

DROP table OPERACION.MIGRT_DATAPRINC;
DROP table OPERACION.MIGRT_CLIENTES_A_MIGRAR;
DROP table OPERACION.MIGRT_BLACKLIST_CLIENTES;
DROP table OPERACION.MIGRT_BLACKLIST_PLANES;
DROP table OPERACION.MIGRT_ERROR_MIGRACION;
DROP table OPERACION.MIGRT_EQU_SGA_SISACT;
DROP table OPERACION.MIGRT_EQUIPOS_SGA_SISACT;
DROP table OPERACION.MIGRT_DET_TEMP_SOT;
DROP table OPERACION.MIGRT_CAB_TEMP_SOT;
DROP table OPERACION.MIGRT_SERV_ADICIONAL;

DROP SEQUENCE OPERACION.MIGRSEQ_DET_TEM;
DROP SEQUENCE OPERACION.MIGRSEQ_CAB_TEM;
DROP SEQUENCE OPERACION.MIGRSEQ_ERROR_M;
DROP SEQUENCE OPERACION.MIGRSEQ_EQU_SGA;
DROP SEQUENCE OPERACION.MIGRSEQ_DATAPRI;
DROP SEQUENCE OPERACION.MIGRSEQ_EQ_EQUIPO;
DROP SEQUENCE OPERACION.MIGRSEQ_SERV_ADI;