CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_CORTE_TV_SAT(l_fecha date,l_numero number)
  IS

  /*************************************************************************************************
     NAME:       P_GENERA_CORTE_TV_SAT
     PURPOSE:    Procedimiento que genera Cortes para clientes con deuda vencida, servicio TV-SAT
     Author  :   José Ramos
     reated :    16/09/2009 15:00:00
     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        16/09/2009   José Ramos       1. Created this procedure.Req.103102
     2.0        06/10/2010                      REQ.139588 Cambio de Marca
***************************************************************************************************/

  cursor cur_suspension is
    select distinct ct.idfac, ct.codcli, ct.nomabr, 12 tipo
      from cxctabfac ct,
           (select max(c.idfac) max_idfac
              from cxctabfac c,
                   bilfac b,
                   inssrv i,
                   vtatabcli v,
                   categoria ca,
                   insprd ip,
                   instxproducto ins,
                   cr,
                   reginsdth reg,
                   estregdth e
             where c.fecven <= l_fecha
               and b.idfaccxc = c.idfac
               and i.codinssrv = ip.codinssrv
               and ip.pid = ins.pid
               and ins.idinstprod = cr.idinstprod
               and cr.idbilfac = b.idbilfac
               and i.codcli = c.codcli
               and c.codcli = v.codcli
               and ca.idcategoria(+) = v.idcategoria
               and i.codinssrv = reg.codinssrv
               and reg.estado = e.codestdth
               and nvl(reg.flg_recarga, 0) = 0
               and nvl(e.tipoestado, 0) <> 3
               and b.cicfac in (22, 23)
               and ip.flgprinc = 1
               and c.estfac in ('02', '04')
               and c.estfacrec = 0
               and c.tipdoc = 'REC'
               and ip.estinsprd = 1
             group by c.nomabr, c.codcli, ca.idcategoria) maximos
     where maximos.max_idfac = ct.idfac;

  l_cont      number;
  l_codsolot  solot.codsolot%type;
  l_numpuntos number;
  l_corte     number;
  l_corte_v   number;
BEGIN
  l_cont := 0;
  for c_sus in cur_suspension loop

    select count(*)
      into l_corte
      from transacciones_cable
     where codcli = c_sus.codcli
       and nomabr = c_sus.nomabr
       and tipo = c_sus.tipo
       and idfac = c_sus.idfac
       and transaccion = 'SUSPENSION'
       and codsolot is not null
       and fecini is not null
       and fecfin is null;

    select count(*)
      into l_corte_v
      from transacciones_cable
     where codcli = c_sus.codcli
       and nomabr = c_sus.nomabr
       and tipo = c_sus.tipo
       and idfac = c_sus.idfac
       and transaccion = 'SUSPENSION'
       and codsolot is null
       and fecini is null
       and fecfin is null;

    if ( l_corte = 0 and l_corte_v = 0 ) then
      -- inserta la suspensión a la que se le asignará una SOT con el procedimiento que corre con el JOB
      INSERT INTO OPERACION.TRANSACCIONES_CABLE
        (IDFAC, NOMABR, CODCLI, TRANSACCION, CODUSU, IDTRANSORI, TIPO)
      VALUES
        (c_sus.idfac,
         c_sus.nomabr,
         c_sus.codcli,
         'SUSPENSION',
         user,
         null,
         c_sus.tipo);
      l_cont := l_cont + 1;

    end if;

    if l_cont = l_numero then
        for c_tra in (select distinct idtrans, idfac, codcli, nomabr, tipo
                        from transacciones_CABLE
                       where transaccion = 'SUSPENSION'
                         and fecini is null
                         and codsolot is null
                         and tipo in (12)) loop

            if (operacion.pq_corteservicio_cable.f_verdocpendiente(c_tra.idfac) = 0) then
              --verifico no haya cancelado todos sus documentos.
              update transacciones_cable
                 set fecini = sysdate, fecfin = sysdate
               where idtrans = c_tra.idtrans; -- modificación para que la suspension quede anulada y no genere activación posterior
            else
                l_numpuntos := 0;
                if operacion.pq_corteservicio_cable.f_cuenta_puntos_cable(c_tra.idfac) > 0 then
                  operacion.pq_corteservicio_cable.p_insert_sot(c_tra.codcli,
                                                                425,
                                                                '0061',
                                                                1,
                                                                958,
                                                                l_codsolot);
                  operacion.pq_corteservicio_cable.p_insert_solotpto_cable(c_tra.idtrans,
                                                                           l_codsolot,
                                                                           c_tra.codcli,
                                                                           c_tra.idfac);
                  l_numpuntos := 1;
                else
                  update transacciones_cable
                     set fecini = sysdate, fecfin = sysdate
                   where idtrans = c_tra.idtrans;
                end if;
                if l_numpuntos = 1 then
                  update transacciones_cable
                     set fecini = sysdate, codsolot = l_codsolot
                   where idtrans = c_tra.idtrans;
                  OPERACION.PQ_SOLOT.p_ejecutar_solot(l_codsolot);
                end if;
            end if;
        end loop;

      l_cont := 0;

      OPERACION.PQ_DTH_WF.p_ejecuta_wf_corte_dth;

      begin
        OPERACION.PQ_DTH_WF.p_verif_sol_corte;
      exception
        when others then
          p_envia_correo_c_attach('Verificación de Cortes DTH',
                                  'joseramos.creo@claro.com.pe', --2.0
                                  'Error en el proceso de verificación de cortes DTH',
                                  null,
                                  'SGA');--2.0

          p_envia_correo_c_attach('Verificación de Cortes DTH',
                                  'rolando.martinez@claro.com.pe', --2.0
                                  'Error en el proceso de verificación de cortes DTH',
                                  null,
                                  'SGA');--2.0

      end;
    end if;
  end loop;
END;
/


