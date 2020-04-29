CREATE OR REPLACE PROCEDURE OPERACION.P_ENVIO_OBS_TAREAWFSEG (a_tareadef in number,
	   a_obs in varchar2,a_idwf in number) IS

l_idtareawf number;

BEGIN
	 begin
		 SELECT IDTAREAWF INTO l_idtareawf FROM TAREAWF
		 WHERE TAREADEF = a_tareadef AND IDWF = a_idwf;

		 exception
		     when others then
	 	 	RAISE_APPLICATION_ERROR (-20500,'La tarea no está definida en esta solicitud');
	 end;

	 INSERT INTO TAREAWFSEG (IDTAREAWF,OBSERVACION,FLAG) VALUES (l_idtareawf,a_obs,1);
END ;
/


