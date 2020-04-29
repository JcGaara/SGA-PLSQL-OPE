CREATE OR REPLACE FUNCTION OPERACION.F_VALIDA_BAJA ( p_numslc IN VARCHAR2 )
RETURN NUMBER IS


   ps_idpaq                number(10);
   ln_resultado            number;
   cantidadcodins          number(5);
   cantidadcodbaja         number(5);

   cursor c_codigo_ext_baja is
   select distinct codigo_ext
   from  operacion.reg_archivos_enviados
   where estado = 2 and tipo_proceso = 'B';


   cursor c_codigo_ext_ins(p_idpaq number)  is
            select distinct tystabsrv.codigo_ext
            from  paquete_venta, detalle_paquete, linea_paquete, producto, tystabsrv
            where paquete_venta.idpaq = p_idpaq and
                  paquete_venta.idpaq = detalle_paquete.idpaq and
                  detalle_paquete.iddet = linea_paquete.iddet and
                  detalle_paquete.idproducto = producto.idproducto and
                  detalle_paquete.flgestado=1 and
                  linea_paquete.flgestado=1 and
                  producto.tipsrv = '0062' and--cable
                  linea_paquete.codsrv = tystabsrv.codsrv and
                  tystabsrv.codigo_ext is not null;


 BEGIN

  ln_resultado := 0;
  cantidadcodins := 0;
  cantidadcodbaja := 0;

  select idpaq into ps_idpaq from operacion.reginsdth where numslc = p_numslc;

  FOR c_cod_ext_ins in c_codigo_ext_ins(ps_idpaq) LOOP
     cantidadcodins := cantidadcodins + 1;
     FOR c_cod_ext_baja in c_codigo_ext_baja LOOP

         IF c_cod_ext_baja.codigo_ext = c_cod_ext_ins.codigo_ext  THEN
              cantidadcodbaja := cantidadcodbaja + 1;
         END IF;

     END LOOP;

  END LOOP;

  if cantidadcodins = cantidadcodbaja and cantidadcodins <> 0 then
    ln_resultado := 1;
  else
    ln_resultado := 0;
  end if;
  return(ln_resultado);
 END F_VALIDA_BAJA;
/


