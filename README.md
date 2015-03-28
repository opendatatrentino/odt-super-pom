
Open Data in Trentino Super POM

Super POM used by Open Data in Trentino Java projects.

For common library toolkit see [Odt Commons](https://github.com/opendatatrentino/odt-commons)


[Usage](#usage)

[Deploy Prerequisites](#deploy-prerequisites)

[Deploy snapshots](#deploy-snapshots)

[Release](#release)
___________________________

### Usage

Releases of the POM are on Central. To use it in your project, just write this in your project

```
    <parent>
        <groupId>eu.trentorise.opendata.commons</groupId>
        <artifactId>odt-super-pom</artifactId>
        <version>THE_VERSION</version>
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

TODO put other things to copy!!!

### Deploy prerequisites

So far we only tried releasing from a Windows environment. Since Windows, Maven, Git and GPG don't play well together, we resorted to putting passwords in clear in maven `.m2/settings.xml` (which is not much secure..) and made a `bat` script to ease the process.

To deploy to Sonatype any odt project, you need this prerequisites:

1. Register on sonatype to have username/passoword.
2. Create GPG keys
3. Edit Maven `.m2/settings.xml` in your user home

These three steps are only needed once for all the projects you might need to maintain.

#### 1. Register to Sonatype

TODO write something

#### 2. Create GPG keys

TODO write something

#### 3. Edit Maven settings.xml


Put this in the `<servers>` section in `.m2/settings.xml` of your user home:

```

    <server>
      <id>sonatype-nexus-snapshots</id>
        <username>YOUR_SONATYPE_USERNAME</username>
        <password>YOUR_PASSWORD</password>
    </server>
    <server>
      <id>sonatype-nexus-staging</id>
        <username>YOUR_SONATYPE_USERNAME</username>
        <password>YOUR_PASSWORD</password>
    </server>

	<server>
      <id>ossrh</id>
        <username>YOUR_SONATYPE_USERNAME</username>
        <password>YOUR_PASSWORD</password>
    </server>

```

Put this in the `<profiles>` section in `.m2/settings.xml` of your user home:

```
	<profile>
	  <id>ossrh</id>
	  <activation>
		<activeByDefault>true</activeByDefault>
	  </activation>
	  <properties>
		<gpg.executable>gpg2</gpg.executable>
		<gpg.passphrase>YOUR_GPG_PASSPHRASE</gpg.passphrase>
	  </properties>
	</profile>
```

### Deploy snapshots

Before attempting deployment, make sure you meet the [Deploy prerequisites](#deploy-prerequisites).

Snapshots are deployed on Sonatype:
<a href="https://oss.sonatype.org/content/repositories/snapshots/eu/trentorise/opendata/commons/" target="_blank">https://oss.sonatype.org/content/repositories/snapshots/eu/trentorise/opendata/commons/odt-super-pom/</a>

with this command:

```
    mvn clean deploy
```

In Netbeans, you can also:

```
right click on the project -> Custom -> Deploy to Sonatype
```


### Release

Before attempting release, make sure you meet the [Deploy prerequisites](#deploy-prerequisites).

So far we only tried releasing from a Windows environment. Since Windows, Maven and Git don't play well together, we made a [release.bat file](release.bat) to ease the process. You can use the bat for this or other odt projects.

To print help, just type the command:

```
release.bat
```

To release `my-program` with version `1.2.3` , from your project root run `release.bat` followed by the release tag:
```
path\to\release.bat my-program-1.2.3
```

If something goes wrong along the way just run `release.bat` to see help on how to recover.


#### Credits

* David Leoni - DISI, University of Trento - david.leoni@unitn.it
