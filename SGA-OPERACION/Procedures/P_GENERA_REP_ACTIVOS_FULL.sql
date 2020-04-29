CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_REP_ACTIVOS_FULL
is
/******************************************************************************
   NOMBRE:       P_GENERA_REP_ACTIVOS_FULL
   PROPOSITO:

   REVISIONES:
   Ver        Fecha        Autor           Solicitado por Descripcion
   ---------  ----------  ---------------  -------------  -----------------------
    1.0                                                   Creación
    2.0       14/09/2010  Joseph Asencios  Juan Gallegos  REQ 142589: Adecuaciones por ampliación del campo codigo_ext(tystabsrv)

*********************************************************************/

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
-- ini 2.0
/*s_bouquets                 VARCHAR2(100);*/
s_bouquets                 tystabsrv.codigo_ext%type;
-- fin 2.0
n_largo                    number;
numbouquets                number;
p_text_io                  UTL_FILE.FILE_TYPE;


cursor c_codigo_externo is
select distinct tystabsrv.codigo_ext
         from  OPERACION.reginsdth a ,paquete_venta, detalle_paquete, linea_paquete, producto, tystabsrv
         where paquete_venta.idpaq   = a.idpaq and
               paquete_venta.idpaq   = detalle_paquete.idpaq and
               detalle_paquete.iddet = linea_paquete.iddet and
               detalle_paquete.idproducto = producto.idproducto and
               paquete_venta.estado=0 and
               detalle_paquete.flgestado=1 and
               linea_paquete.flgestado=1 and
               producto.tipsrv = '0062' and--cable
               linea_paquete.codsrv = tystabsrv.codsrv and
               a.estado in ('02','07','17') and
               tystabsrv.codigo_ext is not null;

cursor    c_conax_activos(cod_ext varchar2) is
select distinct trim(b.serie) as serie
from OPERACION.reginsdth a ,paquete_venta, detalle_paquete, linea_paquete, producto, tystabsrv ,operacion.equiposdth b
where paquete_venta.idpaq = a.idpaq and
      paquete_venta.idpaq = detalle_paquete.idpaq and
      detalle_paquete.iddet = linea_paquete.iddet and
      detalle_paquete.idproducto = producto.idproducto and
      paquete_venta.estado=0 and
      detalle_paquete.flgestado=1 and
      linea_paquete.flgestado=1 and
      producto.tipsrv = '0062' and--cable
      linea_paquete.codsrv = tystabsrv.codsrv and
      tystabsrv.codigo_ext is not null and
      a.estado in ('02','07','17') and
      a.numregistro = b.numregistro and
      b.grupoequ = 1 and
      b.serie is not null and
      tystabsrv.codigo_ext = cod_ext order by trim(b.serie) asc;


