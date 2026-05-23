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

- **Platform Setup**: Swarm and Network must be initialized (see `Forge/yggdrasil-os`).

## Setup Instructions

### 1. Deployment
The service is deployed via GitHub Actions or manually via Docker Swarm on the Gaia node.

1. Run the host setup script to ensure the persistent directories exist on the host with correct permissions:
   ```bash
   chmod +x setup_host.sh
   ./setup_host.sh
   ```
2. Deploy the stack manually (if not using the GitHub Actions workflow):
   ```bash
   docker stack deploy -c docker-compose.yml poseidon
   ```

### 2. Initial Setup Wizard (Port 3000 to Port 80)
When deploying AdGuard Home for the first time, you must complete the setup wizard:
1. Ensure the Traefik load balancer port in `docker-compose.yml` is temporarily set to **`3000`** (the default port for the wizard):
   ```yaml
   - "traefik.http.services.adguard.loadbalancer.server.port=3000"
   ```
2. Deploy the stack and open the Web UI at `https://yoursubdomain.yourdomain.com` to complete the wizard steps.
3. When the wizard asks for the **Admin Web Interface** port, select **`80`** (the default).
4. After clicking finish, the container will shift to port 80, causing a `502 Bad Gateway`.
5. Update `docker-compose.yml` to change the load balancer port back to **`80`**:
   ```yaml
   - "traefik.http.services.adguard.loadbalancer.server.port=80"
   ```
6. Re-deploy the stack. The dashboard will load securely on port 80.

### 3. DNS Configuration (Split-Horizon)
AdGuard Home is configured to rewrite DNS requests for your internal domain to keep traffic local.

*   **Wildcard Rewrite:** `*.yourdomain.com` → `192.168.1.X`
*   **Root Rewrite:** `yourdomain.com` → `192.168.1.X`

This setting is managed in the Web UI: **AdGuard Home ➔ Filters ➔ DNS rewrites**.

### 4. Client Setup
To utilize Poseidon, clients (or your main router) must be configured to use your DNS server's IP as their primary DNS server.

**Linux/macOS/Windows:**
1. Open Network Settings.
2. Change DNS Server to **Manual**.
3. Enter IP: `192.168.1.X`.

**Router (Network-wide):**
1. Log in to your router's admin panel.
2. Set **Primary DNS** to `192.168.1.X`.

## 📂 File Structure & Persistency

Persistent configuration and query logs are stored on the host machine to prevent data loss during runner workspace updates:

```text
/opt/poseidon/
├── conf/               # AdGuard configuration files (AdGuardHome.yaml)
└── work/               # Persistent data (filters, query logs, stats)
```

## 🔗 Network Integration

*   **Network:** `aether-net` (External Docker network shared with Olympus/Traefik).
*   **Traefik Labels:** Exposes the Web UI securely at `yoursubdomain.yourdomain.com`.

## 🚀 Services

| Service | URL / Port | Description |
| :--- | :--- | :--- |
| **AdGuard Home (UI)** | `https://yoursubdomain.yourdomain.com` | Admin dashboard (secured by Authelia). |
| **DNS Resolver** | `192.168.1.X:53` | Primary DNS entry point for clients (TCP/UDP). |
