DROP TABLE OPERACION.TABEQUIPO_MATERIAL;
DROP SEQUENCE OPERACION.SQ_TABEQUIPO_MATERIAL;
DROP TABLE OPERACION.OPE_VAL_INSTALADOR_DTH_REL;
DROP INDEX OPERACION.IDX_SOLOTPTOEQU_03;
DROP TABLE OPERACION.tarjeta_deco_asoc;
DROP sequence OPERACION.SQ_TARJETA_DECO_ASOC;
alter table OPERACION.SOLOTPTOEQU drop column IDDET; 

delete from operacion.opedd where tipopedd = (select tipopedd from tipopedd where abrev='DTH_AUTOMATICO'); 
delete from operacion.tipopedd where abrev='DTH_AUTOMATICO';
commit;

--RQM 161362
-- DELETE
DELETE FROM OPERACION.OPEDD WHERE CODIGON = 497 AND UPPER(Descripcion) LIKE '%TRASLADO INTERNO%';
DELETE FROM OPERACION.OPEDD WHERE CODIGON = 498 AND UPPER(Descripcion) LIKE '%MANTENIMIENTO%';
DELETE FROM OPERACION.OPEDD WHERE CODIGON = 612 AND UPPER(Descripcion) LIKE '%TRASLADO EXTERNO%';
DELETE FROM OPERACION.TIPOPEDD WHERE UPPER(ABREV) LIKE '%TIPO_TRANS_DTH%';

DELETE FROM OPERACION.OPEDD WHERE CODIGON = 61 AND UPPER(Descripcion) LIKE '%AREA DE TRABAJO%';
DELETE FROM OPERACION.OPEDD WHERE CODIGON = 61 AND UPPER(Descripcion) LIKE '%MOTIVO%';
DELETE FROM OPERACION.TIPOPEDD WHERE UPPER(ABREV) LIKE '%DATO_SOLOT_DTH%';

COMMIT;

delete from OPERACION.CONSTANTE where upper(constante) like '%DTH_DIRSUC%';
delete from OPERACION.CONSTANTE where upper(constante) like '%DTH_NOMSUC%';
commit;

--rollback
alter table OPERACION.SOLOT
drop column CODIGO_CLARIFY;

--PAQUETE
DROP PACKAGE operacion.pq_integracion_dth;
--Revoke PQ_INTEGRACION_DTH
revoke execute on operacion.PQ_INTEGRACION_DTH to usrwebunipost;