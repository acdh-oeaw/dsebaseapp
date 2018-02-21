xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace app="http://www.digital-archiv.at/ns/millinger-archive/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/millinger-archive/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:script to add tei:idno elements containing normdata-ID-URLs:)

for $x in doc($app:personIndex)//tei:person[./tei:persName/@key]
let $gnd := "http://d-nb.info/gnd/"||data($x/tei:persName/@key)
let $idno := <tei:idno type="URL">{$gnd}</tei:idno>
let $insert := update insert $idno into $x
return
    $x