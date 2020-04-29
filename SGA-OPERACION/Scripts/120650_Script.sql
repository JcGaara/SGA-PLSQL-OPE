
--Creacion Tipo objeto: type_calendario 
CREATE OR REPLACE TYPE operacion.type_calendario AS OBJECT
(
  tiptra       number,
  codcon       number,
  codcuadrilla varchar2(30),
  hora         varchar2(15),
  color        number
);
/

--Creacion Tipo objeto: type_calendario _ope
CREATE OR REPLACE TYPE operacion.type_calendario_ope AS OBJECT
(
  idagenda     number(8),
  fecagenda    date,
  tiptra       number(4),
  codcon       number(6),
  codcuadrilla varchar2(30),
  hora         varchar2(15),
  color        number
);
/

--Creacion Tipo objeto: type_hora
CREATE OR REPLACE TYPE operacion.type_hora as object(hora varchar2(15));
/
 