# Adventurer Passport Protocol

🌍 A blockchain-based global explorer identity and journey tracking system built in Clarity.

## Overview

The **Adventurer Passport Protocol** is a decentralized smart contract system designed to:
- Register adventurers using their blockchain principal ID
- Record their alias, age, passions, wishlist destinations, and expedition history
- Provide analytical functions to summarize an explorer’s profile
- Ensure all explorers meet age and content requirements before registration

This protocol serves as a digital passport for adventurers seeking to log their journeys and aspirations on-chain.

---

## Features

- ✅ Register new adventurers with validated profile data  
- 🔄 Update explorer passports anytime with new passions or destinations  
- 🔍 View full passport data, alias, age, interests, and travel logs  
- 📊 Generate explorer summaries with count-based insights  
- ⚠️ Handles duplicate registration, invalid inputs, and missing data gracefully

---

## Contract Structure

### Core Map
```clojure
explorer-registry: principal => {
  explorer-alias: string,
  age-count: uint,
  passions: list of strings,
  dream-destinations: list of strings,
  expedition-history: list of strings
}
```

### Key Functions

- `register-new-explorer`: Adds a new explorer with full validation
- `update-explorer-passport`: Modifies an existing passport
- `get-full-passport`: Returns the complete data of an explorer
- `generate-explorer-summary`: Outputs profile stats (counts)

---

## Error Codes

- `u404`: Explorer not found  
- `u409`: Explorer already registered  
- `u400`: Age validation failed  
- `u401`: Missing or empty alias  
- `u402`: Invalid destinations  
- `u403`: Invalid passions  

---

## Getting Started

Clone the repository and deploy to a Clarity-compatible blockchain (e.g., a Stacks devnet).

```bash
git clone https://github.com/YOUR-USERNAME/adventurer-passport-protocol.git
```

Deploy the contract using Clarinet or your preferred Clarity development tool.

---

## License

MIT License © 2025

---

## Credits

Crafted with purpose for digital wanderers and trailblazing souls.
