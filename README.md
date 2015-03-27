
Open Data in Trentino Super POM

Super POM used by Open Data in Trentino Java projects. 

For common library toolkit see [Odt Commons](https://github.com/opendatatrentino/odt-commons)

### Usage 

Releases of the POM are on Central. To use it, just write this in your project

```
    <parent>
        <groupId>eu.trentorise.opendata.commons</groupId>
        <artifactId>odt-super-pom</artifactId>
        <version>1.0.0-SNAPSHOT</version>
    </parent>  
```

and copy plugins list like in [Odt Commons pom](https://github.com/opendatatrentino/odt-commons/blob/master/pom.xml): 

```
  <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-release-plugin</artifactId>
            </plugin>             
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-javadoc-plugin</artifactId>
            </plugin>             
            <plugin>

    ...

    </build>
```

todo write about scm stuff

#### Credits

* David Leoni - DISI at University of Trento - david.leoni@unitn.it
