drop table OPERACION.OPE_CAB_XML;
drop table OPERACION.OPE_det_XML;
delete from operacion.opedd where tipopedd=(select tipopedd from tipopedd where abrev='PARAM_REG_AGE');
delete from operacion.tipopedd where tipopedd=(select tipopedd from tipopedd where abrev='PARAM_REG_AGE');
commit;