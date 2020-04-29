CREATE OR REPLACE PROCEDURE operacion.consulta_query(PARAM_ESTSOL in number,
                                           PARAM_TIPTRA in number,
                                           ptiptra      in number,
                                           pwfdef       in number) IS

  l_varchar    varchar2(300);
  ls_resultado varchar2(100);
  ls_mensaje   varchar2(100);

  l_cuenta    number(8);
  l_idwftarea tareawf.idtareawf%type;
  l_tareadef  tareawf.tareadef%type;

  -- Cursor para 1ra validación
  CURSOR c_pendiente IS
    SELECT COUNT(1) PENDIENTES_CIERRE,
           TIPTRA,
           DECODE(ESTSOL,
                  17,
                  'EN EJECUCION',
                  15,
                  'RECHAZADA',
                  10,
                  'GENERADA') ESTADO
      FROM SOLOT
     WHERE ESTSOL IN (PARAM_ESTSOL) --$PARAM_ESTSOL 17,15,10
       AND TIPTRA IN (PARAM_TIPTRA) --$PARAM_TIPTRA  483,484
       AND TRUNC(FECUSU) < TRUNC(SYSDATE)
     GROUP BY TIPTRA, ESTSOL;

  -- Cursor para 2da validación
  CURSOR c_contego IS
    SELECT S.TRXC_ESTADO, COUNT(1) PENDIENTES
      FROM OPERACION.SGAT_TRXCONTEGO S
     GROUP BY S.TRXC_ESTADO;

  -- Cursor donde obtengo los execute
  CURSOR p_cursor IS
    select codsolot,
           'execute operacion.cambiowf_dth(' || codsolot || ',' || ptiptra || ',' ||
           pwfdef || ');' as execu
    --||codsolot||,483,1022
      from solot
     where estsol in (17)
       and tiptra in (484, 483)
       and trunc(fecusu) < trunc(sysdate);

  /*2*/
  cursor cur is
    select distinct s.fecusu,
                    s.codsolot,
                    s.tiptra,
                    wf.idwf,
                    so.codinssrv,
                    c.numregistro,
                    c.estado      estado_cab,
                    d.estado      estado_det,
                    c.flg_recarga,
                    d.pid,
                    wf.wfdef
      from solot               s,
           solotpto            so,
           wf,
           tareawf             tw,
           ope_srv_recarga_cab c,
           ope_srv_recarga_det d
     where s.codsolot = so.codsolot
       and s.codsolot = wf.codsolot
       and wf.idwf = tw.idwf
       and c.numregistro = d.numregistro
       and d.codinssrv = so.codinssrv
       and c.estado <> '04'
       and s.tiptra in (484)
       and s.estsol in (17)
       and c.flg_recarga = 1;

  /*3*/
  cursor cur_1 is
    select distinct aux.idlote,
                    aux.estado,
                    s.codsolot,
                    s.estsol,
                    s.tiptra,
                    d.codinssrv,
                    d.pid,
                    cab.numregistro,
                    wf.idwf
      from ope_tvsat_lote_sltd_aux aux,
           ope_tvsat_sltd_cab      c,
           solot                   s,
           ope_srv_recarga_cab     cab,
           ope_srv_recarga_det     d,
           wf
     where c.idlote = aux.idlote
       and c.numregistro = cab.numregistro
       and cab.numregistro = d.numregistro
       and wf.codsolot = s.codsolot
       and aux.estado = 6
       and s.codsolot = c.codsolot
       and s.estsol = 17
       and cab.estado <> '04'
       and wf.valido = 1
       and c.tiposolicitud = 2
       and c.flg_recarga = 1
       and trunc(s.fecusu) < trunc(sysdate)
     order by 3 desc;

  /*4--suspenciones*/
  cursor cur_2 is
    select distinct aux.idlote,
                    aux.estado,
                    s.codsolot,
                    s.estsol,
                    s.tiptra,
                    d.codinssrv,
                    d.pid,
                    cab.numregistro,
                    wf.idwf
      from ope_tvsat_lote_sltd_aux aux,
           ope_tvsat_sltd_cab      c,
           solot                   s,
           ope_srv_recarga_cab     cab,
           ope_srv_recarga_det     d,
           wf
     where c.idlote = aux.idlote
       and c.numregistro = cab.numregistro
       and cab.numregistro = d.numregistro
       and wf.codsolot = s.codsolot
       and aux.estado = 6
       and s.codsolot = c.codsolot
       and s.estsol = 17
       and cab.estado <> '04'
       and wf.valido = 1
       and c.tiposolicitud = 5
       and c.flg_recarga = 1
       and trunc(s.fecusu) < trunc(sysdate)
    -- and s.codsolot=10377235
     order by 3 desc;

