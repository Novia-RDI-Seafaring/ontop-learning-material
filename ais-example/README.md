# Ontology for AIS data 


## Load example database
Lacate the file `./h2/bin/h2w.bat`, use login credentials:
- Drive class: `org.h2.Driver`
- JDBC URL: `jdbc:h2:tcp://localhost/../ais-session` 
- User Name: `sa`
- Password:

The database runs on port `8080`. 

## The Ontology
The goal is to create an ontology that describes the AIS data from [Digitraffic](https://www.digitraffic.fi/meriliikenne/) topics `vessels-v2/<mmsi>/metadata` and `vessels-v2/<mmsi>/locations`. Examples of topic data:

**Metadata**
```json
{
  "name" : "NORD SUPERIOR",
  "timestamp" : 1591521868371,
  "destination" : "NL AMS",
  "draught" : 118,
  "eta" : 416128,
  "posType" : 1,
  "referencePointA" : 148,
  "referencePointB" : 35,
  "referencePointC" : 23,
  "referencePointD" : 9,
  "shipType" : 80,
  "mmsi" : 219598000,
  "callSign" : "OWPA2",
  "imo" : 9692129
}
```
**Location**
```json
{
  "type" : "FeatureCollection",
  "dataUpdatedTime" : "2025-03-22T12:15:54Z",
  "features" : [ {
    "mmsi" : 219598000,
    "type" : "Feature",
    "geometry" : {
      "type" : "Point",
      "coordinates" : [ 20.85169, 55.770832 ]
    }
```

**Steps:**
- Create an owl file sin `./inputs/`. This will defin the `Classes`, `Object Properties`, and `Data Properties` of the ontology.

### Define Classes
We define the following three classes:

**Vessel**
The `:Vessel` class is stable and provide unique identifiers of a vessel based on `ais:mmsi`.
```turtle
###  http://example.org/voc#Vessel
:Vessel rdf:type owl:Class .
``` 

**Metadata**
The `ais:Metadata` class linkt to data properties like `mmsi`, `name`, `imo`, `call_sign`,...  
```turtle
###  http://example.org/ais#Metadata
ais:Metadata rdf:type owl:Class .
``` 

**Location**
The `ais:Location` class linkt to data properties like `mmsi`, `lat`, `lon`, `sog`, `cog`, `call_sign`,...  
```turtle
###  http://example.org/ais#Location
ais:Location rdf:type owl:Class .
``` 

### Define Object Properties
We define the following object properties that link the `:Vessel` class to `ais:Location` and `ais:Metadata`:

**hasLocation**
```turtle
###  http://example.org/ais#hasLocation
ais:hasLocation rdf:type owl:ObjectProperty ;
                rdfs:domain :Vessel ;
                rdfs:range ais:Location .
``` 

**hasMetadata**
```turtle
###  http://example.org/ais#hasMetadata
ais:hasMetadata rdf:type owl:ObjectProperty ;
                rdfs:domain :Vessel ;
                rdfs:range ais:Metadata .
``` 

### Define Data Properties
#### Location
The `ais:Location` class has data properties:
- `ais:time` of type `xsd:dataTime`
- `ais:mmsi` of type `xsd:integer` 
- `ais:sog` of type `xsd:decimal`
- `ais:sog` of type `xsddecimal:`
- `ais:cog` of type `xsd:decimal`
- `ais:navStat` of type `xsd:integer`
- `ais:rot` of type `xsd:decimal`
- `ais:posAcc` of type `xsd:boolean`
- `ais:raim` of type `xsd:boolean`
- `ais:heading` of type `xsd:integer`
- `ais:lon` of type `xsd:double`
- `ais:lat` of type `xsd:double`

The data properties are defined in the ontology as:
```turtle
###  http://example.org/ais#ais:<name>
ais:<name>   rdf:type owl:DatatypeProperty ;
             rdfs:domain ais:Location ;
             rdfs:range xsd:<type> .
```

#### Metadata
The `ais:Metadata` class has data properties:
- `ais:time` of type `xsd:dataTime`
- `ais:mmsi` of type `xsd:integer` 
- `ais:imo` of type `xsd:integer`
- `ais:name` of type `xsd:string`
- `ais:shipType` of type `xsd:string`
- `ais:destination` of type `xsd:string`
- `ais:draught` of type `xsd:decimal`
- `ais:callSign` of type `xsd:string`
- `ais:eta` of type `xsd:integer`
- `ais:posType` of type `xsd:integer`

The data properties are defined in the ontology as:
```turtle
###  http://example.org/ais#ais:<name>
ais:<name>   rdf:type owl:DatatypeProperty ;
             rdfs:domain ais:Metadata ;
             rdfs:range xsd:<type> .
```

## Deploy endpoint
Run 

```bash
docker-compose up
```

the application will run on `http://localhost:8080`.

> **⚠️ Note:** If you have been running the H2 console on port 8082, you might need to stop it before starting the  Docker setup. First, find its process ID (PID) by running:
> ```bash
> netstat -ano | findstr :8082
> ```
> Then, kill the process with:
> ```bash
>  taskkill /PID <PID> /F  
> ```