CREATE OR REPLACE PROCEDURE OPERACION.P_ENVIAR_CORREO_OT_EJECUTADO (varcodot in number, punto in number, varCid solotpto.CID%type, TipoTrabajo in number) is
Descripcion varchar(2000);
Asunto varchar(200);
NombreCliente varchar(150);
Trabajo varchar(200);
Proyecto solot.NUMSLC%type;
begin
  if TipoTrabajo=1 then
    Descripcion:='Se ha activado el CID ';
	Asunto:='Se ha activado un nuevo CID';
  else
    if TipoTrabajo=3 then
	  Descripcion:='Se ha dado de baja el CID ';
	  Asunto:='Se a dado de baja un CID';
	end if;
  end if;
  Descripcion:=Descripcion || Varcid;
  Descripcion:=Descripcion || ', del Cliente ';

  select v.nomcli into NombreCliente
  from ot, solot, vtatabcli v
  where ot.CODSOLOT=solot.CODSOLOT and
	 	   v.codcli=solot.codcli and
		   ot.CODOT=varcodot;

  Descripcion:=Descripcion || NombreCliente;



  select distinct SOLOT.NUMSLC into Proyecto
  from solot, ot
  where solot.CODSOLOT=ot.CODSOLOT and ot.CODOT=varcodot;

  Descripcion:=Descripcion || ', del proyecto ';
  Descripcion:=Descripcion || Proyecto;
end;
/


