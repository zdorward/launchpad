#!/bin/bash

# Firebase Realtime Database seed script for LaunchPad
BASE_URL="https://launchpad-2bfd9-default-rtdb.firebaseio.com"

echo "🌱 Seeding LaunchPad database..."

# ============================================
# EMPLOYEES
# ============================================
echo "Adding employees..."

# Manager 1
curl -s -X POST "$BASE_URL/employees.json" -d '{
  "name": "Sarah",
  "id": 1001,
  "pin": "1234",
  "manager": true,
  "requests": null,
  "logged in": false
}'

# Manager 2
curl -s -X POST "$BASE_URL/employees.json" -d '{
  "name": "Mike",
  "id": 1002,
  "pin": "5678",
  "manager": true,
  "requests": null,
  "logged in": false
}'

# Employee 1
curl -s -X POST "$BASE_URL/employees.json" -d '{
  "name": "Alex",
  "id": 2001,
  "pin": "1111",
  "manager": false,
  "requests": null,
  "logged in": false
}'

# Employee 2
curl -s -X POST "$BASE_URL/employees.json" -d '{
  "name": "Jordan",
  "id": 2002,
  "pin": "2222",
  "manager": false,
  "requests": null,
  "logged in": false
}'

# Employee 3
curl -s -X POST "$BASE_URL/employees.json" -d '{
  "name": "Taylor",
  "id": 2003,
  "pin": "3333",
  "manager": false,
  "requests": null,
  "logged in": false
}'

# Employee 4
curl -s -X POST "$BASE_URL/employees.json" -d '{
  "name": "Casey",
  "id": 2004,
  "pin": "4444",
  "manager": false,
  "requests": null,
  "logged in": false
}'

# Employee 5 - with a shift change request
curl -s -X POST "$BASE_URL/employees.json" -d '{
  "name": "Riley",
  "id": 2005,
  "pin": "5555",
  "manager": false,
  "requests": [{"name": "Alex", "date": "2026-03-10T00:00:00.000"}],
  "logged in": false
}'

echo ""
echo "✅ Employees added"

# ============================================
# SCHEDULES
# ============================================
echo "Adding schedules..."

# Get current week's Monday
MONDAY=$(date -v-monday "+%Y-%m-%dT00:00:00.000")
SUNDAY=$(date -v-monday -v+6d "+%Y-%m-%dT00:00:00.000")

# Schedule data format:
# Row 0: Header row (blank, Mon, Tue, Wed, Thu, Fri, Sat, Sun)
# Row 1+: Employee name, then their shifts for each day
# Each row has 8 cells

curl -s -X POST "$BASE_URL/schedules.json" -d "{
  \"first date\": \"$MONDAY\",
  \"last date\": \"$SUNDAY\",
  \"employee names\": [\"Sarah\", \"Mike\", \"Alex\", \"Jordan\", \"Taylor\", \"Casey\", \"Riley\"],
  \"data\": [
    \"\", \"Mon\", \"Tue\", \"Wed\", \"Thu\", \"Fri\", \"Sat\", \"Sun\",
    \"Sarah\", \"9-5\", \"9-5\", \"OFF\", \"9-5\", \"9-5\", \"OFF\", \"OFF\",
    \"Mike\", \"OFF\", \"12-8\", \"12-8\", \"12-8\", \"OFF\", \"10-6\", \"10-6\",
    \"Alex\", \"6-2\", \"6-2\", \"6-2\", \"OFF\", \"OFF\", \"6-2\", \"6-2\",
    \"Jordan\", \"2-10\", \"OFF\", \"2-10\", \"2-10\", \"2-10\", \"OFF\", \"2-10\",
    \"Taylor\", \"OFF\", \"9-5\", \"9-5\", \"9-5\", \"9-5\", \"9-5\", \"OFF\",
    \"Casey\", \"12-8\", \"12-8\", \"OFF\", \"OFF\", \"12-8\", \"12-8\", \"12-8\",
    \"Riley\", \"9-5\", \"OFF\", \"OFF\", \"6-2\", \"6-2\", \"6-2\", \"OFF\"
  ]
}"

# Add another schedule for next week
NEXT_MONDAY=$(date -v-monday -v+7d "+%Y-%m-%dT00:00:00.000")
NEXT_SUNDAY=$(date -v-monday -v+13d "+%Y-%m-%dT00:00:00.000")

