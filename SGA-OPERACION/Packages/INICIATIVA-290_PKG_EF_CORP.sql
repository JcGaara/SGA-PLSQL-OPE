CREATE OR REPLACE PACKAGE OPERACION.pkg_ef_corp IS
  /****************************************************************
  '* Nombre Package : <PKG_EF_CORP>
  '* Propósito : Repositorio de la lógica de Estudios de factibilidad corporativa
  '* Creado por : <Célula Factibilidad Corporativa>
  '* Fec Creación : <2020/02/20>
  '* Fec Actualización : <2020/02/20>
  '****************************************************************/

  PROCEDURE sgass_dias_plazo(pi_codef NUMBER, po_qty_dias_plazo OUT NUMBER);

END pkg_ef_corp;
/