begin
  FOR A IN c_pendiente LOOP
    -- VALIDA LA PRIMERA ALERTA SI TIENE PENDIENTE CIERRE
    IF A.PENDIENTES_CIERRE > 0 THEN
      -- RECCORRE EL CURSOR Y REALIZA EL EXECUTE A TODO EL RESULTADO DEL CURSOR
      FOR c in p_cursor loop
        dbms_output.put_line('ejecuto: ' || c.codsolot || ' - ' || ptiptra ||
                             ' - ' || pwfdef);
        operacion.cambiowf_dth(c.codsolot, ptiptra, pwfdef);
      end loop;
      EXIT; -- SALGO DEL FOR
    END IF;
  
  END LOOP;

  FOR CO IN c_contego LOOP
    IF CO.PENDIENTES > 0 THEN
      /*2*/
      BEGIN
        for c in cur loop
          update ope_srv_recarga_cab
             set estado = '03'
           where numregistro = c.numregistro
             and estado <> '03';
          update ope_srv_recarga_det
             set estado = '16'
           where numregistro = c.numregistro
             and estado <> '16';
          update inssrv
             set estinssrv = 2
           where codinssrv = c.codinssrv
             and estinssrv <> 2;
          update insprd
             set estinsprd = 2
           where pid = c.pid
             and estinsprd <> 2;
          commit;
          operacion.pq_dth.p_reconexion_dth(c.pid,
                                            ls_resultado,
                                            ls_mensaje);
          update ope_srv_recarga_cab
             set estado = '02'
           where numregistro = c.numregistro
             and estado <> '02';
          update ope_srv_recarga_det
             set estado = '17'
           where numregistro = c.numregistro
             and estado <> '17';
          update inssrv
             set estinssrv = 1
           where codinssrv = c.codinssrv
             and estinssrv <> 1;
          update insprd
             set estinsprd = 1
           where pid = c.pid
             and estinsprd <> 1;
        
          opewf.pq_wf.P_DEL_WF(c.idwf);
          operacion.pq_solot.p_ejecutar_solot(c.codsolot);
          commit;
        end loop;
      END;
    
      /*3*/
      BEGIN
        for c in cur_1 loop
          begin
          
            for c_tarea in (select idtareawf
                              from tareawfcpy
                             where idwf = c.idwf
                               and tareadef = 1015) loop
              update tareawfcpy
                 set pre_proc = ''
               where idtareawf = c_tarea.idtareawf;
            end loop;
            commit;
            select count(*)
              into l_cuenta
              from wf w, tareawf t, tareadef d
             where w.idwf = t.idwf
               and t.tareadef = d.tareadef
               and t.esttarea in (1, 2, 19)
               and w.valido = 1
               and w.codsolot = c.codsolot;
            WHILE 0 < l_cuenta LOOP
              begin
                select min(t.idtareawf)
                  into l_idwftarea
                  from wf w, tareawf t
                 where w.idwf = t.idwf
                   and t.esttarea in (1, 2, 19)
                   and w.valido = 1
                   and w.codsolot = c.codsolot
                 group by w.codsolot;
              exception
                when no_data_found then
                  l_idwftarea := NULL;
              end;
              select tareadef
                into l_tareadef
                from tareawf
               where idtareawf = l_idwftarea;
            
              if l_tareadef = 299 then
                operacion.p_ejecuta_activ_desactiv(c.codsolot,
                                                   299,
                                                   sysdate);
              else
                opewf.PQ_WF.P_CHG_STATUS_TAREAWF(l_idwftarea,
                                                 4,
                                                 4,
                                                 null,
                                                 sysdate,
                                                 sysdate);
              end if;
              commit;
              select count(*)
                into l_cuenta
                from wf w, tareawf t, tareadef d
               where w.idwf = t.idwf
                 and t.tareadef = d.tareadef
                 and t.esttarea in (1, 2, 19)
                 and w.valido = 1
                 and w.codsolot = c.codsolot;
            END LOOP;
            commit;
            update ope_srv_recarga_cab
               set estado = '02'
             where numregistro = c.numregistro
               and estado <> '02';
            update ope_srv_recarga_det
               set estado = '17'
             where numregistro = c.numregistro
               and estado <> '17';
            update inssrv
               set estinssrv = 1
             where codinssrv = c.codinssrv
               and estinssrv <> 1;
            update insprd
               set estinsprd = 1
             where pid = c.pid
               and estinsprd <> 1;
            commit;
          
          exception
            when others then
              null;
          end;
        end loop;
      
      END;
    
      /*4--suspenciones*/
    
      begin
        for c in cur_1 loop
          begin
          
            /*for c_tarea in (select idtareawf from tareawfcpy where idwf=c.idwf and tareadef=1015) loop
                update tareawfcpy set pre_proc='' where idtareawf=c_tarea.idtareawf;
            end loop;*/
            commit;
            select count(*)
              into l_cuenta
              from wf w, tareawf t, tareadef d
             where w.idwf = t.idwf
               and t.tareadef = d.tareadef
               and t.esttarea in (1, 2, 19)
               and w.valido = 1
               and w.codsolot = c.codsolot;
            WHILE 0 < l_cuenta LOOP
              begin
                select min(t.idtareawf)
                  into l_idwftarea
                  from wf w, tareawf t
                 where w.idwf = t.idwf
                   and t.esttarea in (1, 2, 19)
                   and w.valido = 1
                   and w.codsolot = c.codsolot
                 group by w.codsolot;
              exception
                when no_data_found then
                  l_idwftarea := NULL;
              end;
              select tareadef
                into l_tareadef
                from tareawf
               where idtareawf = l_idwftarea;
            
              if l_tareadef = 299 then
                operacion.p_ejecuta_activ_desactiv(c.codsolot,
                                                   299,
                                                   sysdate);
              else
                opewf.PQ_WF.P_CHG_STATUS_TAREAWF(l_idwftarea,
                                                 4,
                                                 4,
                                                 null,
                                                 sysdate,
                                                 sysdate);
              end if;
              commit;
              select count(*)
                into l_cuenta
                from wf w, tareawf t, tareadef d
               where w.idwf = t.idwf
                 and t.tareadef = d.tareadef
                 and t.esttarea in (1, 2, 19)
                 and w.valido = 1
                 and w.codsolot = c.codsolot;
            END LOOP;
            commit;
            update ope_srv_recarga_cab
               set estado = '03'
             where numregistro = c.numregistro
               and estado <> '03';
            update ope_srv_recarga_det
               set estado = '16'
             where numregistro = c.numregistro
               and estado <> '16';
            update inssrv
               set estinssrv = 2
             where codinssrv = c.codinssrv
               and estinssrv <> 2;
            update insprd
               set estinsprd = 2
             where pid = c.pid
               and estinsprd <> 2;
            commit;
          
          exception
            when others then
              null;
          end;
        end loop;
      end;
      EXIT; -- SALGO DEL FOR
    END IF;
  END LOOP;

END;
/