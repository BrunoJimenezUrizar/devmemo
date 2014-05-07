//// Place all the behaviors and hooks related to the matching controller here.
//// All this logic will automatically be available in application.js.

$(function(){

	$('#modal-building').on('shown.bs.modal', function () {
        $(ClientSideValidations.selectors.forms).validate();
    });

});

//$(function(){
//	$('div#modal-building').delegate("button#reDraw", 'click', function(eventObject){reDrawPolygon(eventObject);});
//});

//var newPolygon;
//var overlay = new google.maps.OverlayView();
//var drawingMan;

//// Función utilizada para inicializar un mapa. Recibe como parámetros
//// el nombre de la instancia de google.maps.Map a inicializar y el id 
////del div (canvas) en el cual se desplegará:
//function initializeMap(map_name, canvas_id) {

//	var myLatLng = new google.maps.LatLng(-33.498702,-70.612688);
//	var mapOptions = {
//		zoom: 16,
//		center: myLatLng,
//		mapTypeId: google.maps.MapTypeId.SATELLITE
//	};

//	this[map_name] = new google.maps.Map(document.getElementById(canvas_id), mapOptions);

//	initializedrawingMan(this[map_name]);				
//	
//	// Agregamos manejador para cancelar dibujo del polígono a mitad de camino:
//	google.maps.event.addListener(this[map_name], 'rightclick', cancelPolygon);
//	
//	// Agregamos hashMaps para guardar los polígonos y marcadores:
//	this[map_name].campuses = {};					// Hashmap para contener los pares  [campus_id, polygon]
//	this[map_name].buildings = {};				// Hashmap para contener los pares  [building_id, polygon]
//	this[map_name].pois = {};							// Hashmap para contener los pares  [poi_id, marker]
//	this[map_name].pors = {};							// Hashmap para contener los pares  [por_id, marker]
//	this[map_name].events = {};						// Hashmap para contener los pares  [event_id, marker]
//}

//function initializedrawingMan(map){
//				//drawingModes : [google.maps.drawing.OverlayType.MARKER] 
//	drawingMan = new google.maps.drawing.drawingMan({
//		drawingMode: google.maps.drawing.OverlayType.POLYGON,
//		drawingControl: false,
//		drawingControlOptions: {
//			position: google.maps.ControlPosition.TOP_CENTER,
//			drawingModes: [google.maps.drawing.OverlayType.POLYGON]
//		},
//		markerOptions: {
//			icon: new google.maps.MarkerImage('http://www.example.com/icon.png')
//		},
//		polygonOptions: buildingOptions
//	});
//	
//	// Lo agregamos al mapa:
//	drawingMan.setMap(map);

//	// Agregamos manejador para cuando se termina de dibujar un polígono:
//	google.maps.event.addListener(drawingMan, 'polygoncomplete', createPolygonObject);
//}


///** @this {google.maps.Polygon} */
//function createPolygonObject(polygon)
//{
//	// Agregamos el polígono a polygons:
//	newPolygon = polygon;
//	
//	// Seteamos las coordenadas del polígono en el hidden field:
//	var rgeoPolygon = polygonAjax(polygon);
//	$("div#modal-building input#building_polygon_s").val(rgeoPolygon);
//	
//	// Desactivamos el dibujo:
//	drawingMan.setDrawingMode(null);

//	// Habilitamos el botón 'redibujar':
//	$("div#modal-building button#reDraw").attr("disabled", false);

//	// Enfocamos el input:				
//	$("div#modal-building input#building_name").focus();
//}

//function polygonAjax(polygon)
//{
//	// Inicializamos el string a retornar
//	var polygonString = 'POLYGON((';
//	
//	// Obtenemos el listado de vértices del polígono:
//	var vertices = polygon.getPath();
//	
//	// Recorremos la lista de polígonos, agregando cada par "longitud latitud" al resultado
//	for (var i =0; i < vertices.getLength(); i++) {
//		var xy = vertices.getAt(i);
//		polygonString += xy.lng() + ' ' + xy.lat() + ', ';
//	}
//	
//	// Repetimos el primer punto al final del listado y cerramos la inicialización:
//	// (Esto es requisito de los RGeo::PolygonImpl, los cuales deben ser rutas cerradas)
//	polygonString += vertices.getAt(0).lng() + ' ' + vertices.getAt(0).lat() + '))';
//	
//	// Retornamos el string en formato válido para RGeo::PolygonImpl:
//	return polygonString;
//}

//function reDrawPolygon2(event)
//{
//	event.preventDefault();

//	// Si ya había un polígono dibujado, lo borramos y vaciamos el hidden field asociado:
//	if(newPolygon != null){
//		newPolygon.setMap(null);
//		$("div#modal-building input#building_polygon_s").val("");					
//	}
//	
//	// rehabilitamos el control de dibujo:
//	drawingMan.setDrawingMode(google.maps.drawing.OverlayType.POLYGON);
//	
//	// deshabilitamos el botón nuevamente:
//	$("div#modal-building button#reDraw").attr("disabled", true);
//}


//// En este caso this es la instancia de google.maps.Map en la cual se gatilla en evento 			
//function cancelPolygon(event){
//	// reiniciamos el drawingMan:
//	drawingMan.setMap(null);
//	initializedrawingMan(this);
//}

///** @this {google.maps.Polygon} */
//function deleteNode(event){
//	// obtenemos los vértices del polígono:
//	var path = this.getPath();

//	// obtenemos punto en el cual se hizo click:
//	var proj = polygonMap.getProjection();
//	var clickPoint = proj.fromLatLngToPoint(event.latLng);

//	var minDist = 512;
//	var selectedIndex = -1;
//	var nodeWidth = 6;

//	// variables auxiliares:
//	var nodeToDelete;
//	var n = 0;
//	var length = path.getLength();

//	// Buscamos vértice más cercano:
//	for(n = 0; n <= length-1; n=n+1) {
//	
//		var nodePoint = proj.fromLatLngToPoint(path.getAt(n));
//		var dist = Math.sqrt(Math.pow(Math.abs(clickPoint.x - nodePoint.x),2) + Math.pow(Math.abs(clickPoint.y - nodePoint.y),2));
//	
//		if (dist < minDist) {
//			minDist = dist;
//			selectedIndex = n;
//			
//			//store point
//			nodeToDelete = path.getAt(n);
//		}
//	}

//	//check if we're clicking inside the node		
//	var ovProj = overlay.getProjection();

//	var clickPx = overlay.getProjection().fromLatLngToContainerPixel(event.latLng);
//	var nodePx = overlay.getProjection().fromLatLngToContainerPixel(nodeToDelete);
//	var xDist = Math.abs(nodePx.x - clickPx.x);
//	var yDist = Math.abs(nodePx.y - clickPx.y);

//	if( xDist < nodeWidth && yDist < nodeWidth) {
//		
//		//chequeamos que tenga más de 3 puntos; en caso contrario, no dejamos que lo borre
//		if(path.length > 3)
//			path.removeAt(selectedIndex);
//		else
//			alert("Un polígono no puede contener menos de 3 vértices");
//	}
//	return false;			
//}
