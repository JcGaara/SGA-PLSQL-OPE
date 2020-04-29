CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_BLOQUEOSERVICIO AS

/*
estado de la transaccion  - ESTTRANSFCO
------------------------
1  GENERADO
2  EN ESPERA
3  APLICADO
4  APLICADO OTRO
5  CANCELADO
6  APLICADO POR SUSPENSION
*/


  PROCEDURE p_genera_solicitudes
  IS

  ------------------------------------
  --VARIABLES PARA EL ENVIO DE CORREOS
  c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_CORTESERVICIO.P_GENERA_TRANSACCION';
  c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='241';
  c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
  --------------------------------------------------

  l_dia number;
  l_tmp number;
  BEGIN

      --verifica q no se ejecute en fin de semana
      select to_char(sysdate,'d')
      into l_dia
      from dual;
      --verifica q no se ejecute feriado
      select count(*)
      into l_tmp
      from tlftabfer
      where trunc(FECINI) = trunc(sysdate);

     /* if( (l_dia in (6) and (l_tmp = 0) )) then
         begin
            p_verificaregistro;
            p_genera_trans_BLOQUEO();
            p_genera_trans_DESBLOQUEO();
            p_pendiente_transacciones();
          end;
      end if;*/

      if ( (l_dia in (2,3,4,5,6)) and (l_tmp = 0) )  then
         begin
            p_verificaregistro;
            p_genera_trans_BLOQUEO();
            p_genera_trans_DESBLOQUEO();
            p_pendiente_transacciones();
         end;
      end if;


  --------------------------------------------------
  ---ester codigo se debe poner en todos los stores
  ---que se llaman con un job
  --para ver si termino satisfactoriamente
  sp_rep_registra_error
     (c_nom_proceso, c_id_proceso,
      sqlerrm , '0', c_sec_grabacion);

  ------------------------
  exception
    when others then
        sp_rep_registra_error
           (c_nom_proceso, c_id_proceso,
            sqlerrm , '1',c_sec_grabacion );
        raise_application_error(-20000,sqlerrm);

  END;


PROCEDURE p_genera_desbloqueo(a_idtransfco transacciones_fco.idtransfco%type)
  IS
  l_codsolot solot.codsolot%type;
  l_codmotot  motot.codmotot%type;
  l_observacion solot.observacion%type;
  l_validaoperador number;
  l_resultado number;--<3.0>
  v_tipo_paquete number;--<3.0>
  l_codsrv tystabsrv.codsrv%type;--<3.0>
  l_nombrencos configuracion_itw.descripcion%type;--<3.0>
  l_observacion_trans transacciones_fco.observacion%type;--<3.0>

  cursor cur_tra is
  select c.descripcion, o.codigon_aux, o.codigon, o.abreviacion, i.numslc, i.codsrv, t.* --<3.0>
    from transacciones_fco t,operador  c, inssrv i,
         opedd o --<3.0>
   where t.transaccion = 'DESBLOQUEO'
     and t.codsolot is null
     and i.estinssrv in (1)
     and t.idoperadorfco = c.idoperadorfco
     and i.numero = t.nomabr
     and i.codcli = t.codcli
     and t.flgvalido = 1
     and o.abreviacion = 'GENERA_DESBLOQ' --<3.0>
     and o.codigoc = t.tipo --<3.0>
     and t.idtransfco = a_idtransfco;

  BEGIN
  --Obtenemos el motivo
  select m.codmotot
    into l_codmotot
    from constante c, motot m
   where c.valor = m.codmotot and
c.constante = 'MOTIVO_FCO';

  for c_tra in cur_tra loop

   --Validamos que el operador  sea el mismo del bloqueo anterior
    select count(1)      into l_validaoperador
      from transacciones_fco
     where transaccion = 'BLOQUEO' and
       fecfin is null and
       idoperadorfco = c_tra.idoperadorfco and
       nomabr = c_tra.nomabr and
       codcli = c_tra.codcli and
       codsolot is not null;

     ---Valida el tipo de paquete del servicio <3.0>
     begin
      SELECT distinct e.tipo--, c.codsuc
       INTO v_tipo_paquete
       FROM vtadetptoenl c, paquete_venta e
      WHERE c.idpaq = e.idpaq
        and c.numslc = c_tra.numslc;
     exception
     when others then
       v_tipo_paquete:= null;
     end;
     ---Fin <3.0>

    if l_validaoperador > 0 then

         l_observacion:= 'Se genero desbloqueo a solicitud del operador : ' || c_tra.descripcion;
         begin
          if c_tra.tipo = 1 then
              --p_insert_sot(c_tra.codcli,436,'0004',1,l_codmotot,l_observacion,l_codsolot);
        p_insert_sot(c_tra.codcli,c_tra.codigon,'0004',1,l_codmotot,l_observacion,l_codsolot);--<3.0>
              p_insert_solotpto_bloqueo(l_codsolot,c_tra.nomabr);

              --Actualizar el NCOS <3.0>
              if v_tipo_paquete IN (1,4) then
              p_Actualiza_ncos(l_codsolot,c_tra.nomabr,l_resultado,l_codsrv,l_nombrencos);
              l_observacion_trans := 'Error en el proceso por no estar configurado el NCOS: '||l_nombrencos||' para el Servicio: '||l_codsrv;
              else
              l_resultado := 0;
              end if;
              --Fin Actualizar el NCOS<3.0>
          --Actualizar el estado de la transaccion FCO <3.0>
              if l_resultado = 0 then--<3.0>
              update transacciones_fco
              set fecini = sysdate, codsolot = l_codsolot, esttransfco = 3, observacion='' --<3.0>
              where idtransfco = c_tra.idtransfco;

              update operacion.transacciones_fco
              set fecfin = sysdate
              where nomabr = c_tra.nomabr and
                    codcli = c_tra.codcli and
                    transaccion = 'BLOQUEO' and
                    esttransfco not in (5) and
                    fecfin is null and
                    codsolot is not null;
              pq_solot.p_asig_wf(l_codsolot,c_tra.codigon_aux);--<3.0>
              commit;--<3.0>
              else--<3.0>
              rollback;--<3.0>
              update transacciones_fco--<3.0>
              set esttransfco = 2, codsolot = l_codsolot, observacion=l_observacion_trans--<3.0>
              where idtransfco = c_tra.idtransfco;--<3.0>
              commit;--<3.0>
              end if;--<3.0>
          --Fin Actualizar el estado de la transaccion FCO <3.0>
          elsif c_tra.tipo = 2 then
              --p_insert_sot(c_tra.codcli,436,'0058',1,l_codmotot,l_observacion,l_codsolot);
              p_insert_sot(c_tra.codcli,c_tra.codigon,'0058',1,l_codmotot,l_observacion,l_codsolot);--<3.0>
              p_insert_solotpto_bloqueo(l_codsolot,c_tra.nomabr);

              --Actualizar el NCOS<3.0>
              if v_tipo_paquete IN (1,4) then
              p_Actualiza_ncos(l_codsolot,c_tra.nomabr,l_resultado,l_codsrv,l_nombrencos);
              l_observacion_trans := 'Error en el proceso por no estar configurado el NCOS: '||l_nombrencos||' para el Servicio: '||l_codsrv;
              else
              l_resultado := 0;
              end if;
              --Fin Actualizar el NCOS<3.0>
          --Actualizar el estado de la transaccion FCO <3.0>
              if l_resultado = 0 then--<3.0>
              update transacciones_fco
              set fecini = sysdate, codsolot = l_codsolot, esttransfco = 3
                  ,observacion=''--<3.0>
              where idtransfco = c_tra.idtransfco;

              update operacion.transacciones_fco
              set fecfin = sysdate
              where nomabr = c_tra.nomabr and
                    codcli = c_tra.codcli and
                    transaccion = 'BLOQUEO' and
                    esttransfco not in (5) and
                    fecfin is null and
                    codsolot is not null;
        pq_solot.p_asig_wf(l_codsolot,c_tra.codigon_aux);--<3.0>
              commit;--<3.0>
              else--<3.0>
              rollback;--<3.0>
              update transacciones_fco--<3.0>
              set esttransfco = 2, codsolot = l_codsolot, observacion=l_observacion_trans--<3.0>
              where idtransfco = c_tra.idtransfco;--<3.0>
              commit;--<3.0>
              end if;--<3.0>
          --Fin Actualizar el estado de la transaccion FCO <3.0>
          elsif c_tra.tipo = 4 then
              --p_insert_sot(c_tra.codcli,430,'0061',1,l_codmotot,l_observacion,l_codsolot);
        p_insert_sot(c_tra.codcli,c_tra.codigon,'0061',1,l_codmotot,l_observacion,l_codsolot);--<3.0>
              p_insert_solotpto_bloqueo(l_codsolot,c_tra.nomabr);

              --Fin Actualizar el NCOS<3.0>
              if v_tipo_paquete IN (1,4) then
              p_Actualiza_ncos(l_codsolot,c_tra.nomabr,l_resultado,l_codsrv,l_nombrencos);
              l_observacion_trans := 'Error en el proceso por no estar configurado el NCOS: '||l_nombrencos||' para el Servicio: '||l_codsrv;
              else
              l_resultado := 0;
              end if;
              --Fin Actualizar el NCOS<3.0>
              --Actualizar el estado de la transaccion FCO <3.0>
              if l_resultado = 0 then--<3.0>
              update transacciones_fco
              set fecini = sysdate, codsolot = l_codsolot, esttransfco = 3, observacion=''
              where idtransfco = c_tra.idtransfco;

              update operacion.transacciones_fco
              set fecfin = sysdate
              where nomabr = c_tra.nomabr and
                    codcli = c_tra.codcli and
                    transaccion = 'BLOQUEO' and
                    esttransfco not in (5) and
                    fecfin is null and
                    codsolot is not null;
        pq_solot.p_asig_wf(l_codsolot,c_tra.codigon_aux);--<3.0>
              commit;--<3.0>
              else--<3.0>
              rollback;--<3.0>
              update transacciones_fco--<3.0>
              set esttransfco = 2, codsolot = l_codsolot, observacion=l_observacion_trans--<3.0>
              where idtransfco = c_tra.idtransfco;--<3.0>
              commit;--<3.0>
              end if;--<3.0>
          --Fin Actualizar el estado de la transaccion FCO <3.0>
          end if;
        end;
    end if;
  end loop;

  END;
