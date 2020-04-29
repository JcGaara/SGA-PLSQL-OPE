CREATE OR REPLACE PROCEDURE OPERACION.SP_CREO_MANEJO_CANTIDADES
(/*Requisition in char,vSegsItem in varchar2,*/Solot in number, Punto in number,Orden in number, Item in varchar2,
 Solocitado out number, Atendido out number, devuelto out number )
 is

   NumAtendido    number;
   Numdevuelto    number;
   NumSolicitado  number;
   NumReq         number;
   stokable       varchar2(1);
   vSegsItem      varchar2(30);
   Item_name      varchar2(15);
   vItemID        number;

/*  Cursor c_Transacciones is
  select d.request_id,d.point_id,d.orden,c.codmat,a.transaction_quantity
  from
  mtl_material_transactions a,
  mtl_system_items_b b,
  matope c,
  attla_inv_requisition d
  where
  a.inventory_item_id = b.inventory_item_id and
  a.transaction_source_name = d.demand_source_name (+) and
  c.campo1 = b.segment3||'.'||b.segment2||'.'||b.segment1 and
  d.request_id = Solot and
  b.organization_id = 357;*/

begin

 Solocitado := 0;

 begin
   select replace(a.campo1,'.','')
   into vSegsItem
   from matope a
   where a.codmat = '006802';
 exception
    when no_data_found then
       vSegsItem := null;
 end;


 if vSegsITem is not null then
   begin
     select inventory_item_id, stock_enabled_flag, c.segment3||'.'||c.segment2||'.'||c.segment1
     into vItemID, stokable, Item_name
     from mtl_system_items_b c
     where c.organization_id = 357 and
           c.segment3||c.segment2||c.segment1 = vSegsItem  ;
   exception
      when no_data_found then
         vItemID := null;
   end;

/*     insert into operacion.requis
   select a.*
        from
            attla_inv_requisition a,
            attla_inv_requisition_det b
        where
            a.request_id = Solot and 
            a.point_id = Punto and 
            to_number(a.orden) = to_number(Orden) 
            and b.inventory_item_id = vItemId and
            a.reservation_batch_id = b.reservation_batch_id
        Union all
        select a.*
        from
            attla_inv_requisition a,
            attla_inv_requisition_fa b
        where
            a.request_id = Solot and
            a.point_id = Punto and
            a.orden = Orden and
            b.inventory_item_id = vItemId and
            a.reservation_batch_id = b.reservation_batch_id;
            commit;*/
   
   
   if vItemid is not null then
      Select nvl(sum(a.sol ),0) into Solocitado
      from
        (select nvl(sum(b.reservation_quantity ),0) Sol
        from
            attla_inv_requisition a,
            attla_inv_requisition_det b
        where
            a.request_id = Solot and
            a.point_id = Punto and
            to_number(a.orden) = to_number(Orden) and
            b.inventory_item_id = vItemId and
            a.reservation_batch_id = b.reservation_batch_id
/*        Union all
        select nvl(sum(b.reservation_quantity ),0) Sol
        from
            attla_inv_requisition a,
            attla_inv_requisition_fa b
        where
            a.request_id = Solot and
            a.point_id = Punto and
            to_number(a.orden) = Orden and
            b.inventory_item_id = vItemId and
            a.reservation_batch_id = b.reservation_batch_id*/) a;

        if stokable = 'Y' then
            select nvl(sum(decode(sign(transaction_quantity),-1,transaction_quantity,0)),0)* -1,
                   nvl(sum(decode(sign(transaction_quantity), 1,transaction_quantity,0)),0)
                   into Atendido, devuelto
            from
                mtl_material_transactions a,
                attla_inv_requisition d
            where
                d.request_id = Solot and
                d.point_id = Punto and
                d.orden = Orden and
                a.inventory_item_id = vItemID and
                a.transaction_source_name = d.demand_source_name;
        else
/*Comentado por Victor Valqui, ya que hay casos en que existen 2 requerimientos.
            Begin

              select a.reservation_batch_id
              into NumReq
              from
                attla_inv_requisition a,
                attla_inv_requisition_fa b
              where
                a.request_id = Solot and
                a.point_id = Punto and
                a.orden = Orden and
                b.inventory_item_id = vItemID and
                a.reservation_batch_id = b.reservation_batch_id;
            exception
                when no_data_found then
                   NumReq := 0;
            end;

            Begin
              select count(*)
              into Atendido
              from
              fa_asset_keywords a,
              fa_additions_b b,
              attla_br_fa_change_categories c
              where
              a.segment5 = Item_name and
              c.req_num = NumReq and
              a.code_combination_id = b.ASSET_KEY_CCID and
              b.asset_id = c.asset_id and
              c.status = 'PROCESSED' and
              c.type = 'LOCATION';
            exception
                when no_data_found then
                   Atendido := 0;
            end;
Fin del comentario--- Reemplazado por las siguietnes lineas*/
            Begin
              select count(*)
              into Atendido
              from
              fa_asset_keywords a,
              fa_additions_b b,
              attla_br_fa_change_categories c
              where
              a.segment5 = Item_name and
              c.req_num in (select a.reservation_batch_id from attla_inv_requisition a, attla_inv_requisition_fa b
		  			   		   where a.request_id = Solot and
							   		 a.point_id = Punto and
									 a.orden = Orden and
									 b.inventory_item_id = vItemID and
									 a.reservation_batch_id = b.reservation_batch_id) and
              a.code_combination_id = b.ASSET_KEY_CCID and
              b.asset_id = c.asset_id and
              c.status = 'PROCESSED' and
              c.type = 'LOCATION';
            exception
                when no_data_found then
                   Atendido := 0;
            end;

        end if;
   end if;
end if;
end;
/


