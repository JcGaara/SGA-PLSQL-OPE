CREATE OR REPLACE TRIGGER OPERACION.T_RECONEXIONPORPAGO_BOGA_BI
  before insert on  OPERACION.reconexionporpago_BOGA
  for each row

  /*********************************************************************************************
   NOMBRE:            OPERACION.T_RECONEXIONPORPAGO_BOGA_BI
   PROPOSITO:
   REVISIONES:
   Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  -----------------------------------
   1.0                                     Creacion
   2.0        22/06/2010   Miguel Aroñe    REQ 114326 - Bloque de reconexiones servicios DTH Facturable
   3.0        06/10/2010   Juan Gallegos   REQ 145146 - Al pagar un recibo de servicios DTH que estén activos, se debe considerar
                                                        ampliar la fecha de vigencia.
   4.0        09/08/2010   Miguel Aroñe    REQ 129858 - Bloqueo cable analogico - single play analogico - triple play
   5.0        02/11/2011   Widmer Quispe   REQ 161199 - DTH Post Venta
  ***********************************************************************************************/
declare
  -- local variables here
  --ini 2.0
  ln_migrado number(5);
  --fin 2.0
  --ini 3.0
  ln_dth_fac_act number(5);
  --fin 3.0
begin

  --ini 2.0
  select count(1) into ln_migrado
  from bilfac b,
  instanciaservicio iser,
  inssrv i,
  vtatabslcfac p,
  soluciones s
  where b.idfaccxc = :new.idfac
  and b.codcli = :new.codcli
  and b.idisprincipal = iser.idinstserv
  and b.codcli = iser.codcli
  and iser.codinssrv = i.codinssrv
  and iser.codcli = i.codcli
  and i.numslc = p.numslc
  and i.codcli = p.codcli
  and p.idsolucion = s.idsolucion
  --ini 4.0
  and s.idgrupocorte in(10,11,12,15); --DTH Facturable. Se agregar al bloqueo 10-Cable Analogico, 11-Single Play Analogico, 12-Triple Play
  --fin 4.0

  --ini 3.0
  select count(distinct r.numregistro)
    into ln_dth_fac_act
    from bilfac              b,
         cr                  c,
         instxproducto       i,
         ope_srv_recarga_cab r,
         ope_srv_recarga_det e,
         vtatabslcfac p
   where b.idbilfac = c.idbilfac
     and c.idinstprod = i.idinstprod
     and i.pid = e.pid
     and r.numregistro = e.numregistro
     and r.numslc = p.numslc
     --<5.0
     --and p.idsolucion = 67
     and sales.pq_dth_postventa.f_obt_solucion_dth(p.idsolucion) = 1
     --5.0>
     and e.tipsrv =
         (select valor from constante where constante = 'FAM_CABLE')
     and b.idfaccxc = :new.idfac
     and r.estado = '02'
     and nvl(r.flg_recarga, 0) = 0;
  --fin 3.0

  --ini 3.0
  /*if ln_migrado > 0 then*/
  if ln_migrado > 0 and ln_dth_fac_act = 0 then
  --fin 3.0
    :new.flgleido := 2;--Para que no sea tomado en cuenta por el antiguo de cortes
    :new.obs      := 'La reconexion debe ser procesada por el nuevo proceso de cortes';
  end if;
  --fin 2.0

  if :new.IDRECPAGO is null then
      SELECT OPERACION.SQ_RECONEXIONPORPAGO_BOGA.NEXTVAL
             INTO :new.IDRECPAGO
      FROM DUAL;
  end if;

end T_RECONEXIONPORPAGO_BOGA_BI;
/
