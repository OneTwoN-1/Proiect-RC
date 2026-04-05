import requests
import json
from datetime import datetime, timezone

# load credentials from json file
with open('credentials.json', 'r') as f:
    creds = json.load(f) #opens creds file

client_id = creds['clientId']
client_secret = creds['clientSecret']

# acces token
token_response = requests.post(
    "https://auth.opensky-network.org/auth/realms/opensky-network/protocol/openid-connect/token",
    data={
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret,
    }
)

token = token_response.json()["access_token"]#getting the token
headers = {"Authorization": f"Bearer {token}"}#standard security format

# search for QFA162 departing from wellington on april 4th
begin_ts = int(datetime(2026, 4, 3, 0, 0, tzinfo=timezone.utc).timestamp())
end_ts   = int(datetime(2026, 4, 4, 23, 59, tzinfo=timezone.utc).timestamp())

print("Looking for QFA162 departing NZWN...")

response = requests.get(
    "https://opensky-network.org/api/flights/departure",
    headers=headers,
    params={'airport': 'NZWN', 'begin': begin_ts, 'end': end_ts} #getting flights from that period of time
)

flights = response.json()

# find our flight in the list
icao24 = None
flight_time = None

for flight in flights:
    if flight.get('callsign', '').strip() == 'QFA162':
        icao24 = flight['icao24']
        flight_time = flight['firstSeen']
        print("Found it!")
        break

if icao24 is None:
    print("Flight not found, try different dates")
    exit()

# now get the actual flight track
track_response = requests.get(
    "https://opensky-network.org/api/tracks/all",
    headers=headers,
    params={'icao24': icao24, 'time': flight_time}
)#retrieve info about our flight

waypoints = track_response.json().get('path', [])

# pull out lat, lon, altitude - skip any points with missing data
lats, lons, alts = [], [], []

for point in waypoints:
    if point[1] and point[2] and point[3]:
        lats.append(point[1])
        lons.append(point[2])
        alts.append(point[3])

# pick 15 evenly spaced points
indices = [i * (len(lats) - 1) // 15 for i in range(16)]

print("\n Waypoints ")
print("latitudes  = [", ", ".join(f"{lats[i]:.4f}" for i in indices), "];")
print("longitudes = [", ", ".join(f"{lons[i]:.4f}" for i in indices), "];")
print("altitudes  = [", ", ".join(f"{alts[i]:.1f}" for i in indices), "];")