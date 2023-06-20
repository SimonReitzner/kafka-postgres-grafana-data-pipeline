from kafka import KafkaProducer
import json
import random
import time
import os
import hashlib

# Define Kafka producer settings
bootstrap_servers = [os.environ['KAFKA_HOST'] + ":" + str(os.environ['KAFKA_PORT'])]
topic_name = os.environ["KAFKA_TOPIC"]

# Get shop id from environment variables
shop_id = os.environ["SHOP_ID"]

# Create Kafka producer instance
producer = KafkaProducer(
    bootstrap_servers=bootstrap_servers,
    value_serializer=lambda v: json.dumps(v).encode("utf-8"),
    max_block_ms=10000
)

# Define function to generate fake data
def create_fake_data() -> dict:
    """Generate fake data

    Returns:
        dict: dictionary of artificial data
    """
    random_input = os.urandom(16)
    hash_object = hashlib.sha256(random_input)
    hex_dig = hash_object.hexdigest()
    
    data = {
        "id": hex_dig,
        "shop_id": shop_id,
        "products": random.sample(range(1, 15), random.randint(1, 6))
    }
    return data


def main():
    """Main function sending data to kafka"""
    while True:
        data = create_fake_data()
        
        # Assign a timestamp to the message in milliseconds
        timestamp = int(time.time() * 1000)
        
        # Send fake data to Kafka
        producer.send(topic_name, value=data, timestamp_ms=timestamp)
        producer.flush()

        # Add time offset until next
        offset = int(shop_id)
        time.sleep(offset)


if __name__ == "__main__":
    main()