#!/usr/bin/env groovy

xml = new XmlSlurper().parseText( new File("pom.xml").getText() )
packaging = xml.packaging != "" ? xml.packaging : "jar"
println "packaging : $packaging"
println "groupId : $xml.groupId"
println "artifactId : $xml.artifactId"

def properties = [:]
xml.properties.children().each {
// println "found property : ${it.name()}:${it.text()}"
 properties.put(it.name(),it.text())
}

xml.dependencies.dependency.each {
 scope = it.scope != "" ? it.scope : 'compile'
 String version = it.version
 if ( version != null && version != "" && version.startsWith('${') ){
   version = version.replace('${','')
   version = version.replace('}','')
   version = properties.get(version)
 }
 println "found dependency : $it.groupId:$it.artifactId:$version:$scope"
}

