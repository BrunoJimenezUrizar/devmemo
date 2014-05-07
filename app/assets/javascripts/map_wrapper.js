///////////////////////////////////////////////////////////////////////////////////////////////////////
// ------------------------------------------------------------------------------------------------	///
// MapWrapper																																												///
// ------------------------------------------------------------------------------------------------	///
///////////////////////////////////////////////////////////////////////////////////////////////////////
//																																																	///
// Wrapper de la Api de google maps para simplificar uso y extensibilidad de la aplicación. Provee	///
// funcionalidades para cargar, dibujar y editar polígonos y marcadores en el mapa, así como				///
// ciertas convenciones para intercambiar información entre el mapa y objetos del DOM.							/// 
//																																																	///
//																																																	///
// ------------------------------------------------------------------------------------------------	///
//														IIC2154 - Grupo1, Segundo Semestre 2013																///
// ------------------------------------------------------------------------------------------------	///
//																	Tomás Andrés Fuentes Campos																			///
//																		 tafuentesc@gmail.com																					///
///////////////////////////////////////////////////////////////////////////////////////////////////////


// ----------------------------------------------------------------------------------------------------
// Enum usado para indicar el tipo de marcador que se desea cargar/remover del mapa, es un atributo
// estático de MapWrapper.
// ----------------------------------------------------------------------------------------------------
MapWrapper.MarkerType = {
		POI_MARKER: "poi",			// El marcador representa un "Punto de interes"		
		POR_MARKER: "por", 			// El marcador representa un "Punto de reciclaje"
		EVENT_MARKER: "event",	// El marcador representa un "Evento"
}


