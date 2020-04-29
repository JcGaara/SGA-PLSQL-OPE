CREATE OR REPLACE PACKAGE OPERACION.PQ_CUSTOPER AS
/******************************************************************************
   NAME:       PQ_CUSTOPER
   PURPOSE:    Customizaciones Peru

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        17/10/2006  Luis Olarte           1. Created this package.
   2.0        02/07/2007  Juan C. Lara          1. Se incluye la funcion p_transfieresotproyecto_sap para transeferir proyectos al SAP por cada SOT.
   3.0        02/07/2013  Edilberto Astulle     PROY-9381 IDEA-11686  Seleccion Multiple
   4.0        02/09/2013  Edilberto Astulle     PQT-166197-TSK-34400
******************************************************************************/


  PROCEDURE p_cancservtrastel( a_idtareawf in number,
  							               a_idwf in number,
							                 a_tarea in number,
							                 a_tareadef in number
							                 );

  PROCEDURE p_actiservtrastel( a_idtareawf in number,
            							     a_idwf in number,
							                 a_tarea in number,
							                 a_tareadef in number
							                 );

  PROCEDURE                          p_verificacid;

  PROCEDURE p_transfiereproyectosap(n_numslc in number);

  PROCEDURE p_transfieresotproyecto_sap(v_numslc in varchar, v_codsolot in varchar);

 /* FUNCTION f_getfechaprgPEX( a_codsolot in number) return date;

  FUNCTION f_getfechacierreatendidopin( a_codsolot in number) return date;  */
  procedure p_asocia_sot_pto (an_codsolot solot.codsolot%type,an_codinssrv inssrv.codinssrv%type, an_cid acceso.cid%type,an_pid insprd.pid%type, an_tipo number);--3.0

END PQ_CUSTOPER;
/