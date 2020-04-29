CREATE OR REPLACE FUNCTION OPERACION.F_GET_NRO_REQ_X_MAT( a_codsolot in number, a_punto in number,
a_orden in number, a_codmat in almtabmat.codmat%type) RETURN varchar2 IS

ls_nroreq varchar2(500);

BEGIN

	select a.demand_source_name into ls_nroreq
	from attla_inv_requisition a,
		 attla_inv_requisition_det b,
		 mtl_system_items_b c,
		 almtabmat d
	where a.RESERVATION_BATCH_ID = b.reservation_batch_id and
		  b.inventory_item_id = c.inventory_item_id and
		  c.organization_id = 357 and
		  c.segment3||'.'||c.segment2||'.'||c.segment1 = d.item_segment1||'.'||d.item_segment2||'.'||d.item_segment3 and
		  a.request_id = a_codsolot and
		  a.point_id = a_punto and
		  a.orden = a_orden and
		  d.codmat = a_codmat;

   return ls_nroreq;

   exception
   		when others then
     		return null;
END;
/


