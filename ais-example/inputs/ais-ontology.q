[QueryItem="get mmsi"]
PREFIX ais: <http://example.org/ais#>
PREFIX : <http://example.org/voc#>

SELECT DISTINCT ?mmsi ?name
WHERE {
  ?vessel a :Vessel ;
          ais:mmsi ?mmsi ;
          ais:hasMetadata ?metadata .
  ?metadata ais:name ?name .
}
[QueryItem="distinct_mmsi"]
PREFIX : <http://example.org/voc#>
PREFIX ais: <http://example.org/ais#>

SELECT DISTINCT ?mmsi
WHERE {
  ?vessel a :Vessel ;
          ais:mmsi ?mmsi .
}
[QueryItem="distinct_mmsi_name"]
PREFIX : <http://example.org/voc#>
PREFIX ais: <http://example.org/ais#>

SELECT DISTINCT ?mmsi ?name
WHERE {
  ?vessel a :Vessel ;
          ais:mmsi ?mmsi ;
          ais:hasMetadata ?metadata .
  ?metadata a ais:Metadata ;
            ais:name ?name .
}
[QueryItem="distinct_mmsi_name_sog"]
PREFIX : <http://example.org/voc#>
PREFIX ais: <http://example.org/ais#>

SELECT DISTINCT ?mmsi ?name ?sog
WHERE {
  ?vessel a :Vessel ;
          ais:mmsi ?mmsi ;
          ais:hasMetadata ?metadata ;
          ais:hasLocation ?location .
          
  ?metadata a ais:Metadata ;
            ais:name ?name .

  ?location a ais:Location ;
            ais:sog ?sog .
}
[QueryItem="mmsi_name_lat_lon"]
PREFIX : <http://example.org/voc#>
PREFIX ais: <http://example.org/ais#>

SELECT DISTINCT ?time ?mmsi ?name ?lat ?lon 
WHERE {
  ?vessel a :Vessel ;
          ais:mmsi ?mmsi ;
          ais:hasMetadata ?metadata ;
          ais:hasLocation ?location .
          
  ?metadata a ais:Metadata ;
            ais:name ?name .

  ?location a ais:Location ;
            ais:lat ?lat ;
	   ais:lon ?lon ;
	   ais:time ?time .
}
[QueryItem="mmsi_name_destination"]
PREFIX : <http://example.org/voc#>
PREFIX ais: <http://example.org/ais#>

SELECT DISTINCT ?mmsi ?name ?destination
WHERE {
  ?vessel a :Vessel ;
          ais:mmsi ?mmsi ;
          ais:hasMetadata ?metadata .
          
  ?metadata a ais:Metadata ;
            ais:name ?name ;
	   ais:destination ?destination ;
}
[QueryItem="distinct_mmsi_name_shipType_shipTypeDescription"]
PREFIX : <http://example.org/voc#>
PREFIX ais: <http://example.org/ais#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT DISTINCT ?mmsi ?name ?shipType ?shipTypeDescription
WHERE {
  ?metadata a ais:Metadata ;
            ais:mmsi ?mmsi ;
            ais:name ?name ;
            ais:hasShipType ?shipType .
  
  ?shipType a ais:ShipTypeDescription ;
            ais:shipTypeDescription ?shipTypeDescription .
}