/**********************************************************************
Genera las sots para Bloqueo de telefonia
**********************************************************************/

 PROCEDURE p_genera_bloqueo(a_idtransfco transacciones_fco.idtransfco%type)
  IS
  l_codsolot solot.codsolot%type;
  l_codmotot  motot.codmotot%type;
  l_observacion solot.observacion%type;
  -- INI <3.0>
  l_resultado number;
  v_tipo_paquete number;
  l_codsrv tystabsrv.codsrv%type;
  l_nombrencos configuracion_itw.descripcion%type;
  l_observacion_trans transacciones_fco.observacion%type;
  -- FIN --<3.0>

  cursor cur_tra is
  select c.descripcion, o.codigon_aux, o.codigon, o.abreviacion, i.numslc, t.*--<3.0>
    from transacciones_fco t, operador c, inssrv i, opedd o--<3.0>
   where t.transaccion = 'BLOQUEO'
     and t.codsolot is null
     and i.estinssrv in (1)
     and t.idoperadorfco = c.idoperadorfco
     and i.numero = t.nomabr
     and i.codcli = t.codcli
     and t.flgvalido = 1
     and o.abreviacion = 'GENERA_BLOQUEO'--<3.0>
     and o.codigoc = t.tipo--<3.0>
     and t.idtransfco = a_idtransfco;

  BEGIN
  --Obtenemos el motivo
  select m.codmotot into l_codmotot
  from constante c, motot m
  where c.valor = m.codmotot and
        c.constante = 'MOTIVO_FCO';

  for c_tra in cur_tra loop

     ---Valida el tipo de paquete del servicio<3.0>
     begin
      SELECT distinct e.tipo--, c.codsuc
       INTO v_tipo_paquete
       FROM vtadetptoenl c, paquete_venta e
      WHERE c.idpaq = e.idpaq
        and c.numslc = c_tra.numslc;
     exception
     when others then
       v_tipo_paquete:= null;
     end;
     ---Fin <3.0>

     l_observacion:= 'Se generó bloqueo a solicitud del operador : ' || c_tra.descripcion;
     begin
      if c_tra.tipo = 1 then
          --p_insert_sot(c_tra.codcli,186,'0004',1,l_codmotot,l_observacion,l_codsolot);
      p_insert_sot(c_tra.codcli,c_tra.codigon,'0004',1,l_codmotot,l_observacion,l_codsolot);--<3.0>
          p_insert_solotpto_bloqueo(l_codsolot,c_tra.nomabr);

          --Actualizar el NCOS <3.0>
          if v_tipo_paquete IN (1,4) then
          p_Actualiza_ncos(l_codsolot,c_tra.nomabr,l_resultado,l_codsrv,l_nombrencos);
          l_observacion_trans := 'Error en el proceso por no estar configurado el NCOS: '||l_nombrencos||' para el Servicio: '||l_codsrv;
          else
          l_resultado := 0;
          end if;
          --Fin Actualizar el NCOS<3.0>
          --Actualizar el estado de la transaccion FCO <3.0>
          if l_resultado = 0 then--<3.0>
          update transacciones_fco
          set fecini = sysdate,
              codsolot = l_codsolot,
              esttransfco = 3,
              observacion = '' --<3.0>
          where idtransfco = c_tra.idtransfco;

          update operacion.transacciones_fco
          set fecfin = sysdate
          where nomabr = c_tra.nomabr
             and codcli = c_tra.codcli
             and transaccion in ('DESBLOQUEO')
             and esttransfco not in (5)
             and fecfin is null
             and codsolot is not null;
      pq_solot.p_asig_wf(l_codsolot,c_tra.codigon_aux);--<3.0>
          commit;
          else--<3.0>
          rollback;
          update transacciones_fco--<3.0>
          set esttransfco = 2, codsolot = l_codsolot, observacion=l_observacion_trans--<3.0>
          where idtransfco = c_tra.idtransfco;--<3.0>
          commit;
          end if;--<3.0>
          --Fin Actualizar el estado de la transaccion FCO <3.0>
      elsif c_tra.tipo = 2 then
          --p_insert_sot(c_tra.codcli,186,'0058',1,l_codmotot,l_observacion,l_codsolot);
      p_insert_sot(c_tra.codcli,c_tra.codigon,'0058',1,l_codmotot,l_observacion,l_codsolot);--<3.0>
          p_insert_solotpto_bloqueo(l_codsolot,c_tra.nomabr);

          --Actualizar el NCOS<3.0>
          if v_tipo_paquete IN (1,4) then
          p_Actualiza_ncos(l_codsolot,c_tra.nomabr,l_resultado,l_codsrv,l_nombrencos);
          l_observacion_trans := 'Error en el proceso por no estar configurado el NCOS: '||l_nombrencos||' para el Servicio: '||l_codsrv;
          else
          l_resultado := 0;
          end if;
          --Fin Actualizar el NCOS<3.0>
          --Actualizar el estado de la transaccion FCO <3.0>
          if l_resultado = 0 then--<3.0>
          update transacciones_fco
          set fecini = sysdate,
              codsolot = l_codsolot,
              esttransfco = 3,
              observacion = ''--<3.0>
          where idtransfco = c_tra.idtransfco;

          update operacion.transacciones_fco
          set fecfin = sysdate
          where nomabr = c_tra.nomabr
             and codcli = c_tra.codcli
             and transaccion in ('DESBLOQUEO')
             and esttransfco not in (5)
             and fecfin is null
             and codsolot is not null;
      pq_solot.p_asig_wf(l_codsolot,c_tra.codigon_aux);--<3.0>
          commit;--<3.0>
          else--<3.0>
          rollback;--<3.0>
          update transacciones_fco--<3.0>
          set esttransfco = 2, codsolot = l_codsolot, observacion=l_observacion_trans--<3.0>
          where idtransfco = c_tra.idtransfco;--<3.0>
          commit;--<3.0>
          end if;--<3.0>
          --Fin Actualizar el estado de la transaccion FCO <3.0>
      elsif c_tra.tipo = 4 then
          --p_insert_sot(c_tra.codcli,430,'0061',1,l_codmotot,l_observacion,l_codsolot);
      p_insert_sot(c_tra.codcli,c_tra.codigon,'0061',1,l_codmotot,l_observacion,l_codsolot);--<3.0>
          p_insert_solotpto_bloqueo(l_codsolot,c_tra.nomabr);

          --Actualizar el NCOS<3.0>
          if v_tipo_paquete IN (1,4) then--<3.0>
          p_Actualiza_ncos(l_codsolot,c_tra.nomabr,l_resultado,l_codsrv,l_nombrencos);--<3.0>
          l_observacion_trans := 'Error en el proceso por no estar configurado el NCOS: '||l_nombrencos||' para el Servicio: '||l_codsrv;
          else --<3.0>
          l_resultado := 0;--<3.0>
          end if;--<3.0>
          --Fin Actualizar el NCOS<3.0>

          --Actualizar el estado de la transaccion FCO <3.0>
          if l_resultado = 0 then --<3.0>
          update transacciones_fco
          set fecini = sysdate,
              codsolot = l_codsolot,
              esttransfco = 3,
              observacion = ''--<3.0>
          where idtransfco = c_tra.idtransfco;

          update operacion.transacciones_fco
          set fecfin = sysdate
          where nomabr = c_tra.nomabr
             and codcli = c_tra.codcli
             and transaccion in ('DESBLOQUEO')
             and esttransfco not in (5)
             and fecfin is null
             and codsolot is not null;
      pq_solot.p_asig_wf(l_codsolot,c_tra.codigon_aux);--<3.0>
          commit;--<3.0>
          else--<3.0>
          rollback;--<3.0>
          update transacciones_fco--<3.0>
          set esttransfco = 2, codsolot = l_codsolot, observacion=l_observacion_trans--<3.0>
          where idtransfco = c_tra.idtransfco;--<3.0>
          commit;--<3.0>
          end if;--<3.0>
          --Fin Actualizar el estado de la transaccion FCO <3.0>

      end if;
     end;
  end loop;

 END;

