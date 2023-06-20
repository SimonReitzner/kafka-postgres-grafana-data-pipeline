from kafka import KafkaConsumer
from json import loads
import psycopg2
import datetime
import os


# Define Kafka producer settings
bootstrap_servers = [os.environ['KAFKA_HOST'] + ":" + str(os.environ['KAFKA_PORT'])]
topic_name = os.environ["KAFKA_TOPIC"]

# Create Kafka consumer instance
consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=bootstrap_servers,
    auto_offset_reset="earliest",
    enable_auto_commit=True,
    value_deserializer=lambda x: loads(x.decode("utf-8"))
)

def main():
    # PostgreSQL database configuration
    connection = psycopg2.connect(
        host=os.environ["POSTGRES_HOST"],
        port=int(os.environ["POSTGRES_PORT"]),
        database=os.environ["POSTGRES_DATABASE"],
        user=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"]
    )
    cursor = connection.cursor()

    # Loop to consume messages from the Kafka topic
    for message in consumer:

        # Fetch the payload of the message
        message_data = message.value
        id = message_data["id"]
        shop_id = int(message_data["shop_id"])
        order_date = datetime.datetime.fromtimestamp(message.timestamp / 1000.0).strftime("%Y-%m-%d %H:%M:%S.%f")

        # Extract the fields from the JSON payload
        values = []
        for sub_id, product_id in enumerate(message_data["products"], 1):
            values.append((id, sub_id, shop_id, order_date, product_id))

        # Insert the data into the postgres table
        insert_query = "INSERT INTO orders (id, sub_id, shop_id, order_date, product_id) VALUES (%s,%s,%s,%s,%s)"
        cursor.executemany(insert_query, values)
        connection.commit()


if __name__ == "__main__":
    main()