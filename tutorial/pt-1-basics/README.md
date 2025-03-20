# Ontop Tutorial
Following intructions on:

Link: https://ontop-vkg.org/tutorial/

Adding my own comments as I go.

## Presentation
In this tutorial, we will see how to design a Virtual Knowledge Graph (VKG) specification, how to deploy it as a SPARQL endpoint, how to consume it and further more advanced topics

### Requirements
- [Java 11](https://www.oracle.com/java/technologies/downloads/?er=221886) (or newer stable release)
- Latest version of Ontop from [GitHub](https://github.com/ontop/ontop/releases) (opens new window) or [SourceForge](https://sourceforge.net/projects/ontop4obda/files/)
- [Git](https://git-scm.com/).


> 📌 **Note:** installed `Java SE Development Kit 21.0.5?` and `ontop-5.3.0`.


### Clone repository
Before start, please clone this repository in order to download all the files
```bash
git clone https://github.com/ontop/ontop-tutorial.git
cd ontop-tutorial
```

## Database and Ontop setup
In this tutorial, we are considering fragments of the information systems of two universities describing students, academic staff and courses.

### Database setup
Procedure to set up the datebase for the following exercises:

1. Unzip the archive of H2 (h2.zip)
2. Start the database:
    - On Mac/Linux: open a terminal, go into h2/bin and run sh h2.sh
    - On Windows: click on the executable h2w.bat
3. After being automatically redirect to the web interface of H2, connect with the default parameters:
    - JDBC URL: jdbc:h2:tcp://localhost/../university-session1
    - User name: sa
    - No password
4. Now you can see the tables in the schema uni1.
5. Try a first SQL query: "Give me the last names of the full professors"

```sql
SELECT "last_name"
FROM "uni1"."academic"
WHERE "position" = 1
```

### Ontop-Protégé setup
Protégé is an open source ontology editor and knowledge management system. Ontop-Protégé is a plugin for designing and testing a VKG specification.

0. Download the latest [Ontop-Protégé](https://sourceforge.net/projects/ontop4obda/files/) bundle for your Operating System and unzip the archive and go into its folder
1. Run it (run.bat on Windows, run.sh on Mac/Linux)
2. Register the H2 JDBC driver: go to `Preferences -> JDBC Drivers` and add an entry with the following information
    - Description: `h2` 
    - Class Name: `org.h2.Driver`
    - Driver file (jar): `/path/to/h2/bin/h2-1.4.196.jar`

## First data source: university1
As a first step, we focus on the database of a first university. It has the schema uni1. It is composed of 5 tables.

**uni1.student**

The table uni1.student contains the local ID, first and last names of the students.

| s_id | first_name | last_name |
|------|------------|----------|
| 1    | Mary       | Smith    |
| 2    | John       | Doe      |

The column s_id is a primary key.

**uni1.academic**

Similarly, the table uni1.academic contains the local ID, first and last names of the academic staff, but also information about their position.

| id  | first_name | last_name | status |
|-----|------------|----------|--------|
| 1   | Anna       | Chambers | 1      |
| 2   | Edward     | May      | 9      |
| 3   | Rachel     | Ward     | 8      |

The column position is populated with magic numbers:

- 1 -> Full Professor
- 2 -> Associate Professor
- 3 -> Assistant Professor
- 8 -> External Teacher
- 9 -> PostDoc

The column a_id is a primary key.

See rest of the tables from the [tutorial](https://ontop-vkg.org/tutorial/basic/university-1.html#ontology-classes-and-properties)

### Ontology: classes and properties
1. Download this [OWL ontology file](https://ontop-vkg.org/tutorial/basic/university.ttl).
2. Download this [mapping file](https://ontop-vkg.org/tutorial/basic/university.obda).
3. Download this [properties file](https://ontop-vkg.org/tutorial/basic/university.properties).
4. In Protégé, go to `File/Open...` to load the ontology file (be sure you have all three files in the same folder).
5. In the tab `Classes` you can visualize the class hierarchy
6. In the tab Object properties you can see the properties attends, isGivenAt, isSupervisedBy, isTaughtBy and teaches (with its two sub-properties givesLab and givesLecture).
7. In the tab Data properties you can see the properties firstName, lastName and title.

> 📌 **Note:** We have the following files:
> - `university.ttl` - OWL ontology file
> - `university.obda` - mapping file
> - `university.properties` - property file, linking to the db.


### Mappings 
1. Go to the Window -> Tabs -> Ontop mapping tab
2. Test the already defined connection configuration using the Test Connection button
3. Switch to the `Mapping Manager` tab in the ontop mappings tab
4. You should see a first mapping assertion called `uni1-student`
5. Double-click on it to observe it and then close this pop-up window.

The mappings `ini1-student` looks like
- Target:
```turtle
:uni1/student/{s_id} a :Student ;
    foaf:firstName {first_name}^^xsd:string ;
    foaf:lastName {last_name}^^xsd:string .
``` 
- Source:
```turtle
SELECT *
FROM "uni1"."student"
```

Some remarks:

- The target part is described using a [Turtle-like syntax](https://github.com/ontop/ontop/wiki/TurtleSyntax) while the source part is a regular SQL query.
- We used the primary key s_id to create the IRI. As we will see later, this practice enables Ontop to remove self-joins, which is very important for optimizing the query performance.
- This entry could be split into three mapping assertions

> 📌 **Note:**
> - **IRI** stands for **Internationalized Resource Identifier**. Basically an URL or URI.
> - `:uni1/student/{s_id}` — generates a unique IRI for each student using the `s_id` from the database.
> - `a :Student` — declares that each generated IRI represents an instance of the `:Student` class.
> - `^^` The datatype indicator — it tells RDF that the literal has a specific datatype.
> - `xsd:string` The datatype from XML Schema — a standard way of saying "this is a string literal."
> In RDF (and Turtle syntax), `^^xsd:string` is a **datatype annotation** that tells the RDF triple: **"This value is a literal of type xsd:string (an XML Schema string)."**
> - `foaf:firstName {first_name}^^xsd:string` — maps the `first_name` column from the database to the RDF property `foaf:firstName` as a string literal.
> - `foaf:lastName {last_name}^^xsd:string` — maps the `last_name` column from the database to the RDF property `foaf:lastName` as a string literal.
> - This mapping is applied to each row of the following SQL query:
> ```sql
>SELECT *
>FROM "uni1"."student"

Added the other mappings as in the [Tutorial](https://ontop-vkg.org/tutorial/basic/university-1.html#mappings), and proceeded by adding `AssociateProfessor`, `AssistantProfessor`, `ExternalTeacher`, and  `PostDoc`. 

> 📌 **Note:**
>
> I added the `AssociateProfessor` mapping
>
> Target:
> ```turtle 
> :uni1/academic/{a_id} a :AssociateProfessor .
>```
> Source: 
> ```sql 
> SELECT *
> FROM "uni1"."academic"
> WHERE "position" = 2
>```
>"position 2 -> "AssociateProfessor"

> I added the `AssistantProfessor` mapping
>
> Target:
> ```turtle 
> :uni1/academic/{a_id} a :AssistantProfessor . 
>```
> Source: 
> ```sql 
> SELECT *
> FROM "uni1"."academic"
> WHERE "position" = 3
>```
>"position 3 -> "AssistantProfessor"

> I added the `ExternalTeacher` mapping
>
> Target:
> ```turtle 
> :uni1/academic/{a_id} a :ExternalTeacher . 
>```
> Source: 
> ```sql 
> SELECT *
> FROM "uni1"."academic"
> WHERE "position" = 8
>```
>"position 8 -> "ExternalTeacher"

> I added the `PostDoc` mapping
>
> Target:
> ```turtle 
> :uni1/academic/{a_id} a :ExternalTeacher . 
>```
> Source: 
> ```sql 
> SELECT *
> FROM "uni1"."academic"
> WHERE "position" = 9
>```
>"position 9 -> "PostDoc"

### SPARQL
> 📌 **Note:** SPARQL is a query language used to retrieve and manipulate data > stored in RDF (Resource Description Framework) format — basically, it’s like SQL but for querying semantic web data or linked data.

1. Run Protégé and go to the `Window -> Tabs -> Ontop SPARQL tab`
2. Select `Ontop` in the Reasoner menu
3. Start the reasoner
4. Add a query in the `Query Manager` and run the following query in `SPARQL query editor`:

```sparql
PREFIX : <http://example.org/voc#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>

SELECT DISTINCT ?prof ?lastName {
  ?prof a :FullProfessor ; foaf:lastName ?lastName .
}
```
**💡 Tip:** do a right click on the SPARQL query field to visualize the generated SQL query.

> 📌 **Note:** The generated SQL query 
> ```sql
> ans1(prof, lastName)
>CONSTRUCT [prof, lastName] [lastName/RDF(VARCHARToTEXT>(last_name2m7),xsd:string), prof/RDF(http://example.org/voc#uni1/academic/{}(INTEGERToTEXT(a_id1m19)),IRI)]
>   NATIVE [a_id1m19, last_name2m7]
>SELECT V1."a_id" AS "a_id1m19", V1."last_name" AS "last_name2m7"
>FROM "uni1"."academic" V1
>WHERE 1 = V1."position"
>```
>
> - The CONSTRUCT query outputs RDF triples:
>   - `prof` is turned into an RDF IRI (using `http://example.org/voc#uni1/>academic/{a_id}`)
>   - `lastName` is turned into a literal of type `xsd:string`.
>- A SQL `SELECT` query outputs plain rows in a table: no RDF structure, >just data.

### Inference
Ontop embeds some inference capabilities and is thus capable of answering a query like the following:

```sparql
PREFIX : <http://example.org/voc#>

SELECT DISTINCT ?teacher {
  ?teacher a :Teacher .
}
```
These inference capabilities can be, for a large part, understood as the ability to infer new mappings from the original mappings and the ontological axioms (e.g. Professor is a sub-class of Teacher). We will discuss it later in [this tutorial](https://ontop-vkg.org/tutorial/mapping/foreign-keys.html).

> **Note:** The inference allows you to not just match explicit `?teacher a :Teacher` statements, but also return results where `:Teacher` is implicitly true based on ontology rules (like subclass relationships).
>
> In other words, this would not only return individuals that are explicitely defined as `a :Teacher`, but also individuals that are of a subclass of `:Teacher`. 

## Second data source: university2
We now consider the database of another university. It has a different schema, composed of three tables:

**uni2.person**
| pid | fname  | lname  | status |
|-----|--------|--------|--------|
| 1   | Zak    | Lane   | 8      |
| 2   | Mattie | Moses  | 1      |
| 3   | Céline | Mendez | 2      |

The column status is populated with magic numbers (they differ from the ones of the first university):
- 1 -> Undergraduate Student
- 2 -> Graduate Student
- 3 -> PostDoc
- 7 -> Full Professor
- 8 -> Associate Professor
- 9 -> Assistant Professor

As you can see, undergraduate and graduate students are now distinguished.

See rest of tables from the [Tutorial](https://ontop-vkg.org/tutorial/basic/university-2.html#new-mappings).

### New mappings
Let us add the following mapping assertions together with the previous one.

**Mapping uni2.person**
- Target:
```turtle
:uni2/person/{pid} a foaf:Person ;
    foaf:firstName {fname}^^xsd:string ;
    foaf:lastName {lname}^^xsd:string .
```
- Source:
```sql
SELECT *
FROM "uni2"."person
```
See rest of mappings intutorial.

> 📌 **Note:** Added mappings for `GraduateStudent`, `PostDoc`, `FullProfessor`, `AssociateProfessor`,and `AssistantProfessor`.

### SPARQL
We can now run the previous SPARQL queries and observe that the results combine entries from the two datasets.

> 📌 **Note:** Remember to restart the reasoner whenever you modify the mappings!

