CREATE OR REPLACE PACKAGE OPERACION.PQ_EF_CLONACION AS
/******************************************************************************
   NAME:       PQ_EF_CLONACION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/12/2005             1. Created this package.
   2.0        14/04/2014  Jorge Armas.  RQIT 164919 - IDEA-15668 - Proyecto de Renovación en SGA
******************************************************************************/

  --<ini 2.0>modif
  PROCEDURE p_clonar_ef(a_codef_origen in number, a_codsolot_origen in number ,a_codef_destino in number, a_codsolot_destino in number);

  PROCEDURE p_clonar_puntos(a_codef_origen in number,a_codsolot_origen in number, a_codef_destino in number,a_codsolot_destino in number);
  --<fin 2.0>modif
  
  PROCEDURE p_clonar_etapas(a_codef_origen in number, a_codef_destino in number);

  PROCEDURE p_clonar_actividades(a_codef_origen in number, a_codef_destino in number);

  PROCEDURE p_clonar_materiales(a_codef_origen in number, a_codef_destino in number);

  PROCEDURE p_clonar_formulas(a_codef_origen in number, a_codef_destino in number);

  PROCEDURE p_clonar_datos(a_codef_origen in number, a_codef_destino in number);

  PROCEDURE p_clonar_informes(a_codef_origen in number, a_codef_destino in number);

  PROCEDURE p_clonar_metrados(a_codef_origen in number, a_codef_destino in number);

  FUNCTION  f_valida_clonar_ef(a_codef_origen in number, a_codef_destino in number) return number ;

  PROCEDURE p_clonar_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_punto_fil_eta(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_something_x_punto(an_tipo number, a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_etapas_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_actividades_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_materiales_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_formulas_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_datos_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_informes_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_metrados_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_equipos_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_componentes_x_punto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);

  PROCEDURE p_clonar_punto_fil_eta2(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number);
  
  FUNCTION  f_valida_clonar_efpto(a_codef_origen in number, a_codef_destino in number, a_punto_origen in number, a_punto_destino in number) return number ;
  
  --<ini 2.0>nuevo
  PROCEDURE p_clonar_solxarea_ef_rnv(a_codef_origen in number, a_codef_destino in number);
  
  PROCEDURE p_act_ef_rnv(a_codef_origen in number,a_codef_destino in number);

  PROCEDURE p_registro_clonacion(a_codef_origen in number, a_codef_destino in number,
                                 a_codsolot_origen in number,a_codsolot_destino  in number);
  --<fin 2.0>nuevo

END PQ_EF_CLONACION;
/
