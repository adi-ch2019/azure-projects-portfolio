curl -X POST https://watchtower-api.azure-api.net/v1/incidents \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "incidentType": "ALIEN_INVASION",
    "location": "Metropolis",
    "severity": 5,
    "description": "General Zod sighted"
  }'