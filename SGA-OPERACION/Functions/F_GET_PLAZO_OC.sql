CREATE OR REPLACE FUNCTION OPERACION.F_GET_PLAZO_OC(a_proyecto in char) return number is
  a_plazo number;
  l_numpsp char(10);
  l_idopc char(2);
begin
/******************************************************************************
Obtinene PROYECTO y devuelve Plazo entrega de servicio
******************************************************************************/
   -- Fecha de firma / duracion
	begin
      select o.numpsp, o.idopc into l_numpsp, l_idopc from
      sales.vtampspcli o
      where numslc = a_proyecto and ESTPSPCLI in ('02','05');
   exception
   	when others then
      	null;
   end;

   -- Plazo
   begin

		select
			decode ( IDCNDCOM ,
			'093'	,	60	,	--	 Entrega de Servicios 60
			'071'	,	65	,	--	Entrega de Servicios  65
			'040'	,	20	,	--	Entrega de servicios 20
			'002'	,	30	,	--	Entrega de Servicios 30
			'017'	,	30	,	--	Entrega de Servicios 30 dias
			'135'	,	45	,	--	Entrega de Servicios 45
			'015'	,	45	,	--	Entrega de Servicios 45
			'016'	,	60	,	--	Entrega de Servicios 60
			'098'	,	7	,	--	Entrega de Servicios 7
			'128'	,	40	,	--	Entrega del Servicio 40 dias
			'090'	,	45	,	--	Entrega del Servicio 45
			'138'	,	75	,	--	Entrega del Servicio 75
			'129'	,	15	,	--	Entrega del Servicio PIA 15
			'045'	,	15	,	--	Tiempo de Entrega  equipos 15
			'047'	,	45	,	--	Tiempo de Entrega  Equipos 45
			'010'	,	60	,	--	Tiempo de Entrega  equipos 60
			'048'	,	90	,	--	Tiempo de Entrega Equipos 90
         '019' ,5,
			'023' ,3,
			'038' ,10,
			'039' ,15,
			'041' ,25,
			'042' ,35,
			'044' ,7,
			'046' ,30,
			'209' ,7,
			null )
		into a_plazo
	   from vtacndcompspcli
   where ( vtacndcompspcli.numpsp = l_numpsp ) and
         ( vtacndcompspcli.idopc = l_idopc ) and
         rownum = 1 and
         idcndcom in (
				'093'	,
				'071'	,
				'040'	,
				'002'	,
				'017'	,
				'135'	,
				'015'	,
				'016'	,
				'098'	,
				'128'	,
				'090'	,
				'138'	,
				'129'	,
				'045'	,
				'047'	,
				'010'	,
				'048',
            '019',
				'023',
				'038',
				'039',
				'041',
				'042',
				'044',
				'046',
				'209'
				);
	exception
   	when others then
      	null;
   end;

  return a_plazo;
end ;
/


