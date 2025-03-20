# Deploying SPARQ endpoint
To deploy a SPARQL endpoint, we recommend to use the Ontop endpoint from the

- [Command Line Interface](https://ontop-vkg.org/tutorial/endpoint/endpoint-cli.html) or from the
- [Docker image](https://ontop-vkg.org/tutorial/endpoint/endpoint-docker.html)

## Docker
To deploy the endpoint, make sure that 
- The files `university.obda`, `university.compose.properties`, `university.ttl` exist in the `input/` folder.
- The file `university.portal.toml` is optional and (I think) is for having predefined queries in the endpoint.
- **Note:**  `university.compose.properties` is somewhat different from the `university.properties` file in pt-1-basice. *Can someone explain the difference*?

To deploy the endpoint, execute
```docker
docker compose up
```