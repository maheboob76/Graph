
# CSV without headers
LOAD CSV FROM 'file:///artists.csv' AS line
CREATE (:Artist { name: line[1], year: toInteger(line[2])});

# CSV with Headers
LOAD CSV WITH HEADERS FROM 'file:///margin_trades.csv' AS line
CREATE (:Trade { trade_id: toInteger( line[1] ), trade_name: line[2], trade_created_date: line[3], trade_arr_status: line[4] } );

You need to use column name to access value from the line/row, when loading data with LOAD CSV WITH HEADERS.

#periodic commit helps with regular synch and avoiding OutOfMemory issues
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM 'file:///margin_trades.csv' AS line
CREATE (:Trade { trade_id: line.trade_id, trade_name: line.trade_name, trade_created_date: line.trade_created_date,trade_arr_status: line.trade_arr_status, agreement_id: line.agreement_id } );

#create Index
CREATE INDEX ON :Trade(trade_id);
CREATE INDEX ON :Trade(trade_arr_status);
CREATE INDEX ON :Trade(agreement_id);

#Search nodes
MATCH(t:Trade) WHERE t.trade_arr_status="off" RETURN t LIMIT 10;


#UPDATE nodes/properties
MATCH(t:Trade) WHERE t.trade_id="1" SET t.trade_arr_status="on"  RETURN t;


MERGE guarantees that a node will exist afterwards (either matched or created). If you don't want to create the node, you need to use MATCH instead. (Since you say "if node exists", that implies it shouldn't be created)

USING PERIODIC COMMIT 10000

MATCH(t:Trade) SET t.trade_arr_status="off" RETURN count(t);



#UNWIND - very useful and need to explore
{batch: [{name:"Alice",age:32},{name:"Bob",age:42}]}UNWIND {batch} as row
CREATE (n:Label)
SET n += row




USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM 'file:///margin_agreements.csv' AS line
CREATE (:Agreement { agreement_id: line.agreement_id, agreement_name: line.agreement_name, agreement_created_date: line.agreement_created_date } );

CREATE INDEX ON :Agreement(agreement_id);


USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///trade_relationships.csv' AS row
MATCH (t:Trade {trade_id: row.trade_id})
MATCH (a:Agreement {agreement_id: row.agreement_id})
MERGE (t)-[r:IS_PART_OF]->(a)
RETURN count(*);


# SEARCH 
MATCH(a:Agreement)-[r:IS_PART_OF]-(t:Trade) WHERE a.agreement_id="1" RETURN t;
 
 
MATCH(a:Agreement)-[r:IS_PART_OF]-(t:Trade) WHERE a.agreement_id="1" AND t.trade_arr_status="off" RETURN t;


#Find pending agreements at the time of sweep
MATCH(a:Agreement)-[r:IS_PART_OF]-(t:Trade) WHERE t.trade_arr_status="off" RETURN a.agreement_id, count(t);

