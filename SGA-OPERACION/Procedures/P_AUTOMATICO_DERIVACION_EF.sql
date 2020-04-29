CREATE OR REPLACE PROCEDURE OPERACION.P_AUTOMATICO_DERIVACION_EF IS

  /******************************************************************************
     NAME:       PQ_INT_PRYOPE
     PURPOSE:    Manejo de Sol. OT.

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
    1.0         05/10/2009  Hector Huaman M  REQ-103745:se comento el procedmiento que actualiza el tipo de trabajo, tal procedimiento sera llamado en  P_DET_AUTOMATICO_DERIVACION_EF
    2.0         26/07/2010  Antonio Lagos    REQ-134789:correccion para que el proceso tome los proyectos
                                             que no tienen tipo de trabajo
    3.0         23/02/2012  Roy Concepcion   REQ-161655:Optimizacion del Query                                                                    
    4.0         06/01/2017  Anderson Julca   Optimización del query y traslado de restricción de créditos
                                             hacia la aprobación de la Oferta Comercial
  ******************************************************************************/
------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_AUTOMATICO_DERIVACION_EF';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='422';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------



cursor cur_aut is
            SELECT A.ID,A.TIPSRV,A.IDCAMPANHA,A.TIPTRA,A.IDPRODUCTO,B.AREA,B.RESPONSABLE,A.ACCESO,A.PREPROC
            FROM EFAUTOMATICO A,EFAUTOXAREA B
            WHERE A.ID=B.IDEF;
--ini 2.0
cursor cur_proy is
select distinct numslc from tmp_vtatabslcfac_derivef;
--fin 2.0
BEGIN
      --operacion.p_tiptra_proyecto; --<1.0>
      operacion.p_tiptra_cambioplan;
      insert into tmp_vtatabslcfac_derivef (NUMSLC,NUMPTO,CODCLI,TIPSRV,TIPSOLEF,CLIINT)
      -- ini 3.0
      --,codubi,idcategoria)
      -- fin 3.0
      select trim(B.NUMSLC),c.numpto, B.CODCLI,trim(B.TIPSRV),B.TIPSOLEF,B.CLIINT
      -- ini 3.0
      --,trim(g.codubi),e.idcategoria
      -- fin 3.0
      from vtatabslcfac B, vtadetptoenl C, vtatabcli p, cxcpspchq Q
      -- ini 3.0
      --, vtasuccli F, vtatabdst G, tystabsrv E
      -- fin 3.0
      where to_number(B.numslc) not in (select codef from ef where codef = to_number(b.numslc))
      and B.CODCLI=p.codcli
      and b.numslc = c.numslc
      and b.numslc = q.numslc
      and b.tipo in (0,5)
      and b.estsolfac in ('03')
      -- ini 4.0
      AND b.tipsrv IN (SELECT o.codigoc FROM tipopedd t, opedd o WHERE t.tipopedd=o.tipopedd AND t.abrev='TIPSRV_CORP')
      AND TRUNC(b.fecapr)>=TRUNC(SYSDATE)-(SELECT TO_NUMBER(valor) FROM constante WHERE constante='IS_DIASDERIV')
      -- fin 4.0
      -- ini 3.0
      /*
      and c.codsrv = e.codsrv(+)
      and c.codsuc = f.codsuc(+)
      and f.ubisuc = g.codubi(+)*/
      -- fin 3.0
      --ini 2.0
      --and b.numslc  not in (select numslc from vtadetptoenl where tiptra is null)
      --fin 2.0
      --and b.numslc = '0000076129'
      group by B.NUMSLC,c.numpto,B.CODCLI,B.TIPSRV,B.TIPSOLEF,B.CLIINT;
      -- ini 3.0
      --,g.codubi,e.idcategoria;
      -- fin 3.0
      commit;
      --ini 2.0
      for row_proy in cur_proy loop
        operacion.p_tiptra_proyecto(row_proy.numslc);
      end loop;
      --fin 2.0
      for row_aut in cur_aut loop
        P_DET_AUTOMATICO_DERIVACION_EF(row_aut.id,row_aut.tipsrv,row_aut.idproducto,row_aut.idcampanha,row_aut.acceso,row_aut.tiptra);
      end loop;

      delete from tmp_vtatabslcfac_derivef;
      -- ini 3.0
      COMMIT;
      -- fin 3.0
--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);


exception
   when no_data_found then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20500, sqlerrm);
   when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/
END;
/
