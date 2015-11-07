
Trentino Open Data Super POM

Super POM used by Open Data in Trentino Java projects.

For common library toolkit see [Tod Commons](https://github.com/opendatatrentino/tod-commons)


[Usage](#usage)

[Deploy Prerequisites](#deploy-prerequisites)

[Deploy snapshots](#deploy-snapshots)

[Release](#release)
___________________________

### Usage

Releases of the POM are on Central. To use it in your project, just write this in your project

```
    <parent>
        <groupId>eu.trentorise.opendata</groupId>
        <artifactId>tod-super-pom</artifactId>
        <version>#{version}</version>
    </parent>
```

and copy plugins list like in [Tod Commons pom](https://github.com/opendatatrentino/tod-commons/blob/master/pom.xml):

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

Make sure to put a url tag with the correct github addreass, i.e.:
```
 <url>https://github.com/opendatatrentino/tod-commons</url>
```

And put the scm:

```
   <scm>
        <url>${project.url}</url>
        <connection>scm:git:${project.url}.git</connection>
        <developerConnection>scm:git:${project.url}.git</developerConnection>        
        <tag>HEAD</tag>
   </scm>
```


### Deploy prerequisites

So far we only tried releasing from a Windows environment. Since Windows, Maven, Git and GPG don't play well together, we resorted to putting passwords in clear in maven `.m2/settings.xml` (which is not much secure..) and made a `bat` script to ease the process.

To deploy to Sonatype any tod project, you need this prerequisites:

1. Register on sonatype to have username/passoword.
2. Create GPG keys
3. Edit Maven `.m2/settings.xml` in your user home

These three steps are only needed once for all the projects you might need to maintain.

#### 1. Register to Sonatype

TODO write something

#### 2. Create GPG keys

TODO write something

#### 3. Edit Maven settings.xml

You will need to edit `.m2/settings.xml` of your user home to add passwords for Sonatype, Github and GPG

##### Sonatype

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

##### GitHub access

For publishing websites to Gitub pages, you also need to put Github server OAuth token in `settings.xml`. 
NOTE: anybody with the OAuth token to programmatically access all of your 
repositories with the given permissions. As such, it is not ideal but it's the simplest to start with. 

To get the token:
- Go to https://github.com/settings/applications 
- Go to `personal access tokens -> Generate new token`, and give only the following permissions :
    - repo
    - public_repo 
    - user:email
           
Put this in the `<servers>` section in `.m2/settings.xml` of your user home:

```
    <server>
          <id>github</id>
          <password>YOUR_OAUTH_TOKEN_HERE</password>
    </server>
```

##### GPG

To allow signing artifacts, put this in the `<profiles>` section in `.m2/settings.xml` of your user home:

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
<a href="https://oss.sonatype.org/content/repositories/snapshots/eu/trentorise/opendata/commons/" target="_blank">https://oss.sonatype.org/content/repositories/snapshots/eu/trentorise/opendata/commons/tod-super-pom </a>

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

#### Release with .bat file

So far we only tried releasing from a Windows environment. Since Windows, Maven and Git don't play well together, we made a [release.bat file](release.bat) to ease the process. You can use the bat for this or other tod projects.

To print help, just type the command:

```
release.bat
```

To release `my-program` with version `1.2.3` , from your project root run `release.bat` followed by the release tag and the branch where you want to push:
```
path\to\release.bat my-program-1.2.3 master
```

If something goes wrong along the way just run `release.bat` to see help on how to recover.

By default the release will generate website with josman and try to send it to GitHub `gh-pages` branch. To prevent such behaviour, add -nosite parameter to the bat.


#### Manual release workflow

TODO make this a proper bash script

To check website docs before releasing:
```
mvn josman:site -Dsite.snapshot=true
```


Ideal commands workflow:
```
    mvn release:clean
    mvn release:prepare
    mvn release:perform
```

Workflow when having problems with git: 
```
    mvn -DpushChanges=false release:clean release:prepare
    git push origin master
    git push origin PUT_REPO_NAME-X.Y.Z
    release:perform
```

To make website:
```
mvn josman:site
```

To send website to gh-pages branch:
```
mvn com.github.github:site-maven-plugin:site
```

#### Credits

* David Leoni - DISI, University of Trento - david.leoni@unitn.it
