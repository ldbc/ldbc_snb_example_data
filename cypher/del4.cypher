MATCH (forum:Forum {id: $forumId})-[:CONTAINER_OF]->(:Post)<-[:REPLY_OF*0..]-(message:Message)
DETACH DELETE forum, message
