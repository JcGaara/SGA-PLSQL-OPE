CREATE OR REPLACE PROCEDURE OPERACION.P_LIBERARNUMEROS(v_desde VARCHAR, v_hasta VARCHAR) is
/*
Fecha Creación: 19/09/2007
Creado por: Juan Carlos Lara
Descripcion: Permite Liberar los numeros que han sido marcados como "Reserva Sistemas"
             para poder asiganrlos al mismo cliente.
*/
begin
      update numtel
      set
            estnumtel = 1,
            codinssrv = null,
            codusuasg = null,
            publicar = 0,
            fecasg = null
      where
            numero >= rtrim(ltrim(v_desde))
            and numero <= rtrim(ltrim(v_hasta))
            and estnumtel = 6;

      commit;
end P_LIBERARNUMEROS;
/


