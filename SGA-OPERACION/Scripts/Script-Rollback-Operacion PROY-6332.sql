
DELETE FROM OPERACION.OPEDD where ABREVIACION = 'P_IMSI';

DELETE FROM OPERACION.OPEDD where ABREVIACION = 'P_HCTR';

DELETE FROM OPERACION.OPEDD where ABREVIACION = 'P_HCON';

DELETE FROM OPERACION.OPEDD where ABREVIACION = 'P_HCCD';

DELETE FROM OPERACION.TIPOPEDD  where abrev = 'PAR_PLATAF_JANUS';

commit;

drop package operacion.PQ_OPE_ASIG_PLATAF_JANUS;

drop table operacion.int_plataforma_bscs;

drop sequence OPERACION.SQ_INT_PLATAFORMA_BSCS;
commit;