PROCEDURE p_pendiente_transacciones
  IS
  lc_error varchar2(4000);
  l_codcli vtatabcli.codcli%type;
  l_validabloqueo1 number;
  l_validabloqueo2 number;
  l_idtransfco transacciones_fco.idtransfco%type;
  l_idtransfcobloqueo transacciones_fco.idtransfco%type;
  r_transbloq transacciones_fco%rowtype;
  l_codinssrv inssrv.codinssrv%type;
  l_ncos_new inssrv.ncos_new%type;
  l_codsolotbloqueo solot.codsolot%type;
  l_codsolotdesbloqueo solot.codsolot%type;
  ln_diferenciasot     number;
  ln_operadorbloqueo   number;

  cursor cur_trans is
    (select t.idtransfco, t.nomabr,t.transaccion,t.fecini,t.fecfin,t.idoperadorfco,
    t.codmototfco, i.codcli,i.estinssrv , t.esttransfco
    from transacciones_fco t, inssrv i
    where t.nomabr = i.numero and
          t.esttransfco in (1,2,3,4) and
          t.codcli = i.codcli and
          t.fecfin is null and
          t.transaccion = 'BLOQUEO' and
          /*t.codcli = i.codcli and */
          t.codsolot is null and
          t.flgvalido = 0 and
          i.estinssrv in (1,2)
    UNION
    select t.idtransfco, t.nomabr,t.transaccion,t.fecini,t.fecfin,t.idoperadorfco,
    t.codmototfco, i.codcli,i.estinssrv, t.esttransfco
    from transacciones_fco t, inssrv i
    where t.nomabr = i.numero and
          --t.esttransfco in (1,2,3) and   -- jmap
          t.esttransfco in (1,2,3,4) and   -- jmap
          t.codcli = i.codcli and
          t.fecfin is null and
          t.transaccion = 'DESBLOQUEO' and
          /*t.codcli = i.codcli and */
          t.codsolot is null and
          t.flgvalido = 0 and
          i.estinssrv in(1,2))
    ORDER BY /*transaccion desc,*/idtransfco;

  BEGIN

      for all_trans in cur_trans loop
        CASE
              --DESBLOQUEO
         WHEN all_trans.transaccion = 'DESBLOQUEO' THEN
            --Verificamos existencia de SOT de Bloqueo
               select count(1)
                 into l_validabloqueo1
                 from transacciones_fco
                where nomabr = all_trans.nomabr
                  and codcli = all_trans.codcli ---jmap
                  and transaccion = 'BLOQUEO'
                  and esttransfco not in (5) ---jmap
                  and fecfin is null
                  and idtransfco < all_trans.idtransfco ---jmap
                  --and flgvalido = 1
                  ;

            /*if l_validabloqueo1 = 1  then*/  ---jmap
            if l_validabloqueo1 > 0 then      ---jmap
            --Encontramos la solicitud de BLOQUEO previa
              BEGIN
                select max(idtransfco)
                into l_idtransfcobloqueo
                from transacciones_fco
                where transaccion = 'BLOQUEO'
                 and nomabr = all_trans.nomabr
                 and codcli = all_trans.codcli ---jmap
                 and esttransfco not in (5)
                 and fecfin is null
                 ---and flgvalido = 1
                 and idoperadorfco = all_trans.idoperadorfco
                 and idtransfco < all_trans.idtransfco ---jmap
                 --and codsolot is not null
                 ;

                if l_idtransfcobloqueo is not null then
                   select *  into r_transbloq from transacciones_fco
                   where idtransfco = l_idtransfcobloqueo;

                   if f_verifica_baja(all_trans.codcli , all_trans.nomabr) = 0 then

                     if all_trans.estinssrv = 1 then
                      --GENERADO
                      if r_transbloq.esttransfco = 1 then
                          --Actualiza estado del BLOQUEO a APLICADO POR SUSPENSION
                          update transacciones_fco
                          set esttransfco = 6
                          where idtransfco = r_transbloq.idtransfco;

                         --Actualiza estado del DESBLOQUEO a APLICADO POR SUSPENSION
                          update transacciones_fco
                          set esttransfco = 6
                          where idtransfco = all_trans.idtransfco;
                      --EN ESPERA
                      elsif r_transbloq.esttransfco = 2  then
                          --Actualiza estado del BLOQUEO a APLICADO POR SUSPENSION
                          update transacciones_fco
                          set esttransfco = 6
                          where idtransfco= r_transbloq.idtransfco;

                          --Actualiza estado del DESBLOQUEO a APLICADO POR SUSPENSION
                          update transacciones_fco
                          set esttransfco = 6
                          where idtransfco = all_trans.idtransfco;

                          --Se Verifica existencia de transacciones de BLOQUEO de otros operadores en estado APLICADO OTRO
                          select count(*)
                            into l_validabloqueo2
                            from transacciones_fco
                           where transaccion = 'BLOQUEO'
                             --and esttransfco in (4) --adic
                             and esttransfco in (2,4) --adic
                             and fecfin is null
                             and flgvalido = 0
                             and nomabr = all_trans.nomabr
                             and codcli = all_trans.codcli  ---jmap
                             and idoperadorfco <> all_trans.idoperadorfco;

                          if l_validabloqueo2 > 0 then
                             --Encontramos la transaccion mas antigua
                             select min(idtransfco)
                             into l_idtransfco
                             from transacciones_fco
                             where transaccion = 'BLOQUEO'
                             -- and esttransfco in (4) --adic
                             and esttransfco in (2,4) --adic
                             and fecfin is null
                             and flgvalido = 0
                             and nomabr = all_trans.nomabr
                             and codcli = all_trans.codcli  ---jmap
                             and idoperadorfco <> all_trans.idoperadorfco;

                             --Se actualiza el BLOQUEO mas antiguo a EN ESPERA
                             update transacciones_fco
                             set /*esttransfco = 4*/ ---jmap
                                 esttransfco = 2     ---jmap
                             where idtransfco = l_idtransfco;
                          end if;
                      --APLICADO
                      elsif r_transbloq.esttransfco = 3  then
                         begin

                          select max(codinssrv)
                          into l_codinssrv
                          from inssrv
                          where estinssrv in (1, 2) and
                                numero = trim(r_transbloq.nomabr) and
                                codcli = r_transbloq.codcli;

                          select codcli,  ncos_new
                          into  l_codcli  , l_ncos_new
                          from inssrv
                          where codinssrv = l_codinssrv;

                         exception
                         when others then
                          l_codinssrv := null;
                         end;
                          --Buscamos la ultima SOT de bloqueo .a Solicitud del Cliente
                         if l_codinssrv is not null then
                             begin
                              select max(s.codsolot) into l_codsolotbloqueo
                                from solot      s,
                                     constante  c,
                                     motot      m,
                                     tiptrabajo t,
                                     solotpto   p,
                                     estsol e
                               where s.codmotot = m.codmotot --jmap
                                 and c.valor <> m.codmotot
                                 and c.constante = 'MOTIVO_FCO'
                                 and t.tiptra = s.tiptra
                                 --and t.bloqueo_desbloqueo in ('B', 'D') ---jmap
                                 and t.bloqueo_desbloqueo in ('B')   ---jmap
                                 and p.codsolot = s.codsolot
                                 and p.codinssrv = l_codinssrv
                                 and s.estsol = e.estsol
                                 and e.tipestsol not in (5,7)
                                 ;

                             exception
                             when others then
                                l_codinssrv := null;
                                l_codsolotbloqueo := 0; -- jmap
                             end;

                             begin
                              select max(s.codsolot) into l_codsolotdesbloqueo
                                from solot      s,
                                     constante  c,
                                     motot      m,
                                     tiptrabajo t,
                                     solotpto   p,
                                     estsol e
                               where s.codmotot = m.codmotot --jmap
                                 and c.valor <> m.codmotot
                                 and c.constante = 'MOTIVO_FCO'
                                 and t.tiptra = s.tiptra
                                 and t.bloqueo_desbloqueo in ('D')   ---jmap
                                 and p.codsolot = s.codsolot
                                 and p.codinssrv = l_codinssrv
                                 and s.estsol = e.estsol
                                 and e.tipestsol not in (5,7);

                             exception
                             when others then
                                l_codinssrv := null;
                                l_codsolotdesbloqueo := 0; -- jmap
                             end;

                              ln_diferenciasot := nvl(l_codsolotdesbloqueo,0) - nvl(l_codsolotbloqueo,0);

                             /*if l_codsolotbloqueo is null then*/
                             if ln_diferenciasot >= 0 then
                                update transacciones_fco
                                  set flgvalido = 1
                                where idtransfco = all_trans.idtransfco;

                                p_genera_desbloqueo(all_trans.idtransfco);
                             end if;
                         end if;
                         --Verificamos si existe un bloqueo Previo en estado APLICADO OTRO del mismo operador

                         select count(*)
                         into l_validabloqueo1
                         from transacciones_fco
                         where transaccion = 'BLOQUEO' and
                                /*esttransfco = 4  and*/   ---adic
                                esttransfco in (2,4)  and  ---adic
                                nomabr = all_trans.nomabr and
                                codcli = all_trans.codcli  and ---jmap
                                fecfin is null and
                                flgvalido = 0 and
                                idtransfco < all_trans.idtransfco /*and
                                idoperadorfco = all_trans.idoperadorfco*/;

                           if l_validabloqueo1 > 0 then

                              select min(idtransfco)
                                into l_idtransfcobloqueo
                                from transacciones_fco
                               where transaccion = 'BLOQUEO'
                                 --and esttransfco = 4  --adic
                                 and esttransfco in (2,4) --adic
                                 and nomabr = all_trans.nomabr
                                 and codcli = all_trans.codcli   ---jmap
                                 and fecfin is null
                                 and flgvalido = 0
                                 and idtransfco < all_trans.idtransfco
                                 /*and idoperadorfco = all_trans.idoperadorfco*/; --adic

                               --Verificamos que no tenga bloqueos activos
                               select count(1)
                                 into l_validabloqueo2
                                 from transacciones_fco
                                where nomabr = all_trans.nomabr
                                  and codcli = all_trans.codcli
                                  and codsolot is not null
                                  and transaccion = 'BLOQUEO'
                                  and fecfin is null
                                  and esttransfco not in (5/*6*/);

                               if l_validabloqueo2 = 0 then
                                  update transacciones_fco
                                    set flgvalido = 1
                                  where idtransfco = l_idtransfcobloqueo;
                                  --Generamos la SOT
                                  p_genera_bloqueo(l_idtransfcobloqueo);
                               end if;
                           end if;

                       --APLICADO OTRO
                      elsif r_transbloq.esttransfco = 4  then
                        update transacciones_fco
                           set fecfin = sysdate
                         where idtransfco = r_transbloq.idtransfco;

                        update transacciones_fco
                           set esttransfco = 4
                         where idtransfco = all_trans.idtransfco;
                      end if;

                     /*elsif all_trans.estinssrv = 3 then
                        update transacciones_fco
                        set esttransfco = 5 ,
                            fecfin = sysdate
                        where idtransfco = all_trans.idtransfco;*/
                     end if;
                  else
                     update transacciones_fco
                     set esttransfco = 5 ,
                         fecfin = sysdate
                     where idtransfco = all_trans.idtransfco;
                  end if;
                else
                  update transacciones_fco
                  set esttransfco = 2
                  where idtransfco = all_trans.idtransfco;
                end if;

              EXCEPTION
              WHEN OTHERS THEN
                   --No tiene Bloqueo previo
                 update transacciones_fco
                 set esttransfco = 5 ,
                     fecfin = sysdate
                 where idtransfco = all_trans.idtransfco;
              END;
             else
                 update transacciones_fco
                 set esttransfco = 5 ,
                     fecini = sysdate ,
                     fecfin = sysdate
                 where idtransfco = all_trans.idtransfco;
             end if;
           WHEN all_trans.transaccion = 'BLOQUEO' THEN
             --Verificamos que el servicio no este bloqueado
               select count(1)
                 into l_validabloqueo1
                 from transacciones_fco
                where nomabr = all_trans.nomabr
                  and codcli = all_trans.codcli  ---jmap
                  and transaccion = 'BLOQUEO'
                  and esttransfco not in (5)
                  and fecfin is null
                  and flgvalido = 1;
                --Verifica el estado del servicio

                if f_verifica_baja(all_trans.codcli , all_trans.nomabr) = 0 then
                   if l_validabloqueo1 = 0 then
                      if all_trans.estinssrv = 1 then
                         if  all_trans.esttransfco = 1 then
                             select min(idtransfco)
                             into l_idtransfco
                             from transacciones_fco
                             where nomabr = all_trans.nomabr and
                                   codcli = all_trans.codcli and  ---jmap
                                   transaccion = 'BLOQUEO' and
                                   esttransfco not in (5) and
                                   codsolot is not null and
                                   flgvalido = 1;
                             --and fecfin is null;
                             l_idtransfco:= nvl(l_idtransfco,all_trans.idtransfco);

                             --Verificamos que no tenga bloqueos activos
                             select count(1)
                             into l_validabloqueo2
                             from transacciones_fco
                             where nomabr = all_trans.nomabr and
                                   codcli = all_trans.codcli and  ---jmap
                                   transaccion = 'BLOQUEO' and
                                   codsolot is not null and
                                   fecfin is null and
                                   esttransfco not in (5/*6*/);

                             if l_validabloqueo2 = 0 then
                               --Se genera la SOT y actualiza el estado de la trasaccion mas antigua a APLICADO
                                update transacciones_fco
                                  set flgvalido = 1
                                --where idtransfco = l_idtransfco;  ---jmap
                                where idtransfco = all_trans.idtransfco ;
                                /*p_genera_bloqueo(l_idtransfco);*/
                                p_genera_bloqueo(all_trans.idtransfco);

                                --Las demas transacciones se colocan en estado APLICADO OTRO
                                update transacciones_fco
                                  set esttransfco = 4
                                where idtransfco <> all_trans.idtransfco
                                  and nomabr = all_trans.nomabr
                                  and codcli = all_trans.codcli   ---jmap
                                  and flgvalido = 0
                                  and transaccion = 'BLOQUEO'
                                  and fecfin is null
                                  and codsolot is null;
                             end if;

                         /*elsif all_trans.esttransfco in (2) then
                                update transacciones_fco
                                set esttransfco = 3
                                where idtransfco = all_trans.idtransfco;*/
                         elsif all_trans.esttransfco in (/*3*/2,4) then
                                 --Verificamos que no tenga bloqueos activos
                                select count(1)
                                into l_validabloqueo2
                                from transacciones_fco
                                where nomabr = all_trans.nomabr
                                and codcli = all_trans.codcli   ---jmap
                                and transaccion = 'BLOQUEO'
                                and codsolot is not null
                                and fecfin is null
                                and esttransfco not in (5/*6*/);

                                if l_validabloqueo2 = 0 then
                                   update transacciones_fco
                                     set flgvalido = 1
                                   where idtransfco = all_trans.idtransfco;
                                   p_genera_bloqueo(all_trans.idtransfco);
                                end if;
                         end if;
                      elsif all_trans.estinssrv = 2 then
                            if all_trans.esttransfco in (3) then
                                update transacciones_fco
                                set  esttransfco = 2
                                where idtransfco = all_trans.idtransfco;
                            end if;
                      end if;
                   else
                       select count(1)
                       into ln_operadorbloqueo
                       from transacciones_fco
                       where nomabr = all_trans.nomabr
                        and codcli = all_trans.codcli  ---jmap
                        and transaccion = 'BLOQUEO'
                        and esttransfco not in (5)
                        and fecfin is null
                        and flgvalido = 1
                        and idoperadorfco = all_trans.idoperadorfco;
                        --Validamos qué operador bloqueó el servicio de LD
                        if ln_operadorbloqueo > 0 then
                           update transacciones_fco
                           set esttransfco = 5,
                               fecini = sysdate,
                               fecfin = sysdate
                           where idtransfco = all_trans.idtransfco;
                        else
                           update transacciones_fco
                           set esttransfco = 2
                           where idtransfco = all_trans.idtransfco;
                        end if;
                   end if;
                else
                   update transacciones_fco
                   set esttransfco = 5,
                       fecini = sysdate,
                       fecfin = sysdate
                   where idtransfco = all_trans.idtransfco;
                end if;

                /*if all_trans.estinssrv = 1 and l_validabloqueo1 = 0 then
                   if f_verifica_baja(all_trans.codcli , all_trans.nomabr) = 0 then
                       --Estado Generado
                      if  all_trans.esttransfco = 1 then

                         select min(idtransfco)
                         into l_idtransfco
                         from transacciones_fco
                         where nomabr = all_trans.nomabr and
                               codcli = all_trans.codcli and  ---jmap
                               transaccion = 'BLOQUEO' and
                               codsolot is not null and
                               flgvalido = 1;
                         --and fecfin is null;
                         l_idtransfco:= nvl(l_idtransfco,all_trans.idtransfco);

                         --Verificamos que no tenga bloqueos activos
                         select count(1)
                         into l_validabloqueo2
                         from transacciones_fco
                         where nomabr = all_trans.nomabr and
                               codcli = all_trans.codcli and  ---jmap
                               transaccion = 'BLOQUEO' and
                               codsolot is not null and
                               fecfin is null and
                               esttransfco not in (5\*6*\);

                         if l_validabloqueo2 = 0 then
                           --Se genera la SOT y actualiza el estado de la trasaccion mas antigua a APLICADO
                            update transacciones_fco
                              set flgvalido = 1
                            --where idtransfco = l_idtransfco;  ---jmap
                            where idtransfco = all_trans.idtransfco ;
                            \*p_genera_bloqueo(l_idtransfco);*\
                            p_genera_bloqueo(all_trans.idtransfco);

                            --Las demas transacciones se colocan en estado APLICADO OTRO
                            update transacciones_fco
                              set esttransfco = 4
                            where idtransfco <> all_trans.idtransfco
                              and nomabr = all_trans.nomabr
                              and codcli = all_trans.codcli   ---jmap
                              and flgvalido = 0
                              and transaccion = 'BLOQUEO'
                              and fecfin is null
                              and codsolot is null;
                         end if;

                      elsif all_trans.esttransfco in (2) then
                            update transacciones_fco
                            set esttransfco = 3
                            where idtransfco = all_trans.idtransfco;
                      elsif all_trans.esttransfco in (3,4) then
                            --Verificamos que no tenga bloqueos activos
                            select count(1)
                            into l_validabloqueo2
                            from transacciones_fco
                            where nomabr = all_trans.nomabr
                            and codcli = all_trans.codcli   ---jmap
                            and transaccion = 'BLOQUEO'
                            and codsolot is not null
                            and fecfin is null
                            and esttransfco not in (5\*6*\);

                            if l_validabloqueo2 = 0 then
                               update transacciones_fco
                                 set flgvalido = 1
                               where idtransfco = all_trans.idtransfco;
                               p_genera_bloqueo(all_trans.idtransfco);
                            end if;
                      end if;
                    else
                       update transacciones_fco
                       set esttransfco = 5\*6*\ ,
                           fecini = sysdate,
                           fecfin = sysdate
                       where idtransfco = all_trans.idtransfco;
                    end if;

                elsif all_trans.estinssrv = 2 and l_validabloqueo1 = 0 then
                   if f_verifica_baja(all_trans.codcli , all_trans.nomabr) = 0 then
                       --Estado Generado
                      if  all_trans.esttransfco = 1  then
                        --Se queda en estado Generado
                         update transacciones_fco
                         set  esttransfco = 1
                         where idtransfco = all_trans.idtransfco;
                      elsif all_trans.esttransfco in (3) then
                         update transacciones_fco
                         set  esttransfco = 2
                         where idtransfco = all_trans.idtransfco;
                      end if;
                   else
                       update transacciones_fco
                       set esttransfco = 5\*6*\,
                           fecini = sysdate,
                           fecfin = sysdate
                       where idtransfco = all_trans.idtransfco;
                   end if;
                end if;*/
           END CASE;


      end loop;


      EXCEPTION
      WHEN OTHERS THEN
      lc_error := sqlerrm;
      /*p_envia_correo_c_attach('Cortes y Reconexiones',
                                              'DL-PE-ITSoportealNegocio',
                                              'Ocurrió un error en el proceso de depuración de transacciones_fco (operacion.pq_bloqueoservicio.p_pendiente_transacciones)' ||
                                              ', CODCLI: ' || l_codcli ||
                                              ', NUMERO: ' || l_nomabr,
                                              null,
                                              'SGA);*/
  END;

