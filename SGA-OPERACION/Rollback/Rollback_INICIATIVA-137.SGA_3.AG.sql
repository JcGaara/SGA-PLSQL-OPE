alter table OPERACION.OPE_CAB_XML drop column TIMEOUT;
alter table OPERACION.OPE_WS_INCOGNITO drop column TIPO_TRS;
alter table OPERACION.OPE_WS_INCOGNITO drop column EST_ENVIO;
alter table OPERACION.OPE_WS_INCOGNITO drop column METODO;
alter table OPERACION.OPE_WS_INCOGNITO drop column IDSEQ;
alter table OPERACION.OPE_WS_INCOGNITO drop column AGRUPADOR;

delete from OPERACION.OPE_det_XML where idcab =81 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =82 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =83 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =84 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =85 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =86 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =87 and campo='codmotot';

delete from OPERACION.OPE_det_XML where idcab =88 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =89 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =90 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =91 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =92 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =93 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =94 and campo='codmotot';

delete from OPERACION.OPE_det_XML where idcab =79 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =80 and campo='codmotot';
delete from OPERACION.OPE_det_XML where idcab =113 and campo='codmotot';

delete from operacion.tipopedd where ABREV = 'PROV_MASIVA_SHELL';
delete from operacion.opedd where ABREVIACION = 'CANT_REG_SHELL';
delete from operacion.opedd where ABREVIACION = 'CANT_HILOS_SHELL';
delete from operacion.opedd where ABREVIACION = 'CONSTANTE_PROVISION_MASIVA';

DROP TABLE OPERACION.REG_LOG_SHELL;
DROP SEQUENCE OPERACION.SQ_REG_LOG_SHELL;

commit;