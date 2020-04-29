create or replace procedure operacion.P_CIERRA_TAREA_CP_JANUS_CE is
  /*******************************************************************************
   PROPOSITO: Ejecutar Cierre de la Tarea Act/Desc Lineas control Janus
     
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      18/12/2015  Luis Flores  	 Giovanni Vasquez    SD_600307
     2.0      14/06/2016  Jose Varillas  Fernando Utiveros   PROY-23947 Migración de clientes SGA a BSCS
  /* ****************************************************************************/

  cn_estcerrado constant number := 4;
  ln_contenvio number;

  cursor c_solot is
    select c.idtareawf, c.mottarchg, c.idwf, c.tarea, c.tareadef
      from solot a, wf b, tareawf c
     where a.codsolot = b.codsolot
       and b.idwf = c.idwf
       and c.tareadef in (select distinct o.codigon_aux from  tipopedd t, opedd o
                          where o.tipopedd = t.tipopedd
                          and t.abrev = 'TIPOTRAJANUSCAUTOCPCE'
                          and o.codigon_aux is not null)
       and b.valido = 1
       and a.estsol = 17
       and c.esttarea in (1,2)
       and a.tiptra in (select distinct o.codigon from  tipopedd t, opedd o
                        where o.tipopedd = t.tipopedd
                        and t.abrev = 'TIPOTRAJANUSCAUTOCPCE'
                        and o.codigon is not null);

    cursor c_codinssrv(an_idwf number) is
      select distinct tcd.codinssrv
      from operacion.telefonia_ce_det tcd,
           operacion.telefonia_ce tc
      where tcd.id_telefonia_ce = tc.id_telefonia_ce
      and tc.idwf = an_idwf;
      
  cursor c_solot_cp is
    select c.idtareawf, c.mottarchg, c.idwf, c.tarea, c.tareadef  ,a.codsolot
      from solot a, wf b, tareawf c
     where a.codsolot = b.codsolot
       and b.idwf = c.idwf
       and c.tareadef in (select distinct o.codigon_aux from  tipopedd t, opedd o
                          where o.tipopedd = t.tipopedd
                          and t.abrev = 'TIPOTRAJANUSCAUTOCPCE'
                          and o.codigon_aux is not null
                          and o.codigon = 1)
       and b.valido = 1
       and a.estsol = 17
       and c.esttarea in (1,2)
       and a.tiptra in (select distinct o.codigon from  tipopedd t, opedd o
                        where o.tipopedd = t.tipopedd
                        and t.abrev = 'TIPOTRAJANUSCAUTOCPCE'
                        and o.codigon is not null);      

  ln_valida number;

begin

  FOR c_tarea IN c_solot LOOP

    ln_valida := 0;

    select count(distinct tcd.codinssrv)
           into ln_contenvio
    from operacion.telefonia_ce_det tcd, operacion.telefonia_ce tc
    where tcd.id_telefonia_ce = tc.id_telefonia_ce
    and tc.idwf = c_tarea.idwf;

    if ln_contenvio > 0 then

      for c_in in c_codinssrv(c_tarea.idwf) loop

        if operacion.pq_sga_iw.f_val_prov_janus_pend(c_in.codinssrv) != 0 then
           ln_valida := ln_valida + 1;
        end if;

      end loop;

      if ln_valida = 0 then

        PQ_WF.P_CHG_STATUS_TAREAWF(c_tarea.idtareawf,
                                   cn_estcerrado,
                                   cn_estcerrado,
                                   c_tarea.mottarchg,
                                   sysdate,
                                   sysdate);
      end if;

    end if;

  end loop;
  
  
  FOR lc_solot_cp IN c_solot_cp LOOP
    ln_valida := 0;
    
    select count(1)
      into ln_valida
      from tareawf t
     where t.tareadef = (select distinct o.codigon_aux
                           from tipopedd t, opedd o
                          where o.tipopedd = t.tipopedd
                            and t.abrev = 'TIPOTRAJANUSCAUTOCPCE'
                            and o.codigon_aux is not null
                            and o.codigon = 2)
       and t.idwf = lc_solot_cp.idwf
       and t.tipesttar = 4
       and t.esttarea = 4;
       
    if ln_valida > 0 then
      UPDATE tareawf
         SET tipesttar = 4, esttarea = 4
       WHERE tareadef = (select distinct o.codigon_aux
                           from tipopedd t, opedd o
                          where o.tipopedd = t.tipopedd
                            and t.abrev = 'TIPOTRAJANUSCAUTOCPCE'
                            and o.codigon_aux is not null
                            and o.codigon = 1)
         and idwf = lc_solot_cp.idwf;
    end if;


  end loop;  
  
end;
/
