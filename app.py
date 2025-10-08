from flask import Flask
import redis

app = Flask(__name__)
r = redis.Redis(host='redis', port=6379, decode_responses=True)

@app.route('/')
def index():
    count = r.incr('visitor_count')
    return f"This is the {count} visitor."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
