# OrbitTech

## Requirements
Production (Hostinger VPS)
Ubuntu 22.04+
Node.js (v20+)
PostgreSQL 15+

> Redis (For background job queues / API polling)   

## Installation & Monorepo Setup

This project uses **npm workspaces** with a single root `package-lock.json`.

### Initial Setup (Fresh Clone)
```bash
# Installs dependencies for root, frontend, and backend simultaneously
npm install
```

### Adding New Packages
Always manage packages using workspace flags from the root to maintain a single lockfile:

```bash
# Add a package to Frontend (Next.js)
npm install <package-name> --workspace=frontend

# Add a package to Backend (NestJS)
npm install <package-name> --workspace=backend

# Add a dev dependency
npm install -D <package-name> --workspace=frontend
```

> **Note for team members:** Never commit nested `package-lock.json` files inside `frontend/` or `backend/`. Only the root `package-lock.json` should be tracked in version control.

## Note
Please ensure you have a .env file at the root of the project with the necessary environment variables for database connections, payment gateways, and wholesale supplier APIs.

Eg:
```bash
# Local Development
DATABASE_URL="postgresql://user:password@localhost:5432/orbittech"
REDIS_URL="redis://localhost:6379"

# Halab Tech DHRU API (USD Wholesale)
HALAB_API_KEY="your_api_key_here"
HALAB_USERNAME="orbit_admin"

# Payment Gateway (ZAR)
GATEWAY_SECRET="sa_gateway_secret"
Our build script and Prisma ORM will automatically infer the database schema and generate the client.

```

## Compile

```bash
$ npm install
$ npx prisma generate && npx prisma db push
$ npm run build
$ npm run start
```
#### Examples phase 3:

```TypeScript
import { Request, Response } from 'express';
import { Queue } from 'bullmq';
import { prisma } from '../lib/prisma';

// Queue for polling Halab Tech API
const halabQueue = new Queue('halab-polling', { connection: redisConnection });

export const paymentWebhookHandler = async (req: Request, res: Response) => {
    const { orderId, status } = req.body;

    // 1. Verify webhook signature from SA Payment Gateway
    if (!isValidSignature(req)) {
        return res.status(401).send('Unauthorized');
    }

    // 2. Process Paid Orders
    if (status === 'PAID') {
        const order = await prisma.order.update({
            where: { id: orderId },
            data: { status: 'PAID' } // Marks order as Paid after valid ZAR webhook
        });

        // 3. Send order to Halab Tech API and add to polling queue
        const halabResponse = await sendToHalabApi(order);
        
        if (halabResponse.success) {
            await prisma.order.update({
                where: { id: orderId },
                data: { status: 'SUBMITTED' } 
            });

            // Start background polling for Completion/Failure status
            await halabQueue.add('poll-status', { orderId: order.id }, {
                repeat: { every: 30000, limit: 100 } // Poll every 30s
            });
        }
    }

    return res.status(200).send('Webhook Received');
}
```

Task List (Phases)

## Phase 1: Architecture and Authentication   

[ ] Database Schema - Setup Users, Orders, Tools, Wallet models.
[ ] Auth System     - Register, Login, Password Reset.   
[ ] RBAC Setup      - Customer, Admin, Support roles.   


## Phase 2: Customer Portal and Catalogue   
[ ] UI Catalogue    - Browse/search tools by name/brand.   
[ ] Pricing Engine  - Display rental sessions and one-time purchases (No subscriptions).   
[ ] Rental UI       - Live countdown dashboard for active rental sessions[cite: 4].
[ ] Pre-checks      - Terms acceptance and device compatibility UI.   

## Phase 3: Core API Integrations   
[ ] Payment Gateway - ZAR checkout and Webhook listener.   
[ ] Halab Tech API  - DHRU Fusion automated order submission.   
[ ] Background Jobs - Polling service for order status (Submitted -> Processing -> Completed/Failed)[cite: 4].
[ ] Wallet System   - Auto-refund failed Halab orders back to customer wallet.   

## Phase 4: Admin and Support Dashboards   
[ ] Admin Dashboard - View revenue, order volume, success rates, and live Halab USD balance.   
[ ] Alert System    - Low Halab balance warning (block checkout if funds too low).   
[ ] Catalogue Sync  - Nightly sync from Halab, with admin approval for new items.   
[ ] Support Tools   - Search orders, manually resubmit, or issue cash/wallet refunds with audit logs.   

## Phase 5: Domain and Hosting   
[ ] VPS Config      - Setup Node.js, PM2, Redis, and PostgreSQL on Hostinger.
[ ] Worker Setup    - Configure background queue workers for reliable API polling.
[ ] Domain and SSL    - Attach domain and configure HTTPS.