/**********************************************************************
Insertar la cabecera de la SOT
**********************************************************************/
  PROCEDURE p_insert_sot(v_codcli in solot.codcli%type,
                         v_tiptra in solot.tiptra%type,
                         v_tipsrv in solot.tipsrv%type,
                         v_grado in solot.grado%type,
                         v_motivo in solot.codmotot%type,
                         v_obsservacion  in solot.observacion%type,
                         v_codsolot out number ) IS

  BEGIN

  v_codsolot:=  F_GET_CLAVE_SOLOT();
  insert into solot(codsolot, codcli, estsol, tiptra,tipsrv, grado,codmotot,areasol,observacion)-- tiprec, feccom, fecini, fecfin, fecultest)
  values (v_codsolot, v_codcli, 11, v_tiptra,v_tipsrv,v_grado,v_motivo,119,v_obsservacion);-- 'S', sysdate, sysdate, sysdate, sysdate);

  END;

  PROCEDURE p_insert_solotpto_desbloqueo(v_codsolot solot.codsolot%type,
                                        v_numero inssrv.numero%type
                                        ) IS
   cursor cur_detalle is
    select i.codsrv,i.bw,i.codinssrv,i.cid,i.descripcion,i.direccion,i.codubi
    from inssrv i
    where i.numero=v_numero
    and i.estinssrv=1;

  l_cont number;

  BEGIN
  l_cont := 1;
     for c_det in cur_detalle loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,estado,visible,codubi)
        values(v_codsolot,l_cont,c_det.codsrv,c_det.bw,c_det.codinssrv,c_det.cid,c_det.descripcion,c_det.direccion,1,1,c_det.codubi);
        l_cont := l_cont + 1;
        end;
      end loop;
  END;
