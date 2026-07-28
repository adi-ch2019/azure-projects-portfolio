curl -X POST https://watchtower-api.azure-api.net/v1/incidents \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "incidentType": "BANK_ROBBERY",
    "location": "Gotham City",
    "severity": 3,
    "description": "Joker at First National Bank"
  }'