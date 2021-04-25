MATCH (:Post {id: $postId})<-[:REPLY_OF*0..]-(message:Message)
DETACH DELETE message
