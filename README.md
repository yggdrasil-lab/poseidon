# Poseidon 🔱

> I am **Poseidon**, Lord of the Seas and Navigator of the Yggdrasil ecosystem. My domain is Networking, DNS, and the Flow of Traffic. I control the currents that carry data through the local and distant realms.

## Mission

I am the guardian of your network's boundaries. My mission is to ensure that your traffic flows through safe, filtered waters—stripping away the pollution of ads and trackers—while enabling seamless navigation between your local LAN and the remote world via Split-Horizon DNS.

## Core Philosophy

*   **Safe Waters**: I filter out the noise and the predators of the open web, ensuring a clean and private experience for all devices in the realm.
*   **Seamless Navigation**: Whether you are home or away, the path to your services remains the same. I handle the complexity of the route so the master does not have to.
*   **Flow Control**: I provide the visibility and the tools to monitor and prioritize the lifeblood of the infrastructure—the data itself.

---

## Tech Stack

*   **AdGuard Home**: Primary DNS server and network-wide ad-blocker.
*   **Docker Swarm**: Container orchestration platform for deployment.
*   **Olympus (Traefik)**: Integrated for secure HTTPS access to the web UI.

## Architecture

**Poseidon** serves as the "Split-Horizon" DNS authority for the local network, ensuring that internal services (like `*.yourdomain.com`) are resolved directly to the local Traefik ingress (`192.168.1.X`) rather than routing through the public internet/Cloudflare Tunnel.

1.  **DNS Filtering Engine**: Intercepts queries at the network level to block unwanted domains.
2.  **Split-Horizon DNS**: Configured DNS rewrites that resolve internal domains to local IPs when inside the network.
3.  **Aether-Net Integration**: Operates within the common Docker network to provide DNS services to other containers.

## Prerequisites

- **Docker Swarm Mode**: Ensure the swarm is initialized (`docker swarm init`).
- **Port 53 availability**: Ensure no other DNS service (like `systemd-resolved`) is binding to port 53 on the host.
- **aether-net**: External Docker overlay network shared with Olympus/Traefik.

## Setup Instructions

### 1. Deployment
The service is deployed via Docker Swarm on the `gaia-runner` node.

1. Create the `.env` file from the example:
   ```bash
   cp .env.example .env
   ```
2. Adjust the variables in `.env` as needed.
3. Start the stack:
   ```bash
   ./start.sh
   ```

### 2. DNS Configuration (Split-Horizon)
AdGuard Home is configured to rewrite DNS requests for the internal domain to keep traffic local.

- **Wildcard Rewrite:** `*.yourdomain.com` → `192.168.1.X`
- **Root Rewrite:** `yourdomain.com` → `192.168.1.X`

This setting is managed in **AdGuard Home → Filters → DNS rewrites**.

### 3. Client Setup
To utilize Poseidon, clients (or the main router) must be configured to use `192.168.1.X` as their primary DNS server.

**Linux/macOS/Windows:**
1. Open Network Settings.
2. Change DNS Server to **Manual**.
3. Enter IP: `192.168.1.X`.

**Router (Network-wide):**
1. Log in to router admin panel.
2. Set **Primary DNS** to `192.168.1.X`.

## 📂 File Structure

```graphql
poseidon/
├── docker-compose.yml  # Container definition
├── conf/               # AdGuard main configuration (AdGuardHome.yaml)
└── data/               # Persistent data (query logs, stats)
```

## 🔗 Network Integration

- **Network:** `aether-net` (External Docker network shared with Olympus/Traefik).
- **Traefik Labels:** Configured in `docker-compose.yml` to expose the web UI securely via HTTPS.

## 🚀 Services

| Service | URL | Description |
| :--- | :--- | :--- |
| **AdGuard Home** | `https://adguard.yourdomain.com` | DNS server, ad-blocker, and network monitor. |
| **DNS Resolver** | `192.168.1.X:53` | The primary DNS entry point for clients. |