curl -s -X POST "$BASE_URL/schedules.json" -d "{
  \"first date\": \"$NEXT_MONDAY\",
  \"last date\": \"$NEXT_SUNDAY\",
  \"employee names\": [\"Sarah\", \"Mike\", \"Alex\", \"Jordan\", \"Taylor\", \"Casey\", \"Riley\"],
  \"data\": [
    \"\", \"Mon\", \"Tue\", \"Wed\", \"Thu\", \"Fri\", \"Sat\", \"Sun\",
    \"Sarah\", \"9-5\", \"OFF\", \"9-5\", \"9-5\", \"9-5\", \"OFF\", \"OFF\",
    \"Mike\", \"12-8\", \"12-8\", \"OFF\", \"12-8\", \"OFF\", \"10-6\", \"10-6\",
    \"Alex\", \"OFF\", \"6-2\", \"6-2\", \"6-2\", \"OFF\", \"6-2\", \"6-2\",
    \"Jordan\", \"2-10\", \"2-10\", \"OFF\", \"2-10\", \"2-10\", \"OFF\", \"2-10\",
    \"Taylor\", \"9-5\", \"9-5\", \"9-5\", \"OFF\", \"9-5\", \"9-5\", \"OFF\",
    \"Casey\", \"OFF\", \"12-8\", \"12-8\", \"OFF\", \"12-8\", \"12-8\", \"12-8\",
    \"Riley\", \"6-2\", \"OFF\", \"OFF\", \"9-5\", \"6-2\", \"OFF\", \"6-2\"
  ]
}"

echo ""
echo "✅ Schedules added"

# ============================================
# PROMOTIONS
# ============================================
echo "Adding promotions..."

curl -s -X POST "$BASE_URL/promotions.json" -d '{
  "name": "Happy Hour Special",
  "description": "50% off all appetizers from 4-6pm weekdays. Mention this promo to customers!"
}'

curl -s -X POST "$BASE_URL/promotions.json" -d '{
  "name": "Weekend Bundle",
  "description": "Buy 2 entrees, get 1 free dessert. Valid Saturday and Sunday only."
}'

curl -s -X POST "$BASE_URL/promotions.json" -d '{
  "name": "Loyalty Card",
  "description": "Remind customers about our loyalty program - every 10th visit is free!"
}'

curl -s -X POST "$BASE_URL/promotions.json" -d '{
  "name": "Spring Menu Launch",
  "description": "New seasonal items available! Featured: Strawberry Salad, Lemon Chicken, Mango Smoothie"
}'

echo ""
echo "✅ Promotions added"

# ============================================
# SHIFTS (Shift Pool - shifts available for pickup)
# ============================================
echo "Adding shifts to pool..."

# Shifts in the pool for people to pick up
SHIFT_DATE_1=$(date -v+3d "+%Y-%m-%dT00:00:00.000")
SHIFT_DATE_2=$(date -v+5d "+%Y-%m-%dT00:00:00.000")
SHIFT_DATE_3=$(date -v+7d "+%Y-%m-%dT00:00:00.000")

curl -s -X POST "$BASE_URL/shifts.json" -d "{
  \"name\": \"Jordan\",
  \"date\": \"$SHIFT_DATE_1\",
  \"shift\": \"2-10\"
}"

curl -s -X POST "$BASE_URL/shifts.json" -d "{
  \"name\": \"Taylor\",
  \"date\": \"$SHIFT_DATE_2\",
  \"shift\": \"9-5\"
}"

curl -s -X POST "$BASE_URL/shifts.json" -d "{
  \"name\": \"Casey\",
  \"date\": \"$SHIFT_DATE_3\",
  \"shift\": \"12-8\"
}"

echo ""
echo "✅ Shift pool added"

# ============================================
# UPDATES (Shift change history)
# ============================================
echo "Adding shift change history..."

curl -s -X POST "$BASE_URL/updates.json" -d '{
  "employeeName1": "Alex",
  "employeeName2": "Jordan",
  "date": "Monday, March 2",
  "seen": true
}'

curl -s -X POST "$BASE_URL/updates.json" -d '{
  "employeeName1": "Taylor",
  "employeeName2": "Casey",
  "date": "Wednesday, March 4",
  "seen": true
}'

curl -s -X POST "$BASE_URL/updates.json" -d '{
  "employeeName1": "Riley",
  "employeeName2": "Mike",
  "date": "Friday, March 6",
  "seen": false
}'

echo ""
echo "✅ Shift change history added"

echo ""
echo "🎉 Database seeding complete!"
echo ""
echo "Test accounts:"
echo "  Manager:  ID=1001, PIN=1234 (Sarah)"
echo "  Manager:  ID=1002, PIN=5678 (Mike)"
echo "  Employee: ID=2001, PIN=1111 (Alex)"
echo "  Employee: ID=2002, PIN=2222 (Jordan)"
echo "  Employee: ID=2003, PIN=3333 (Taylor)"
echo "  Employee: ID=2004, PIN=4444 (Casey)"
echo "  Employee: ID=2005, PIN=5555 (Riley)"
