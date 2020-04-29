/*Se eliminan los parametros y contantes creadas*/

  delete from constante c where c.constante = 'PAR_SUSP_APC';
  delete from constante c where c.constante = 'ESTPRV_BSCS';
  
  
  
  delete from opedd where tipopedd = (select t.tipopedd  
                                      from tipopedd t where t.abrev = 'TIPREGCONTIWSGABSCS');
  delete from tipopedd where tipopedd = (select t.tipopedd  
                                         from tipopedd t where t.abrev = 'TIPREGCONTIWSGABSCS');

  
/*Se elimina el nuevo paquete creado*/
  drop package operacion.pq_sga_janus;
  
COMMIT;  
/