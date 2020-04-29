CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_REP_ACTIVOS
is
  /************************************************************
   NOMBRE:     P_GENERA_REP_ACTIVOS
   PROPOSITO:  Realiza el refresco de la señal del servicio de cable satelital para todos los clientes
               que estan activos.

   PROGRAMADO EN JOB:  NO

   REVISIONES:
   Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------
   2.0        12/03/2009  Joseph Asencios  Se enviará para el refresco de la señal los bouquets adicionales
                                           a los clientes activos que tengan activos sus bouquets adicionales.
   3.0        16/10/2009  Jimmy A. Farfán  Se redefinió el procedure para que la cantidad de registros a enviar
                                           sea parametrizable.
   4.0        24/03/2010  Antonio Lagos    REQ.119998, se actualiza procedimiento para llamar a nuevas estructuras de recarga
   5.0        05/05/2010  Antonio Lagos    REQ.119999, se actualiza valor de estado de tabla recargaproyectocliente
   6.0        06/07/2010  Dennys Mallqui   Promociones DTH: Desacoplar el motor de cálculo de promociones en PESGAINT con PESGAPRD
   ***********************************************************/
pidtarjeta                 OPERACION.reginsdth.idtarjeta%TYPE;
p_nombre                   VARCHAR2(50);
p_ruta                     VARCHAR2(100);
p_fecini                   VARCHAR2(12);
p_fecfin                   VARCHAR2(12);
p_resultado                VARCHAR2(300);
p_mensaje                  VARCHAR2(300);
s_codext                   VARCHAR2(8);
s_numconax                 VARCHAR2(6);
pHost                      VARCHAR2(50);
pPuerto                    VARCHAR2(10);
pUsuario                   VARCHAR2(50);
pPass                      VARCHAR2(50);
pDirectorio                VARCHAR2(50);
pArchivoLocalenv           VARCHAR2(50);
pArchivoRemotoreq          VARCHAR2(50);
pcantidad                  VARCHAR2(5);
l_numconax                 NUMBER;
lcantidad                  NUMBER(15);
l_numtransacconax          NUMBER(15);
l_numregistro              number(10);
s_numregistro              varchar2(10);
l_cantidad1                NUMBER;
s_bouquets                 VARCHAR2(100);
n_largo                    number;
numbouquets                number;
p_text_io                  UTL_FILE.FILE_TYPE;
--<3.0>
ln_cant_archivos           number;
ln_nro_archivo             number;
ln_inicio                  number;
ln_fin                     number;
ln_cant_registros          number;
--</3.0>

--<3.0 -- Los bouquets serán obtenidos de la tabla OPEDD>
--Cursor de Bouquets principales.
cursor c_codigo_externo is
select codigon bouquet
  from operacion.opedd
 where tipopedd = 226;

--Cursor de Tarjetas por Bouquet principal
cursor c_conax_activos(p_inicio number, p_fin number) is
select tarjeta
  from tarjetas_activas
 where orden >= p_inicio
   and orden < p_fin;

/*--Cursor de Bouquets adicionales
cursor c_codigo_externo_ba is
select distinct br.bouquets from operacion.bouquetxreginsdth br
where br.tipo = 0 and br.estado = 1;
*/

--</3.0>

--Cursor de Tarjetas por Bouquets adicionales
cursor c_conax_activos_ba(cod_ext varchar2) is
select distinct trim(b.serie) as serie
from operacion.reginsdth a ,operacion.equiposdth b , bouquetxreginsdth br
where a.estado in (select codestdth from estregdth where tipoestado = 1) and
      a.numregistro = b.numregistro and
      b.grupoequ = 1 and
      b.serie is not null and
      br.numregistro = a.numregistro and
      br.tipo = 0 and
      br.estado = 1 and
      br.bouquets = cod_ext
order by trim(b.serie) asc;


