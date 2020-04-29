CREATE OR REPLACE TRIGGER OPERACION."T_RECONEXIONPORPAGO_BI"
  before insert on OPERACION.reconexionporpago
  for each row
  /*********************************************************************************************
   NOMBRE:            OPERACION.T_RECONEXIONPORPAGO_BOGA_BI
   PROPOSITO:
   REVISIONES:
   Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  -----------------------------------
   1.0                                     Creacion
   2.0        29/03/2011   Miguel Aroñe    REQ 101786 - Bloque de reconexiones Telefonia Fija, TPI, Telmex Negocio
  ***********************************************************************************************/
declare
  ln_migrado number(5);--2.0
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
  and s.idgrupocorte in(1,3); --1-Telefonia Fija, 3-Telmex Negocio, 5-TPI

  if ln_migrado > 0 then
    :new.flgleido := 2;--Para que no sea tomado en cuenta por el antiguo de cortes
    :new.obs      := 'La reconexion debe ser procesada por el nuevo proceso de cortes';
  end if;
  --fin 2.0

  if :new.IDRECPAGO is null then
	SELECT OPERACION.SQ_RECONEXIONPORPAGO.NEXTVAL
         INTO :new.IDRECPAGO
  FROM DUAL;
  end if;
end T_RECONEXIONPORPAGO_BI;
/



