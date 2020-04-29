CREATE OR REPLACE PROCEDURE OPERACION.asigna_numtelefono_cdma
is


/******************************************************************************
   Ver        Date                        Author                            Description
   --------- ----------                   ---------------               ------------------------------------
   1.0
   2.0    16/07/2009           Marco De la Cruz Aquino    --req 97354. Envio de correo según los errores encontrados.
   3.0    13/11/2009           Hector Huaman              --req 106908. Se agregó la logica para el bundle
   4.0    06/10/2010                      REQ.139588
******************************************************************************/

--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.ASIGNA_NUMTELEFONO_CDMA';
c_id_proceso  LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='1862';
c_sec_grabacion float:=fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/

n_codcab number;
n_estinssrv inssrv.estinssrv%type;

--req 97354
l_codsolot solot.codsolot%type;
l_numero numtel.numero%type;
v_mensaje1 varchar2(500);

--req 97354
cursor cur is
         /* select tw.idtareawf, r.numtel, i.codinssrv, n.codnumtel, n.estnumtel, s.codsolot
          from solot s, solotpto sp, sales.reginfcdma r, inssrv i, wf w, tareawf tw, numtel n, estsol e
          where s.numslc=r.numslc
          and s.codsolot=sp.codsolot
          and sp.codsolot=w.codsolot
          and w.idwf=tw.idwf
          and sp.codinssrv=i.codinssrv
          and r.numtel=n.numero
          and s.estsol=e.estsol
          and e.tipestsol =6
          and n.estnumtel <>2
          and tareadef=322
          and w.valido=1
          and i.tipinssrv=3
          and i.numero is null
          and s.tipsrv='0064'
          order by r.numtel;*/

            select distinct tw.idtareawf, r.numtel,i.codinssrv,n.codnumtel,n.estnumtel,s.codsolot,s.numslc
            from solot            s,
                 solotpto         sp,
                 sales.reginfcdma r,
                 inssrv           i,
                 wf               w,
                 tareawf          tw,
                 numtel           n,
                 estsol           e
           where s.numslc = r.numslc
             and s.codsolot = sp.codsolot
             and sp.codsolot = w.codsolot
             and w.idwf = tw.idwf
             and sp.codinssrv = i.codinssrv
             and r.numtel = n.numero
             and s.estsol = e.estsol
             and e.tipestsol = 6
             and n.estnumtel <> 2
             and tareadef = 322
             and w.valido = 1
             and i.tipinssrv = 3
             and i.numero is null
             --and s.tipsrv = '0064' <3.0>
             and s.tipsrv in ('0064','0061')
             and r.tipo = 1
             and r.flg_reserva = 0
           order by r.numtel;

begin

for c in cur loop

      /*  update inssrv set numero = c.numtel where codinssrv = c.codinssrv;
        update numtel
           set estnumtel = 2,
               fecasg    = sysdate,
               codinssrv = c.codinssrv,
               codusuasg = user
         where numero = c.numtel;
        update solot
           set observacion = 'Tarea cerrada por asignación automatica de numero telefonico'
         where codsolot = c.codsolot;

        opewf.pq_wf.p_chg_status_tareawf(c.idtareawf,
                                         4,
                                         4,
                                         null,
                                         sysdate,
                                         sysdate);

        select estinssrv
          into n_estinssrv
          from numtel n, inssrv i
         where n.numero = c.numtel
           and n.codinssrv = i.codinssrv;
        update inssrv
           set estinssrv = 4
         where codinssrv in
               (select codinssrv from numtel where codnumtel = c.codnumtel);

        telefonia.pq_telefonia.p_crear_hunting(c.codnumtel, n_codcab);

        update inssrv
           set estinssrv = n_estinssrv
         where codinssrv in
               (select codinssrv from numtel where codnumtel = c.codnumtel);*/

--req 97354
l_codsolot := c.codsolot;
l_numero :=c.numtel;

        update inssrv set numero = c.numtel, fecini = sysdate where codinssrv = c.codinssrv;
        update numtel set estnumtel = 2, fecasg    = sysdate, codinssrv = c.codinssrv, codusuasg = user where numero = c.numtel;
        update solot set observacion = 'Tarea cerrada por asignación automatica de numero telefonico'  where codsolot = c.codsolot;
        update sales.reginfcdma set flg_reserva = 1 where numslc = c.numslc; -- Adicional para identificar que el numero fue asignado

        opewf.pq_wf.p_chg_status_tareawf(c.idtareawf,
                                         4,
                                         4,
                                         null,
                                         sysdate,
                                         sysdate);

        update solotpto
           set fecinisrv = sysdate
         where codsolot = c.codsolot; -- Se asigna la fecha de inicio del servicio

        select estinssrv
          into n_estinssrv
          from numtel n, inssrv i
         where n.numero = c.numtel
           and n.codinssrv = i.codinssrv;

        update inssrv
           set estinssrv = 4
         where codinssrv in
               (select codinssrv from numtel where codnumtel = c.codnumtel);

        telefonia.pq_telefonia.p_crear_hunting(c.codnumtel, n_codcab);

        update inssrv
           set estinssrv = n_estinssrv
         where codinssrv in
               (select codinssrv from numtel where codnumtel = c.codnumtel);
commit;
end loop;

-- Este codigo se debe poner en todos los stores que se llaman con unjob para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);*/
------------------------------
exception
  when others then
/*      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/


      v_mensaje1 := 'Error Asignación Número Telefónico - CDMA; SOT: '||l_codsolot||'- Número: '||l_numero||' con problemas - ' ||sqlerrm;

     if trim(v_mensaje1) <> '' then

     opewf.pq_send_mail_job.p_send_mail('Revisar JOB - asigna_numtelefono_cdma','DL-PE-ITSoportealNegocio@claro.com.pe',v_mensaje1);
--     opewf.pq_send_mail_job.p_send_mail('Revisar JOB - asigna_numtelefono_cdma','DL-PE-Inalambrico-Soportedegestionycontrol@telmex.com',v_mensaje1);--4.0

     end if;
 --req 97354
---------
end;
/


