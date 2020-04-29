CREATE OR REPLACE PACKAGE OPERACION.PQ_VIGILANTE IS
/******************************************************************************
   NAME:       PQ_VIGILANTE
   PURPOSE:    Extrae la informacion del SGA y almacena el estado de cada proyecto.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/02/2005  Victor Valqui
******************************************************************************/

procedure p_insert_registro(
   ar_vig  in vigresumen%rowtype
);

procedure p_actualizar_registro(
   ar_vig  in vigresumen%rowtype
);

procedure p_insert_registro_log(
   ar_vig  in vigresumen%rowtype
);

procedure p_fase_proyecto_gral;

procedure p_fase_preventa(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_analisis_crediticio(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_preventa_cerrada(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_efxprovisioning(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_ef(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_ar(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_oc(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_oc_cerrada(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_contrato(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
);

procedure p_fase_operacion_etapa(
	as_numslc in vtatabslcfac.numslc%type, as_codsolot in solot.codsolot%type,
	as_punto in solotpto.punto%type, as_estsol in solot.estsol%type,
	ar_vig out vigresumen%rowtype);

procedure p_fase_operacion_cliente(
	as_numslc in vtatabslcfac.numslc%type, as_codsolot in solot.codsolot%type,
	as_punto in solotpto.punto%type, as_estsol in solot.estsol%type
);

procedure p_fase_operacion_interno(
	as_numslc in vtatabslcfac.numslc%type, as_codsolot in solot.codsolot%type,
	as_punto in solotpto.punto%type, as_estsol in solot.estsol%type
);

procedure p_fase_operacion_cerrado(
	as_numslc in vtatabslcfac.numslc%type, as_codsolot in solot.codsolot%type,
	as_punto in solotpto.punto%type, as_estsol in solot.estsol%type
);

END PQ_VIGILANTE;
/


