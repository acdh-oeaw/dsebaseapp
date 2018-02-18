xquery version "3.0";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace gn="http://www.geonames.org/ontology#";
declare namespace wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#";

import module namespace functx = "http://www.functx.com";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/millinger-archive/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/millinger-archive/templates" at "../modules/app.xql";

(:let $gnd := doc("http://www.geonames.org/2772400/about.rdf"):)
(:let $lat := $gnd//wgs84_pos:lat/text():)
(:let $lng := $gnd//wgs84_pos:long/text():)



let $input := doc('listplace.xml')//tei:place[not(.//tei:idno) and .//tei:placeName]
for $x in $input
    let $key := data($x/tei:placeName/@key)
    let $gnd := "http://www.geonames.org/"||$key||'/about.rdf'
    let $gnd := doc($gnd)
(:    return $gnd:)
    let $lat := $gnd//wgs84_pos:lat/text()
    let $lng := $gnd//wgs84_pos:long/text()
    let $newnode :=
    <tei:location>
        <tei:geo decls="LatLng">{concat($lat, ' ', $lng)}</tei:geo>
    </tei:location>
    let $updated := update insert $newnode following $x/tei:placeName
    let $idno :=
        <tei:idno type='URL'>{concat('http://www.geonames.org/', $key)}</tei:idno>
    let $addidno := update insert $idno into $x
    return $x
