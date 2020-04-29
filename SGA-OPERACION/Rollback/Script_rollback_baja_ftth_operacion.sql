delete from operacion.mototxtiptra where TIPTRA in (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO');
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - A SOLICITUD DEL CLIENTE';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - MIGRACION A CLARO EMPRESA';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - UNIFICACIÓN DE SERVICIOS POR MIGRACIÓN';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - MIGRACION A CLARO INALAMBRICO (LTE)';

delete from operacion.opedd
 where CODIGON =
       (select tiptra
          from operacion.tiptrabajo
         where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO')
		 AND CODIGON_AUX = 11;

delete from operacion.opedd
 where TIPOPEDD = (select TIPOPEDD from operacion.TIPOPEDD where descripcion = 'SGAREASONTIPMOTOT')
   and CODIGON_AUX in
       (select tiptra
          from tiptrabajo
         where descripcion = 'FTTH/SIAC - BAJA TOTAL DEL SERVICIO');
		 
		 
delete from operacion.mototxtiptra where TIPTRA in (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - BAJA ADMINISTRATIVA');
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - PORT OUT';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - FRAUDE';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - CAMBIO DE NUMERO';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - POR REGULARIZACION';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - CAMBIO DE TITULARIDAD';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - CAMBIO DE PLAN';
delete from operacion.motot where DESCRIPCION = 'FTTH/SIAC - TRASLADO A OTRA PROVINCIA';

delete from operacion.opedd
 where CODIGON =
       (select tiptra
          from operacion.tiptrabajo
         where descripcion = 'FTTH/SIAC - BAJA ADMINISTRATIVA')
		 AND CODIGON_AUX = 11;
		 

delete from operacion.opedd
where CODIGON in (select tiptra
      from operacion.tiptrabajo
     where descripcion = 'FTTH/SIAC - BAJA ADMINISTRATIVA')
and TIPOPEDD in (select tipopedd from operacion.tipopedd t where t.abrev = 'ASIGNARWFBSCS'); 

delete from operacion.opedd
 where TIPOPEDD = (select TIPOPEDD from operacion.TIPOPEDD where descripcion = 'SGAREASONTIPMOTOT')
   and CODIGON_AUX in
       (select tiptra
          from tiptrabajo
         where descripcion = 'FTTH/SIAC - BAJA ADMINISTRATIVA');
		 
delete from operacion.tiptrabajo
 where descripcion = 'FTTH/SIAC - BAJA ADMINISTRATIVA';
 
commit;
/