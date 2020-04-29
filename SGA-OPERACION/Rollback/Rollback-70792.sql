--Eliminacion de Packages y Packages Bodies
DROP PACKAGE BODY OPERACION.PQ_DECO_ADICIONAL_ADC;
DROP PACKAGE BODY OPERACION.PQ_INTEGRACION_DTH_ADC;
DROP PACKAGE BODY OPERACION.PQ_SIAC_POSTVENTA_ADC;

DROP PACKAGE OPERACION.PQ_DECO_ADICIONAL_ADC;
DROP PACKAGE OPERACION.PQ_INTEGRACION_DTH_ADC;
DROP PACKAGE OPERACION.PQ_SIAC_POSTVENTA_ADC;

--Configuracion ETAdirect

delete from operacion.opedd t
 where t.tipopedd in (select tipopedd
                        from operacion.tipopedd
                       where abrev in ('etadirect'));
  
delete from operacion.tipopedd
 where abrev in ('etadirect');

commit;