// ----------------------------------------------------------------------------------------------------
// Constructor de MapWrapper, contiene los objetos y métodos privados (propios) del objeto:
// ----------------------------------------------------------------------------------------------------
// @params
// - mapContainerID: 	id del contenedor del dom donde se encuentran los diversos objetos con
//										los que interactuará el mapa.
// - campusPolygon: 	polígono codificado según google.maps.geometry.encoding.encodePath, usado para
//										inicializar el polígono del campus y centrar el mapa. En caso de ser undefined,
//										se inicializa el mapa en su posición por defecto.
// ----------------------------------------------------------------------------------------------------
function MapWrapper(mapContainerID, campusPolygon){

	// Llamamos a la función de inicialización, la que se encarga de inicializar las variables
	// y vincular los eventos necesarios para el funcionamiento de los mapas:
	// --------------------------------------------------------------------------------------------
	initializeMapWrapper(mapContainerID, campusPolygon);


	///////////////////////////////////////////////////////////////////////////////////////////////
	// SECCION I: Varibles privadas																															///
	///////////////////////////////////////////////////////////////////////////////////////////////

	// --------------------------------------------------------------------------------------------
	// Convención Utilizada:																																		
	// --------------------------------------------------------------------------------------------
	// - var myVariable:		String u otro tipo de objeto																				
	// - var $myVariable:		Objeto JQuery del DOM con el cual se interactuará										
	// - var s_myVariable:	Selector JQuery para buscar un determinado objeto en el DOM					
	// --------------------------------------------------------------------------------------------


	// Variables propias del contexto del mapa:
	// --------------------------------------------------------------------------------------------
	var mapInstance;					// Instancia de google.maps.Map en la que se cargará el contenido

	var $mapContext;					// Selector del DOM container donde se buscarán los objetos
	var $mapCanvas;						// Selector con el cual se accederá al contenedor del mapa. Debe ser 
														// un <div> con el atributo data-map-output="map".


	// Variables específicas para la manipulación de polígonos dentro del mapa:
	// --------------------------------------------------------------------------------------------
	var s_rgeoPolygon;				// Selector del objeto donde se guardarán las coordenadas del polígono  
														// dibujado en el formato utilizado por RGeo::Cartesian::PolygonImpl. 
														// Debe ser un <input> con el atributo data-map-output="polygon".

	var s_encPolygon;					// Selector del objeto donde se guardarán las coordenadas del polígono
														// dibujado codificado según el formato utilizado por
														// google.maps.geometry.encoding.encodePath().

	var s_reDrawButton;				// Selector del objecto que permite redibujar polígonos. Debe ser
														// un <a> ó un <button> con el atributo data-map-input="polygon-redraw".


	// Variables específicas para la manipulación de direcciones dentro del mapa:
	// --------------------------------------------------------------------------------------------
	var geocoderURL;					// Url base del geocoder, la cual contiene un placeholder para insertar
														// la dirección a buscar.
														
	var s_address;						// Selector del objeto desde donde se leerá la dirección inicial del mapa.
														// Debe ser un <input> con el atributo data-map-input="address".

	var s_addrSearchButton;		// Selector del objeto que gatillará la búsqueda de la dirección
														// ingresada en $(s_address).Debe ser un <a> ó <button> con el 
														// atributo data-map-input="address-search"

	var s_addressLatitude;		// Selector del objeto donde se escribirá la latitud de la dirección 
														// en $address. Debe ser un <input> con el atributo 
														// data-map-output="address-lat".

	var s_addressLongitude;		// Selector del objeto donde se escribirá la dirección inicial del mapa.
														// Debe ser un <input> con el atributo data-map-output="address-lng".

	var s_rgeoAddress;				// Selector del objeto donde se escribirán las coordenadas de $address
														// en formato utilizado por RGeo::Cartesian::Point. Debe ser un <input>
														// con el atributo data-map-output="address-coord".


	// Variables específicas para la manipulación de marcadores dentro del mapa:
	// --------------------------------------------------------------------------------------------
	var s_markerLatitude;			// Selector del objecto donde se escribirá la latitud del marcador.
														// Debe ser un <input> con el atributo data-map-output="marker-lat".

	var s_markerLongitude;		// Selector del objeto donde se escribirá la longitud del marcador.
														// Debe ser un <input> con el atributo data-map-output="marker-lng".

	var s_markerCoordinates;	// Selector del objeto donde se escribirán las coordenadas del marcador.
														// Debe ser un <input> con el atributo data-map-output="marker-coord".


	// variables para manejar las opciones de dibujo en el mapa (data-map-draw="polygon"/"marker"):
	// --------------------------------------------------------------------------------------------
	var drawingManager;				// Instancia de google.maps.drawing.DrawingManager con la que se dibujan
														// los polígonos en mapInstance.
	var drawingOptions;				// Opciones con las que se inicializará drawingManager.
	
	var sketchedPolygon;			// Instancia de google.maps.Polygon actualmente dibujado en el mapa.
	var sketchedMarker;				// Instancia de google.maps.Marker actualmente dibujado en el mapa.
	
	var drawingMode;					// Variable que indica si se dibujará un Polígono, un Marcador o ninguno.
														// (Actualmente en desuso, se usará si se desea cambiar de modo)

	// Variables usadas para guardar los objetos a mostrar en el mapa (backgroundObjects)
	// --------------------------------------------------------------------------------------------
	var campus;								// Variable para contener el polygon del mapa.
	
	var buildings = {};				// Hashmap para contener los pares  [building_id, polygon]
	var pois = {};						// Hashmap para contener los pares  [poi_id, marker]
	var pors = {};						// Hashmap para contener los pares  [por_id, marker]
	var events = {};					// Hashmap para contener los pares  [event_id, marker]

	// Variables usadas para guardar las opciones de visualización de los distintos objetos
	// --------------------------------------------------------------------------------------------
	var campusOptions;				// Opciones sobre cómo desplegar un campus en el mapa.
	var buildingOptions;			// Opciones sobre cómo desplegar un edificio en el mapa.
	var poiOptions;						// Opciones sobre cómo desplegar un poi en el mapa.
	var porOptions;						// Opciones sobre cómo desplegar un por en el mapa.
	var eventOptions;					// Opciones sobre cómo desplegar un evento en el mapa.

	var drawPolygonOptions;		// Opciones sobre cómo desplegar un polígono al dibujarlo.
	var drawMarkerOptions;		// Opciones sobre cómo desplegar un marcador al dibujarlo.


	///////////////////////////////////////////////////////////////////////////////////////////////
	// SECCION II: Funciones	Privadas																													///
	///////////////////////////////////////////////////////////////////////////////////////////////

	// --------------------------------------------------------------------------------------------
	// Función para inicializar las componentes de MapWrapper
	// --------------------------------------------------------------------------------------------
	// @params
	// - mapContainerID: 	id del contenedor del dom donde se encuentran los diversos objetos con
	//										los que interactuará el mapa.
	// - campusPolygon: 	polígono codificado según google.maps.geometry.encoding.encodePath, usado
	//										para inicializar el polígono del campus y centrar el mapa
	// --------------------------------------------------------------------------------------------
	function initializeMapWrapper(mapContainerID, campusPolygon){

		// Inicializamos $mapContext:
		$mapContext = $("#" + mapContainerID);
	
		// Revisamos que $mapContext haya sido correctamente inicializado. En caso contrario,
		// arrojamos un error y detenemos la inicialización:
		if($mapContext.length == 0)
			throw new Error("MapWrapper- Error: No se pudo encontrar el objeto con el id indicado");
		else if($mapContext.length > 1)
			throw new Error("MapWrapper - Error: El id entregado debe ser único");
		
		// Si el objeto es válido procedemos a llamar a las funciones de inicialización:
		// ------------------------------------------------------------------------------
		initializeMapOptions(); 					// Se inicializan las opciones de visualización.
		initializeMapVariables();					// Se inicializan los selectores y las variables globales.
		initializeMap(campusPolygon);			// Se crea la instancia de google.maps.Map a utilizar
		initializeDrawingOptions();				// Se inicializa drawing manager y se setea el modo de dibujo.
		initializeMapHandlers();					// Se vinculan los eventos de interacción con el mapa
	}
	

	// --------------------------------------------------------------------------------------------
	// Función utilizada para inicializar mapInstance, la instancia de google.maps.Map usada por
	// MapWrapper.
	// --------------------------------------------------------------------------------------------
	// - campusPolygon: 	polígono codificado según google.maps.geometry.encoding.encodePath, usado
	//										para inicializar el polígono del campus y centrar el mapa
	// --------------------------------------------------------------------------------------------
	function initializeMap(campusPolygon) {
		
		// Partimos por defecto en SJ:
		var myCenter = new google.maps.LatLng(-33.498702,-70.612688);

		// Seteamos las opciones para mostrar el mapa:		
		var mapOptions = {
			zoom: 16,
			center: myCenter,
			mapTypeId: google.maps.MapTypeId.SATELLITE
		};

		// Inicializamos mapInstance.
		mapInstance = new google.maps.Map($mapCanvas[0], mapOptions);
		
		// Si campusPolygon != undefined, entonces llamamos a setCampus:
		//if(campusPolygon != undefined)
		//	this.setCampus(campusPolygon);
	}

	
	// --------------------------------------------------------------------------------------------
	// Función utilizada para obtener el centro de un polígono:	
	// --------------------------------------------------------------------------------------------
	// @params
	// - polygon:				Instancia de google.maps.Polygon del cual se desea obtener el centro
	// --------------------------------------------------------------------------------------------
	// @returns
	// - center:				objeto google.maps.LatLng con las coordenadas del centro
	// --------------------------------------------------------------------------------------------
	function getPolygonCenter(polygon) {
		// Inicializamos objeto auxiliar que usaremos para extraer el centro:
		var bounds = new google.maps.LatLngBounds();

		// Extraemos el arreglo de vértices dentro del path:
		var polygonCoords = polygon.getPath();
	
		// Recorremos la lista de polígonos, agregando cada LatLng a bounds:
		for (i = 0; i < polygonCoords.length; i++) {
			bounds.extend(polygonCoords.getAt(i));
		}
//		for (var i =0; i < vertices.getLength(); i++) {
//			var xy = vertices.getAt(i);
//			polygonString += xy.lng() + ' ' + xy.lat() + ', ';
//		}

		// Finalmente extraemos el centro y lo retornamos:
		var center = bounds.getCenter();		
		return center;	
	}


	// --------------------------------------------------------------------------------------------
	// Función para inicializar las variables del mapa:
	// --------------------------------------------------------------------------------------------
	function initializeMapVariables(){

		// Seteamos el objeto JQuery del contenedor donde se mostrará el mapa:
		$mapCanvas = $mapContext.find("div[data-map-output='map']");
		
		// Si no encontramos un div marcado para desplegar el mapa, arrojamos un error:
		if($mapCanvas.length == 0)
			throw new Error("MapWrapper Error: no se encontró ningún div con el atributo data-map-output='map'");

		// Inicializamos las variables para la manipulación de polígonos dentro del mapa:
		// ------------------------------------------------------------------------------
		s_rgeoPolygon = "input[data-map-output='polygon']";
		s_reDrawButton = "a[data-map-input='polygon-redraw']," +
										" button[data-map-input='polygon-redraw']";

		// Inicializamos las variables para la manipulación de direcciones dentro del mapa.
		// ------------------------------------------------------------------------------
		geocoderURL = "http://maps.googleapis.com/maps/api/geocode/json?address=[searchAddress]&sensor=false";
		
		s_address = "input[data-map-input='address']";
		s_addrSearchButton = "a[data-map-input='address-search']," +
												" button[data-map-input='address-search']";
		s_addressLatitude = "input[data-map-output='address-lat']";
		s_addressLongitude = "input[data-map-output='address-lng']";
		s_rgeoAddress = "input[data-map-output='address-coord']";

		// Iniializamos las variables para la manipulación de marcadores dentro del mapa:
		// ------------------------------------------------------------------------------
		s_markerLatitude = "input[data-map-output='marker-lat']";
		s_markerLongitude = "input[data-map-output='marker-lng']";
		s_markerCoordinates = "input[data-map-output='marker-coord']";	
	}


	// --------------------------------------------------------------------------------------------
	// Función para asociar los eventos del mapa a los objetos adecuados. por ahora sólo se usará
	// para inicializar el delegate del botón de búsqueda de las direcciones, cuando se pueda cambiar
	// el modo de dibujo on demand se agregarán aquí los handlers correspondientes.
	// --------------------------------------------------------------------------------------------
	function initializeMapHandlers(){
		// Vinculamos el botón de búsqueda de las direcciones con la llamada al Geocoder:
		$mapContext.delegate(s_addrSearchButton, 'click', searchAddress);
	}
	
	
	// --------------------------------------------------------------------------------------------
	// Función para inicializar las opciones con las cuales se cargarán las distintas componentes:
	// --------------------------------------------------------------------------------------------
	function initializeMapOptions(){

		// Seteamos las opciones para los edificios:
		// ------------------------------------------------------------------------------
		buildingOptions = {
			strokeColor: "000000",					// Seteamos el color del borde negro
			strokeOpacity: 0.8,							// Seteamos la opacidad del trazo
			strokeWeight: 3,								// Seteamos su grozor en 3
			fillColor: "#FF0000",						// Setemamos el color de llenado rojo
			fillOpacity: 0.35,							// La opacidad del relleno
			zIndex: 2												// Posición en el eje-Z del mapa
		}; 																// (es la segunda capa, sobre el campus)

		// Seteamos las opciones para los campus:
		// ------------------------------------------------------------------------------
		campusOptions = {
			strokeColor: "000000",					// Seteamos el color del borde negro
			strokeOpacity: 0.8,							// Seteamos la opacidad del trazo
			strokeWeight: 3,								// Seteamos su grozor en 3
			fillColor: "#FFFFFF",						// Setemamos el color de llenado blanco
			fillOpacity: 0.2,								// La opacidad del relleno de polígono
			zIndex: 1												// Posición en el eje-Z del mapa
		};																// (en este caso, es la primera capa)

		// Seteamos las opciones para los pois:
		// ------------------------------------------------------------------------------
		poiOptions = {										
			icon: {url: '/assets/point-of-interest.png',				// url del ícono a usar
		  scaledSize: new google.maps.Size(32, 37)},// tamaño con que se mostrará en el mapa
		  zIndex: 3																	// Posición en el eje-Z del mapa
		};																					// (los dibujamos sobre los edificios)

		// Seteamos las opciones para los pors:
		// ------------------------------------------------------------------------------
		porOptions = {
			icon: {url: '/assets/recycle.png',			// url del ícono a usar
		  scaledSize: new google.maps.Size(32, 37)},// tamaño con que se mostrará en el mapa
		  zIndex: 3																	// Posición en el eje-Z del mapa
		};																					// [los dibujamos sobre los edificios]
	
		// Seteamos las opciones para los eventos:
		// ------------------------------------------------------------------------------
		eventOptions = {
			icon: {url: '/assets/festival.png',
		  scaledSize: new google.maps.Size(32, 37)},
		  zIndex: 3												
		};
		
		// Seteamos las opciones para dibujar los polígonos:
		// ------------------------------------------------------------------------------
		drawPolygonOptions = {
			strokeColor: "#F88B0F",					// Seteamos el color del borde negro
			strokeOpacity: 0.8,							// Seteamos la opacidad del trazo
			strokeWeight: 3,								// Seteamos su grozor en 3
			fillColor: "#F69D01",						// Setemamos el color de llenado blanco
			fillOpacity: 0.4,								// La opacidad del relleno
			zIndex: 4												// Lo ubicamos arriba de todo
		};

		// Seteamos las opciones para dibujar los marcadores:
		// ------------------------------------------------------------------------------
		drawMarkerOptions = {
			icon: {url: '/assets/direction_down.png',			// ícono con el que se despliega
		  scaledSize: new google.maps.Size(32, 37)},// Tamaño con que se mostrará en el mapa
		  zIndex: 4	,																// Lo ubicamos arriba de todo
      animation: google.maps.Animation.DROP			// Animación para mostrar el marcador
		};										
	}


	// --------------------------------------------------------------------------------------------
	// Función usada para setear el modo de dibujo del mapa. Para lo anterior se lee el atributo
	// data-map-draw de $mapContext, el cual puede ser "polygon", "marker" o simplemente no estar:
	// --------------------------------------------------------------------------------------------
	function initializeDrawingOptions(){
		// primero, extraemos el atributo data-map-draw del contexto del mapa:
		var drawAttr = $mapContext.attr("data-map-draw");
		
		// Posteriormente, procedemos a setear el modo de dibujo dependiendo de su valor:
		switch(drawAttr){	
			case "polygon":										// Si data-map-draw="polygon", inicializamos
				initializeDrawingManager();			// el drawingManager.
				break;
			case "marker":
				google.maps.event.							// Si data-map-draw="marker", vinculamos el evento click
					addListener(mapInstance, 			// sobre el mapa con drawMarker.
					'click', function(event){
						drawMarker(event);
					});
				break;
			default:													// Si no es ninguna de las anteriores, no se hace nada
				break;													
		}
	}
	
	
	// --------------------------------------------------------------------------------------------
	// Función para inicializar el drawingManager utilizado para dibujar los polígonos en el mapa:
	// --------------------------------------------------------------------------------------------
	function initializeDrawingManager(){

		// Creamos la instancia del DrawingManager y vinculamos los eventos necesarios para dibujar
		// los polígonos y manejar las interacciones entre éste y los otros objetos del DOM:
		drawingManager = new google.maps.drawing.DrawingManager({
			drawingMode: google.maps.				// Indicamos la opción de dibujo con la cual se inicializa
				drawing.OverlayType.POLYGON,	// el drawingManager (en este caso, dibujar polígono)

			drawingControl: false,							// Indica que no se mostrará el control con los botones
																					// para seleccionar el modo de dibujo.					
			polygonOptions: drawPolygonOptions	// Se indican las opciones con la que se dibujarán los 
		});																		// polígonos en el mapa.
		
		// Lo agregamos al mapa:
		drawingManager.setMap(mapInstance);

		// Agregamos manejador para cuando se termina de dibujar un polígono:
		google.maps.event.addListener(drawingManager, 'polygoncomplete', createPolygonObject);
		
		// Agregamos manejador para cancelar dibujo del polígono a mitad de camino:
		google.maps.event.addListener(mapInstance, 'rightclick', cancelPolygon);

		// Vinculamos el evento con el botón redraw:
		$mapContext.delegate(s_reDrawButton, 'click', reDrawPolygon);
	}


	// --------------------------------------------------------------------------------------------
	// Función para inicializar las opciones con las cuales se cargarán las distintas componentes:
	// --------------------------------------------------------------------------------------------
	function searchAddress(eventObject){
		// Evitamos cualquier redireccionamiento indeseado:
		eventObject.preventDefault();
		
		// Obtenemos el elemento DOM donde se está la dirección.
		var $address = $(s_address);
		
		// Si este no existe, enviamos error:
		if($address.length == 0)
			throw new Error("No se pudo encontrar un campo de input con el atributo data-map-input='address'");
		
		// En caso contrario, obtenemos la dirección desde éste y buscamos sus coordenadas:
		var searchAddress = $address.val();
		
		// Construimos la url con la cual realizaremos la búsqueda:
		var searchURL = geocoderURL.replace('[searchAddress]', searchAddress);
		
		// Construimos la llamada Ajax:
		$.ajax({
			url: searchURL,
			dataType: "json",
			type: 'GET',
			success: function(data){
				try{
					// Si obtuvimos el resultado, intentamos extraer la ubicación:
					var location = data.results[0].geometry.location;
					
					// Seteamos las coordenadas en los campos asociados:
					$(s_addressLatitude).val(location.lat);		// Seteamos su latitud
					$(s_addressLongitude).val(location.lng);	// Seteamos su longitud

					// Construimos las coordenadas para setear s_rgeoAddress:					
					var rgeoCoordinates = "POINT ("+ location.lng + " " + location.lat + ")";
					$(s_rgeoAddress).val(rgeoCoordinates);
					
					// Finalmente, centramos el mapa en la dirección adecuada:
					var newCenter = new google.maps.LatLng(location.lat, location.lng);
					mapInstance.setCenter(newCenter);
				}
				catch(err){
					alert("ERROR: " + err + "\n\n" + searchURL + "\n\n");
				}
			}
		});
	}

		
	// --------------------------------------------------------------------------------------------
	// Función gatillada al hacer click sobre el mapa, se usa para dibujar un marcador en la
	// posición correspondiente
	// --------------------------------------------------------------------------------------------
	// @params
	// - eventObject:		Objeto que contiene la información del evento gatillado al hacer click en
	//									el mapa.
	// --------------------------------------------------------------------------------------------
	function drawMarker(eventObject){
	
		var coords = eventObject.latLng;					// Extraemos las coordenadas donde ocurrió el click
    
    $(s_markerLatitude).val(coords.lat()); 		// Seteamos la latitud en el campo indicado.
    $(s_markerLongitude).val(coords.lng());		// Seteamos la longitud en el campo indicado.
    
    // Revisamos si sketchedMarker ya existe. En caso de ser así, borramos el marcador pre-existente:
    if(sketchedMarker != undefined)
    	sketchedMarker.setMap(null); 
    
    // Creamos el marcador en la posición del click:
    sketchedMarker = new google.maps.Marker({
      position: coords,
      map: mapInstance, 
    });
    
    // Finalmente, le asignamos las opciones para desplegarlo:
    sketchedMarker.setOptions(drawMarkerOptions);
	}
	
	
	// --------------------------------------------------------------------------------------------
	// Función gatillada tras terminar de dibujar un polígono:
	// --------------------------------------------------------------------------------------------
	// @params
	// - polygon:					Instancia de google.maps.Polygon entregada por el drawingManager.
	// --------------------------------------------------------------------------------------------
	function createPolygonObject(polygon)
	{
		// Guardamos el polígono dibujado en sketchedPolygon:
		sketchedPolygon = polygon;
	
		// Seteamos las coordenadas del polígono en el campo marcado como data-map-output="polygon":
		var rgeoPolygon = polygonToRGeo(polygon);
		$(s_rgeoPolygon).val(rgeoPolygon);
	
		// Desactivamos el dibujo:
		drawingManager.setDrawingMode(null);

		// Habilitamos el botón 'redibujar':
		$(s_reDrawButton).attr("disabled", false);	
	}


	// --------------------------------------------------------------------------------------------
	// Función gatillada al presionar el botón "redibujar"
	// --------------------------------------------------------------------------------------------
	// @params
	// - eventObject:		Objeto del DOM que gatilla el evento.
	// --------------------------------------------------------------------------------------------
	function reDrawPolygon(eventObject)
	{
		// Evitamos que el click gatille algún redireccionamiento indeseado:
		eventObject.preventDefault();

		// Si ya había un polígono dibujado, lo borramos y vaciamos el campo asociado:
		if(sketchedPolygon != null){
			sketchedPolygon.setMap(null);
			$(s_rgeoPolygon).val("");					
		}
	
		// Habilitamos el dibujo:
		drawingManager.setDrawingMode(google.maps.drawing.OverlayType.POLYGON);
	
		// deshabilitamos el botón nuevamente:
		$(s_reDrawButton).attr("disabled", true);	
	}


	// --------------------------------------------------------------------------------------------
	// Función gatillada al hacer click derecho mientras se dibuja un polígono, reinicia el 
	// drawingManager para anular el dibujo.
	// --------------------------------------------------------------------------------------------
	function cancelPolygon(){
		drawingManager.setMap(null);	// Se desasocia el drawingManager anterior del mapa.
		initializeDrawingManager();		// Se vuelve a inicializar.
	}


	// --------------------------------------------------------------------------------------------
	// Función para obtener la representación de un polígono válida para RGeo::Cartesian::PolygonImpl.
	// --------------------------------------------------------------------------------------------
	// @params
	// - polygon:				instancia de google.maps.Polygon que se desea codificar
	// --------------------------------------------------------------------------------------------
	// @returns
	// - polygonString:	representación válida para inicializar un objeto RGeo::PolygonImpl
	//									Retorna string de la forma "POLYGON((lng1 lat1, ..., lngN latN, lng1 lat1))"
	// --------------------------------------------------------------------------------------------
	function polygonToRGeo(polygon)
	{
		// Inicializamos el string a retornar
		var polygonString = 'POLYGON((';
	
		// Obtenemos el listado de vértices del polígono:
		var vertices = polygon.getPath();
	
		// Recorremos la lista de polígonos, agregando cada par "longitud latitud" al resultado
		for (var i =0; i < vertices.getLength(); i++) {
			var xy = vertices.getAt(i);
			polygonString += xy.lng() + ' ' + xy.lat() + ', ';
		}
	
		// Repetimos el primer punto al final del listado y cerramos la inicialización:
		// (Esto es requisito de los RGeo::PolygonImpl, los cuales deben ser rutas cerradas)
		polygonString += vertices.getAt(0).lng() + ' ' + vertices.getAt(0).lat() + '))';
	
		// Retornamos el string en formato válido para RGeo::PolygonImpl:
		return polygonString;
	}	


	///////////////////////////////////////////////////////////////////////////////////////////////
	// SECCION II: Funciones	Privilegiadas																											///
	///////////////////////////////////////////////////////////////////////////////////////////////


	// --------------------------------------------------------------------------------------------
	// Función utilizada para setear el campus del mapa, desplegarlo y centrar el mapa en éste.
	// --------------------------------------------------------------------------------------------
	// - campusPolygon: 	polígono codificado según google.maps.geometry.encoding.encodePath, usado
	//										para inicializar el polígono del campus y centrar el mapa
	// --------------------------------------------------------------------------------------------
	this.setCampus = function(campusPolygon){
		// Construimos el polígono del campus:
		// TODO: eliminar código repetido de loadBuilding
		
		// Primero decodificamos encodedPath para obtener el listado de vértices del polígono:
		var vertices = google.maps.geometry.encoding.decodePath(campusPolygon);
	
		// Quitamos el último vértice del arreglo 
		//(es el mismo que el primero, esto es un requisito de RGeo::PolygonImpl):
		vertices = vertices.slice(0,vertices.length-1);

		// inicializamos el polígono y seteamos las opciones correspondientes:
		var polygon = new google.maps.Polygon({path: vertices});
		polygon.setOptions(campusOptions);

		// Obtenemos el centro del polígono:
		var myCenter = getPolygonCenter(polygon);
		
		// Centramos el mapa en el nuevo campus:
		mapInstance.setCenter(myCenter);
		
		// Finalmente, si el modo de dibujo es marker, vinculamos el handler asociado:
		if($mapContext.attr("data-map-draw") == "marker")
			google.maps.event.addListener(polygon, 'click', drawMarker);
				
		// Guardamos el campus en su variable y lo desplegamos en el mapa:
		campus = polygon; campus.setMap(mapInstance);
	}
	

	// --------------------------------------------------------------------------------------------
	// Función para cargar un marcador en una determinada ubicación
	// --------------------------------------------------------------------------------------------
	// @params
	// - id: 						string con el id del poi/por/event asociado (ej: '1')
	// - latitude:			latitud en la que se desea desplegar el marcador
	// - longitude:			longitud en la que se desea desplegar el marcador
	// - description:		información del punto a desplegar como título del mismo
	// - markerType: 		enum MarkerType, indica si se trata de un poi, por o event
	// --------------------------------------------------------------------------------------------
	this.loadMarker = function(id, latitude, longitude, description, markerType)
	{
		// Creamos el marcador a cargar:
		var marcador = new google.maps.Marker({
		  	position : new google.maps.LatLng(latitude, longitude),
		});
		
		// Si el mapa no está en modo de dibujo, entonces les agregamos el evento onClick:
		var drawAttr = $mapContext.attr("data-map-draw");
		
		if(drawAttr == undefined){
		  marcador.info = new google.maps.InfoWindow({
			  content: description   
		  });
		  
			google.maps.event.addListener(marcador, 'click', function() {
			  this.info.open(mapInstance,this);
			});
		}
		
		// Cargamos las opciones correctas dependiendo el tipo de marcador:
		var pointOptions;												// Opciones con las que se cargará el punto en el mapa
		var pointListName;											// Lista en la que se cargará el nuevo punto
		
		var formerMarker;
		
		switch(markerType){	
			case MapWrapper.MarkerType.POI_MARKER:// Verificamos si se trata de un punto de interés:
				pointOptions = poiOptions;					// Seteamos las opciones correctas al tipo de marcador
				formerMarker = pois[id];
				pois[id] = marcador;
				pointListName = "pois";							// Indicamos cuál será la lista en la que se cargará el punto
				break;
			case MapWrapper.MarkerType.POR_MARKER:// Verificamos si se trata de un punto de reciclaje:
				pointOptions = porOptions;					// Seteamos las opciones correctas al tipo de marcador
				formerMarker = pors[id];
				pors[id] = marcador;
				pointListName = "pors";							// Indicamos cuál será la lista en la que se cargará el punto
				break;
			case MapWrapper.MarkerType.EVENT_MARKER:// Verificamos si se trata de un evento:
				pointOptions = eventOptions;				// Seteamos las opciones correctas al tipo de marcador
				formerMarker = events[id];
				events[id] = marcador;
				pointListName = "events";						// Indicamos cuál será la lista en la que se cargará el punto
				break;
			default:															// Si no es un tipo válido, se arroja un error 
				throw new Error("EL tipo de marcador especificado no existe").
				break;
		}

		// Adicionalmente, revisamos si ya existía. de ser así, quitamos la instancia previa del mapa:
		if(formerMarker != undefined)
			formerMarker.setMap(null);
		
		// Finalmente, seteamos las opciones y lo cargamos en el mapa indicado:
		marcador.setOptions(pointOptions);			// Cargamos las opciones correspondientes
		marcador.setMap(mapInstance);
	}
	

	// --------------------------------------------------------------------------------------------
	// Función para cargar un marcador para editarlo
	// --------------------------------------------------------------------------------------------
	// @params
	// - id: 						string con el id del poi/por/event asociado (ej: '1')
	// - latitude:			latitud en la que se desea desplegar el marcador
	// - longitude:			longitud en la que se desea desplegar el marcador
	// - description:		información del punto a desplegar como título del mismo
	// - markerType: 		enum MarkerType, indica si se trata de un poi, por o event
	// --------------------------------------------------------------------------------------------
	this.editMarker = function(id, latitude, longitude, description, markerType)
	{
		// Cargamos el marcador en el mapa:
		this.loadMarker(id,latitude, longitude, description, markerType);
		
		// Buscamos el marcador creado y lo guardamos en sketchedMarker:
		switch(markerType){	
			case MapWrapper.MarkerType.POI_MARKER:// Verificamos si se trata de un punto de interés:
				sketchedMarker = pois[id];
				break;
			case MapWrapper.MarkerType.POR_MARKER:// Verificamos si se trata de un punto de reciclaje:
				sketchedMarker = pors[id];
				break;
			case MapWrapper.MarkerType.EVENT_MARKER:// Verificamos si se trata de un evento:
				sketchedMarker = events[id];
				break;
			default:															// Si no es un tipo válido, se arroja un error 
				throw new Error("EL tipo de marcador especificado no existe").
				break;
		}
		
		// Seteamos las opciones para mostrarlo y lo agregamos al mapa:
		sketchedMarker.setOptions(drawMarkerOptions);			// Cargamos las opciones correspondientes
		sketchedMarker.setMap(mapInstance);
	}


	// --------------------------------------------------------------------------------------------
	// Función para eliminar un edificio de un mapa determinado
	// --------------------------------------------------------------------------------------------
	// @params
	// - id: 						string con el id del poi/por/event asociado (ej: '1')
	// - markerType: 		enum MarkerType, indica si se trata de un poi, por o event
	// --------------------------------------------------------------------------------------------
	this.deleteMarker = function(id, markerType){
		// Extraemos el marcador del mapa
		var marker;

		switch(markerType){	
			case MapWrapper.MarkerType.POI_MARKER:// Verificamos si se trata de un punto de interés:	
				marker = pois[id];									// Lo extraemos del hashMap asociado
				pois[id] = undefined;								// Lo sacamos del listado de pois
				break;
			case MapWrapper.MarkerType.POR_MARKER:// Verificamos si se trata de un punto de reciclaje:
				marker = pors[id];									// Lo extraemos del hashMap asociado	
				pors[id] = undefined;								// Lo sacamos del listado de pors
				break;
			case MapWrapper.MarkerType.EVENT_MARKER:// Verificamos si se trata de un evento:
				marker = events[id];								// Lo extraemos del hashMap asociado
				events[id] = undefined;							// Lo sacamos del listado de events
				break;
			default:															// Si no es un tipo válido, se arroja un error 
				throw new Error("EL tipo de marcador especificado no existe").
				break;
		}

		// Si el marcador existe, entonces lo borramos
		if(marker != undefined){					
			marker.setMap(null);								// Dejamos de desplegarlo en el mapa
		}	
	}

	
	// --------------------------------------------------------------------------------------------
	// Función para cargar un edificio en un mapa determinado
	// --------------------------------------------------------------------------------------------
	// @params
	// - id: 						string con el id del edificio asociado (ej: '1')
	// - encodedPath:		string con el polígono encodeado a través del método building.encoded_path
	// --------------------------------------------------------------------------------------------
	this.loadBuilding = function(id, encodedPath){
		try{
			// Primero decodificamos encodedPath para obtener el listado de vértices del polígono:
			var vertices = google.maps.geometry.encoding.decodePath(encodedPath);
		
			// Quitamos el último vértice del arreglo 
			//(es el mismo que el primero, esto es un requisito de RGeo::PolygonImpl):
			vertices = vertices.slice(0,vertices.length-1);

			// inicializamos el polígono y seteamos las opciones correspondientes:
			var polygon = new google.maps.Polygon({path: vertices});
			polygon.setOptions(buildingOptions);
	
			// Adicionalmente, revisamos si ya existía. de ser así, quitamos la instancia previa del mapa:
			if(buildings[id] != undefined)
				buildings[id].setMap(null);
	
			// Si el modo de dibujo es marker, vinculamos el handler asociado:
			if($mapContext.attr("data-map-draw") == "marker")
				google.maps.event.addListener(polygon, 'click', drawMarker);
	
			// Finalmente, lo agregamos al listado de edificios y lo desplegamos en el mapa:
			buildings[id] = polygon;
			polygon.setMap(mapInstance);
		}
		catch(err){
			alert("Error: " + err);
		}
	}

	
	// --------------------------------------------------------------------------------------------
	// Función para cargar un edificio en un mapa determinado para editarlo
	// --------------------------------------------------------------------------------------------
	// @params
	// - id: 						string con el id del edificio asociado (ej: '1')
	// - encodedPath:		string con el polígono encodeado a través del método building.encoded_path
	// --------------------------------------------------------------------------------------------
	this.editBuilding = function(id, encodedPath){
		// Cargamos el edificio en el listado de edificios:
		this.loadBuilding(id, encodedPath);
		// Posterior a esto, lo seteamos en sketchedPolygon para poder manejarlo adecuadamente		
		sketchedPolygon = buildings[id];
		
		// Seteamos las opciones de edición:
		sketchedPolygon.setOptions(drawPolygonOptions);
		
		// Desactivamos el dibujo:
		drawingManager.setDrawingMode(null);

		// Habilitamos el botón 'redibujar':
		$(s_reDrawButton).attr("disabled", false);	
	}


	// --------------------------------------------------------------------------------------------
	// Función para eliminar un edificio de un mapa determinado
	// --------------------------------------------------------------------------------------------
	// @params
	// - id: 						string con el id del edificio asociado (ej: '1')
	// --------------------------------------------------------------------------------------------
	this.deleteBuilding = function(id){
		// Extraemos el polígono del mapa
		var polygon = buildings[id];								
	
		// Si el polígono existe, entonces lo borramos
		if(polygon != undefined){					
			polygon.setMap(null);						// Dejamos de desplegarlo en el mapa
			buildings[id] = undefined;			// Lo sacamos del listado de edificios
		}	
	}
}	// ------------------------------ End MapWrapper ----------------------------------------------------
// ----------------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------------
// Prototype de MapWrapper, contiene los métodos públicos de éste.
// ----------------------------------------------------------------------------------------------------
MapWrapper.prototype = {
	// No creamos nada acá, puesto que éstos métodos no pueden acceder a las variables privadas.
}

// --------------------------------------------------------------------------------------------
// ALTERNATIVAS DE DISEÑO:
// --------------------------------------------------------------------------------------------
// Cambiar data-map-input='...' y data-map-output='...' por 
// doble atributo data-map-object='...' y data-map-type= 'input' / 'output'.
// Con esto hacemos más flexible la función de un tipo de variable, lo cual es espcialmente
// util para las variables asociadas a address (se dejará para otra iteración)
// --------------------------------------------------------------------------------------------
// Dividir las funcionalidades en PolygonModule y MarkerModule, de forma de disminuir el tamaño
// del archivo.
// --------------------------------------------------------------------------------------------
// Comprimir poiOptions, porOptions y eventOptions en un hash markerOptions, el cual contenga
// una entrada por cada tipo en el enum MarkerType
// --------------------------------------------------------------------------------------------