/**********************************************************************
Insertar los puntos de lineas analogicas a la sot
**********************************************************************/

  PROCEDURE p_insert_solotpto_bloqueo(v_codsolot solot.codsolot%type,
                                       v_numero inssrv.numero%type) IS
   cursor cur_detalle is
    select i.codsrv,i.bw,i.codinssrv,i.cid,i.descripcion,i.direccion,i.codubi
    from inssrv i
    where i.numero =v_numero
    and i.estinssrv=1;

  l_cont number;

  BEGIN

  l_cont := 1;
     for c_det in cur_detalle loop
        begin
         insert into solotpto(codsolot, punto,codsrvnue,bwnue,codinssrv,cid,descripcion,direccion,estado,visible,codubi)
        values(v_codsolot,l_cont,c_det.codsrv,c_det.bw,c_det.codinssrv,c_det.cid,c_det.descripcion,c_det.direccion,1,1,c_det.codubi);
        l_cont := l_cont + 1;
        end;
      end loop;
  END;


PROCEDURE  p_genera_trans_DESBLOQUEO
  IS

l_tienebaja number;
l_tipo  transacciones_fco.tipo%type;
l_codinssrv  inssrv.codinssrv%type;
l_codcli  vtatabcli.codcli%type;
l_bloqueo number;
l_validanumero number;
l_tienesuspension number;
ln_estinssrv  inssrv.estinssrv%type;
  -- obtiene el registro de la suspensión sobre la que se va a reconectar la línea por medio del nombre del cliente
  cursor cur_desbloqueo is
    select t.idsuspension_old, trim(t.telefono) telefono, t.idopeext
      from fco.suspension_old t
       where t.tipo_motivo = 'R'
       and t.estado = 0
       and t.flgleido = 0
       order by t.idsuspension_old;

  BEGIN
  for c_des in cur_desbloqueo loop
      --Validamos que sea numero Claro y que no sea control 2.0
      select count(1)
        into l_validanumero
        from numtel n, inssrv i, tystabsrv t
       where n.numero = i.numero
         and i.codsrv = t.codsrv
         and n.numero = c_des.telefono
         and nvl(t.flag_lc, 0) = 0;

      --Validamos que haya tenido una solicitud de Bloqueo
      select count(1)
      into l_bloqueo
      from transacciones_fco
      where transaccion = 'BLOQUEO' and
            trim(nomabr) = c_des.telefono and
            esttransfco not in (5);

      if l_validanumero > 0 then
         if l_bloqueo > 0 then
            begin
              select max(codinssrv)
              into l_codinssrv
              from inssrv
              where estinssrv not in (4) and
                    numero = trim(c_des.telefono);

              select codcli, estinssrv into  l_codcli  , ln_estinssrv
              from inssrv
              where codinssrv = l_codinssrv;

              if ln_estinssrv = 3 then
                 update fco.suspension_old
                 set estado = 1 , tiporechazo = '01', flgleido = 1
                 where idsuspension_old = c_des.idsuspension_old;
              /*elsif ln_estinssrv = 2 then
                 update fco.suspension_old
                 set estado = 0, tiporechazo = '27', flgleido = 0
                 where idsuspension_old = c_des.idsuspension_old; */
              elsif ln_estinssrv in (1,2) then
                 l_tipo:=f_obtienetiponumero(c_des.telefono);
                 -- inserta el desbloqueo de una SOT con el procedimiento que corre con el JOB
                 insert into operacion.Transacciones_Fco
                 (nomabr,idoperadorfco,transaccion,esttransfco,codcli,tipo,idsuspension_old)
                 values(c_des.telefono,c_des.idopeext,'DESBLOQUEO',1,l_codcli,l_tipo,c_des.idsuspension_old);

                 update fco.suspension_old
                 set estado = 0, flgleido = 1
                 where idsuspension_old = c_des.idsuspension_old;
              end if;

    /*           --Verificación de existencia de SOT de BAJA
                select count(1) into l_tienebaja
                from solot S1, SOLOTPTO SP, INSSRV I, tiptrabajo t
                where S1.codcli = l_codcli
                and c_des.telefono = I.NUMERO
                and I.CODINSSRV =  SP.CODINSSRV
                and I.CODINSSRV = l_codinssrv
                and SP.CODSOLOT = S1.CODSOLOT
                and S1.tiptra = t.tiptra
                and t.tiptrs in (5)
                and S1.estsol in (12,29);

               --Verificación de existencia de SOT de SUSPENSION
                select count(1) into l_tienesuspension
                from solot S1, SOLOTPTO SP, INSSRV I, tiptrabajo t
                where S1.codcli = l_codcli
                and c_des.telefono = I.NUMERO
                and I.CODINSSRV =  SP.CODINSSRV
                and I.CODINSSRV = l_codinssrv
                and SP.CODSOLOT = S1.CODSOLOT
                and S1.tiptra = t.tiptra
                and t.tiptrs in (3,7)
                and S1.estsol in (12,29);

                if l_tienebaja = 0 then
                  if l_tienesuspension = 0 then
                     l_tipo:=f_obtienetiponumero(c_des.telefono);
                     -- inserta el desbloqueo de una SOT con el procedimiento que corre con el JOB
                     INSERT INTO OPERACION.Transacciones_Fco
                     (nomabr,idoperadorfco,transaccion,esttransfco,codcli,tipo,idsuspension_old)
                     VALUES(c_des.telefono,c_des.idopeext,'DESBLOQUEO',1,l_codcli,l_tipo,c_des.idsuspension_old);

                     update fco.suspension_old set estado = 0, flgleido = 1 where idsuspension_old=c_des.idsuspension_old;
                  else
                     update fco.suspension_old set estado = 1, tiporechazo = '27', flgleido = 1 where idsuspension_old=c_des.idsuspension_old;
                  end if;
                else
                  update fco.suspension_old set estado = 1 , tiporechazo = '01', flgleido = 1 where idsuspension_old=c_des.idsuspension_old;
                end if;*/
            exception
            when others then
                 update fco.suspension_old
                 set estado = 1, tiporechazo = '70', flgleido = 1
                 where idsuspension_old = c_des.idsuspension_old;
            end;
         else
            update fco.suspension_old
              set estado = 1, tiporechazo = '26', flgleido = 1
            where idsuspension_old = c_des.idsuspension_old;
         end if;
      else
         update fco.suspension_old
         set estado = 1, tiporechazo = '01', flgleido = 1
         where idsuspension_old = c_des.idsuspension_old;
      end if;
  end loop;

