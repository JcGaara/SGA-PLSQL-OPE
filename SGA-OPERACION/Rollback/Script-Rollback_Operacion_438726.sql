/*Eliminamos nuevos campos de la tabla OPERACION.OPE_SOL_SIAC*/
alter table OPERACION.OPE_SOL_SIAC drop column estado;
alter table OPERACION.OPE_SOL_SIAC drop column servi_cod;
alter table OPERACION.OPE_SOL_SIAC drop column fecmod;
alter table OPERACION.OPE_SOL_SIAC drop column usumod;
alter table OPERACION.OPE_SOL_SIAC drop column flgfideliza;
alter table OPERACION.OPE_SOL_SIAC drop column codinteracion;
alter table OPERACION.OPE_SOL_SIAC drop column fecha_prog;

/*Eliminamos variables creadas*/
delete operacion.opedd
 where tipopedd = (select tipopedd 
                               from tipopedd 
                              where abrev = 'HFC_SIAC_DEC_ADICIONAL');

delete operacion.tipopedd
 where abrev = 'HFC_SIAC_DEC_ADICIONAL';

delete operacion.constante
 where constante = 'REMARK_OCC';

COMMIT;
/