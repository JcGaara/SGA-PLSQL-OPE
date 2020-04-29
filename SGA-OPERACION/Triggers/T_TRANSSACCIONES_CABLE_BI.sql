CREATE OR REPLACE TRIGGER OPERACION.T_TRANSSACCIONES_CABLE_BI
  before insert on operacion.transacciones_CABLE
  REFERENCING OLD AS OLD NEW AS NEW
  for each row

  /*********************************************************************************************
   NOMBRE:            OPERACION.T_TRANSSACCIONES_CABLE_BI
   PROPOSITO:
   REVISIONES:
   Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  -----------------------------------
   1.0                                     Creacion
   2.0        22/06/2010   Miguel Aroñe    REQ 114326 - Bloque de suspensiones y reconexiones DTH Facturable
   3.0        08/09/2010   Miguel Aroñe    REQ 129858 - Bloqueo cable analogico - single play analogico - triple play
  ***********************************************************************************************/
declare
  -- local variables here
  --ini 2.0
  ln_migrado number(5);
  --fin 2.0
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
  --ini 3.0
  and s.idgrupocorte in(10,11,12,15);--DTH Facturable. Se agrega al bloqueo 10-Cable Analogico, 11-Single Play Analogico, 12-Triple Play
  --fin 3.0

  if ln_migrado > 0 then
    :new.transaccion := substr('_'||:new.transaccion,1,10);
    :new.fecini      := sysdate;
    :new.fecfin      := sysdate;
    :new.comentario  := 'La transaccion se va a manejar por el nuevo proceso de cortes y reconexiones';
  end if;
  --fin 2.0

  if :new.idtrans is null then
  SELECT SEQ_TRANSACCIONES_CABLE.NEXTVAL
         INTO :new.idtrans
  FROM DUAL;
  end if;

end T_TRANSSACCIONES_CABLE_BI;
/