END;


/**********************************************************************
Genera las transacciones para los bloqueos
**********************************************************************/

PROCEDURE  p_genera_trans_BLOQUEO
  IS
l_tipo  transacciones_fco.tipo%type;
l_codinssrv  inssrv.codinssrv%type;
l_codcli  vtatabcli.codcli%type;
l_validanumero number;
l_tienebaja number;
l_tienesuspension number;
ln_estinssrv  inssrv.estinssrv%type;

  cursor cur_bloqueo is
    select t.idsuspension_old,
           trim(t.telefono) telefono, t.idopeext
      from fco.suspension_old t
     where t.tipo_motivo = 'C'
       and t.estado = 0
       and t.flgleido = 0
       order by t.idsuspension_old;

  BEGIN
   for c_bloq in cur_bloqueo loop
      --Validamos que sea numero Claro y que no sea control 2.0
      select count(*)
      into l_validanumero
      from numtel n, inssrv i, tystabsrv t
      where n.numero = i.numero
      and i.codsrv = t.codsrv
      and n.numero = c_bloq.telefono
      and nvl(t.flag_lc, 0) = 0;

     if l_validanumero > 0 then
        begin
          select max(codinssrv)
          into l_codinssrv
          from inssrv
          where estinssrv not in (4)
          and numero = c_bloq.telefono;

          select codcli, estinssrv into  l_codcli  , ln_estinssrv
          from inssrv
          where codinssrv = l_codinssrv;

          /*--Verificación de existencia de SOT de BAJA
          select count(1) into l_tienebaja
          from solot S1, SOLOTPTO SP, INSSRV I, tiptrabajo t
          where S1.codcli = l_codcli
          and c_bloq.telefono = I.NUMERO
          and I.CODINSSRV =  SP.CODINSSRV
          and I.CODINSSRV = l_codinssrv
          and SP.CODSOLOT = S1.CODSOLOT
          and S1.tiptra = t.tiptra
          and t.tiptrs in (5)
          and S1.estsol in (12,29);


          --Verificación de existencia de SOT de SUSPENSION
          select count(1) into l_tienesuspension
          from solot S1, SOLOTPTO SP, INSSRV I, tiptrabajo t
          where S1.codcli = l_codcli
          and c_bloq.telefono = I.NUMERO
          and I.CODINSSRV =  SP.CODINSSRV
          and I.CODINSSRV = l_codinssrv
          and SP.CODSOLOT = S1.CODSOLOT
          and S1.tiptra = t.tiptra
          and t.tiptrs in (3,7)
          and S1.estsol in (12,29);*/

          if ln_estinssrv = 3 then
             update fco.suspension_old
             set estado = 1 , tiporechazo = '01', flgleido = 1
             where idsuspension_old = c_bloq.idsuspension_old;
          /*elsif ln_estinssrv = 2 then
             update fco.suspension_old
             set estado = 0, tiporechazo = '27', flgleido = 0
             where idsuspension_old = c_bloq.idsuspension_old;*/
          elsif ln_estinssrv in (1,2) then
             l_tipo := f_obtienetiponumero(c_bloq.telefono);
             -- Inserta el bloqueo a la que se le asignará una SOT con el procedimiento que corre con el JOB
             insert into operacion.Transacciones_Fco
             (nomabr,idoperadorfco,transaccion,esttransfco,codcli,tipo,idsuspension_old)
             values(c_bloq.telefono,c_bloq.idopeext,'BLOQUEO',1,l_codcli,l_tipo,c_bloq.idsuspension_old);

             update fco.suspension_old
             set estado=0, flgleido=1
             where idsuspension_old=c_bloq.idsuspension_old;
          end if;

          /*if l_tienebaja = 0 then
             if l_tienesuspension = 0 then
                l_tipo := f_obtienetiponumero(c_bloq.telefono);
                update fco.suspension_old
                set estado=0, flgleido=1
                where idsuspension_old=c_bloq.idsuspension_old;
             else
                update fco.suspension_old
                set estado = 1, tiporechazo = '27', flgleido = 1
                where idsuspension_old=c_bloq.idsuspension_old;
             end if;
          else
            update fco.suspension_old
            set estado = 1 , tiporechazo = '01', flgleido = 1
            where idsuspension_old=c_bloq.idsuspension_old;
          end if;*/

        exception
        when others then
          update fco.suspension_old
          set estado=1,tiporechazo='70' ,flgleido=1
          where idsuspension_old=c_bloq.idsuspension_old;
        end;
     else
       update fco.suspension_old
       set estado = 1, tiporechazo = '01', flgleido = 1
       where idsuspension_old = c_bloq.idsuspension_old;
     end if;

   end loop;
 END;

