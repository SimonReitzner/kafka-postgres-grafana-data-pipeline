from diagrams import Cluster, Diagram, Edge
from diagrams.programming.language import Python
from diagrams.onprem.database import Postgresql
from diagrams.onprem.queue import Kafka
from diagrams.onprem.compute import Server
from diagrams.onprem.container import Docker
from diagrams.onprem.monitoring import Grafana


graph_attr = {
    "color": "black"
}


with Diagram(
    "Kafka Shops Architecture",
    show=False,
    outformat="png",
    filename="flowchart",
    direction="LR",
    graph_attr=graph_attr
):
    kafka = Kafka("Kafka")

    with Cluster("Producers"):
        producer1 = Docker("Shop-1")
        producer8 = Docker("Shop-8")
        producer1 >> Edge(color="black") >> kafka
        producer8 >> Edge(color="black") >> kafka
        producer1 - Edge(style="dotted", rankdir="TB") - producer8
    
    with Cluster("Consumers"):
        consumer = Docker("To-Database")

    with Cluster("Analytics"):
        postgres = Postgresql("Postgres")
        grafana = Grafana("Grafana")

    kafka >> Edge(color="black") >> consumer
    consumer >> Edge(color="black") >> postgres
    postgres >> Edge(color="black") >> grafana