BEGIN
          p_resultado := 'OK';
          p_ruta      := '/u92/oracle/peprdrac1/dth';
          --p_ruta      := '/u03/oracle/PESGAPRD/UTL_FILE';

          select count(*) into l_cantidad1 from operacion.reg_archivos_enviados where tipo_proceso = 'R';

          if l_cantidad1 > 0 then
             delete operacion.reg_archivos_enviados
             where tipo_proceso = 'R';
             commit;
          end if;

          select TO_CHAR(trunc(sysdate,'MM'),'yyyymmdd') || '0000' into p_fecini  from dual;
          select TO_CHAR(trunc(last_day(sysdate)),'yyyymmdd') || '0000' into p_fecfin from dual;

      for c_cod_ext in c_codigo_externo loop

          s_bouquets := trim(c_cod_ext.codigo_ext);

          select count(distinct trim(b.serie)) into lcantidad
          from OPERACION.reginsdth a ,paquete_venta, detalle_paquete, linea_paquete, producto, tystabsrv ,operacion.equiposdth b
          where paquete_venta.idpaq = a.idpaq and
                paquete_venta.idpaq = detalle_paquete.idpaq and
                detalle_paquete.iddet = linea_paquete.iddet and
                detalle_paquete.idproducto = producto.idproducto and
                paquete_venta.estado=0 and
                detalle_paquete.flgestado=1 and
                linea_paquete.flgestado=1 and
                producto.tipsrv = '0062' and--cable
                linea_paquete.codsrv = tystabsrv.codsrv and
                tystabsrv.codigo_ext is not null and
                a.estado in ('02','07','17') and
                a.numregistro = b.numregistro and
                b.grupoequ = 1 and
                b.serie is not null and
                tystabsrv.codigo_ext = s_bouquets;


          pcantidad         :=  LPAD(lcantidad,5,'0');



          if  lcantidad  > 0 and lcantidad is not null  then

            n_largo := length(s_bouquets);
            numbouquets := (n_largo + 1)/4;

            for i in 1..numbouquets loop
            s_codext := LPAD(operacion.f_cb_subcadena2(s_bouquets,i),8,'0');

            --<REQ 93175
            --select max(to_number(LASTNUMREGENV)) into l_numconax from  operacion.LOG_reg_archivos_enviados;
            --REQ 93175>

            select OPERACION.SQ_FILENAME_ARCH_ENV.NEXTVAL into l_numconax  from dual;


             --<REQ 93175
           /*   if l_numconax is null then
                 l_numconax := 0 ;
              end if;

              if l_numconax = 999999 then
                 l_numconax := 0 ;
              end if;

              l_numconax := l_numconax + 1;*/
            --REQ 93175>


              s_numconax := LPAD(l_numconax,6,'0');
              p_nombre  := 'ps' || s_numconax || '.emm';

              --ABRE EL ARCHIVO    operacion.PQ_DTH_INTERFAZ
              operacion.PQ_DTH_INTERFAZ.p_abrir_archivo(p_text_io,p_ruta,p_nombre,'W',p_resultado,p_mensaje);
              --ESCRIBE EN EL ARCHIVO
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'U' ,'1');
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , s_numconax ,'1');
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , s_codext ,'1');
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , p_fecini ,'1');
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , p_fecfin ,'1');
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'U' ,'1');
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'EMM' ,'1');
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'U' ,'1');
              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , pcantidad ,'1');

              FOR r_cursor in c_conax_activos(c_cod_ext.codigo_ext) loop

                  pidtarjeta      := r_cursor.serie;
                  --ESCRIBE LOS NUMEROS DE LAS TARJETAS A ACTIVAR
                  operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , pidtarjeta ,'1');

              END LOOP;

              operacion.PQ_DTH_INTERFAZ.p_escribe_linea(p_text_io , 'ZZZ' ,'1');
              operacion.PQ_DTH_INTERFAZ.p_cerrar_archivo(p_text_io);

              BEGIN
                p_resultado       :='OK';
                pArchivoLocalenv  := p_nombre;
                pArchivoRemotoreq := 'autreq/req';
                pHost             := '10.245.23.41';
                pPuerto           := '22';
                pUsuario          := 'peru';
                pPass             := '/home/oracle/.ssh/id_rsa';
                pDirectorio       := '/u92/oracle/peprdrac1/dth';
                --pDirectorio       := '/u03/oracle/PESGAPRD/UTL_FILE';

                operacion.PQ_DTH_INTERFAZ.p_enviar_archivo_ascii(pHost,pPuerto,pUsuario,pPass,pDirectorio,pArchivoLocalenv,pArchivoRemotoreq);

                begin
                     SELECT OPERACION.SQ_NUMTRANS.NEXTVAL  INTO l_numtransacconax FROM DUAL;
                     SELECT OPERACION.SQ_REGINSDTH.NEXTVAL INTO l_numregistro FROM dual;

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

              EXCEPTION
                WHEN OTHERS THEN
                p_resultado := 'ERROR1';

              END;
              end loop;
           end if ;
      end loop;
EXCEPTION
    WHEN OTHERS THEN
    p_resultado := 'ERROR';
    p_mensaje   := 'Error al generar archivo CONAX. ' || SQLCODE || ' ' ||
                     SQLERRM;

END P_GENERA_REP_ACTIVOS_FULL;
/