FUNCTION f_obtienetiponumero(v_numero in numtel.numero%type) return number
  IS
  l_tipnumtel number;
BEGIN
  BEGIN
  select s.tipnumtel
    into l_tipnumtel
    from numtel n, inssrv i, soluciones s, vtatabslcfac v
   where trim(n.numero) = v_numero
     and n.codinssrv = i.codinssrv
     and i.numslc = v.numslc
     and v.idsolucion = s.idsolucion;
      EXCEPTION
      WHEN OTHERS THEN
      l_tipnumtel:=0;
     END;
  RETURN l_tipnumtel;


  END;

PROCEDURE p_Actualiza_ncos(v_codsolot in solot.codsolot%type,
                           v_numero in   numtel.numero%type,
                           an_error_ncos out number,--<3.0>
                           l_codsrv out tystabsrv.codsrv%type,--<3.0>
                           l_nombrencos out configuracion_itw.descripcion%type) is--<3.0>

l_valido tiptrabajo.bloqueo_desbloqueo%type;
l_ncos_new inssrv.ncos_new%type;
l_ncos_old inssrv.ncos_old%type;
l_codinssrv inssrv.codinssrv%type;
l_idncosactual configuracion_itw.idncos%type;
l_idncoscorte configuracion_itw.idncos%type;
l_cuerpocorreo operacion.contacto_email_bloqueo.cuerpo_correo%type;--<3.0>
l_departamento vtatabest.nomest%type;--<3.0>
-- INI <3.0>
cursor cur_contacto_bloqueado is
select *
from operacion.contacto_email_bloqueo
where estado = 1
and motivo = 'BLOQUEADO';

cursor cur_contacto_desbloqueado is
select *
from operacion.contacto_email_bloqueo
where estado = 1
and motivo = 'DESBLOQUEADO';
-- FIN <3.0>
  begin

      select codinssrv,codsrv,ncos_new,ncos_old
      into l_codinssrv, l_codsrv, l_ncos_new, l_ncos_old
      from inssrv
      where numero = v_numero and
            estinssrv in (1,2);

      --Valido tipo de bloqueo para el tipo de trabajo
       begin
       select t.bloqueo_desbloqueo
         into l_valido
         from tiptrabajo t, solot s
        where s.codsolot = v_codsolot
          and s.tiptra = t.tiptra;
       exception
       when others then
        l_valido:=null;
       end ;

       if l_valido in('B','D') then
       --Obtenemos el idncos actual
          if l_ncos_new is not null then
             begin
             --Inicio - Datos para envío de correo<3.0>
             --Obtener nombre del NCOS para llenar el cuerpo del correo<3.0>
              select c.descripcion
                into l_nombrencos
                from configuracion_itw c,
                     ncosxdepartamento n
               where c.idncos = n.idncos and
                     c.tipo='B' and
                     n.codigo_ext = l_ncos_new;
             --Obtener nombre del Departamento del ncosxdepartamento para llenar el cuerpo del correo<3.0>
              select v.nomest
                into l_departamento
                from configuracion_itw c,
                     ncosxdepartamento n,
                     vtatabest v
                where c.idncos = n.idncos and
                      n.codest = v.codest and
                      v.codpai = 51 and
                      c.tipo='B' and
                      n.codigo_ext = l_ncos_new;
              --Fin <3.0>

              select n.idncos into l_idncosactual
                from configuracion_itw c,
                     ncosxdepartamento n
               where c.idncos = n.idncos and
                     c.tipo='B' and
                     n.codigo_ext = l_ncos_new;
             exception
             when others then
              l_idncosactual:= null;
              l_nombrencos:= '[NO CONFIGURADO]';--<3.0>
              l_departamento:= '[NO CONFIGURADO]';--<3.0>
             end;
             l_ncos_old := l_ncos_new;

          else
            l_idncosactual:= 0;
          end if;

          if l_idncosactual is not null then --<3.0>
          begin--<3.0>
          --Hallamos el idncos del corte
          select  idncos_corte
          into l_idncoscorte
          from configuracion_itw
          where idncos = l_idncosactual;
          ---Inicio - Envío de Correo por error<3.0>
          exception
          when others then
          l_idncoscorte := null;
          an_error_ncos := 1;

          if l_valido = 'B' then
           for c_contacto in cur_contacto_bloqueado loop
              --Crear cuerpo de correo
            select replace(c_contacto.cuerpo_correo, '[SERVICIO]', l_codsrv)
              into l_cuerpocorreo
              from dual;
            select replace(l_cuerpocorreo, '[NCOS]', l_nombrencos||' - '||l_departamento)
              into l_cuerpocorreo
              from dual;
              --envío de correo bloqueado
              OPEWF.pq_send_mail_job.p_send_mail(c_contacto.asunto_correo,c_contacto.email_destino,l_cuerpocorreo,c_contacto.email_origen);
           end loop;
          else
          for c_contacto in cur_contacto_desbloqueado loop
              --Crear cuerpo de correo
            select replace(c_contacto.cuerpo_correo, '[SERVICIO]', l_codsrv)
              into l_cuerpocorreo
              from dual;
            select replace(l_cuerpocorreo, '[NCOS]', l_nombrencos||' - '||l_departamento)
              into l_cuerpocorreo
              from dual;
              --envío de correo desbloqueado
              OPEWF.pq_send_mail_job.p_send_mail(c_contacto.asunto_correo,c_contacto.email_destino,l_cuerpocorreo,c_contacto.email_origen);
           end loop;
          end if;
          end;
          ---Fin <3.0>
          end if;

          if l_idncoscorte is not null then --<3.0>
          --Hallamos en numero ncos
          select n.codigo_ext
          into l_ncos_new
          from configuracion_itw   c,
               configxproceso_itw  p,
               ncosxdepartamento   n,
               configxservicio_itw s,
               solotpto            t,
               v_ubicaciones       v
           where c.idconfigitw = p.idconfigitw
            and p.proceso = 19
            and c.idconfigitw = s.idconfigitw
            and s.codsrv = l_codsrv
            and s.codsrv = t.codsrvnue
            and c.idncos = n.idncos
            and c.idncos= l_idncoscorte
            and t.codubi = v.codubi
            and t.codsolot =v_codsolot
            and v.codest = trim(n.codest);

            --Actualizamos el NCOS
            update inssrv
            set ncos_new = l_ncos_new ,
                ncos_old = l_ncos_old
            where codinssrv = l_codinssrv;

            update solotpto
            set ncos_new = l_ncos_new ,
                ncos_old = l_ncos_old
            where codinssrv = l_codinssrv and
                  codsrvnue = l_codsrv;

            an_error_ncos := 0; --<3.0>
            end if;    --<3.0>
       end if;
  end;
  FUNCTION f_verifica_baja( v_codcli transacciones.codcli%type, v_nomabr transacciones.nomabr%type ) return number
  IS

    l_tiene_baja number;
    sid_actual INSSRV.CODINSSRV%TYPE;
    hay_sid_actual number;

  BEGIN
        /*Se identifica el último servicio asociado al número de teléfono y al cliente. No se consideran servicios sin activar (estado = 4)*/
        select count(codinssrv)
        into hay_sid_actual
        from inssrv
        where numero = v_nomabr and
              codcli = v_codcli and
              estinssrv not in (4);

        if hay_sid_actual > 0 then
            select max(codinssrv)
            into sid_actual
            from inssrv
            where numero = v_nomabr and
                  codcli = v_codcli and
                  estinssrv not in (4);
            /*Se verifica si existe una baja atendida, cerrada o pendiente por fecha de compromiso*/
            select count(1) into l_tiene_baja
            from solot s, solotpto sp, inssrv i
            where i.numero = v_nomabr
            and i.codinssrv = sp.codinssrv
            and sp.codsolot = s.codsolot
            --and s.tiptra in( 406,408,440,448,426,423)
      and s.tiptra in (select codigon from opedd where abreviacion = 'VERIFICA_BAJA')--<3.0>
            and s.codcli = v_codcli
            and (s.estsol in (29,12) or trunc(s.feccom) <= trunc(sysdate))
            and i.codinssrv = sid_actual;
        end if;

        return l_tiene_baja; -- 0 si no existe baja, 1 si existe una baja.
  END;


