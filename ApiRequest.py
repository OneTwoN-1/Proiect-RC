import json
import requests
import matplotlib.pyplot as plt
from datetime import datetime, timezone

# load credentials
with open('credentials.json', 'r') as f:
    creds = json.load(f)

client_id = creds['clientId']
client_secret = creds['clientSecret']

# get access token
token_response = requests.post(
    "https://auth.opensky-network.org/auth/realms/opensky-network/protocol/openid-connect/token",
    data={
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret,
    }
)

token = token_response.json()["access_token"]
headers = {"Authorization": f"Bearer {token}"}

# search QFA162 departing wellington, covering april 3-4 to avoid timezone issues
begin_ts = int(datetime(2026, 4, 3, 0, 0, tzinfo=timezone.utc).timestamp())
end_ts   = int(datetime(2026, 4, 4, 23, 59, tzinfo=timezone.utc).timestamp())

print("Searching for QFA162 at NZWN...")

response = requests.get(
    "https://opensky-network.org/api/flights/departure",
    headers=headers,
    params={'airport': 'NZWN', 'begin': begin_ts, 'end': end_ts}
)

flights = response.json()

# find our flight
icao24 = None
flight_time = None

for flight in flights:
    if flight.get('callsign', '').strip() == 'QFA162':
        icao24 = flight['icao24']
        flight_time = flight['firstSeen']
        print(f"Found it! Aircraft hex: {icao24}, took off at: {flight_time}")
        break

if icao24 is None:
    print("Flight not found, try different dates")
    exit()

# get the flight track
print("Downloading flight path...")

track_response = requests.get(
    "https://opensky-network.org/api/tracks/all",
    headers=headers,
    params={'icao24': icao24, 'time': flight_time}
)

waypoints = track_response.json().get('path', [])

# extract lat/lon, skip missing points
lats, lons = [], []

for point in waypoints:
    if point[1] and point[2]:
        lats.append(point[1])
        lons.append(point[2])

print(f"Got {len(lats)} points, plotting...")

# plot the route
plt.figure(figsize=(10, 6))
plt.plot(lons, lats, color='purple', linewidth=2, marker='.', markersize=4)

plt.scatter(lons[0],  lats[0],  color='green', s=100, label='NZWN (Wellington)', zorder=5)
plt.scatter(lons[-1], lats[-1], color='red',   s=100, label='YSSY (Sydney)',     zorder=5)

readable_date = datetime.fromtimestamp(flight_time).strftime('%B %d, %Y')
plt.title(f"QFA162 Flight Path - {readable_date}")
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.legend()
plt.grid(True)
plt.show()