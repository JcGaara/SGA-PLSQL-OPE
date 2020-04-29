/*eliminamos los nuevos paquetes creados*/
drop package operacion.pq_sga_siac;
drop package operacion.pq_sga_bscs;

/*Elimina tabla*/
drop table OPERACION.TAB_DEC_ADI_MODELO;

/*elimina type - usuario operacion*/
DROP type operacion.split_tbl;  

/*Eliminamos parametros*/
delete opedd 
 where abreviacion in ('WFBDECADIC','SOLINSBAJA','RBTIPTRA')
   and tipopedd = (select tipopedd 
                     from tipopedd 
                    where abrev = 'DECO_ADICIONAL');

delete opedd 
 where abreviacion in ('SIAC-HFC-DECO_ADICIONAL')
   and tipopedd = (select tipopedd 
                     from tipopedd 
                    where abrev = 'TRANS_POSTVENTA');

/*Eliminamos la constante*/
delete constante
 where constante = 'BAJADECO_SIAC';

COMMIT;
/