PROCEDURE p_verificadesbloqueo(v_numero numtel.numero%type
, v_idtipobloqueo varchar2) is

l_valido number;
l_codinssrv inssrv.codinssrv%type;
l_codcli vtatabcli.codcli%type;
l_validabloqueoLD number;
l_idtransfco  transacciones_fco.idtransfco%type;
l_operador varchar2(500);
ln_contador number;

  begin
   --Verificamos si esta el numero bloqueada a pedido del operador
   select count(*)
     into l_valido
     from transacciones_fco
    where nomabr = v_numero
      and flgvalido = 1
      and fecfin is null;

      begin
        select max(codinssrv)
        into l_codinssrv
        from inssrv
        where estinssrv in (1,2)
        and numero = v_numero;

        select codcli into l_codcli
        from inssrv
        where codinssrv = l_codinssrv;

      exception
       when others then
        l_codinssrv:=null;
      end ;
   --Verificamos que la linea este bloqueada para LDI
     if l_codinssrv is not null then
        select INSTR(v_idtipobloqueo,'01') into l_validabloqueoLD  from dual;

        if l_validabloqueoLD = 0 then

            select count(1) into ln_contador from transacciones_fco
            where nomabr = v_numero
            and flgvalido = 1
            and fecfin is null
            and transaccion = 'BLOQUEO'
            and esttransfco not in (5) ;

            if ln_contador > 0 then
               select max(idtransfco)
               into l_idtransfco
               from transacciones_fco
               where nomabr = v_numero
               and flgvalido = 1
               and fecfin is null
               and transaccion = 'BLOQUEO'
               and esttransfco not in (5) ;

               select p.descripcion
               into l_operador
               from operador p, transacciones_fco t
               where t.idoperadorfco = p.idoperadorfco
               and t.idtransfco = l_idtransfco;

               RAISE_APPLICATION_ERROR(-20500, 'No es posible aplicar esta opción de desbloqueo a solicitud del cliente, ya que el servicio se encuentra bloqueado a solicitud del operador '||l_operador||'.' );
            end if;


        end if;

     end if;

  end;

PROCEDURE p_verificaregistro is
l_validabloqueoprevio number;
l_validadesbloqueoprevio number;
l_validalineacontrol number;--<3.0>
l_validatelefonobaja number;--<3.0>
sid_actual INSSRV.CODINSSRV%TYPE;--<3.0>
hay_sid_actual number;--<3.0>

  cursor cur_reg is
    select idsuspension_old, telefono, tipo_motivo, idopeext
     , idinscripcion --<3.0>
      from fco.suspension_old
     where flgleido = 0
     order by idsuspension_old;

  begin
   for c_reg in cur_reg loop
     --Verifica campos obligados
     if c_reg.telefono is null or c_reg.tipo_motivo not in ('C','R') then
       update fco.suspension_old
          set flgleido = 1, estado = 1, tiporechazo = '70'
        where idsuspension_old = c_reg.idsuspension_old;
     else
       --Inicio <3.0>
       --verificar si el número telefónico esta dado de baja
        select count(codinssrv)
          into hay_sid_actual
          from inssrv
         where numero = trim(c_reg.telefono)
           and codcli = trim(c_reg.idinscripcion);

        if hay_sid_actual > 0 then
            select max(codinssrv)
              into sid_actual
              from inssrv
             where numero = trim(c_reg.telefono)
               and codcli = trim(c_reg.idinscripcion);

            select estinssrv
              into l_validatelefonobaja
              from inssrv
             where codinssrv = sid_actual;

            if l_validatelefonobaja = '3' then
               update fco.suspension_old
                  set flgleido = 1, estado = 1, tiporechazo = '29'
                where idsuspension_old = c_reg.idsuspension_old;
            end if;
        end if;
       --Fin <3.0>

       --Verifica que no haya suspension vigente
       if  c_reg.tipo_motivo ='C' then
       --Inicio <3.0>
       --verificar si teléfono a bloquear pertenece a una linea control
         select count(1)
           into l_validalineacontrol
           from inssrv i, tystabsrv b
          where i.codinssrv = sid_actual
            and i.codsrv = b.codsrv
            and i.codcli = trim(c_reg.idinscripcion)
            and i.numero = trim(c_reg.telefono)
            and i.estinssrv in (1, 2)
            and b.flag_lc = 1;

         if l_validalineacontrol > 0 then
           update fco.suspension_old
              set flgleido = 1, estado = 1, tiporechazo = '  '
            where idsuspension_old = c_reg.idsuspension_old;
         end if;
         --Fin <3.0>

           select count(1)
            into l_validabloqueoprevio
           from transacciones_fco
           where nomabr = trim(c_reg.telefono)
            and transaccion = 'BLOQUEO'
            and esttransfco not in (5)   ---jmap
            and fecfin is null
            and flgvalido = 1
            and idoperadorfco = c_reg.idopeext;

         if l_validabloqueoprevio > 0 then
           update fco.suspension_old
              set flgleido = 1, estado = 1, tiporechazo = '27'
            where idsuspension_old = c_reg.idsuspension_old;
         end if;
       end if;


       if  c_reg.tipo_motivo = 'R' then

           select count(1)
           into l_validabloqueoprevio
           from transacciones_fco
           where nomabr = trim(c_reg.telefono)
           and transaccion = 'BLOQUEO'
           and esttransfco not in (5)   ---jmap
           and fecfin is null
           and flgvalido = 1 ;
           --Verifica que el servicio se encuentre bloqueado
           if l_validabloqueoprevio > 0 then
              select count(1)
              into l_validadesbloqueoprevio
              from transacciones_fco
              where nomabr = trim(c_reg.telefono)
              and transaccion = 'BLOQUEO'
              and esttransfco not in (5)   ---jmap
              and fecfin is null
              and idoperadorfco <> c_reg.idopeext
              and flgvalido = 1 ;
             --Verifica que la solicitud de desbloqueo sea del mismo operador que solicitó el bloqueo
              if l_validadesbloqueoprevio > 0 then
                 update fco.suspension_old
                   set flgleido = 1, estado = 1, tiporechazo = '24'
                 where idsuspension_old = c_reg.idsuspension_old;
              end if;
           else
              update fco.suspension_old
                set flgleido = 1, estado = 1, tiporechazo = '26'
              where idsuspension_old = c_reg.idsuspension_old;
           end if;
       end if;
     end if;
   end loop;
 end;

END PQ_BLOQUEOSERVICIO;
/