BEGIN
      p_resultado := 'OK';
      p_ruta      := '/u92/oracle/peprdrac1/dth';
          --p_ruta    := '/u03/oracle/PESGAPRD/UTL_FILE';


      select count(1) into l_cantidad1 from operacion.reg_archivos_enviados where tipo_proceso = 'R';

      if l_cantidad1 > 0 then
         delete operacion.reg_archivos_enviados
         where tipo_proceso = 'R';
         commit;
      end if;

      --<3.0 -- Se cambió el formato de fecha>
      select TO_CHAR(trunc(new_time (SYSDATE,'EST','GMT'),'MM'),'yyyymmdd') || '0000'
        into p_fecini
        from dummy_ope;

      select TO_CHAR(trunc(last_day(new_time (SYSDATE,'EST','GMT'))),'yyyymmdd') || '0000'
        into p_fecfin
        from dummy_ope;

      select BILLCOLPER.F_PARAMETROSFAC(656)
        into ln_cant_registros
        from dummy_ope;
      --</3.0>

      --<3.0>
      for c_cod_ext in c_codigo_externo loop

        -- Codigo de Bouquet
        s_bouquets := trim(c_cod_ext.bouquet);

        -- Eliminamos los registros temporales de tarjetas previamente enviadas
        delete from tarjetas_activas;

        -- Cargamos todas las tarjetas que se van a enviar al conax que contengan el bouquet
        insert into tarjetas_activas
          (orden, tarjeta)
          select rownum, tarjeta
            from (select distinct trim(b.serie) tarjeta
                    from operacion.reginsdth a,
                         paquete_venta,
                         detalle_paquete,
                         linea_paquete,
                         producto,
                         tystabsrv,
                         operacion.equiposdth b
                   where paquete_venta.idpaq = a.idpaq
                     and paquete_venta.idpaq = detalle_paquete.idpaq
                     and detalle_paquete.iddet = linea_paquete.iddet
                     and detalle_paquete.idproducto = producto.idproducto
                     and paquete_venta.estado = 1
                     and detalle_paquete.flgestado = 1
                     and linea_paquete.flgestado = 1
                     and detalle_paquete.flg_opcional = 0
                     and producto.tipsrv = '0062'
                     and linea_paquete.codsrv = tystabsrv.codsrv
                     and tystabsrv.codigo_ext is not null
                     and a.estado in (select codestdth
                                        from estregdth
                                       where tipoestado = 1)
                     and a.numregistro = b.numregistro
                     and b.grupoequ = 1
                     and b.serie is not null
                     and tystabsrv.codigo_ext like '%' || s_bouquets || '%'
                   union
                  select distinct trim(b.serie) tarjeta
                    from operacion.reginsdth  a,
                         operacion.equiposdth b,
                         bouquetxreginsdth    br
                   where a.estado in (select codestdth
                                        from estregdth
                                       where tipoestado = 1)
                     and a.numregistro = b.numregistro
                     and b.grupoequ = 1
                     and b.serie is not null
                     and br.numregistro = a.numregistro
                     and br.tipo = 0
                     and br.estado = 1
                     and br.bouquets like '%' || s_bouquets || '%'
                     --Ini 6.0: Se adiciona los bouquets promocionales que se encuentren vigentes
                     Union
                      select distinct trim(b.serie) tarjeta
                        from operacion.reginsdth  a,
                             operacion.equiposdth b,
                             bouquetxreginsdth    br
                       where a.estado in (select codestdth
                                            from estregdth
                                           where tipoestado = 1)
                         and a.numregistro = b.numregistro
                         and b.grupoequ = 1
                         and b.serie is not null
                         and br.numregistro = a.numregistro
                         and br.tipo = 2
                         and br.estado = 1
                         and br.bouquets like '%' || s_bouquets || '%'
                         and trunc(sysdate) between br.fecha_inicio_vigencia and
                             br.fecha_fin_vigencia
                     --Fin 6.0
                  --<4.0
                  union

                  select distinct trim(b.numserie) tarjeta
                    --from recargaproyectocliente a, --5.0
                    from ope_srv_recarga_cab a, --5.0
                         paquete_venta,
                         detalle_paquete,
                         linea_paquete,
                         producto,
                         tystabsrv,
                         solotptoequ b,
                         tipequdth c
                   where paquete_venta.idpaq = a.idpaq
                     and paquete_venta.idpaq = detalle_paquete.idpaq
                     and detalle_paquete.iddet = linea_paquete.iddet
                     and detalle_paquete.idproducto = producto.idproducto
                     and paquete_venta.estado = 1
                     and detalle_paquete.flgestado = 1
                     and linea_paquete.flgestado = 1
                     and detalle_paquete.flg_opcional = 0
                     and producto.tipsrv = (select valor from constante where constante = 'FAM_CABLE')
                     and linea_paquete.codsrv = tystabsrv.codsrv
                     and tystabsrv.codigo_ext is not null
                     --<5.0
                     /*and a.estado in (select codestdth
                                        from estregdth
                                       where tipoestado = 1)*/
                     and a.estado in (2)--Activo, tabla ope_estado_recarga
                     --5.0>
                     and a.codsolot = b.codsolot
                     and c.grupoequ = 1
                     and b.codequcom = c.codequcom
                     and b.numserie is not null
                     and tystabsrv.codigo_ext like '%' || s_bouquets || '%'
                  union
                   select distinct trim(b.numserie) tarjeta
                    --from recargaproyectocliente  a, --5.0
                    from ope_srv_recarga_cab  a, --5.0
                         solotptoequ b,
                         bouquetxreginsdth    br,
                         tipequdth c
                   --<5.0
                   /*where a.estado in (select codestdth
                                        from estregdth
                                       where tipoestado = 1)*/
                   where a.estado in (2)--Activo, tabla ope_estado_recarga
                   --5.0>
                     and a.codsolot = b.codsolot
                     and c.grupoequ = 1
                     and b.numserie is not null
                     and b.codequcom = c.codequcom
                     and br.numregistro = a.numregistro
                     and br.tipo = 0
                     and br.estado = 1
                     and br.bouquets like '%' || s_bouquets || '%'
                     --4.0>
                     --Ini 6.0: Se adiciona los bouquets promocionales que se encuentren vigentes
                     Union
                     select distinct trim(b.numserie) tarjeta
                      from ope_srv_recarga_cab a,
                           solotptoequ         b,
                           bouquetxreginsdth   br,
                           tipequdth           c
                     where a.estado in (2) --Activo, tabla ope_estado_recarga
                       and a.codsolot = b.codsolot
                       and c.grupoequ = 1
                       and b.numserie is not null
                       and b.codequcom = c.codequcom
                       and br.numregistro = a.numregistro
                       and br.tipo = 2
                       and br.estado = 1
                       and trunc(sysdate) between br.fecha_inicio_vigencia and
                           br.fecha_fin_vigencia
                       and br.bouquets like '%' || s_bouquets || '%'
                     --Fin 6.0
                     );

        select count(1) into lcantidad from tarjetas_activas;

        if  lcantidad  > 0 then

          ln_cant_archivos := ceil(lcantidad/ln_cant_registros);
          ln_nro_archivo := 0;

          while ln_nro_archivo < ln_cant_archivos loop

            ln_inicio := ln_cant_registros*ln_nro_archivo;
            ln_fin := ln_cant_registros*(ln_nro_archivo+1);

            select LPAD(count(1),5,'0')
              into pcantidad
              from tarjetas_activas
             where orden > ln_inicio
               and orden <= ln_fin;

            select OPERACION.SQ_FILENAME_ARCH_ENV.NEXTVAL into l_numconax  from dummy_ope;

            s_numconax := LPAD(l_numconax,6,'0');
            p_nombre  := 'ps' || s_numconax || '.emm';

            --</3.0>

            --ABRE EL ARCHIVO    operacion.PQ_DTH_INTERFAZ
            operacion.PQ_DTH_INTERFAZ.p_abrir_archivo(p_text_io,p_ruta,p_nombre,'W',p_resultado,p_mensaje);
            --ESCRIBE EN EL ARCHIVO
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'U' ,'1');
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , s_numconax ,'1');
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , lpad(s_bouquets,8,'0') ,'1');
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , p_fecini ,'1');
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , p_fecfin ,'1');
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'U' ,'1');
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'EMM' ,'1');
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'U' ,'1');
            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , pcantidad ,'1');

            for r_cursor in c_conax_activos(ln_inicio, ln_fin) loop         --<3.0>
               pidtarjeta := r_cursor.tarjeta ;
               operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , pidtarjeta ,'1');
            end loop;

            operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'ZZZ' ,'1');
            operacion.PQ_DTH_INTERFAZ.p_cerrar_archivo(p_text_io);

            begin
               p_resultado       :='OK';
               pArchivoLocalenv  := p_nombre;
               pArchivoRemotoreq := 'autreq/req';
               pHost             := '10.245.23.41';
               pPuerto           := '22';
               pUsuario          := 'peru';
               pPass             := '/home/oracle/.ssh/id_rsa';
               pDirectorio       := '/u92/oracle/peprdrac1/dth';
               operacion.PQ_DTH_INTERFAZ.p_enviar_archivo_ascii(pHost,pPuerto,pUsuario,pPass,pDirectorio,pArchivoLocalenv,pArchivoRemotoreq);

               begin
                  select operacion.sq_numtrans.nextval  into l_numtransacconax from dummy_ope;
                  select operacion.sq_reginsdth.nextval into l_numregistro from dummy_ope;

                  s_numregistro :=  LPAD(l_numregistro,10,'0');
                  insert into operacion.LOG_reg_archivos_enviados(numregenv,numregins,filename,LASTNUMREGENV,codigo_ext,tipo_proceso,numtrans)
                  values (s_numconax,s_numregistro,p_nombre,s_numconax,s_codext,'R',l_numtransacconax);

                  insert into operacion.reg_archivos_enviados(numregenv,numregins,filename,estado,LASTNUMREGENV,codigo_ext,tipo_proceso,numtrans)
                  values (s_numconax,s_numregistro,p_nombre,1,s_numconax,s_codext,'R',l_numtransacconax);

                  commit;
               exception
                  when others then
                    rollback;
               end;

            exception
               when others then
                  p_resultado := 'ERROR1';
            end;

            ln_nro_archivo := ln_nro_archivo + 1;

          end loop;
        end if ;
      end loop;

EXCEPTION
    WHEN OTHERS THEN
    p_resultado := 'ERROR';
    p_mensaje   := 'Error al generar archivo CONAX. ' || SQLCODE || ' ' ||
                     SQLERRM;

END P_GENERA_REP_ACTIVOS;
/


