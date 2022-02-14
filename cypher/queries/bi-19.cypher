// Q19. Interaction path between cities
// Requires the Neo4j Graph Data Science library
/*
:param [{ city1Id, city2Id }] => {
  RETURN
    669 AS city1Id,
    648 AS city2Id
  }
*/
MATCH
  (person1:Person)-[:IS_LOCATED_IN]->(city1:City {id: $city1Id}),
  (person2:Person)-[:IS_LOCATED_IN]->(city2:City {id: $city2Id})
CALL gds.shortestPath.dijkstra.stream({
  sourceNode: person1,
  targetNode: person2,
  nodeQuery: 'MATCH (p:Person) RETURN id(p) AS id',
  relationshipQuery:
      'MATCH (personA:Person)-[knows:KNOWS]-(personB:Person)
       RETURN id(personA) AS source, id(personB) AS target, knows.q19weight AS weight',
  relationshipWeightProperty: 'weight'
})
YIELD totalCost
RETURN person1.id, person2.id, totalCost AS totalWeight
ORDER BY totalWeight ASC, person1.id ASC, person2.id ASC
LIMIT 20
